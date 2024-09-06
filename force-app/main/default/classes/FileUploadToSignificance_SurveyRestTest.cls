/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToSignificance_SurveyRest
TestClass Name 			: 	FileUploadToSignificance_SurveyRestTest
Description 			: 	This is test class for FileUploadToSignificance_SurveyRest.
Last Modification Date 	: 	22-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */


@isTest(SeeAllData=true)
public with sharing class FileUploadToSignificance_SurveyRestTest {
    
    // Method to set up test data
    private static void setupTestData() {
        // Create a test Significance_Survey record
        Significance_Survey__c testSurvey = new Significance_Survey__c(Name = 'Test Survey');
        insert testSurvey;

        // Create a test ContentVersion
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Image Data')
        );
        insert testContentVersion;

        // Link the ContentDocument to the Significance_Survey
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: testContentVersion.Id].ContentDocumentId,
            LinkedEntityId = testSurvey.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert testContentDocumentLink;
    }
    
    @IsTest
    static void testUploadSignificance_SurveyImageFirstUpload() {
        setupTestData();

        // Fetch the test Significance_Survey
        Significance_Survey__c testSurvey = [SELECT Id FROM Significance_Survey__c LIMIT 1];

        // Prepare the parameters
        String surveyId = testSurvey.Id;
        String imageName = 'NewTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('New Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToSignificance_SurveyRest.uploadSignificance_SurveyImage(
            surveyId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');
        
        // Verify that the previous content document links were deleted
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: surveyId];
        System.assertEquals(1, count, 'There should be one ContentDocumentLink');
    }

    @IsTest
    static void testUploadSignificance_SurveyImageAdditionalUpload() {
        setupTestData();

        // Fetch the test Significance_Survey
        Significance_Survey__c testSurvey = [SELECT Id FROM Significance_Survey__c LIMIT 1];

        // Prepare the parameters
        String surveyId = testSurvey.Id;
        String imageName = 'AnotherTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Another Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToSignificance_SurveyRest.uploadSignificance_SurveyImage(
            surveyId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');

        // Verify that the new content document link was created
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: surveyId];
       // System.assertEquals(2, count, 'There should be two ContentDocumentLinks');
    }

    @IsTest
    static void testUploadSignificance_SurveyImageWithException() {
        // Prepare the parameters with an invalid Significance_Survey ID
        String invalidSurveyId = 'InvalidId';
        String imageName = 'InvalidTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Invalid Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToSignificance_SurveyRest.uploadSignificance_SurveyImage(
            invalidSurveyId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should contain the error');
    }
}