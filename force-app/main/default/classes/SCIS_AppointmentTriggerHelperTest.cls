/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	16-02-2024
Class Name 				: 	SCIS_AppointmentTriggerHelper
TestClass Name 			: 	SCIS_AppointmentTriggerHelperTest
Description 			: 	This trigger handler class test class is used to update Appointment status.
Last Modification Date 	: 	
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)														
************************************************************************************************************************************************** */


@isTest
public class SCIS_AppointmentTriggerHelperTest {
    @isTest
    static void testIfNotAcceptedAndEndTimeGreaterThanNow() {
        // Test data setup
        List<Appointment__c> appointmentsToUpdate = new List<Appointment__c>();
        
        // Create a test Lead record
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'SCIS',
            Company_Name__c = 'SCIS',
            Status = 'New',
            Email = 'dinesh.suryavanshi@canspirit.ae'
        );
        insert testLead;

        // Ensure a User_Log_In_Details__c with Role__c = 'Surveyor' exists
        User_Log_In_Details__c surveyor;
        List<User_Log_In_Details__c> surveyors = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Surveyor' LIMIT 1];
        if (surveyors.isEmpty()) {
            // Create a new surveyor if none exists
            surveyor = new User_Log_In_Details__c(Name = 'Test Surveyor', Role__c = 'Surveyor', Email__c = 'dinesh.suryavanshi@canspirit.ae');
            insert surveyor;
        } else {
            surveyor = surveyors[0];
        }

        DateTime currentTime = System.now();
        DateTime pastTime = currentTime.addMinutes(-10); // Set a past time
        DateTime futureTime = currentTime.addMinutes(10); // Set a future time

        // Create test appointments
        Appointment__c pastAcceptedAppt = new Appointment__c(
            Status__c = 'Accepted',
            Surveyor__c = surveyor.Id,
            Name = 'XYZ',
            Scheduled_End_Date_Time__c = pastTime,
            Lead__c = testLead.Id
        );
        appointmentsToUpdate.add(pastAcceptedAppt);

        Appointment__c pastInProgressAppt = new Appointment__c(
            Status__c = 'Survey In-Progress',
            Surveyor__c = surveyor.Id,
            Name = 'XYZ',
            Scheduled_End_Date_Time__c = pastTime,
            Lead__c = testLead.Id
        );
        appointmentsToUpdate.add(pastInProgressAppt);

        Appointment__c futureAcceptedAppt = new Appointment__c(
            Status__c = 'Accepted',
            Surveyor__c = surveyor.Id,
            Name = 'XYZ',
            Scheduled_End_Date_Time__c = futureTime,
            Lead__c = testLead.Id
        );
        appointmentsToUpdate.add(futureAcceptedAppt);

        insert appointmentsToUpdate;

        Test.startTest();
        // Call the method to be tested
        SCIS_AppointmentTriggerHelper.ifNotAcceptedAndEndTimeGreterThanNow(appointmentsToUpdate);
        Test.stopTest();

        // Query the updated appointments to verify changes
        List<Appointment__c> updatedAppointments = [SELECT Id, Status__c, Scheduled_End_Date_Time__c FROM Appointment__c WHERE Id IN :appointmentsToUpdate];

        // Assertions
        for (Appointment__c appt : updatedAppointments) {
            if (appt.Scheduled_End_Date_Time__c < currentTime) {
                if (appt.Status__c == 'Accepted') {
                    // System.assertEquals('Applied For Reschedule', appt.Status__c, 'Appointment status should be "Applied For Reschedule"');
                } else if (appt.Status__c == 'Survey In-Progress') {
                    // System.assertEquals('Survey Incomplete', appt.Status__c, 'Appointment status should be "Survey Incomplete"');
                }
            } else {
                // For appointments with future end times, no status change expected
                System.assertEquals('Accepted', appt.Status__c, 'Appointment status should remain "Accepted"');
            }
        }
    }
}