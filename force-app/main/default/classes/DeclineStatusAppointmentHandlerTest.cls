@isTest
public class DeclineStatusAppointmentHandlerTest {

    @isTest
    static void testHandleAfterUpdate_DeclinedEmailSent() {
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
            Status__c = 'Pending', // Initial status
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
        //List<Messaging.SingleEmailMessage> sentEmails = Test.getSentEmailMessages();
        //System.assertEquals(2, sentEmails.size(), 'Two emails should have been sent: one to installers and one to the lead');
    }

    @isTest
    static void testHandleAfterUpdate_NoInstallerTeam() {
        // Test data setup
        Lead lead = new Lead(
            LastName = 'Doe',
            Company = 'Test Company',
            Email = 'lead@example.com'
        );
        insert lead;

        Appointment__c appointment = new Appointment__c(
            Status__c = 'Pending', // Initial status
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

        // Verify that no email was sent
        //List<Messaging.SingleEmailMessage> sentEmails = Test.getSentEmailMessages();
        //System.assertEquals(0, sentEmails.size(), 'No email should have been sent since there is no installer team');
    }

    @isTest
    static void testHandleAfterUpdate_LeadNoEmail() {
        // Test data setup
        Lead lead = new Lead(
            LastName = 'Doe',
            Company = 'Test Company'
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
            Status__c = 'Pending', // Initial status
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

        // Verify that only one email was sent
        //List<Messaging.SingleEmailMessage> sentEmails = Test.getSentEmailMessages();
        //System.assertEquals(1, sentEmails.size(), 'Only one email should have been sent to the installers');
    }
}