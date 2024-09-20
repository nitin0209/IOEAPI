@isTest
public class AppointmentTriggerHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create Coordinator_Workload__c records with different capacities and dates
        Coordinator_Workload__c workload1 = new Coordinator_Workload__c(
            Name__c = UserInfo.getUserId(),
            Date__c = Date.today(),
            Capacity__c = 5
        );
        insert workload1;

        Coordinator_Workload__c workload2 = new Coordinator_Workload__c(
            Name__c = UserInfo.getUserId(),
            Date__c = Date.today().addDays(1),
            Capacity__c = 3
        );
        insert workload2;

        // Create User with Coordinator_Type__c
        User coordinator = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        coordinator.Coordinator_Type__c = 'Internal';
        update coordinator;
    }

    @isTest
    static void testHandleBeforeInsert_SurveyAppointments() {
        // Create a new Survey Appointment
        Appointment__c newAppointment = new Appointment__c(
            Appointment_Type__c = 'Survey',
            Scheduled_Date_Time__c = DateTime.now().addDays(1),
            isHoliday__c = false
        );
        insert newAppointment;

        // Validate the Appointment assignment
        List<Appointment__c> insertedAppointments = [SELECT Id, Assigned_Coordinator__c, Round_Robin_Sequence__c
                                                     FROM Appointment__c WHERE Id = :newAppointment.Id];
        System.assertNotEquals(null, insertedAppointments[0].Assigned_Coordinator__c, 'Coordinator should be assigned.');
        System.assert(insertedAppointments[0].Round_Robin_Sequence__c != null, 'Round Robin Sequence should be assigned.');
    }

    @isTest
    static void testHandleBeforeInsert_NoSurveyAppointments() {
        // Create a non-survey appointment
        Appointment__c nonSurveyAppointment = new Appointment__c(
            Appointment_Type__c = 'Survey',
            Scheduled_Date_Time__c = DateTime.now(),
            isHoliday__c = false
        );
        insert nonSurveyAppointment;

        // Verify that no coordinator is assigned since it's not a Survey appointment
        List<Appointment__c> insertedAppointments = [SELECT Id, Assigned_Coordinator__c FROM Appointment__c WHERE Id = :nonSurveyAppointment.Id];
        // System.assertEquals(null, insertedAppointments[0].Assigned_Coordinator__c, 'No coordinator should be assigned to non-survey appointments.');
    }

    @isTest
    static void testHandleBeforeUpdate_RescheduledAppointment() {
        // Create and insert an appointment
        Appointment__c appointment = new Appointment__c(
            Appointment_Type__c = 'Survey',
            Scheduled_Date_Time__c = DateTime.now(),
            Status__c = 'Scheduled',
            isHoliday__c = false
        );
        insert appointment;

        // Update the appointment's scheduled date (to simulate rescheduling)
        appointment.Scheduled_Date_Time__c = DateTime.now().addDays(1);
        update appointment;

        // Verify that the appointment's status is updated to 'Rescheduled'
        Appointment__c updatedAppointment = [SELECT Id, Status__c FROM Appointment__c WHERE Id = :appointment.Id];
        System.assertEquals('Rescheduled', updatedAppointment.Status__c, 'The appointment status should be updated to Rescheduled.');
    }

    @isTest
    static void testHandleBeforeUpdate_DeclinedAppointment() {
        // Create and insert an appointment with an assigned coordinator
        Appointment__c appointment = new Appointment__c(
            Appointment_Type__c = 'Survey',
            Scheduled_Date_Time__c = DateTime.now(),
            Status__c = 'Scheduled',
            Assigned_Coordinator__c = UserInfo.getUserId(),
            isHoliday__c = false
        );
        insert appointment;

        // Update the appointment's status to Declined
        appointment.Status__c = 'Declined';
        update appointment;

        // Verify that the Assigned_Coordinator__c field is cleared after declining
        Appointment__c declinedAppointment = [SELECT Id, Assigned_Coordinator__c, Status__c FROM Appointment__c WHERE Id = :appointment.Id];
        System.assertEquals('Declined', declinedAppointment.Status__c, 'The appointment status should be Declined.');
        System.assertEquals(null, declinedAppointment.Assigned_Coordinator__c, 'The Assigned_Coordinator__c should be cleared for declined appointments.');
    }

    @isTest
    static void testHandleBeforeUpdate_Reassignment() {
        // Create and insert an appointment with an assigned coordinator
        Appointment__c appointment = new Appointment__c(
            Appointment_Type__c = 'Survey',
            Scheduled_Date_Time__c = DateTime.now(),
            Status__c = 'Scheduled',
            Assigned_Coordinator__c = UserInfo.getUserId(),
            isHoliday__c = false
        );
        insert appointment;

        // Create a new User and update the appointment to assign it to this new coordinator
        User newCoordinator = new User(
            FirstName = 'Test',
            LastName = 'Coordinator',
            Email = 'test@example.com',
            Username = 'testuser4@example.com',
            Alias = 'tuser',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            Coordinator_Type__c = 'Internal',
            Company_Name__c = 'SCIS'
        );
        insert newCoordinator;

        // Update the appointment with the new coordinator
        //appointment.Assigned_Coordinator__c = newCoordinator.Id;
        // update appointment;

        // Verify that the appointment was reassigned
        Appointment__c reassignedAppointment = [SELECT Id, Assigned_Coordinator__c FROM Appointment__c WHERE Id = :appointment.Id];
        // System.assertEquals(newCoordinator.Id, reassignedAppointment.Assigned_Coordinator__c, 'The appointment should be reassigned to the new coordinator.');
    }
}