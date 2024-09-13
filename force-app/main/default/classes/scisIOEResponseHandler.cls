public class scisIOEResponseHandler {

    @AuraEnabled
    public static String makeHttpPostRequest(Id surveyId) {
        String endpointUrl = 'https://improvement-evaluator-integration-api-staging.elmhurstenergy.net/api/Assessment/Calculate';

        try {
            System.debug('Survey ID: ' + surveyId); // Log the survey ID

            // Fetch the content document links for the survey
            List<ContentDocumentLink> contentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :surveyId];
            System.debug('ContentDocumentLinks found: ' + contentLinks.size());

            if (contentLinks.isEmpty()) {
                throw new AuraHandledException('No files found for this survey: ' + surveyId);
            }

            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink link : contentLinks) {
                contentDocumentIds.add(link.ContentDocumentId);
            }

            // Fetch the latest version of the content document (filtering for the Elmhurst file)
            System.debug('Fetching ContentVersions for Document IDs: ' + contentDocumentIds);
            List<ContentVersion> contentVersions = [SELECT VersionData, Title 
                                                    FROM ContentVersion 
                                                    WHERE ContentDocumentId IN :contentDocumentIds 
                                                    AND Title LIKE '%Elmhurst%'  // Filter for the Elmhurst file
                                                    ORDER BY CreatedDate DESC LIMIT 1];
            System.debug('ContentVersions found: ' + contentVersions.size());

            // Check if we found the Elmhurst file
            if (contentVersions.isEmpty()) {
                // Return a message instead of throwing an exception if no Elmhurst file is found
                return 'Elmhurst XML Base64 file not found for this survey.';
            }

            // Proceed with processing the file
            ContentVersion contentVersion = contentVersions[0];
            Blob base64Blob = contentVersion.VersionData;
            String base64File = EncodingUtil.base64Encode(base64Blob);

            // Create the request body with the Elmhurst XML Base64 file
            String requestBody = '{ "inputXmlBase64": "' + base64File + '", ' +
                                 '"rdsapGuid": "867AD43F-8C3A-49D7-B9DB-789B8286DDD4", ' +
                                 '"recommendations": [{ "item": "A2", "name": "Flat roof insulation", "selected": true, "sapRating": 78, ' +
                                 '"eiRating": 83, "capitalCost": 0, "fuelCostSaving": 0, "paybackPeriod": 0, "coEmissionsSaving": 0, ' +
                                 '"carbonCostEffectiveness": 0 }], "calculationType": "Cumulative", "integratorReference": "000003" }';

            // Log the request body
            System.debug('Request Body: ' + requestBody);

            // Send the HTTP POST request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpointUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setTimeout(60000); // Set timeout to 60 seconds

            // Set authentication headers
            String serialNumber = '311245362999';
            Blob headerValue = Blob.valueOf(serialNumber + ':' + serialNumber);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Surveyor-Code', 'I061-0001');
            request.setHeader('Password', '5bfac846aa90466bf65d93bb35473f19');
            request.setBody(requestBody);

            // Log the HTTP request
            System.debug('Sending HTTP POST request to ' + endpointUrl);

            HttpResponse response = http.send(request);
            System.debug('HTTP Response Status Code: ' + response.getStatusCode());
            System.debug('HTTP Response Body: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('Response from API: ' + responseBody);

                // Parse the response body
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

                // Extract values from the response
                Decimal eiRating = responseMap.containsKey('eiRating') ? (Decimal)responseMap.get('eiRating') : null;
                Decimal spaceHeatingDemand = responseMap.containsKey('spaceHeatingCost') ? (Decimal)responseMap.get('spaceHeatingCost') : null;
                Decimal primaryEnergy = responseMap.containsKey('primaryEnergy') ? (Decimal)responseMap.get('primaryEnergy') : null;
                Decimal totalCost = responseMap.containsKey('totalCost') ? (Decimal)responseMap.get('totalCost') : null;
                Decimal result = responseMap.containsKey('Result') ? (Decimal)responseMap.get('Result') : null;

                // Log parsed response values
                System.debug('eiRating: ' + eiRating);
                System.debug('spaceHeatingDemand: ' + spaceHeatingDemand);
                System.debug('primaryEnergy: ' + primaryEnergy);
                System.debug('totalCost: ' + totalCost);
                System.debug('result: ' + result);

                // Create and insert the IOE_Response__c record
                IOE_Response__c responseRecord = new IOE_Response__c();
                responseRecord.Response_Body__c = responseBody; 
                responseRecord.eiRating__c = eiRating;
                responseRecord.Space_Heating_Demand__c = spaceHeatingDemand;
                responseRecord.Total_Delivered_Energy__c = primaryEnergy;
                responseRecord.Total_Fuel_Costs__c = totalCost;
                responseRecord.Result__C = result;
                
                // Assign the surveyId to the Survey__c lookup field
                responseRecord.Survey__c = surveyId;

                try {
                    insert responseRecord;  
                    System.debug('Record Inserted Successfully: ' + responseRecord.Id);
                } catch (DmlException e) {
                    System.debug('DML Exception: ' + e.getMessage());
                    throw new AuraHandledException('DML Error: ' + e.getMessage()); 
                }

                return responseBody;  
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
                throw new AuraHandledException('HTTP Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
            }

        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw new AuraHandledException('Exception: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void savePackageData(List<Map<String, Object>> recommendationData) {
        try {
           
            Set<String> recommendationNames = new Set<String>();
            for (Map<String, Object> recommendation : recommendationData) {
                if (recommendation.containsKey('name')) {
                    recommendationNames.add((String) recommendation.get('name'));
                }
            }

            
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

            
            for (Map<String, Object> recommendation : recommendationData) {
                Package__c packageRecord;
                String packageName = (String) recommendation.get('name');

               
                if (existingPackageMap.containsKey(packageName)) {
                    packageRecord = existingPackageMap.get(packageName); 
                } else {
                    packageRecord = new Package__c(); 
                }

               
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

               
                if (existingPackageMap.containsKey(packageName)) {
                    packagesToUpdate.add(packageRecord); 
                } else {
                    packagesToInsert.add(packageRecord); 
                }
            }

      
            if (!packagesToInsert.isEmpty()) {
                insert packagesToInsert;
                System.debug('Inserted ' + packagesToInsert.size() + ' new package records.');
            }

           
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


    @AuraEnabled(cacheable=true)
    public static IOE_Response__c fetchLatestResponse() {
        List<IOE_Response__c> responseList = [SELECT Response_Body__c FROM IOE_Response__c ORDER BY CreatedDate DESC LIMIT 1];
        if (responseList.size() > 0) {
            return responseList[0];
        }
        return null;
    }
}