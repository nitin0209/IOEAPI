public with sharing class FunderCostingController {
    @AuraEnabled(cacheable=true)
    public static Funder_Costing__c getCostingDetails() {
        return [SELECT Normal_Bead__c, Innovation_Bead__c, RIR__c, Loft__c, Mechanical_Vents__c, EPR_fee__c,
                        EPC_Elmhurst__c, TM_Lodgement__c, TM_Amendment__c, Survey_Fee__c, Tech_Survey__c,
                        Retrofit_Coodintation__c, Land_Registry__c, CIGA_Search__c 
                FROM Funder_Costing__c 
                WHERE Name = 'Costing Details' LIMIT 1];
    }
}