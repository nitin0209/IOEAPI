/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	16-03-2024
Class Name 				: 	SCIS_FileUploadToRoomRest
TestClass Name 			: 	SCIS_FileUploadToRoomRestTest
Description 			: 	This is test class for SCIS_FileUploadToRoomRest.
Last Modification Date 	: 	22-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */


@isTest
public with sharing class SCIS_FileUploadToRoomRestTest {
    
    // Method to set up test data
    private static void setupTestData() {
        // Create a test Room record
        Room__c testRoom = new Room__c(Name = 'Test Room');
        insert testRoom;

        // Create a test ContentDocument
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Image Data')
        );
        insert testContentVersion;

        // Link the ContentDocument to the Room
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: testContentVersion.Id].ContentDocumentId,
            LinkedEntityId = testRoom.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert testContentDocumentLink;
    }
    
    @IsTest
    static void testUploadRoomImageFirstUpload() {
        setupTestData();

        // Fetch the test Room
        Room__c testRoom = [SELECT Id FROM Room__c LIMIT 1];

        // Prepare the parameters
        String roomId = testRoom.Id;
        String imageName = 'NewTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('New Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToRoomRest.uploadRoomImage(
            roomId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');
        
        // Verify that the previous content document links were deleted
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: roomId];
        System.assertEquals(1, count, 'There should be one ContentDocumentLink');
    }

    @IsTest
    static void testUploadRoomImageAdditionalUpload() {
        setupTestData();

        // Fetch the test Room
        Room__c testRoom = [SELECT Id FROM Room__c LIMIT 1];

        // Prepare the parameters
        String roomId = testRoom.Id;
        String imageName = 'AnotherTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Another Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToRoomRest.uploadRoomImage(
            roomId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be success');

        // Verify that the new content document link was created
        Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId =: roomId];
        System.assertEquals(2, count, 'There should be two ContentDocumentLinks');
    }

    @IsTest
    static void testUploadRoomImageWithException() {
        // Prepare the parameters with an invalid Room ID
        String invalidRoomId = 'InvalidId';
        String imageName = 'InvalidTestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Invalid Test Image Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Call the method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToRoomRest.uploadRoomImage(
            invalidRoomId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should contain the error');
    }
}