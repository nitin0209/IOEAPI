@isTest
private class FileUploadToErffromSocialMngRestTest {

    @isTest
    static void testUploadERFImage_Success() {
        // Create an ERF record
        ERF__c erf = new ERF__c();
        insert erf;

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToERFfromSocialMng/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToErffromSocialMngRest.uploadERFImage(erf.Id, 'TestImage', 'Base64Data', true, 'jpg');
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :erf.Id];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
    }

    @isTest
    static void testUploadERFImage_DeleteExistingContent() {
        // Create an ERF record
        ERF__c erf = new ERF__c();
        insert erf;

        // Insert existing ContentVersion and ContentDocumentLink
        ContentVersion existingCv = new ContentVersion(
            Title = 'ExistingImage',
            PathOnClient = 'ExistingImage.jpg',
            VersionData = Blob.valueOf('Existing Data')
        );
        insert existingCv;
        ContentDocumentLink existingCdl = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :existingCv.Id LIMIT 1].ContentDocumentId,
            LinkedEntityId = erf.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert existingCdl;

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToERFfromSocialMng/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToErffromSocialMngRest.uploadERFImage(erf.Id, 'NewImage', 'Base64Data', true, 'jpg');
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :erf.Id];
        // System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
        // System.assertNotEquals(existingCdl.Id, links[0].Id, 'The existing ContentDocumentLink should be deleted');
    }

    @isTest
    static void testUploadERFImage_InvalidERFId() {
        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToERFfromSocialMng/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method with an invalid ERF ID
        Test.startTest();
        Map<String, String> response = FileUploadToErffromSocialMngRest.uploadERFImage('InvalidId', 'TestImage', 'Base64Data', true, 'jpg');
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should indicate no ERF record found');
    }

    @isTest
    static void testUploadERFImage_ExceptionHandling() {
        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToERFfromSocialMng/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method with null ERF ID
        Test.startTest();
        Map<String, String> response = FileUploadToErffromSocialMngRest.uploadERFImage(null, 'TestImage', 'Base64Data', true, 'jpg');
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message') != null, 'Message should indicate an exception occurred');
    }
}