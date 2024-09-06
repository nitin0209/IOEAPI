public class VanManagementController {
    @AuraEnabled(cacheable=true)
    public static List<Van_Assignment__c> getAssignedVans() {
        return [SELECT Id, Van__r.Name, Van__r.License_Plate__c, Installer__r.Name, Status__c 
                FROM Van_Assignment__c 
                WHERE Status__c = 'Active'];
    }

    @AuraEnabled(cacheable=true)
    public static List<Van__c> getUnassignedVans() {
        return [SELECT Id, Name, License_Plate__c, Status__c 
                FROM Van__c 
                WHERE Status__c = 'Available'];
    }

    @AuraEnabled
    public static String removeAssignment(String assignmentId) {
        try {
            Van_Assignment__c assignment = [SELECT Id, Van__c FROM Van_Assignment__c WHERE Id = :assignmentId LIMIT 1];
            assignment.Status__c = 'Inactive';
            update assignment;

            Van__c van = [SELECT Id, Status__c FROM Van__c WHERE Id = :assignment.Van__c LIMIT 1];
            van.Status__c = 'Available';
            update van;

            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error removing van assignment: ' + e.getMessage());
        }
    }
}