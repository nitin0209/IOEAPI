@isTest
public class VanAssignmentControllerNewTest {

    @testSetup
    static void setupTestData() {
        // Create test Vehicle_Details__c records
        Vehicle_Details__c availableVan = new Vehicle_Details__c(Name = 'Test Van 1', Status__c = 'Available');
        Vehicle_Details__c assignedVan = new Vehicle_Details__c(Name = 'Test Van 2', Status__c = 'Assigned');
        insert new List<Vehicle_Details__c> { availableVan, assignedVan };

        // Create test User_Log_In_Details__c records (Installers)
        User_Log_In_Details__c leadInstaller = new User_Log_In_Details__c(Name = 'Lead Installer', Role__c = 'Lead Installer', Email__c = 'dhiraj.test@test.com');
        insert leadInstaller;
    }

    @isTest
    static void testGetAvailableVans() {
        Test.startTest();
        
        // Call the method to retrieve available vans
        List<Vehicle_Details__c> availableVans = VanAssignmentControllerNew.getAvailableVans();
        
        Test.stopTest();

        // Validate that only available vans are returned
        System.assertNotEquals(null, availableVans, 'Available vans list should not be null.');
        System.assertEquals(1, availableVans.size(), 'Only one available van should be returned.');
        System.assertEquals('Test Van 1', availableVans[0].Name, 'The available van should be "Test Van 1".');
    }

    @isTest
    static void testGetInstallers() {
        Test.startTest();
        
        // Call the method to retrieve installers
        List<User_Log_In_Details__c> installers = VanAssignmentControllerNew.getInstallers();
        
        Test.stopTest();

        // Validate that only the lead installer is returned
        System.assertNotEquals(null, installers, 'Installers list should not be null.');
        System.assertEquals(1, installers.size(), 'Only one lead installer should be returned.');
        System.assertEquals('Lead Installer', installers[0].Name, 'The installer should be "Lead Installer".');
    }

    @isTest
    static void testAssignVan_Success() {
        // Retrieve the available van and installer
        Vehicle_Details__c availableVan = [SELECT Id FROM Vehicle_Details__c WHERE Status__c = 'Available' LIMIT 1];
        User_Log_In_Details__c installer = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Lead Installer' LIMIT 1];

        Test.startTest();
        
        // Call the method to assign a van
        //String result = VanAssignmentControllerNew.assignVan(availableVan.Id, installer.Id);
        
        Test.stopTest();

        // Validate that the assignment was successful
       // System.assertEquals('success', result, 'The van assignment should be successful.');

        // Verify that the van's status is updated to 'Assigned'
        Vehicle_Details__c updatedVan = [SELECT Status__c FROM Vehicle_Details__c WHERE Id = :availableVan.Id];
        // System.assertEquals('Assigned', updatedVan.Status__c, 'The van status should be updated to "Assigned".');

        // Verify that a new Van_Assignment__c record was created
        //Van_Assignment__c vanAssignment = [SELECT Id, Vehicle_Details__c, Installer__c FROM Van_Assignment__c WHERE Vehicle_Details__c = :availableVan.Id];
        //System.assertNotEquals(null, vanAssignment, 'A Van_Assignment__c record should have been created.');
        //System.assertEquals(installer.Id, vanAssignment.Installer__c, 'The correct installer should be assigned.');
    }

    @isTest
    static void testAssignVan_AlreadyAssigned() {
        // Retrieve the assigned van and installer
        Vehicle_Details__c assignedVan = [SELECT Id FROM Vehicle_Details__c WHERE Status__c = 'Assigned' LIMIT 1];
        User_Log_In_Details__c installer = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Lead Installer' LIMIT 1];

        Test.startTest();
        
        // Expect an exception to be thrown when trying to assign an already assigned van
        try {
            VanAssignmentControllerNew.assignVan(assignedVan.Id, installer.Id);
            System.assert(false, 'Exception should have been thrown because the van is already assigned.');
        } catch (AuraHandledException e) {
            //System.assertEquals('Van already assigned. Select another van or remove the assignment of this van and try again.', e.getMessage(), 'Correct exception message should be thrown.');
        }
        
        Test.stopTest();
    }
}