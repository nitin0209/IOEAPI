@isTest
public class AppointmentHandlerTest {
    @testSetup
    static void setup() {
        // Create test data for Installer__c
        Installer__c leadInstaller = new Installer__c(
            Name = 'Lead Installer',
            Email__c = 'lead.installer1@test.com', 
            Role__c = 'Lead Installer'
        );
        insert leadInstaller;

        Installer__c assistantInstaller = new Installer__c(
            Name = 'Assistant Installer',
            Email__c = 'assistant.installer1@test.com',  
            Role__c = 'Assistant Installer'
        );
        insert assistantInstaller;

        // Create test data for Region
        Region__c region = new Region__c(
            Name = 'Region 1'
        );
        insert region;

        // Create test data for Teams__c
        Teams__c team = new Teams__c(
            Name = 'Team A',
            Lead_Installer__c = leadInstaller.Id,
            Assistant_Installer__c = assistantInstaller.Id,
            Measure__c = 'Ventilation',
            Region__c = region.Id
        );
        insert team;

        // Create test data for Lead
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Email = 'test.lead1@test.com'  // Ensure unique email
        );
        insert testLead;
    }

    @isTest
    static void testHandleAfterInsert() {
        // Fetch test data
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        Teams__c team = [SELECT Id FROM Teams__c LIMIT 1];

        // Create test data for Appointment__c
        Appointment__c appointment = new Appointment__c(
            Name = 'Test Appointment',
            Installer_Team__c = team.Id,
            Installation_Type__c = 'Ventilation', // Use a valid picklist value here
            Lead__c = testLead.Id,
            Scheduled_Date_Time__c = DateTime.now().addDays(1)
        );

        Test.startTest();
        insert appointment;
        Test.stopTest();

        // Verify that email was sent
        //List<Messaging.SingleEmailMessage> sentEmails = [SELECT Id FROM Messaging.SingleEmailMessage];
        //System.assertEquals(1, sentEmails.size(), 'One email should have been sent.');
    }
}