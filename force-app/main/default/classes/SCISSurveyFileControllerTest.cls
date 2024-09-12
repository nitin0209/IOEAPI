@isTest
public class SCISSurveyFileControllerTest {
    @testSetup
    static void setupTestData() {
        // Create test Survey record
        Survey__c survey = new Survey__c(Name = 'Test Survey');
        insert survey;

        // Create child records for the survey (ERF__c, Risk_Assessment__c, etc.)
        ERF__c erf = new ERF__c(Survey__c = survey.Id);
        insert erf;

        Risk_Assessment__c riskAssessment = new Risk_Assessment__c(Survey__c = survey.Id);
        insert riskAssessment;

        // Create a ContentVersion for an image
        ContentVersion versionImage = new ContentVersion(
            Title = 'Test Image File',
            VersionData = Blob.valueOf('Test Image Data'),
            PathOnClient = 'testimage.jpg',  // The extension is derived from this field
            FirstPublishLocationId = survey.Id,
            IsMajorVersion = true
        );
        insert versionImage;

        // Create a ContentVersion for a PDF
        ContentVersion versionPDF = new ContentVersion(
            Title = 'Test PDF File',
            VersionData = Blob.valueOf('Test PDF Data'),
            PathOnClient = 'testfile.pdf',  // The extension is derived from this field
            FirstPublishLocationId = survey.Id,
            IsMajorVersion = true
        );
        insert versionPDF;

        // Insert more child records to increase test coverage
        Design_Work__c designWork = new Design_Work__c(Survey__c = survey.Id);
        insert designWork;
    }

    @isTest
    static void testGetRelatedFilesByRecordIdForImages() {
        // Get the Survey record
        Survey__c survey = [SELECT Id FROM Survey__c LIMIT 1];

        Test.startTest();
        // Test for image files
        Map<ID, String> imageFiles = SCISSurveyFileController.getRelatedFilesByRecordId(survey.Id, true);
        Test.stopTest();

        // Assert that image files are returned
        System.assertEquals(1, imageFiles.size(), 'Expected one image file to be returned.');
        for (String title : imageFiles.values()) {
            System.assertEquals('Test Image File', title, 'The image file title should match.');
        }
    }

    @isTest
    static void testGetRelatedFilesByRecordIdForPDFs() {
        // Get the Survey record
        Survey__c survey = [SELECT Id FROM Survey__c LIMIT 1];

        Test.startTest();
        // Test for PDF files
        Map<ID, String> pdfFiles = SCISSurveyFileController.getRelatedFilesByRecordId(survey.Id, false);
        Test.stopTest();

        // Assert that PDF files are returned
        System.assertEquals(1, pdfFiles.size(), 'Expected one PDF file to be returned.');
        for (String title : pdfFiles.values()) {
            System.assertEquals('Test PDF File', title, 'The PDF file title should match.');
        }
    }

    @isTest
    static void testGetRelatedFilesByRecordIdInvalidParentId() {
        Test.startTest();
        try {
            // Test with an invalid parent record ID
            SCISSurveyFileController.getRelatedFilesByRecordId(null, false);
            System.assert(false, 'Exception should have been thrown due to invalid parentRecordId');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Invalid parent record ID.', e.getMessage(), 'Expected an IllegalArgumentException with the correct message.');
        }
        Test.stopTest();
    }
}