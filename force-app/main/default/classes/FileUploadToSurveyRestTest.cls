@isTest
private class FileUploadToSurveyRestTest {

    @isTest
    static void testUploadSurveyImage_Success() {
        // Create a Survey record
        Survey__c survey = new Survey__c();
        insert survey;

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToSurvey/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        // Make sure to pass all required parameters
        Map<String, String> response = FileUploadToSurveyRest.uploadsurveyImage(survey.Id, 'TestImage', 'VGhpcyBpcyBhIHRlc3QgYmFzZTY0IGRhdGE=', true, 'jpg', false);
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');
        System.assertNotEquals(null, response.get('url'), 'URL should not be null');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :survey.Id];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
    }

    @isTest
    static void testUploadSurveyImage_DeleteExistingContent() {
        // Create a Survey record
        Survey__c survey = new Survey__c();
        insert survey;

        // Insert existing ContentVersion and ContentDocumentLink
        ContentVersion existingCv = new ContentVersion(
            Title = 'ExistingImage',
            PathOnClient = 'ExistingImage.jpg',
            VersionData = Blob.valueOf('Existing Data')
        );
        insert existingCv;
        ContentDocumentLink existingCdl = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :existingCv.Id LIMIT 1].ContentDocumentId,
            LinkedEntityId = survey.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert existingCdl;

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToSurvey/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> response = FileUploadToSurveyRest.uploadsurveyImage(survey.Id, 'NewImage', 'VGhpcyBpcyBhIHRlc3QgYmFzZTY0IGRhdGE=', true, 'jpg', false);
        Test.stopTest();

        // Assertions
        System.assertEquals('200', response.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should indicate success');

        // Verify ContentVersion and ContentDocumentLink records
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :survey.Id];
        System.assertEquals(1, links.size(), 'There should be one ContentDocumentLink');
        System.assertNotEquals(existingCdl.Id, links[0].Id, 'The existing ContentDocumentLink should be deleted');
    }

    @isTest
    static void testUploadSurveyImage_InvalidSurveyId() {
        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToSurvey/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method with an invalid Survey ID
        Test.startTest();
        Map<String, String> response = FileUploadToSurveyRest.uploadsurveyImage('InvalidId', 'TestImage', 'VGhpcyBpcyBhIHRlc3QgYmFzZTY0IGRhdGE=', true, 'jpg', false);
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message').contains('List has no rows for assignment to SObject'), 'Message should indicate no Survey record found');
    }

    @isTest
    static void testUploadSurveyImage_ExceptionHandling() {
        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/uploadFilesToSurvey/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method with null Survey ID
        Test.startTest();
        Map<String, String> response = FileUploadToSurveyRest.uploadsurveyImage(null, 'TestImage', 'VGhpcyBpcyBhIHRlc3QgYmFzZTY0IGRhdGE=', true, 'jpg', false);
        Test.stopTest();

        // Assertions
        System.assertEquals('500', response.get('status'), 'Status should be 500');
        System.assert(response.get('message') != null, 'Message should indicate an exception occurred');
    }
}