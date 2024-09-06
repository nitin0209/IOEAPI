public with sharing class NewUserController {
    
    @AuraEnabled(cacheable=true)
    public static String getCurrentUserCompanyName() {
        // Get the current user's Id
        Id userId = UserInfo.getUserId();
        
        // Query the User object to fetch company name
        User currentUser = [SELECT Company_Name__c FROM User WHERE Id = :userId LIMIT 1];
        
        // Return company name
        return currentUser.Company_Name__c;
    }
}