@isTest
private class SCISFileUploadToAsbestosRiskFormRestTest {

    @isTest
    static void testUploadAsbestos_Risk_AssessmentImage_Success() {
        // Create a test record
        Asbestos_Risk_Assessment__c testRecord = new Asbestos_Risk_Assessment__c();
        insert testRecord;

        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/uploadFilesToAsbestos_Risk_Assessment/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        Test.startTest();
        Map<String, String> result = SCIS_FileUploadToAsbestos_Risk_Form_Rest.uploadAsbestos_Risk_AssessmentImage(
            testRecord.Id,
            'TestImage',
            'Base64EncodedImage',
            true,
            'jpg'
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('200', result.get('status'), 'Status should be 200');
        System.assertEquals('Image uploaded successfully.', result.get('message'), 'Message should indicate successful upload');
    }

    @isTest
    static void testUploadAsbestos_Risk_AssessmentImage_Exception() {
        // Set up RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/uploadFilesToAsbestos_Risk_Assessment/';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method with an exception-causing scenario
        Test.startTest();
        Map<String, String> result = SCIS_FileUploadToAsbestos_Risk_Form_Rest.uploadAsbestos_Risk_AssessmentImage(
            null,
            'TestImage',
            'Base64EncodedImage',
            true,
            'jpg'
        );
        Test.stopTest();

        // Assertions
        System.assertEquals('500', result.get('status'), 'Status should be 500');
        System.assertNotEquals(null, result.get('message'), 'Message should not be null');
    }

    // Add more test methods for different scenarios as needed
}