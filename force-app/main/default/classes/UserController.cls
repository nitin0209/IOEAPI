public with sharing class UserController {
    @AuraEnabled
    public static void reassignLeadGenerator(Id leadGeneratorId) {
        // Query the Postcode_Assignment__c records for the given lead generator
        List<Postcode_Assignment__c> assignments = [SELECT Id, Assigned_Postcode__c,User_Log_In_Details__r.Id
                                                     FROM Postcode_Assignment__c 
                                                     WHERE User_Log_In_Details__r.Id = :leadGeneratorId];
    System.debug('assign=>>>>>>>>>>>>>>'+assignments);
        // Update the Assigned_Postcode__c field in each assignment record
        for (Postcode_Assignment__c assignment : assignments) {
            //assignment.Assigned_Postcode__c = newPostcode;
        }

        // Update the assignments
        update assignments;
    }

    @AuraEnabled(cacheable=true)
    public static List<Postcode_Assignment__c> getUserLogInDetails(Date selectedDate) {
        List<Postcode_Assignment__c> userDetailsList = [SELECT 	Assigned_Postcode__c,Name,Postcode_Assignment_Date__c,User_Log_In_Details__r.name
                                                        
                                                        FROM Postcode_Assignment__c 
                                                        WHERE Postcode_Assignment_Date__c = :selectedDate and User_Log_In_Details__r.role__c='Lead Generator' ];
        
        return userDetailsList;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<User_Log_In_Details__c> getpostalCode(Date selectedDate) {
        List<User_Log_In_Details__c> userDetailsList = [SELECT Id, Name, Role__c, 
                                                        (SELECT Name, Assigned_Area__c, Assignment_Date__c 
                                                         FROM Area_Assignments__r 
                                                         WHERE Assignment_Date__c = :selectedDate) 
                                                        FROM User_Log_In_Details__c 
                                                        WHERE Role__c = 'Lead Generator'];
        
        return userDetailsList;
    }
    
}