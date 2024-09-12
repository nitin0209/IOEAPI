@isTest
public class ReparentFilesToSurveyHandlerTest {

    @isTest
    static void testReparentFiles() {
        // Step 1: Create test data
        // Insert a Survey__c record
        Survey__c survey = new Survey__c(Name = 'Test Survey');
        insert survey;

        // Insert an ERF__c record related to the Survey
        ERF__c erf = new ERF__c(Name = 'Test ERF', Survey__c = survey.Id);
        insert erf;

        // Insert a ContentVersion record related to the ERF
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test File',
            VersionData = Blob.valueOf('Test data'),
            PathOnClient = 'Test_File.pdf',
            IsMajorVersion = true,
            FirstPublishLocationId = erf.Id
        );
        insert contentVersion;

        // Verify that the ContentVersion was inserted and fetch its associated ContentDocumentId
        ContentVersion insertedVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        
        // Step 2: Call the reparentFiles method
        Test.startTest();
        List<ERF__c> erfList = new List<ERF__c>{erf};
        ReparentFilesToSurveyHandler.reparentFiles(erfList);
        Test.stopTest();

        // Step 3: Assert that a new ContentDocumentLink was created for the Survey
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :survey.Id];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink created for the Survey');
        System.assertEquals(insertedVersion.ContentDocumentId, links[0].ContentDocumentId, 'The ContentDocumentId should match the original file');
        System.assertEquals(survey.Id, links[0].LinkedEntityId, 'The LinkedEntityId should be the Survey');
        
        // Step 4: Assert that no duplicate links exist
        System.assertEquals(1, [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId = :survey.Id], 'There should be no duplicate ContentDocumentLinks for the Survey');
    }
}