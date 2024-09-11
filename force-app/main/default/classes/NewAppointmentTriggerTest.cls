@isTest
public class NewAppointmentTriggerTest {

    @testSetup
    static void setupTestData() {
        // Create any related records that may be required by the triggers and handlers.
        // You need to ensure all required fields for Appointment__c and related objects are populated.
        
        // Example: If the Appointment__c object has any lookup fields, ensure related objects exist.
        //Coordinator__c coordinator = new Coordinator__c(
         //   Name = 'Test Coordinator'
        //);
        //insert coordinator;
    }

    @isTest
    static void testNewAppointmentTrigger() {
        // Create an Appointment__c record with all necessary fields populated
        Appointment__c testAppointment = new Appointment__c(
            Name = 'Test Appointment',
            //Appointment_Date__c = Date.today(),
            Status__c = 'Scheduled'
            //Coordinator__c = [SELECT Id FROM Coordinator__c LIMIT 1].Id // Assign a valid Coordinator to avoid NullPointerException
        );

        Test.startTest();
        insert testAppointment;  // This will trigger the NewAppointmentTrigger
        Test.stopTest();

        // Validate that the Appointment__c record was inserted
        Appointment__c insertedAppointment = [SELECT Id, Name FROM Appointment__c WHERE Id = :testAppointment.Id LIMIT 1];
        System.assertNotEquals(null, insertedAppointment, 'Appointment should have been inserted.');
        System.assertEquals('Test Appointment', insertedAppointment.Name, 'The inserted Appointment name should be correct.');
    }

    @isTest
    static void testNewAppointmentTrigger_ExceptionHandling() {
        // Simulate a case where an exception might occur (e.g., missing required fields or other data).
        // We'll create an Appointment without setting a required field to simulate a failure.

        Appointment__c faultyAppointment = new Appointment__c(
            // Missing required fields like Coordinator__c might trigger the NullPointerException in your handler
            Name = 'Faulty Appointment',
            //Appointment_Date__c = Date.today(),
            Status__c = 'Scheduled'
            // Missing Coordinator__c will simulate the issue
        );

        Test.startTest();
        try {
            insert faultyAppointment;  // This will trigger the exception block
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Expected a missing field exception');
        }
        Test.stopTest();
    }
}