/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   13-06-2024
Trigger Name            :   SCIS_RescheduledAppointmentTrigger
TestClass Name          :   SCIS_RescheduledAppointmentTriggerTest
Connected Class         :   
@Description            :   This trigger execute when update the status of Install lead as rescheduled.
Last Modification Date  :   13-06-2024
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@isTest
public class SCIS_RescheduledAppointmentTriggerTest {
    @testSetup
    static void setupTestData() {
        // Create test data for Appointment__c
        List<Appointment__c> appointments = new List<Appointment__c>();
        appointments.add(new Appointment__c(Name = 'Test Appointment 1', Scheduled_Date_Time__c = Date.today(), Status__c = 'Rescheduled'));
        appointments.add(new Appointment__c(Name = 'Test Appointment 2', Scheduled_Date_Time__c = Date.today().addDays(1), Status__c = 'Rescheduled'));
        insert appointments;
    }

    @isTest
    static void testRescheduledAppointmentTrigger() {
        // Fetch the test data
        List<Appointment__c> appointments = [SELECT Id, Name, Scheduled_Date_Time__c, Status__c FROM Appointment__c];
        
        // Modify the appointments to simulate rescheduling
        for (Appointment__c appt : appointments) {
            appt.Scheduled_Date_Time__c = appt.Scheduled_Date_Time__c.addDays(2);
        }
        
        // Start test context
        Test.startTest();
        
        // Update the appointments to trigger the after update trigger
        update appointments;
        
        // Stop test context
        Test.stopTest();
        
        // Add assertions to verify the behavior of the handleAfterUpdate method
        // This part depends on what the handleAfterUpdate method is supposed to do.
        // For example, if it sets a field on the appointments, you could check that:
        for (Appointment__c appt : [SELECT Id, Name, Scheduled_Date_Time__c, Status__c FROM Appointment__c]) {
            // Assuming handleAfterUpdate sets Status__c to 'Rescheduled' on reschedule
            System.assertEquals('Rescheduled', appt.Status__c, 'The appointment status should be updated to Rescheduled.');
        }
    }
}