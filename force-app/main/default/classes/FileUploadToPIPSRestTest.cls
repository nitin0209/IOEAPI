/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToPIPSRest
TestClass Name 			: 	FileUploadToPIPSRestTest
Description 			: 	This is test class for FileUploadToPIPSRest.
Last Modification Date 	: 	21-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							21-05-2024 - Modified the class with updated new upload functionality.
************************************************************************************************************************************************** */

@isTest(SeeAllData=true)
private class FileUploadToPIPSRestTest {

    @isTest
    static void testUploadPIPSImage_Success() {
        // Setup test data
        PIPS__c pips = new PIPS__c(Name = 'Test PIPS');
        insert pips;
        
        String pipsId = pips.Id;
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPIPS/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPIPSRest.uploadPIPSImage(pipsId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :pipsId];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
    }

    @isTest
    static void testUploadPIPSImage_DeleteExistingContent() {
        // Setup test data
        PIPS__c pips = new PIPS__c(Name = 'Test PIPS');
        insert pips;

        // Insert existing ContentVersion and ContentDocumentLink
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Existing Data'));
        ContentVersion existingCv = new ContentVersion(
            Title = 'ExistingImage',
            PathOnClient = 'ExistingImage.jpg',
            VersionData = Blob.valueOf('Existing Data')
        );
        insert existingCv;
        ContentDocumentLink existingCdl = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :existingCv.Id LIMIT 1].ContentDocumentId,
            LinkedEntityId = pips.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert existingCdl;

        // Insert new image
        String pipsId = pips.Id;
        String imageName = 'NewImage';
        String newImageBase64 = EncodingUtil.base64Encode(Blob.valueOf('New Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPIPS/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPIPSRest.uploadPIPSImage(pipsId, imageName, newImageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :pipsId];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
        System.assertNotEquals(existingCdl.Id, links[0].Id, 'The existing ContentDocumentLink should be deleted');
    }

    @isTest
    static void testUploadPIPSImage_InvalidPIPSId() {
        String pipsId = 'InvalidId';
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPIPS/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPIPSRest.uploadPIPSImage(pipsId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should indicate no PIPS record found');
    }

    @isTest
    static void testUploadPIPSImage_ExceptionHandling() {
        String pipsId = null;
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPIPS/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPIPSRest.uploadPIPSImage(pipsId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message') != null, 'Message should indicate an exception occurred');
    }
}