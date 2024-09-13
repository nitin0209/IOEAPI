public class VanManagementControllerSCIS {
    @AuraEnabled(cacheable=true)
    public static List<Van_Assignment__c> getAssignedVans() {
        /*
        return [SELECT Id,Name, Vehicle_Details__r.Name, Vehicle_Details__r.Vehicle_Registration__c, User_Log_In_Details__r.Name, Status__c 
                FROM Van_Assignment__c 
                WHERE Status__c = 'Active']; */
        return [SELECT Id, Name, Status__c, Vehicle_Details__r.Name, Vehicle_Details__r.Vehicle_Registration__c, User_Log_In_Details__r.Name  
                FROM Van_Assignment__c 
                WHERE Status__c = 'Active'];
        
        
    }

    @AuraEnabled(cacheable=true)
    public static List<Vehicle_Details__c> getUnassignedVans() {
        return [SELECT Id, Name, Vehicle_Registration__c, Status__c 
                FROM Vehicle_Details__c 
                WHERE Status__c = 'Available'];
    }

    @AuraEnabled
    public static String removeAssignment(String assignmentId) {
        try {
            Van_Assignment__c assignment = [SELECT Id,name, Van__c FROM Van_Assignment__c WHERE Id = :assignmentId LIMIT 1];
            assignment.Status__c = 'Inactive';
            update assignment;

            Vehicle_Details__c Vehicle = [SELECT Id,Name, Status__c FROM Vehicle_Details__c WHERE Id = :assignment.Vehicle_Details__c LIMIT 1];
            Vehicle.Status__c = 'Available';
            update Vehicle;

            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error removing van assignment: ' + e.getMessage());
        }
    }
}