/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-03-2024
Class Name 				: 	FileUploadToErfRest
TestClass Name 			: 	FileUploadToErfRest_Test
Description 			: 	This is test class for FileUploadToErfRest.
Last Modification Date 	: 	27-03-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */


@isTest(SeeAllData=true)
private class FileUploadToErfRest_Test {

    @isTest
    static void testUploadERFImage() {
        // Test data setup
        ERF__c erfRecord = new ERF__c();
        erfRecord.Name = 'Test';
        insert erfRecord;
        
        // Generate test image data
        String erfId = erfRecord.Id;
        String imageName = 'TestImage';
        String imageBase64 = 'Base64EncodedImageData'; // Replace with valid base64 encoded image data
        Boolean isFirst = true;
        String fileType = 'jpg'; // Replace with appropriate file type
        
        // Call the REST service method
        Test.startTest();
        Map<String, String> response = FileUploadToErfRest.uploadERFImage(
            erfId, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();
        
        // Verify response
        System.assertEquals('200', response.get('status'), 'Status should be "200"');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be "Image uploaded successfully."');
        
        // Verify image and ContentDocumentLink creation
        List<ContentDocumentLink> contentDocumentLinks = [
            SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :erfRecord.Id
        ];
        System.assertNotEquals(0, contentDocumentLinks.size(), 'ContentDocumentLink should be created');
    }
}