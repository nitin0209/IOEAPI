/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	16-03-2024
Class Name 				: 	SCIS_FileUploadToFloorRest
TestClass Name 			: 	SCIS_FileUploadToFloorRestTest
Description 			: 	This is test class for SCIS_FileUploadToFloorRest.
Last Modification Date 	: 	22-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */


@isTest(SeeAllData=false)
public with sharing class FileUploadToFloorRestTest {
    
    // Method to set up test data
    private static void setupTestData() {
        // Create a test Floor record
        Floor__c testFloor = new Floor__c(Name = 'Test Floor');
        insert testFloor;

        // Create a test ContentDocument
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Image Data')
        );
        insert testContentVersion;

        // Link the ContentDocument to the Floor
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: testContentVersion.Id].ContentDocumentId,
            LinkedEntityId = testFloor.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert testContentDocumentLink;
    }
    
    @IsTest
    static void testUploadFloorImageFirstUpload() {
        setupTestData();

        // Fetch the test Floor
        Floor__c testFloor = [SELECT Id FROM Floor__c LIMIT 1];

        // Prepare the parameters
        String floorId = testFloor.Id;
        String imageName = 'NewTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('New Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToFloorRest.uploadFloorImage(
            floorId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');
        
        // Verify that the previous content document links were deleted
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: floorId];
        System.assertEquals(1, count, 'There should be one ContentDocumentLink');
    }

    @IsTest
    static void testUploadFloorImageAdditionalUpload() {
        setupTestData();

        // Fetch the test Floor
        Floor__c testFloor = [SELECT Id FROM Floor__c LIMIT 1];

        // Prepare the parameters
        String floorId = testFloor.Id;
        String imageName = 'AnotherTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Another Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToFloorRest.uploadFloorImage(
            floorId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');

        // Verify that the new content document link was created
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: floorId];
        System.assertEquals(2, count, 'There should be two ContentDocumentLinks');
    }

    @IsTest
    static void testUploadFloorImageWithException() {
        // Prepare the parameters with an invalid Floor ID
        String invalidFloorId = 'InvalidId';
        String imageName = 'InvalidTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Invalid Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToFloorRest.uploadFloorImage(
            invalidFloorId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should contain the error');
    }
}