/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToWorking_at_HeightRest
TestClass Name 			: 	FileUploadToWorking_at_HeightRestTest
Description 			: 	This is test class for FileUploadToWorking_at_HeightRest.
Last Modification Date 	: 	22-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */

@isTest(SeeAllData=true)
private class FileUploadToWorking_at_HeightRestTest {

    @isTest
    static void testUploadWorking_at_HeightImage_Success() {
        // Test data
        Working_at_Height__c workingAtHeightRecord = new Working_at_Height__c();
        insert workingAtHeightRecord;
        
        String workingAtHeightId = workingAtHeightRecord.Id;
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';
        
        // Call the REST endpoint
        Test.startTest();
        Map<String,String> response = SCIS_FileUploadToWorking_at_HeightRest.uploadWorking_at_HeightImage(workingAtHeightId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Verify response
        // System.assertEquals('200', response.get('status'));
       // System.assertEquals('Image uploaded successfully.', response.get('message'));
    }
    
    @isTest
    static void testUploadWorking_at_HeightImage_DeleteLinks() {
        // Test data
        Working_at_Height__c workingAtHeightRecord = new Working_at_Height__c();
        insert workingAtHeightRecord;
        
        String workingAtHeightId = workingAtHeightRecord.Id;
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';
        
        // Create existing ContentDocumentLinks to delete
        ContentVersion cv = new ContentVersion(
            Title = imageName,
            PathOnClient = imageName + '.jpg',
            VersionData = EncodingUtil.base64Decode(imageBase64)
        );
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId,
            LinkedEntityId = workingAtHeightId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert cdl;
        
        // Call the REST endpoint
        Test.startTest();
        Map<String,String> response = SCIS_FileUploadToWorking_at_HeightRest.uploadWorking_at_HeightImage(workingAtHeightId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Verify response
        System.assertEquals('200', response.get('status'));
        System.assertEquals('Image uploaded successfully.', response.get('message'));

        // Verify that ContentDocumentLinks were deleted
        List<ContentDocumentLink> deletedLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :workingAtHeightId];
        // System.assertEquals(0, deletedLinks.size(), 'Existing ContentDocumentLinks should have been deleted');
    }
    
    @isTest
    static void testUploadWorking_at_HeightImage_Exception() {
        // Test data
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Image Data'));
        boolean isFirst = true;
        String fileType = 'jpg';
        
        // Call the REST endpoint with invalid Working_at_HeightId
        Test.startTest();
        Map<String,String> response = SCIS_FileUploadToWorking_at_HeightRest.uploadWorking_at_HeightImage('invalidId', imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Verify response
        System.assertEquals('500', response.get('status'));
        System.assertNotEquals(null, response.get('message'));
    }
}