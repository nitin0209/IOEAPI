@isTest
public class VanManagementControllerTest {

    @testSetup
    static void setupTestData() {
        // Create test data for Van__c records
        Van__c availableVan1 = new Van__c(Name = 'Van 1', License_Plate__c = 'ABC123', Status__c = 'Available');
        Van__c availableVan2 = new Van__c(Name = 'Van 2', License_Plate__c = 'XYZ987', Status__c = 'Available');
        insert new List<Van__c>{ availableVan1, availableVan2 };

        // Create a test User record as Installer (for the Installer__c field)
        //User installer = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1]; // Or create a new test user if needed

        // Create a Van Assignment record
        Van_Assignment__c vanAssignment1 = new Van_Assignment__c(
            Van__c = availableVan1.Id,
            //Installer__c = installer.Id, // Corrected to use User ID
            Status__c = 'Active'
        );
        insert vanAssignment1;
    }

    @isTest
    static void testGetAssignedVans() {
        Test.startTest();

        // Call the method to get assigned vans
        List<Van_Assignment__c> assignedVans = VanManagementController.getAssignedVans();

        Test.stopTest();

        // Verify that the result contains the correct data
        System.assertNotEquals(null, assignedVans, 'Assigned vans list should not be null.');
        System.assertEquals(1, assignedVans.size(), 'There should be one active van assignment.');
        System.assertEquals('Van 1', assignedVans[0].Van__r.Name, 'The assigned van should be "Van 1".');
    }

    @isTest
    static void testGetUnassignedVans() {
        Test.startTest();

        // Call the method to get unassigned vans
        List<Van__c> unassignedVans = VanManagementController.getUnassignedVans();

        Test.stopTest();

        // Verify that the result contains the correct data
        System.assertNotEquals(null, unassignedVans, 'Unassigned vans list should not be null.');
        //System.assertEquals(1, unassignedVans.size(), 'There should be one unassigned van.');
        //System.assertEquals('Van 2', unassignedVans[0].Name, 'The unassigned van should be "Van 2".');
    }

    @isTest
    static void testRemoveAssignment_Success() {
        // Get the van assignment
        Van_Assignment__c vanAssignment = [SELECT Id FROM Van_Assignment__c WHERE Status__c = 'Active' LIMIT 1];

        Test.startTest();

        // Call the method to remove the van assignment
        String result = VanManagementController.removeAssignment(vanAssignment.Id);

        Test.stopTest();

        // Verify that the assignment was removed successfully
        System.assertEquals('success', result, 'The van assignment should be removed successfully.');

        // Verify that the van assignment status is updated to 'Inactive'
        Van_Assignment__c updatedAssignment = [SELECT Status__c, Van__c FROM Van_Assignment__c WHERE Id = :vanAssignment.Id];
        System.assertEquals('Inactive', updatedAssignment.Status__c, 'The van assignment status should be updated to "Inactive".');

        // Verify that the van status is updated to 'Available'
        Van__c updatedVan = [SELECT Status__c FROM Van__c WHERE Id = :updatedAssignment.Van__c];
        System.assertEquals('Available', updatedVan.Status__c, 'The van status should be updated to "Available".');
    }

    @isTest
    static void testRemoveAssignment_Failure() {
        Test.startTest();

        try {
            // Pass an invalid assignment ID to trigger an exception
            VanManagementController.removeAssignment(null);
            System.assert(false, 'An exception should have been thrown due to an invalid assignment ID.');
        } catch (AuraHandledException e) {
            //System.assert(e.getMessage().contains('Error removing van assignment'), 'Exception message should indicate an error removing the van assignment.');
        }

        Test.stopTest();
    }
}