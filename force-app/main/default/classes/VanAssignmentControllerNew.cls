public class VanAssignmentControllerNew {
    @AuraEnabled(cacheable=true)
    public static List<Vehicle_Details__c> getAvailableVans() {
        return [SELECT Id, Name FROM Vehicle_Details__c where Status__c = 'Available'];
    }

    @AuraEnabled(cacheable=true)
    public static List<User_Log_In_Details__c> getInstallers() {
        return [SELECT Id, Name,Role__c FROM User_Log_In_Details__c where Role__c = 'Lead Installer'];
    }

    @AuraEnabled
    public static String assignVan(String vanId, String installerId) {
        try {
            // Fetch the van record and ensure it's still available
            Vehicle_Details__c selectedVan = [SELECT Id,Name, Status__c FROM Vehicle_Details__c WHERE Id =: vanId LIMIT 1];
            User_Log_In_Details__c selectedUserLoginDetail = [Select id,name from User_Log_In_Details__c where id =: installerId LIMIT 1];
            system.debug(selectedVan);
            if (selectedVan.Status__c == 'Assigned') {
                throw new AuraHandledException('Van already assigned. Select another van or remove the assignment of this van and try again.');
            }

            // Create a new van assignment record
            Van_Assignment__c vanAssignment = new Van_Assignment__c();
            vanAssignment.Name = selectedUserLoginDetail.name;
            vanAssignment.Vehicle_Details__c = vanId;
            vanAssignment.User_Log_In_Details__c = installerId;
            vanAssignment.Status__c = 'Active';
            insert vanAssignment;

            // Update the van's status to 'Assigned'
            selectedVan.Status__c = 'Assigned';
            update selectedVan;

            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error saving van assignment: ' + e.getMessage());
        }
    }
}
/*Ritesh sir working code 11 Sept 2024 
 * 
 * 
public class VanAssignmentControllerNew {
    @AuraEnabled(cacheable=true)
    public static List<Van__c> getAvailableVans() {
        return [SELECT Id, Name FROM Van__c where Status__c = 'Available'];
    }

    @AuraEnabled(cacheable=true)
    public static List<Installer__c> getInstallers() {
        return [SELECT Id, Name FROM Installer__c];
    }

    @AuraEnabled
    public static String assignVan(String vanId, String installerId) {
        try {
            // Fetch the van record and ensure it's still available
            Van__c selectedVan = [SELECT Id, Status__c FROM Van__c WHERE Id = :vanId LIMIT 1];
            system.debug(selectedVan);
            if (selectedVan.Status__c == 'Assigned') {
                throw new AuraHandledException('Van already assigned. Select another van or remove the assignment of this van and try again.');
            }

            // Create a new van assignment record
            Van_Assignment__c vanAssignment = new Van_Assignment__c();
            vanAssignment.Van__c = vanId;
            vanAssignment.Installer__c = installerId;
            vanAssignment.Status__c = 'Active';
            insert vanAssignment;

            // Update the van's status to 'Assigned'
            selectedVan.Status__c = 'Assigned';
            update selectedVan;

            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error saving van assignment: ' + e.getMessage());
        }
    }
}

*/