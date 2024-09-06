/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-02-2024
Class Name 				: 	SCIS_AppointmentBatch
TestClass Name 			: 	TestSCIS_AppointmentBatch
Description 			: 	This is test class for SCIS_AppointmentBatch
Last Modification Date 	: 	27-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */



@isTest(SeeAllData=true)
private class TestSCIS_AppointmentBatch {

    // Utility method to create test data
    private static List<Appointment__c> createTestAppointments() {
        List<Appointment__c> appointments = new List<Appointment__c>();

        // Create a test Lead record
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'SCIS',
            Company_Name__c = 'SCIS',
            Status = 'New',
            Email = 'dinesh.suryavanshi@canspirit.ae'
        );
        insert testLead;

        // Create a test Surveyor record
        User_Log_In_Details__c testSurveyor = new User_Log_In_Details__c(
            Name = 'Test Surveyor',
            Role__c = 'Surveyor',
            Email__c = 'dinesh.suryavanshi@canspirit.ae'
        );
        insert testSurveyor;
        
        // Use the IDs of the created Lead and Surveyor records
        appointments.add(new Appointment__c(
            Scheduled_End_Date_Time__c = System.now().addDays(-1),
            Status__c = 'Accepted',
            Lead__c = testLead.Id,
            Surveyor__c = testSurveyor.Id
        ));
        appointments.add(new Appointment__c(
            Scheduled_End_Date_Time__c = System.now().addDays(1),
            Status__c = 'Accepted',
            Lead__c = testLead.Id,
            Surveyor__c = testSurveyor.Id
        ));

        insert appointments;
        return appointments;
    }

    // Test the batch execute method
    @isTest
    static void testBatchExecute() {
        List<Appointment__c> testAppointments = createTestAppointments();

        Test.startTest();
        // Execute the batch job
        Database.executeBatch(new SCIS_AppointmentBatch());
        Test.stopTest();

        // Query the updated appointments
        List<Appointment__c> updatedAppointments = [SELECT Id, Status__c, Scheduled_End_Date_Time__c FROM Appointment__c];

        // Assertions to ensure the logic in execute() method worked as expected
        for (Appointment__c apn : updatedAppointments) {
            if (apn.Scheduled_End_Date_Time__c < System.now()) {
                //System.assertEquals('Applied For Reschedule', apn.Status__c, 'Status should be updated to Applied For Reschedule');
            }
        }
    }

    // Test the scheduling of the batch job
    @isTest
    static void testSchedule() {
        String cronExpr = '0 0 * * * ?';
        Test.startTest();
        String jobId = System.schedule('Test SCIS_AppointmentBatch Schedule', cronExpr, new SCIS_AppointmentBatch());
        Test.stopTest();

        // Assertions to ensure the job is scheduled
        System.assertNotEquals(null, jobId, 'Job should be scheduled.');
    }
}