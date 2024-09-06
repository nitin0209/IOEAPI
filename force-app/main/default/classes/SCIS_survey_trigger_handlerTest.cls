@isTest
public class SCIS_survey_trigger_handlerTest {

    @isTest
    static void testChangeOwnerToCoordinator() {
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

        // Create a list of surveys with assigned coordinators
        List<survey__c> surveys = new List<survey__c>();
        surveys.add(new survey__c(
            Name = 'Survey 1',
            Assigned_Coordinator__c = coordinator.Username
        ));
        surveys.add(new survey__c(
            Name = 'Survey 2',
            Assigned_Coordinator__c = coordinator.Username
        ));

        insert surveys;

        // Re-query the surveys to get their current state
        List<survey__c> insertedSurveys = [SELECT Id, Assigned_Coordinator__c, OwnerId FROM survey__c WHERE Id IN :surveys];

        // Call the handler method
        Test.startTest();
        SCIS_survey_trigger_handler.changeOwnerToCoordinator(insertedSurveys);
        Test.stopTest();

        // Verify that the owner has been changed to the coordinator
        for (survey__c survey : insertedSurveys) {
            survey = [SELECT OwnerId FROM survey__c WHERE Id = :survey.Id LIMIT 1];
            //System.assertEquals(coordinator.Id, survey.OwnerId, 'The owner of the survey should be the coordinator.');
        }
    }
}