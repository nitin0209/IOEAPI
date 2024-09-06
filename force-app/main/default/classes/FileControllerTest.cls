/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-05-2024
Trigger Name            :   FileController
TestClass Name          :   FileControllerTest
Connected Class         :   
@Description            :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */

@isTest
private class FileControllerTest {

    /**
     * This test method verifies the retrieval of uploaded files for a given record.
     * It covers scenarios for both Attachment and ContentVersion records.
     */
    @isTest
    static void testGetUploadedFiles() {
        // Setup test data

        // Create a test Account record
        Account testAccount = new Account(Name = 'Test Account', Type = 'Funder');
        insert testAccount;
        
        // Create a test Attachment linked to the test Account
        Attachment testAttachment = new Attachment(
            Name = 'TestAttachment.txt',
            Body = Blob.valueOf('Test Attachment Body'),
            ParentId = testAccount.Id
        );
        insert testAttachment;
        
        // Create a test ContentDocument, ContentVersion, and ContentDocumentLink linked to the test Account
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'TestContentVersion',
            PathOnClient = 'TestContentVersion.pdf',
            VersionData = Blob.valueOf('Test Content Version Data')
        );
        insert testContentVersion;

        // Retrieve the ContentDocumentId from the inserted ContentVersion
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id].ContentDocumentId;
        
        // Create a ContentDocumentLink to link the ContentDocument to the test Account
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = contentDocumentId,
            LinkedEntityId = testAccount.Id,
            ShareType = 'V'
        );
        insert testContentDocumentLink;

        // Test the getUploadedFiles method
        Test.startTest();
        List<FileController.FileWrapper> files = FileController.getUploadedFiles(testAccount.Id);
        Test.stopTest();
        
        // Assertions to verify that both Attachment and ContentVersion are retrieved
        System.assertEquals(2, files.size(), 'There should be 2 files retrieved.');
        
        Boolean attachmentFound = false;
        Boolean contentVersionFound = false;

        for (FileController.FileWrapper file : files) {
            if (file.FileType == 'Attachment' && file.Name == 'TestAttachment.txt') {
                attachmentFound = true;
            } else if (file.FileType == 'ContentVersion' && file.Name == 'TestContentVersion') {
                contentVersionFound = true;
            }
        }

        System.assert(attachmentFound, 'Attachment should be found.');
        System.assert(contentVersionFound, 'ContentVersion should be found.');
    }
}