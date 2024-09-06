@isTest
public class AppointmentStatusHandlerTest {

    @isTest
    static void testHandleAfterUpdate_EmailSent() {
        // Test data setup
        Installer__c leadInstaller = new Installer__c(
            Name = 'Jacob',
            Role__c = 'Lead Installer',
            Email__c = 'lead@gmail.com',
            Phone__c = '7898789878',
            Is_team_member__c = true
        );
        insert leadInstaller;

        Installer__c assistantInstaller = new Installer__c(
            Name = 'James',
            Role__c = 'Assistant Installer',
            Email__c = 'assistant@gmail.com',
            Phone__c = '7898589878',
            Is_team_member__c = true
        );
        insert assistantInstaller;

        Teams__c team = new Teams__c(
            Name = 'Test Team',
            Measure__c = 'Ventilation',
            Lead_Installer__c = leadInstaller.Id,
            Assistant_Installer__c = assistantInstaller.Id,
            Region__c = 'a2gUE0000005tBxYAI'
        );
        insert team;

        Appointment__c appointment = new Appointment__c(
            Status__c = 'Accepted',
            Installer_Team__c = team.Id,
            Measure__c = 'Ventilation'
        );
        insert appointment;

        // Simulate old appointment status as not accepted
        Map<Id, Appointment__c> oldAppointmentMap = new Map<Id, Appointment__c>{
            appointment.Id => new Appointment__c(Status__c = 'Pending')
        };

        // Start test
        Test.startTest();
        AppointmentStatusHandler.handleAfterUpdate(new List<Appointment__c>{ appointment }, oldAppointmentMap);
        Test.stopTest();

        // Verify that an email was sent
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject FROM EmailMessage WHERE Subject LIKE 'Appointment Accepted%' AND ToAddress = 'lead@gmail.com'];
        System.assertNotEquals(0, sentEmails.size(), 'An email should have been sent');
    }

    @isTest
    static void testHandleAfterUpdate_NoEmailSent() {
        // Test data setup
        Installer__c leadInstaller = new Installer__c(
            Name = 'Jacob',
            Role__c = 'Lead Installer',
            Email__c = 'lead@gmail.com',
            Phone__c = '7898789878',
            Is_team_member__c = true
        );
        insert leadInstaller;

        Installer__c assistantInstaller = new Installer__c(
            Name = 'James',
            Role__c = 'Assistant Installer',
            Email__c = 'assistant@gmail.com',
            Phone__c = '7898589878',
            Is_team_member__c = true
        );
        insert assistantInstaller;

        Teams__c team = new Teams__c(
            Name = 'Test Team',
            Measure__c = 'Ventilation',
            Lead_Installer__c = leadInstaller.Id,
            Assistant_Installer__c = assistantInstaller.Id,
            Region__c = 'a2gUE0000005tBxYAI'
        );
        insert team;

        Appointment__c appointment = new Appointment__c(
            Status__c = 'Accepted',
            Installer_Team__c = team.Id
        );
        insert appointment;

        // Simulate old appointment status as also accepted
        Map<Id, Appointment__c> oldAppointmentMap = new Map<Id, Appointment__c>{
            appointment.Id => new Appointment__c(Status__c = 'Accepted')
        };

        // Start test
        Test.startTest();
        AppointmentStatusHandler.handleAfterUpdate(new List<Appointment__c>{ appointment }, oldAppointmentMap);
        Test.stopTest();

        // Verify that no email was sent
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject FROM EmailMessage WHERE Subject LIKE 'Appointment Accepted%' AND ToAddress = 'lead@gmail.com'];
        System.assertEquals(0, sentEmails.size(), 'No email should have been sent');
    }

    @isTest
    static void testSendAcceptedAppointmentEmails_NoInstallerTeam() {
        // Test data setup
        Appointment__c appointment = new Appointment__c(
            Status__c = 'Accepted',
            Installer_Team__c = null
        );
        insert appointment;

        // Start test
        Test.startTest();
        AppointmentStatusHandler.sendAcceptedAppointmentEmails(new List<Appointment__c>{ appointment });
        Test.stopTest();

        // Verify that no email was sent
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject FROM EmailMessage WHERE Subject LIKE 'Appointment Accepted%'];
        System.assertEquals(0, sentEmails.size(), 'No email should have been sent');
    }

    @isTest
    static void testDeclineStatusHandler() {
        // Test data setup
        Lead lead = new Lead(
            LastName = 'Doe',
            Company = 'Test Company',
            Email = 'lead@example.com'
        );
        insert lead;

        Installer__c leadInstaller = new Installer__c(
            Name = 'Jacob',
            Role__c = 'Lead Installer',
            Email__c = 'lead@gmail.com',
            Phone__c = '7898789878',
            Is_team_member__c = true
        );
        insert leadInstaller;

        Installer__c assistantInstaller = new Installer__c(
            Name = 'James',
            Role__c = 'Assistant Installer',
            Email__c = 'assistant@gmail.com',
            Phone__c = '7898589878',
            Is_team_member__c = true
        );
        insert assistantInstaller;

        Teams__c team = new Teams__c(
            Name = 'Test Team',
            Measure__c = 'Ventilation',
            Lead_Installer__c = leadInstaller.Id,
            Assistant_Installer__c = assistantInstaller.Id,
            Region__c = 'a2gUE0000005tBxYAI'
        );
        insert team;

        Appointment__c appointment = new Appointment__c(
            Status__c = 'Pending',
            Installer_Team__c = team.Id,
            Lead__c = lead.Id,
            Measure__c = 'Ventilation'
        );
        insert appointment;

        // Update status to 'Declined'
        appointment.Status__c = 'Declined';
        update appointment;

        // Simulate old appointment status as 'Pending'
        Map<Id, Appointment__c> oldAppointmentMap = new Map<Id, Appointment__c>{
            appointment.Id => new Appointment__c(Status__c = 'Pending')
        };

        // Start test
        Test.startTest();
        DeclineStatusAppointmentHandler.handleAfterUpdate(new List<Appointment__c>{ appointment }, oldAppointmentMap);
        Test.stopTest();

        // Verify that emails were sent
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject FROM EmailMessage WHERE Subject LIKE 'Appointment Declined%'];
        System.assertNotEquals(0, sentEmails.size(), 'Emails should have been sent for declined appointment');
    }

    @isTest
    static void testRescheduledHandler() {
        // Test data setup
        Lead lead = new Lead(
            LastName = 'Doe',
            Company = 'Test Company',
            Email = 'lead@example.com'
        );
        insert lead;

        Installer__c leadInstaller = new Installer__c(
            Name = 'Jacob',
            Role__c = 'Lead Installer',
            Email__c = 'lead@gmail.com',
            Phone__c = '7898789878',
            Is_team_member__c = true
        );
        insert leadInstaller;

        Installer__c assistantInstaller = new Installer__c(
            Name = 'James',
            Role__c = 'Assistant Installer',
            Email__c = 'assistant@gmail.com',
            Phone__c = '7898589878',
            Is_team_member__c = true
        );
        insert assistantInstaller;

        Teams__c team = new Teams__c(
            Name = 'Test Team',
            Measure__c = 'Ventilation',
            Lead_Installer__c = leadInstaller.Id,
            Assistant_Installer__c = assistantInstaller.Id,
            Region__c = 'a2gUE0000005tBxYAI'
        );
        insert team;

        Appointment__c appointment = new Appointment__c(
            Status__c = 'Pending',
            Installer_Team__c = team.Id,
            Lead__c = lead.Id,
            Measure__c = 'Ventilation'
        );
        insert appointment;

        // Update the appointment date and time to simulate rescheduling
        appointment.Scheduled_Date_Time__c = System.now().addDays(2);
        update appointment;

        // Simulate old appointment date and time
        Map<Id, Appointment__c> oldAppointmentMap = new Map<Id, Appointment__c>{
            appointment.Id => new Appointment__c(Status__c = 'Pending', Scheduled_Date_Time__c = System.now().addDays(1))
        };

        // Start test
        Test.startTest();
        SCIS_Installer_Rescheduled_Appointment.handleAfterUpdate(new List<Appointment__c>{ appointment }, oldAppointmentMap);
        Test.stopTest();

      
    }
}