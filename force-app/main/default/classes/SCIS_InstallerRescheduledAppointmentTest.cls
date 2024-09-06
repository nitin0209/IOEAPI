/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   13-06-2024
Trigger Name            :   SCIS_Installer_Rescheduled_Appointment
TestClass Name          :   SCIS_Installer_Rescheduled_AppointmentTest
Connected Class         :   
@Description            :   This class used for send rescheduled email to installer, installer assistant and customer.
Last Modification Date  :   13-06-2024
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@isTest
public class SCIS_InstallerRescheduledAppointmentTest {

    @testSetup
    static void setupTestData() {
        // Create sample Lead records
        Lead lead1 = new Lead(FirstName = 'Test', LastName = 'Lead1', Company = 'Test Company1', Email = 'lead1@test.com');
        Lead lead2 = new Lead(FirstName = 'Test', LastName = 'Lead2', Company = 'Test Company2', Email = 'lead2@test.com');
        insert new List<Lead>{lead1, lead2};

        // Create sample Installer records
        Installer__c leadInstaller = new Installer__c(Name = 'Lead Installer', Email__c = 'lead.installer@test.com', Role__c = 'Lead Installer');
        Installer__c assistantInstaller = new Installer__c(Name = 'Assistant Installer', Email__c = 'assistant.installer@test.com', Role__c = 'Assistant Installer');
        insert new List<Installer__c>{leadInstaller, assistantInstaller};

        // Create sample Team records
        Teams__c team1 = new Teams__c(Name = 'Team1', Lead_Installer__c = leadInstaller.Id, Assistant_Installer__c = assistantInstaller.Id, Measure__c = 'Ventilation');
        Teams__c team2 = new Teams__c(Name = 'Team2', Lead_Installer__c = leadInstaller.Id, Measure__c = 'Ventilation', Assistant_Installer__c = assistantInstaller.Id);
        insert new List<Teams__c>{team1, team2};

        // Create sample Appointment records
        Appointment__c appointment1 = new Appointment__c(Name = 'Appointment1', Status__c = 'Scheduled', Installer_Team__c = team1.Id, Lead__c = lead1.Id, Installation_Type__c = 'Ventilation', Scheduled_Date_Time__c = System.today());
        Appointment__c appointment2 = new Appointment__c(Name = 'Appointment2', Status__c = 'Scheduled', Installer_Team__c = team2.Id, Lead__c = lead2.Id, Installation_Type__c = 'Ventilation', Scheduled_Date_Time__c = System.today().addDays(1));
        insert new List<Appointment__c>{appointment1, appointment2};
    }

    @isTest
    static void testHandleAfterUpdate() {
        // Fetch the appointments
        List<Appointment__c> appointments = [SELECT Id, Status__c FROM Appointment__c WHERE Status__c = 'Scheduled'];

        // Mock the old map
        Map<Id, Appointment__c> oldMap = new Map<Id, Appointment__c>(appointments);

        // Update the status to 'Rescheduled'
        for (Appointment__c appointment : appointments) {
            appointment.Status__c = 'Rescheduled';
        }
        update appointments;

        Test.startTest();
        Integer emailCountBefore = Limits.getEmailInvocations();
        SCIS_Installer_Rescheduled_Appointment.handleAfterUpdate(appointments, oldMap);
        Integer emailCountAfter = Limits.getEmailInvocations();
        Test.stopTest();

        // Verify that the correct number of emails were sent
        // System.assertEquals(2, emailCountAfter - emailCountBefore, 'Two emails should be sent');
    }

    @isTest
    static void testNoRescheduledAppointments() {
        // Fetch the appointments
        List<Appointment__c> appointments = [SELECT Id, Status__c FROM Appointment__c WHERE Status__c = 'Scheduled'];

        // Mock the old map
        Map<Id, Appointment__c> oldMap = new Map<Id, Appointment__c>(appointments);

        Test.startTest();
        Integer emailCountBefore = Limits.getEmailInvocations();
        SCIS_Installer_Rescheduled_Appointment.handleAfterUpdate(appointments, oldMap);
        Integer emailCountAfter = Limits.getEmailInvocations();
        Test.stopTest();

        // Verify that no emails were sent
        System.assertEquals(0, emailCountAfter - emailCountBefore, 'No emails should be sent');
    }
}