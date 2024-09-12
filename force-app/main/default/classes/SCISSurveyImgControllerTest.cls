@isTest
public class SCISSurveyImgControllerTest {

    @testSetup
    static void setupTestData() {
        // Create a test Survey record
        Survey__c survey = new Survey__c(Name = 'Test Survey');
        insert survey;

        // Create child records for the survey (ERF__c, Risk_Assessment__c, etc.)
        ERF__c erf = new ERF__c(Survey__c = survey.Id);
        insert erf;

        Risk_Assessment__c riskAssessment = new Risk_Assessment__c(Survey__c = survey.Id);
        insert riskAssessment;

        Asbestos_Risk_Assessment__c asbestosRisk = new Asbestos_Risk_Assessment__c(Survey__c = survey.Id);
        insert asbestosRisk;

        PIBI__c pibi = new PIBI__c(Survey__c = survey.Id);
        insert pibi;

        Working_at_Height__c workingAtHeight = new Working_at_Height__c(Survey__c = survey.Id);
        insert workingAtHeight;

        Significance_Survey__c significanceSurvey = new Significance_Survey__c(Survey__c = survey.Id);
        insert significanceSurvey;

        Assessment_Report__c assessmentReport = new Assessment_Report__c(Survey__c = survey.Id);
        insert assessmentReport;

        PIPS__c pips = new PIPS__c(Survey__c = survey.Id);
        insert pips;

        Design_Work__c designWork = new Design_Work__c(Survey__c = survey.Id);
        insert designWork;

        // Create a ContentVersion for an image file
        ContentVersion versionImage = new ContentVersion(
            Title = 'Test Image File',
            VersionData = Blob.valueOf('Test Image Data'),
            PathOnClient = 'testimage.jpg',  // The file extension is determined by this field
            FirstPublishLocationId = survey.Id,
            IsMajorVersion = true
        );
        insert versionImage;

        // Create a ContentVersion for another image
        ContentVersion versionImage2 = new ContentVersion(
            Title = 'Another Test Image',
            VersionData = Blob.valueOf('Another Test Image Data'),
            PathOnClient = 'anothertestimage.png',
            FirstPublishLocationId = erf.Id, // Link it to a child object
            IsMajorVersion = true
        );
        insert versionImage2;
    }

    @isTest
    static void testGetRelatedFilesByRecordId() {
        // Get the test Survey record
        Survey__c survey = [SELECT Id FROM Survey__c LIMIT 1];

        Test.startTest();
        // Call the method to get related image files by the parent record ID
        Map<ID, String> imageFiles = SCISSurveyImgController.getRelatedFilesByRecordId(survey.Id);
        Test.stopTest();

        // Assert that the correct number of image files are returned
        System.assertEquals(2, imageFiles.size(), 'Expected two image files to be returned.');

        // Assert the titles of the image files
        System.assert(imageFiles.values().contains('Test Image File'), 'Expected Test Image File to be returned.');
        System.assert(imageFiles.values().contains('Another Test Image'), 'Expected Another Test Image to be returned.');
    }

    @isTest
    static void testInvalidParentRecordId() {
        Test.startTest();
        try {
            // Test with an invalid parent record ID
            SCISSurveyImgController.getRelatedFilesByRecordId(null);
            System.assert(false, 'Exception should have been thrown due to invalid parentRecordId.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Invalid parent record ID.', e.getMessage(), 'Expected IllegalArgumentException with correct message.');
        }
        Test.stopTest();
    }
}