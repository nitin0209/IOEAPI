@RestResource(urlMapping='/MileageImageAPI/*')
global with sharing class MileageImageAPI {

    // Method to upload an image with external parameters
    @HttpPost
    global static String uploadImage() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Parse the incoming JSON payload
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        // Extract parameters
        String fileName = (String) params.get('fileName'); // e.g., "image.png"
        String mileageRecordId = (String) params.get('mileageRecordId'); // e.g., Mileage_Details__c Id to link
        String title = (String) params.get('title'); // Optional title for the image
        String fileBodyBase64 = (String) params.get('fileBody'); // Base64 encoded file data

        // Validate parameters
        if (fileName == null || mileageRecordId == null || fileBodyBase64 == null) {
            res.statusCode = 400;
            return 'Missing required parameters: fileName, mileageRecordId, or fileBody.';
        }

        try {
            // Decode the base64 encoded string to get the file Blob
            Blob fileBody = EncodingUtil.base64Decode(fileBodyBase64);

            // Create a ContentVersion record to store the image
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.VersionData = fileBody;
            contentVersion.PathOnClient = fileName;
            contentVersion.Title = title != null ? title : 'Uploaded Image';
            contentVersion.FirstPublishLocationId = mileageRecordId; // Associate image with the Mileage_Details__c record

            insert contentVersion;

            // Fetch the associated ContentDocument Id
            ContentDocument doc = [SELECT Id FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id) LIMIT 1];
            return 'Image uploaded successfully. Document Id: ' + doc.Id;
        } catch (Exception e) {
            res.statusCode = 500;
            return 'Error uploading image: ' + e.getMessage();
        }
    }

    // Method to retrieve an image by ContentDocument Id with optional format parameter
    @HttpGet
    global static void getImage() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Extract the ContentDocument Id from the URL
        String docId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        String format = req.requestURI.contains('?') ? req.requestURI.split('\\?')[1].split('=')[1] : null; // Extracts format if present

        try {
            // Query to retrieve the image data
            ContentVersion contentVersion = [SELECT VersionData, FileType FROM ContentVersion WHERE ContentDocumentId = :docId LIMIT 1];

            // Set response headers based on the format
            String mimeType = format != null ? 'image/' + format : 'image/' + contentVersion.FileType.toLowerCase();
            res.addHeader('Content-Type', mimeType);
            res.responseBody = contentVersion.VersionData;
        } catch (Exception e) {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('Image not found: ' + e.getMessage());
        }
    }
}