/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	02-01-2024
Class Name 				: 	SCIS_surveyImageUploadResource
TestClass Name 			: 	SCIS_surveyImageUploadResourceTest
@Description 			: 	'This class is used to upload images captured from the Surveyor Application Developed using PHP and iOS.
							In Surveyor Application we need to capture image, so this class is used to store captured images to Survey Object in salesforce.'
							* @param surveyId ID of the survey record.
Last Modification Date 	: 	02-01-2024
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

 //working
/**
 * The SCIS_surveyImageUploadResource class provides functionality to upload survey images via REST API.
 * It allows users to upload images associated with a survey and link them to the corresponding survey record.
 */
@RestResource(urlMapping='/surveyImageUpload/*')
global with sharing class SCIS_surveyImageUploadResource {
/**
* Inner class representing image data to be uploaded.
*/
    global class ImageData {
        public String surveyId;
        public String imageName;
        public String imageBase64;
    }
/**
* Inner class representing the image upload request.
*/
    global class ImageUploadRequest {
        public List<ImageData> images;
    }
	 /**
     * REST method to upload survey images.
     * @param jsonRequest JSON string representing the ImageUploadRequest.
     * @return List of strings containing the upload results.
     */
    @HttpPost
    global static List<String> uploadSurveyImages(String jsonRequest) {
        List<String> results = new List<String>();

        try {
            // Deserialize the JSON request into ImageUploadRequest object
            ImageUploadRequest request = (ImageUploadRequest)JSON.deserialize(jsonRequest, ImageUploadRequest.class);

            // Delete previous images associated with the survey
            deletePreviousSurveyImages(request.images[0].surveyId);
			// Iterate through each image data and upload it
            for (ImageData imageData : request.images) {
                String surveyId = imageData.surveyId;
                String imageName = imageData.imageName;
                String imageBase64 = imageData.imageBase64;
				// Decode base64 image data
                Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
				// Retrieve the survey record
                Survey__c surveyRecord = new Survey__c();
                if (Schema.sObjectType.Survey__c.isAccessible()) {
                	surveyRecord = [SELECT Id FROM Survey__c WHERE Id = :surveyId LIMIT 1];
            	}
                // Survey__c surveyRecord = [SELECT Id FROM Survey__c WHERE Id = :surveyId LIMIT 1];
				// Create ContentVersion and insert it
                ContentVersion cv = new ContentVersion();
                cv.Title = imageName;
                cv.PathOnClient = imageName + '.jpg';
                cv.VersionData = imageBlob;
                
                if (Schema.sObjectType.ContentVersion.isCreateable()) {
   					insert cv;
				}
                //insert cv;
				// Retrieve the ContentVersion and link it to the survey record
                ContentVersion cversion = new ContentVersion();
                if(Schema.sObjectType.ContentVersion.isAccessible()){
                	cversion = [SELECT Id, ContentDocumentId, PathOnClient FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            	} 
                // ContentVersion cversion = [SELECT Id, ContentDocumentId, PathOnClient FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
				// Create ContentDocumentLink and insert it
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cversion.ContentDocumentId;
                cdl.LinkedEntityId = surveyRecord.Id;
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                
                if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                	insert cdl; 
            	}
                // insert cdl;
				// Add upload success message to results list
                results.add('Image uploaded successfully: ' + imageName);
            }
        } catch (Exception e) {
            // Add error message to results list in case of exception
            results.add('Error: ' + e.getMessage());
        }

        return results;
    }

    // Helper method to delete previous images associated with the survey
    /**
     * Helper method to delete previous images associated with the survey.
     * @param surveyId ID of the survey record.
     */
    private static void deletePreviousSurveyImages(String surveyId) {
        List<ContentDocumentLink> existingLinks = new List<ContentDocumentLink>();
        // Query existing content document links associated with the survey
        if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
                existingLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :surveyId];
            }
        
        // List<ContentDocumentLink> existingLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :surveyId];
		// Delete existing content document links
        if (!existingLinks.isEmpty()) {
            delete existingLinks;
        }
    }
}






/*

@RestResource(urlMapping='/surveyImageUpload/*')
global with sharing class SCIS_surveyImageUploadResource {
    
    global class ImageData {
        public String surveyId;
        public String imageName;
        public String imageBase64;
    }
    
    global class ImageUploadRequest {
        public List<ImageData> images;
    }
    
    @HttpPost
    global static List<String> uploadSurveyImages(String jsonRequest) {  
        List<String> results = new List<String>();
        
        try {
            ImageUploadRequest request = (ImageUploadRequest)JSON.deserialize(jsonRequest, ImageUploadRequest.class);
            
            for (ImageData imageData : request.images) {
                String surveyId = imageData.surveyId;
                String imageName = imageData.imageName;
                String imageBase64 = imageData.imageBase64;
                
                Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
                
                Survey__c SurveyRecord = [SELECT Id FROM Survey__c WHERE Id = :surveyId LIMIT 1];
                
                ContentVersion cv = new ContentVersion();
                cv.Title = imageName;
                cv.PathOnClient = imageName + '.jpg';
                cv.VersionData = imageBlob;
                insert cv;
                
                ContentVersion cversion = [SELECT Id, ContentDocumentId, PathOnClient FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
                
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cversion.ContentDocumentId;
                cdl.LinkedEntityId = SurveyRecord.Id;
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                insert cdl;
                
                results.add('Image uploaded successfully: ' + imageName);
            }
        } catch (Exception e) {
            results.add('Error: ' + e.getMessage());
        }
        
        return results;
    }
}


*/

/*
{
  "images": [
    {
      "leadId": "LeadId1",
      "imageName": "Image1",
      "imageBase64": "Base64EncodedData1"
    },
    {
      "leadId": "LeadId2",
      "imageName": "Image2",
      "imageBase64": "Base64EncodedData2"
    }
    // ... additional image data
  ]
}

*/