@isTest
public class SurveyPDFViewerControllerTest {

    @isTest
    static void testGetRelatedFilesByRecordId() {
        // Step 1: Create test data for Survey and child records
        Survey__c survey = new Survey__c(Name = 'Test Survey');
        insert survey;

        ERF__c erfRecord = new ERF__c(Survey__c = survey.Id);
        insert erfRecord;

        // Step 2: Create test ContentVersion record for the survey record
        ContentVersion versionPDF = new ContentVersion(
            Title = 'Test PDF File',
            VersionData = Blob.valueOf('Test PDF Data'),
            PathOnClient = 'testfile.pdf',
            FirstPublishLocationId = survey.Id,
            IsMajorVersion = true
        );
        insert versionPDF;

        // Fetch the ContentDocumentId from the inserted ContentVersion
        ContentVersion insertedVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :versionPDF.Id LIMIT 1];

        // Step 3: Test the controller method
        Test.startTest();
        Map<ID, String> result = SurveyPDFViewerController.getRelatedFilesByRecordId(survey.Id);
        Test.stopTest();

        // Step 4: Assert the results
        System.assertEquals(1, result.size(), 'There should be 1 PDF file linked.');
        System.assertEquals('Test PDF File', result.get(insertedVersion.ContentDocumentId), 'The file title should match.');
    }

    @isTest
    static void testGetRelatedFilesByRecordIdInvalidInput() {
        // Test case for invalid input
        Test.startTest();
        try {
            SurveyPDFViewerController.getRelatedFilesByRecordId(null);
            System.assert(false, 'Expected exception was not thrown for null input.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Invalid parent record ID.', e.getMessage(), 'Expected exception message did not match.');
        }
        Test.stopTest();
    }
}