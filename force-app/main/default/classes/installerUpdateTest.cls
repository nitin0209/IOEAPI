@isTest
public class installerUpdateTest {

    @isTest
    static void testInstallerUpdate_AfterUpdate() {
        // Step 1: Create and insert an Installer__c record
        Installer__c testInstaller = new Installer__c(
            Name = 'Test Installer',
            Role__c = 'ABC'
            // Add other required fields if any
        );
        insert testInstaller;

        // Step 2: Modify the Installer__c record to trigger after update logic
        testInstaller.Name = 'Updated Installer Name';

        Test.startTest();
        // Step 3: Update the Installer__c record to invoke the trigger
        update testInstaller;
        Test.stopTest();

        // Step 4: Verify that InstallerUpdateHandler.employeeUpdation was called correctly
        // You would normally query the related employee or other updates expected from employeeUpdation
        // Example:
        // Employee__c emp = [SELECT Id, Name FROM Employee__c WHERE Installer__c = :testInstaller.Id LIMIT 1];
        // System.assertEquals('Updated Installer Name', emp.Name, 'The employee record should have been updated.');
    }
}