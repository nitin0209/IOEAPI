public with sharing class IOEResponseController {
    @AuraEnabled(cacheable=true)
    public static IOE_Response__c fetchLatestResponse() {
        try {
            // Query the latest response from IOE_Response__c
            List<IOE_Response__c> responseList = [SELECT Response_Body__c FROM IOE_Response__c ORDER BY CreatedDate DESC LIMIT 1];
            
            // Check if the list has any records
            if (!responseList.isEmpty()) {
                return responseList[0];  // Return the first record if found
            } else {
                // No records found, return null or handle appropriately
                return null;
            }
        } catch (Exception e) {
            // Log the exception for debugging
            System.debug('Exception occurred in fetchLatestResponse: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching the response: ' + e.getMessage());
        }
    }
}