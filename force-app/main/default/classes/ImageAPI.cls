/* ***********************************************************************************************************************************************
 	Developer Name: Nitin Mane
	Created Date: 04 SEPT,2024
	TestClass Name : ImageAPITest
    Title: Salesforce API for Image Handling with External Parameters
    Description: This API allows for image upload and retrieval in Salesforce using external parameters 
		such as file name, record association, and optional formatting.
	URL:- https://southcoastinsulationservices--dev.sandbox.my.salesforce.com/Services/ApexRest/ImageAPI

**************************************************************************************************************************************************/


@RestResource(urlMapping='/ImageAPI/*')
global with sharing class ImageAPI {

    
    @HttpPost
    global static String uploadImage() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        
        String fileName = (String) params.get('fileName'); 
        String recordId = (String) params.get('recordId'); 
        String title = (String) params.get('title'); 
        String fileBodyBase64 = (String) params.get('fileBody'); // Base64 encoded file data

        
        if (fileName == null || recordId == null || fileBodyBase64 == null) {
            res.statusCode = 400;
            return 'Missing required parameters: fileName, recordId, or fileBody.';
        }

        try {
            
            Blob fileBody = EncodingUtil.base64Decode(fileBodyBase64);

            ContentVersion contentVersion = new ContentVersion();
            contentVersion.VersionData = fileBody;
            contentVersion.PathOnClient = fileName;
            contentVersion.Title = title != null ? title : 'Uploaded Image';
            contentVersion.FirstPublishLocationId = recordId; 

            insert contentVersion;

            ContentDocument doc = [SELECT Id FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id) LIMIT 1];
            return 'Image uploaded successfully. Document Id: ' + doc.Id;
        } catch (Exception e) {
            res.statusCode = 500;
            return 'Error uploading image: ' + e.getMessage();
        }
    }

    
    /*@HttpGet
    global static void getImage() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String docId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        String format = req.requestURI.contains('?') ? req.requestURI.split('\\?')[1].split('=')[1] : null; 

        try {
            
            ContentVersion contentVersion = [SELECT VersionData, FileType FROM ContentVersion WHERE ContentDocumentId = :docId LIMIT 1];
           
            String mimeType = format != null ? 'image/' + format : 'image/' + contentVersion.FileType.toLowerCase();
            res.addHeader('Content-Type', mimeType);
            res.responseBody = contentVersion.VersionData;
        } catch (Exception e) {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('Image not found: ' + e.getMessage());
        }
    }*/
}