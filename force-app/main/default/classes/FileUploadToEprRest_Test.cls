/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   21-03-2024
Trigger Name            :   FileUploadToEPRRest
TestClass Name          :   FileUploadToEPRRestTest
Connected Class         :   
Description             :   This test class for FileUploadToEPRRest.
Last Modification Date  :   27-03-2024
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */

@isTest(SeeAllData=true)
private class FileUploadToEprRest_Test {

    @isTest
    static void testUploadEprImage() {
        // Test data setup
        EPR_XML_Site_Note__c eprRecord = new EPR_XML_Site_Note__c();
        eprRecord.Name = 'Test';
        insert eprRecord;
        
        // Generate test image data
        String eprID = eprRecord.Id;
        String imageName = 'TestImage';
        String imageBase64 = 'Base64EncodedImageData'; // Replace with valid base64 encoded image data
        Boolean isFirst = true;
        String fileType = 'jpg'; // Replace with appropriate file type
        
        // Call the REST service method
        Test.startTest();
        Map<String, String> response = FileUploadToEprRest.uploadEprImage(
            eprID, imageName, imageBase64, isFirst, fileType
        );
        Test.stopTest();
        
        // Verify response
        System.assertEquals('200', response.get('status'), 'Status should be "200"');
        System.assertEquals('Image uploaded successfully.', response.get('message'), 'Message should be "Image uploaded successfully."');
        
        // Verify image and ContentDocumentLink creation
        List<ContentDocumentLink> contentDocumentLinks = [
            SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :eprRecord.Id
        ];
        System.assertNotEquals(0, contentDocumentLinks.size(), 'ContentDocumentLink should be created');
        
        // Verify public URL generation
        String publicUrl = response.get('url');
        System.assertNotEquals(null, publicUrl, 'Public URL should be generated');
    }
}