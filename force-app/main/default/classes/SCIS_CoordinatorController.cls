public class SCIS_CoordinatorController {
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [
            SELECT Name, Company_Name__c, Coordinator_Type__c
            FROM User
            WHERE Coordinator_Type__c IN ('Internal', 'External')
            ORDER BY Coordinator_Type__c ASC, Name
        ];
    }
}