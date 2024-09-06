/**************************************************************************************************************************************************
    Developer Name : Nitin Mane
    Created Date   : 05 SEPT, 2024
    Class Name     : ImageAPI
    Title          : Test class for ImageAPI
    Description    : This test class validates the functionality of the ImageAPI class,
                     which handles image uploads as ContentVersion and associates them 
                     with the specified Salesforce records. The test scenarios cover 
                     successful uploads, missing parameters, and exception handling.

*************************************************************************************************************************************************/

@IsTest
private class ImageAPITest {

    // Test case for successful image upload
    @IsTest
    static void testUploadImage_Success() {
        // Set up test data - creating a test Account to associate the image
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Prepare the request body with valid parameters
        String fileName = 'testImage.png';
        String recordId = testAccount.Id;
        String title = 'Test Image';
        String fileBody = EncodingUtil.base64Encode(Blob.valueOf('Test image data')); // Base64 encoded string representing image data
        
        Map<String, Object> requestBody = new Map<String, Object>{
            'fileName' => fileName,
            'recordId' => recordId,
            'title' => title,
            'fileBody' => fileBody
        };

        // Create the REST request and response context
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/ImageAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        // Call the API method
        String result = ImageAPI.uploadImage();
        
        // Verify the response content and status code
        System.assert(result.contains('Image uploaded successfully.'));
        System.assertEquals(200, RestContext.response.statusCode);
        
        // Verify that the ContentVersion record is inserted correctly
        List<ContentVersion> insertedVersions = [SELECT Id, Title, PathOnClient, FirstPublishLocationId FROM ContentVersion];
        System.assertEquals(1, insertedVersions.size());
        System.assertEquals(fileName, insertedVersions[0].PathOnClient);
        System.assertEquals(recordId, insertedVersions[0].FirstPublishLocationId);
        System.assertEquals(title, insertedVersions[0].Title);

        // Verify that the associated ContentDocument is retrieved correctly
        List<ContentDocument> insertedDocs = [SELECT Id FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :insertedVersions[0].Id) LIMIT 1];
        System.assertEquals(1, insertedDocs.size());
        System.assert(result.contains(insertedDocs[0].Id));
    }
    
    // Test case for handling missing parameters
    @IsTest
    static void testUploadImage_MissingParameters() {
        // Prepare the request body with missing parameters
        Map<String, Object> requestBody = new Map<String, Object>{
            'fileName' => null,
            'recordId' => null,
            'fileBody' => null
        };

        // Create the REST request and response context
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/ImageAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        // Call the API method
        String result = ImageAPI.uploadImage();
        
        // Verify the response message and status code for missing parameters
        System.assertEquals('Missing required parameters: fileName, recordId, or fileBody.', result);
        System.assertEquals(400, RestContext.response.statusCode);
    }

    // Test case to validate exception handling
    @IsTest
    static void testUploadImage_Exception() {
        // Set up test data with an invalid record Id to force an exception
        String fileName = 'testImage.png';
        String recordId = 'invalidId'; // Invalid Id to simulate an exception scenario
        String title = 'Test Image';
        String fileBody = EncodingUtil.base64Encode(Blob.valueOf('Test image data'));

        Map<String, Object> requestBody = new Map<String, Object>{
            'fileName' => fileName,
            'recordId' => recordId,
            'title' => title,
            'fileBody' => fileBody
        };

        // Create the REST request and response context
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/ImageAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        // Call the API method and verify exception handling
        String result = ImageAPI.uploadImage();
        
        // Verify the response is an error message with a 500 status code
        System.assert(result.startsWith('Error uploading image: '));
        System.assertEquals(500, RestContext.response.statusCode);
    }
}