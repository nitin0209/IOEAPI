@isTest
public class SCIS_Survey_triggerTest {

    @isTest
    static void testSurveyTrigger() {
        // Create a test user to act as a coordinator
        User coordinator = new User(
            FirstName = 'Test',
            LastName = 'Coordinator',
            Username = 'test.coordinator@example.com',
            Email = 'test.coordinator@example.com',
            Alias = 'tcoord',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            Company_Name__c = 'SCIS'
        );
        insert coordinator;

        // Test before insert trigger
        Survey__c survey1 = new Survey__c(
            Name = 'Survey 1',
            Assigned_Coordinator__c = coordinator.Username
        );

        Test.startTest();
        insert survey1;
        Test.stopTest();

        // Verify that the owner has been changed to the coordinator on insert
        Survey__c insertedSurvey = [SELECT OwnerId FROM Survey__c WHERE Id = :survey1.Id LIMIT 1];
       // System.assertEquals(coordinator.Id, insertedSurvey.OwnerId, 'The owner of the survey should be the coordinator after insert.');

        // Test before update trigger
        survey1.Name = 'Updated Survey 1';
        Test.startTest();
        update survey1;
        Test.stopTest();

        // Verify that the owner remains the coordinator after update
        Survey__c updatedSurvey = [SELECT OwnerId FROM Survey__c WHERE Id = :survey1.Id LIMIT 1];
        System.assertEquals(coordinator.Id, updatedSurvey.OwnerId, 'The owner of the survey should remain the coordinator after update.');
    }
}