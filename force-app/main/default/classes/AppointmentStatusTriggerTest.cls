@isTest
public class AppointmentStatusTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Setup test data, for example creating an Appointment__c record if needed
        Appointment__c testAppointment = new Appointment__c(
            Name = 'Test Appointment',
            Status__c = 'Scheduled',
            Date__c = Date.today()
        );
        insert testAppointment;
    }

    @isTest
    static void testAfterInsert() {
        // Step 1: Create a new appointment record
        Appointment__c newAppointment = new Appointment__c(
            Name = 'New Test Appointment',
            Status__c = 'Scheduled',
            Date__c = Date.today().addDays(1)
        );
        
        Test.startTest();
        insert newAppointment;
        Test.stopTest();
        
        // Step 2: Verify that the after insert logic was executed successfully
        // Depending on what `AppointmentHandler.handleAfterInsert` does, you can assert results here.
        // Example assertion:
        Appointment__c insertedAppointment = [SELECT Id, Status__c FROM Appointment__c WHERE Id = :newAppointment.Id];
        System.assertEquals('Scheduled', insertedAppointment.Status__c, 'The status should remain Scheduled after insert.');
    }

    @isTest
    static void testAfterUpdate() {
        // Step 1: Query the previously inserted appointment
        Appointment__c testAppointment = [SELECT Id, Status__c, Date__c FROM Appointment__c LIMIT 1];
        
        // Step 2: Modify the appointment to trigger an update
        testAppointment.Status__c = 'Rescheduled';
        testAppointment.Date__c = Date.today().addDays(5);

        Test.startTest();
        update testAppointment;
        Test.stopTest();
        
        // Step 3: Verify that the after update logic was executed successfully
        // Check the results of `AppointmentStatusHandler.handleAfterUpdate`, `DeclineStatusAppointmentHandler.handleAfterUpdate`, 
        // and `SCIS_Installer_Rescheduled_Appointment.handleAfterUpdate`
        
        Appointment__c updatedAppointment = [SELECT Id, Status__c FROM Appointment__c WHERE Id = :testAppointment.Id];
        System.assertEquals('Rescheduled', updatedAppointment.Status__c, 'The status should be updated to Rescheduled.');
        
        // Additional verifications depending on the logic inside your handlers
    }

    @isTest
    static void testExceptionHandlingForInsert() {
        // Insert an invalid Appointment to simulate an exception in after insert
        Appointment__c invalidAppointment = new Appointment__c(
            Name = null, // Assuming Name is required
            Status__c = 'Scheduled',
            Date__c = Date.today().addDays(1)
        );
        
        Test.startTest();
        try {
            insert invalidAppointment;
            System.assert(false, 'Insert should have thrown an exception.');
        } catch (DmlException e) {
            System.assert(true, 'Exception caught as expected.');
        }
        Test.stopTest();
    }

    @isTest
    static void testExceptionHandlingForUpdate() {
        // Query a valid Appointment
        Appointment__c testAppointment = [SELECT Id, Status__c FROM Appointment__c LIMIT 1];
        
        // Modify it in a way that might cause an exception in after update logic
        testAppointment.Status__c = 'Rescheduled';
        
        Test.startTest();
        try {
            update testAppointment;
            System.assert(true, 'Update should pass successfully.');
        } catch (DmlException e) {
            System.assert(false, 'Update should not throw an exception.');
        }
        Test.stopTest();
    }
}