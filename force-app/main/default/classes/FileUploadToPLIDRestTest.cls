/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToPLIDRest
TestClass Name 			: 	FileUploadToPLIDRest_Test
Description 			: 	This is test class for FileUploadToPLIDRest.
Last Modification Date 	: 	21-05-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							21-05-2024 - Modified the class with delete functionality.
************************************************************************************************************************************************** */


@isTest(SeeAllData=true)
private class FileUploadToPLIDRestTest {

    @isTest
    static void testUploadPLIDImage_Success() {
        // Setup test data
        PLID__c plid = new PLID__c(Name = 'Test PLID');
        insert plid;
        
        String plidId = plid.Id;
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPLID/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPLIDRest.uploadPLIDImage(plidId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :plidId];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
    }

    @isTest
    static void testUploadPLIDImage_DeleteExistingContent() {
        // Setup test data
        PLID__c plid = new PLID__c(Name = 'Test PLID');
        insert plid;

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
            LinkedEntityId = plid.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert existingCdl;

        // Insert new image
        String plidId = plid.Id;
        String imageName = 'NewImage';
        String newImageBase64 = EncodingUtil.base64Encode(Blob.valueOf('New Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPLID/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPLIDRest.uploadPLIDImage(plidId, imageName, newImageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :plidId];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
        System.assertNotEquals(existingCdl.Id, links[0].Id, 'The existing ContentDocumentLink should be deleted');
    }

    @isTest
    static void testUploadPLIDImage_InvalidPLIDId() {
        String plidId = 'InvalidId';
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Data'));
        boolean isFirst = false;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPLID/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPLIDRest.uploadPLIDImage(plidId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should indicate no PLID record found');
    }

    @isTest
    static void testUploadPLIDImage_ExceptionHandling() {
        String plidId = null;
        String imageName = 'TestImage';
        String imageBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test Data'));
        boolean isFirst = true;
        String fileType = 'jpg';

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToPLID/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToPLIDRest.uploadPLIDImage(plidId, imageName, imageBase64, isFirst, fileType);
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message') != null, 'Message should indicate an exception occurred');
    }
}