@isTest
public class InstallerTriggerTest {
    
    @isTest
    static void testInstallerTrigger_Insert() {
        // Step 1: Create a new Installer__c record
        Installer__c testInstaller = new Installer__c(
            Name = 'Test Installer',
            Role__c = 'ABC'
            // Add other required fields here
        );

        Test.startTest();
        // Step 2: Insert the Installer record to trigger the after insert logic
        insert testInstaller;
        Test.stopTest();

        // Step 3: Verify that InstallerHandler.syncInstallerToEmployee was called correctly
        // You would normally mock the method or query records to verify the expected results
        // Example: Verify related Employee record if created or updated
        // Employee__c emp = [SELECT Id, Name FROM Employee__c WHERE Installer__c = :testInstaller.Id LIMIT 1];
        // System.assertNotEquals(null, emp, 'Employee record should have been created/updated.');
    }
    
    @isTest
    static void testInstallerTrigger_Update() {
        // Step 1: Create and insert an Installer__c record
        Installer__c testInstaller = new Installer__c(
            Name = 'Test Installer',
            Role__c = 'XYZ'
            // Add other required fields here
        );
        insert testInstaller;

        // Step 2: Update the Installer__c record to trigger the after update logic
        testInstaller.Name = 'Updated Installer Name';
        
        Test.startTest();
        update testInstaller;
        Test.stopTest();

        // Step 3: Verify that InstallerHandler.syncInstallerToEmployee was called correctly
        // You would query records or check that the relevant sync occurred
        // Example: Verify the updated Employee record
        // Employee__c emp = [SELECT Id, Name FROM Employee__c WHERE Installer__c = :testInstaller.Id LIMIT 1];
        // System.assertEquals('Updated Installer Name', emp.Name, 'Employee record should have been updated.');
    }
}