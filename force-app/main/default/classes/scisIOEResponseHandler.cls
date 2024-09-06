public class scisIOEResponseHandler {
    
    @AuraEnabled
    public static String makeHttpPostRequest() {
        String endpointUrl = 'https://improvement-evaluator-integration-api-staging.elmhurstenergy.net/api/Assessment/Calculate';

        String requestBody = '{ "inputXmlBase64": "PFJkU0FQLVJlcG9ydCB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4bWxucz0iaHR0cHM6Ly9lcGJyLmRpZ2l0YWwuY29tbXVuaXRpZXMuZ292LnVrL3hzZC9yZHNhcCIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwczovL2VwYnIuZGlnaXRhbC5jb21tdW5pdW5pdGllcy5nb3YudWsveHNkL3Jkc2FwIGh0dHBzOi8vbWhjbGctZXBiLWZyb250ZW5kLXVpLWludGVncmF0aW9uLmxvbmRvbi5jbG91ZGFwcHMuZGlnaXRhbC54c2QvUmRTQVAvVGVtcGxhdGVzL1JkU0FQLVJlcG9ydC54c2QiPg0KICA8U2NoZW1hLVZlcnNpb24tT3JpZ2luYWw+MjAuMC4wPC9TY2hlbWEtVmVyc2lvbi1PcmlnaW5hbD4NCiAgPFNBUC1WZXJzaW9uPjkuOTQ8L1NBUC1WZXJzaW9uPg0KICA8U0FQLVJlcG9ydC54c2QiPg0K", ' +
                             '"rdsapGuid": "867AD43F-8C3A-49D7-B9DB-789B8286DDD4", "recommendations": [{ "item": "A2", "name": "Flat roof insulation", "selected": true, "sapRating": 78, "eiRating": 83, "capitalCost": 0, "fuelCostSaving": 0, "paybackPeriod": 0, "coEmissionsSaving": 0, "carbonCostEffectiveness": 0 }], ' +
                             '"calculationType": "Cumulative", "integratorReference": "000003" }';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000); // Set timeout to 60 seconds
        String serialNumber = '311245362999';
        Blob headerValue = Blob.valueOf(serialNumber + ':' + serialNumber);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Surveyor-Code', 'I061-0001');
        request.setHeader('Password', '5bfac846aa90466bf65d93bb35473f19');
        System.debug('Request Body: ' + request.getBody());
        request.setBody(requestBody);

        try {
            HttpResponse response = http.send(request);
            System.debug('Status Code: ' + response.getStatusCode());
            System.debug('Full Response: ' + response.getBody());
            
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();

                // Parse the JSON response
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                
                // Extract data from the JSON
                Decimal eiRating = responseMap.containsKey('eiRating') ? (Decimal)responseMap.get('eiRating') : null;
                Decimal spaceHeatingDemand = responseMap.containsKey('spaceHeatingCost') ? (Decimal)responseMap.get('spaceHeatingCost') : null;
                Decimal primaryEnergy = responseMap.containsKey('primaryEnergy') ? (Decimal)responseMap.get('primaryEnergy') : null;
                Decimal totalCost = responseMap.containsKey('totalCost') ? (Decimal)responseMap.get('totalCost') : null;
                
                // Log extracted data
                System.debug('Extracted eiRating: ' + eiRating);
                System.debug('Extracted Space Heating Demand: ' + spaceHeatingDemand);

                // Create a new IOE_Response__c record and map the extracted data
                IOE_Response__c responseRecord = new IOE_Response__c();
                responseRecord.Response_Body__c = responseBody; // Store full JSON response
                responseRecord.eiRating__c = eiRating;
                responseRecord.Space_Heating_Demand__c = spaceHeatingDemand;
                responseRecord.Total_Delivered_Energy__c = primaryEnergy;
                responseRecord.Total_Fuel_Costs__c = totalCost;

                try {
                    insert responseRecord;  // Insert the record into Salesforce
                    System.debug('Record Inserted Successfully: ' + responseRecord.Id);
                } catch (DmlException e) {
                    System.debug('DML Exception: ' + e.getMessage());
                    throw new AuraHandledException('DML Error: ' + e.getMessage()); // Throwing error to LWC
                }

                return responseBody;  // Return the full JSON response if needed
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
                throw new AuraHandledException('HTTP Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw new AuraHandledException('Exception: ' + e.getMessage());
        }
    }
}