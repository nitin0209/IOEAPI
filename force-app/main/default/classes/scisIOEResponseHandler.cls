public class scisIOEResponseHandler {

    // Method to make the HTTP POST request and insert data into IOE_Response__c
    @AuraEnabled
    public static String makeHttpPostRequest() {
        String endpointUrl = 'https://improvement-evaluator-integration-api-staging.elmhurstenergy.net/api/Assessment/Calculate';

        // Prepare request body for the HTTP POST request
        String requestBody = '{ "inputXmlBase64": "PFJkU0FQLVJlcG9ydCB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4bWxucz0iaHR0cHM6Ly9lcGJyLmRpZ2l0YWwuY29tbXVuaXRpZXMuZ292LnVrL3hzZC9yZHNhcCIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwczovL2VwYnIuZGlnaXRhbC5jb21tdW5pdW5pdGllcy5nb3YudWsveHNkL3Jkc2FwIGh0dHBzOi8vbWhjbGctZXBiLWZyb250ZW5kLXVpLWludGVncmF0aW9uLmxvbmRvbi5jbG91ZGFwcHMuZGlnaXRhbC54c2QvUmRTQVAvVGVtcGxhdGVzL1JkU0FQLVJlcG9ydC54c2QiPg0KICA8U2NoZW1hLVZlcnNpb24tT3JpZ2luYWw+MjAuMC4wPC9TY2hlbWEtVmVyc2lvbi1PcmlnaW5hbD4NCiAgPFNBUC1WZXJzaW9uPjkuOTQ8L1NBUC1WZXJzaW9uPg0KICA8U0FQLVJlcG9ydC54c2QiPg0K", ' +
                             '"rdsapGuid": "867AD43F-8C3A-49D7-B9DB-789B8286DDD4", "recommendations": [{ "item": "A2", "name": "Flat roof insulation", "selected": true, "sapRating": 78, "eiRating": 83, "capitalCost": 0, "fuelCostSaving": 0, "paybackPeriod": 0, "coEmissionsSaving": 0, "carbonCostEffectiveness": 0 }], ' +
                             '"calculationType": "Cumulative", "integratorReference": "000003" }';

        // Create HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000); // Set timeout to 60 seconds
        
        // Basic Authentication
        String serialNumber = '311245362999';
        Blob headerValue = Blob.valueOf(serialNumber + ':' + serialNumber);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Surveyor-Code', 'I061-0001');
        request.setHeader('Password', '5bfac846aa90466bf65d93bb35473f19');
        request.setBody(requestBody);

        try {
            // Send the HTTP request and get the response
            HttpResponse response = http.send(request);
            System.debug('Status Code: ' + response.getStatusCode());
            System.debug('Full Response: ' + response.getBody());

            // Check for successful response
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();

                // Parse the JSON response
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

                // Extract necessary fields from the JSON response
                Decimal eiRating = responseMap.containsKey('eiRating') ? (Decimal)responseMap.get('eiRating') : null;
                Decimal spaceHeatingDemand = responseMap.containsKey('spaceHeatingCost') ? (Decimal)responseMap.get('spaceHeatingCost') : null;
                Decimal primaryEnergy = responseMap.containsKey('primaryEnergy') ? (Decimal)responseMap.get('primaryEnergy') : null;
                Decimal totalCost = responseMap.containsKey('totalCost') ? (Decimal)responseMap.get('totalCost') : null;
                Decimal Result = responseMap.containsKey('Result') ? (Decimal)responseMap.get('Result') : null;


                // Create and insert a new IOE_Response__c record with the extracted data
                IOE_Response__c responseRecord = new IOE_Response__c();
                responseRecord.Response_Body__c = responseBody; // Store the full JSON response
                responseRecord.eiRating__c = eiRating;
                responseRecord.Space_Heating_Demand__c = spaceHeatingDemand;
                responseRecord.Total_Delivered_Energy__c = primaryEnergy;
                responseRecord.Total_Fuel_Costs__c = totalCost;
                responseRecord.Result__C=Result;

                try {
                    insert responseRecord;  // Insert the record into Salesforce
                    System.debug('Record Inserted Successfully: ' + responseRecord.Id);
                } catch (DmlException e) {
                    System.debug('DML Exception: ' + e.getMessage());
                    throw new AuraHandledException('DML Error: ' + e.getMessage()); // Propagate error to LWC
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

    // Method to save package data into the Salesforce object (Packages__c)
    @AuraEnabled
public static void savePackageData(List<Map<String, Object>> recommendationData) {
    try {
        // Collect the names or unique identifiers of the incoming recommendations
        Set<String> recommendationNames = new Set<String>();
        for (Map<String, Object> recommendation : recommendationData) {
            if (recommendation.containsKey('name')) {
                recommendationNames.add((String) recommendation.get('name'));
            }
        }

        // Query existing package records based on the unique identifier (e.g., Name)
        List<Package__c> existingPackages = [
            SELECT Id, Name 
            FROM Package__c 
            WHERE Name IN :recommendationNames
        ];

        Map<String, Package__c> existingPackageMap = new Map<String, Package__c>();
        for (Package__c packageRecord : existingPackages) {
            existingPackageMap.put(packageRecord.Name, packageRecord);
        }

        List<Package__c> packagesToUpdate = new List<Package__c>();
        List<Package__c> packagesToInsert = new List<Package__c>();

        // Loop through the incoming recommendation data
        for (Map<String, Object> recommendation : recommendationData) {
            Package__c packageRecord;
            String packageName = (String) recommendation.get('name');

            // Check if the package already exists
            if (existingPackageMap.containsKey(packageName)) {
                packageRecord = existingPackageMap.get(packageName); // Get the existing package
            } else {
                packageRecord = new Package__c(); // Create a new package record if it doesn't exist
            }

            // Update the package fields with new data
            if (recommendation.containsKey('name')) {
                packageRecord.Name = (String) recommendation.get('name');
            }
            if (recommendation.containsKey('text')) {
                packageRecord.Text__c = (String) recommendation.get('text');
            }
            if (recommendation.containsKey('result')) {
                packageRecord.Result__c = (Decimal) recommendation.get('result');
            }
            if (recommendation.containsKey('isEnabled')) {
                packageRecord.isEnabled__c = (Boolean) recommendation.get('isEnabled'); 
            }
            if (recommendation.containsKey('isVisible')) {
                packageRecord.isVisible__c = (Boolean) recommendation.get('isVisible'); 
            }
            if (recommendation.containsKey('isChecked')) {
                packageRecord.isChecked__c = (Boolean) recommendation.get('isChecked'); 
            }
            if (recommendation.containsKey('shortText')) {
                packageRecord.shortText__c = (String) recommendation.get('shortText');
            }
            if (recommendation.containsKey('savingCost')) {
                packageRecord.savingCost__c = (Decimal) recommendation.get('savingCost');
            }
            if (recommendation.containsKey('saPband')) {
                packageRecord.SAP_Band__c = (String) recommendation.get('saPband');
            }
            if (recommendation.containsKey('saPrating')) {
                packageRecord.SAP_Rating__c = (Decimal) recommendation.get('saPrating');
            }
            if (recommendation.containsKey('cO2emissionsChange')) {
                packageRecord.cO2_Emissions_Change__c = (Decimal) recommendation.get('cO2emissionsChange');
            }
            if (recommendation.containsKey('eIrating')) {
                packageRecord.EI_Rating__c = (Decimal) recommendation.get('eIrating');
            }

            // Add the package to the appropriate list
            if (existingPackageMap.containsKey(packageName)) {
                packagesToUpdate.add(packageRecord); // Add to update list if it already exists
            } else {
                packagesToInsert.add(packageRecord); // Add to insert list if it's new
            }
        }

        // Insert new records if any
        if (!packagesToInsert.isEmpty()) {
            insert packagesToInsert;
            System.debug('Inserted ' + packagesToInsert.size() + ' new package records.');
        }

        // Update existing records if any
        if (!packagesToUpdate.isEmpty()) {
            update packagesToUpdate;
            System.debug('Updated ' + packagesToUpdate.size() + ' existing package records.');
        }

    } catch (DmlException e) {
        throw new AuraHandledException('Error saving package data: ' + e.getMessage());
    } catch (Exception e) {
        throw new AuraHandledException('Unexpected error: ' + e.getMessage());
    }
}

    
    //to add medium term plan component
    @AuraEnabled(cacheable=true)
public static IOE_Response__c fetchLatestResponse() {
    List<IOE_Response__c> responseList = [SELECT Response_Body__c FROM IOE_Response__c ORDER BY CreatedDate DESC LIMIT 1];
    if (responseList.size() > 0) {
        return responseList[0];
    }
    return null;
}


}