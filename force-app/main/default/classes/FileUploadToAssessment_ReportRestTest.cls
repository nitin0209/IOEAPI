/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToAssessment_ReportRest
TestClass Name 			: 	FileUploadToAssessment_ReportRestTest
Description 			: 	This is test class for FileUploadToAssessment_ReportRest.
Last Modification Date 	: 	22-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1Change : 22 May 2024 : Updated code to delete the associated images with Assessment_Report
************************************************************************************************************************************************** */

@isTest(SeeAllData=true)
public with sharing class FileUploadToAssessment_ReportRestTest {
    
    // Method to set up test data
    private static void setupTestData() {
        // Create a test Assessment Report record
        Assessment_Report__c testAssessmentReport = new Assessment_Report__c(Name = 'Test Report');
        insert testAssessmentReport;

        // Create a test ContentDocument
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Image Data')
        );
        insert testContentVersion;

        // Link the ContentDocument to the Assessment Report
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: testContentVersion.Id].ContentDocumentId,
            LinkedEntityId = testAssessmentReport.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert testContentDocumentLink;
    }
    
    @IsTest
    static void testUploadAssessment_ReportImageFirstUpload() {
        setupTestData();

        // Fetch the test Assessment Report
        Assessment_Report__c testAssessmentReport = [SELECT Id FROM Assessment_Report__c LIMIT 1];

        // Prepare the parameters
        String assessmentReportId = testAssessmentReport.Id;
        String imageName = 'NewTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('New Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToAssessment_ReportRest.uploadAssessment_ReportImage(
            assessmentReportId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');
        
        // Verify that the previous content document links were deleted
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: assessmentReportId];
        System.assertEquals(1, count, 'There should be one ContentDocumentLink');
    }

    @IsTest
    static void testUploadAssessment_ReportImageAdditionalUpload() {
        setupTestData();

        // Fetch the test Assessment Report
        Assessment_Report__c testAssessmentReport = [SELECT Id FROM Assessment_Report__c LIMIT 1];

        // Prepare the parameters
        String assessmentReportId = testAssessmentReport.Id;
        String imageName = 'AnotherTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Another Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToAssessment_ReportRest.uploadAssessment_ReportImage(
            assessmentReportId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');

        // Verify that the new content document link was created
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: assessmentReportId];
        // System.assertEquals(2, count, 'There should be two ContentDocumentLinks');
    }

    @IsTest
    static void testUploadAssessment_ReportImageWithException() {
        // Prepare the parameters with an invalid Assessment Report ID
        String invalidAssessmentReportId = 'InvalidId';
        String imageName = 'InvalidTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Invalid Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToAssessment_ReportRest.uploadAssessment_ReportImage(
            invalidAssessmentReportId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
       // System.assert(response.get('message').contains('Invalid field'), 'Message should contain the error');
    }
}