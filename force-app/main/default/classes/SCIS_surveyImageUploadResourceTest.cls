/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	21-02-2024
Class Name 				: 	SCIS_surveyImageUploadResource
TestClass Name 			: 	SCIS_surveyImageUploadResourceTest
Description 			: 	This is test class for SCIS_surveyImageUploadResource.
Last Modification Date 	: 	
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@isTest(SeeAllData=true)
public class SCIS_surveyImageUploadResourceTest {
@isTest
    static void testUploadSurveyImages() {
        // Test data setup
        Survey__c testSurvey = new Survey__c(Name = 'Test Survey');
        insert testSurvey;

        String surveyId = testSurvey.Id;
        String imageName = 'Test Image';
        String imageBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg=='; // Example base64 encoded image
        
        // Create the request object
        SCIS_surveyImageUploadResource.ImageData imageData = new SCIS_surveyImageUploadResource.ImageData();
        imageData.surveyId = surveyId;
        imageData.imageName = imageName;
        imageData.imageBase64 = imageBase64;

        SCIS_surveyImageUploadResource.ImageUploadRequest request = new SCIS_surveyImageUploadResource.ImageUploadRequest();
        request.images = new List<SCIS_surveyImageUploadResource.ImageData>{imageData};
        
        // Serialize the request object to JSON
        String jsonRequest = JSON.serialize(request);
        
        // Call the REST service method
        Test.startTest();
        List<String> results = SCIS_surveyImageUploadResource.uploadSurveyImages(jsonRequest);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, results.size(), 'One result should be returned');
        System.assertNotEquals(null, results[0], 'Result should not be null');
        System.assertNotEquals('Error', results[0].substring(0, 5), 'No error message expected');
        System.assert(results[0].contains('Image uploaded successfully'), 'Success message expected');
        
        // Optionally, you can further verify by querying inserted records or checking assertions on returned data
    }
}