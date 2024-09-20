public class VanManagementControllerSCIS {
    @AuraEnabled(cacheable=true)
    public static List<Van_Assignment__c> getAssignedVans() {
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
            // Query the Van_Assignment__c record
            List<Van_Assignment__c> assignments = [SELECT Id, name, Van__c, Vehicle_Details__c 
                                                   FROM Van_Assignment__c 
                                                   WHERE Id = :assignmentId LIMIT 1];

            // Check if any records are returned
            if (assignments.isEmpty()) {
                throw new AuraHandledException('Error: Van assignment not found.');
            }

            Van_Assignment__c assignment = assignments[0];
            assignment.Status__c = 'Inactive';
            update assignment;

            // Query the Vehicle_Details__c record
            List<Vehicle_Details__c> vehicles = [SELECT Id, Name, Status__c 
                                                 FROM Vehicle_Details__c 
                                                 WHERE Id = :assignment.Vehicle_Details__c LIMIT 1];

            // Check if any records are returned
            if (vehicles.isEmpty()) {
                throw new AuraHandledException('Error: Vehicle not found.');
            }

            Vehicle_Details__c vehicle = vehicles[0];
            vehicle.Status__c = 'Available';
            update vehicle;

            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error removing van assignment: ' + e.getMessage());
        }
    }
}