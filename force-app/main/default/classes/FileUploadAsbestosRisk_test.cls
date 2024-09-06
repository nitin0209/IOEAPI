/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToAsbestos_Risk_AssessmentRest.
TestClass Name 			: 	FileUploadToAsbestos_Risk_AssessmentRestTest.
Description 			: 	This is test class for FileUploadToAsbestos_Risk_AssessmentRest.
Last Modification Date 	: 	27-03-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */


@isTest(SeeAllData=true)
private class FileUploadAsbestosRisk_test {
@isTest
    static void testUploadAsbestosRiskAssessmentImage() {
        // Test data setup
        
        Asbestos_Risk_Assessment__c asbestosRiskAssessment = new Asbestos_Risk_Assessment__c();
        asbestosRiskAssessment.Name ='Test';
        insert asbestosRiskAssessment;
        
        // Generate test image data
        String AsbestosId = asbestosRiskAssessment.Id;
        String imageName = 'TestImage';
        String imageBase64 = 'Base64EncodedImageData'; // Replace with valid base64 encoded image data
        Boolean isFirst = true;
        String fileType = 'jpg'; // Replace with appropriate file type
        
        // Call the REST service method
        Test.startTest();
        Map<String, String> response = SCIS_FileUploadToAsbestos_Risk_Form_Rest.uploadAsbestos_Risk_AssessmentImage(
            AsbestosId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();
        
        // Verify response
        System.assertEquals('200', response.get('status'), 'Status should be "200"');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be "Image uploaded successfully."');
        
        // Verify image and ContentDocumentLink creation
        List<ContentDocumentLink> contentDocumentLinks = [
            SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :asbestosRiskAssessment.Id
        ];
        System.assertNotEquals(0, contentDocumentLinks.size(), 'ContentDocumentLink should be created');
    }
}