public with sharing class SCIS_IOE_PackageController {
    @AuraEnabled(cacheable=true)
    public static List<Package__c> getPackages() {
        return [SELECT Id, Name,Text__c,Result__c FROM Package__c];  
    }
}