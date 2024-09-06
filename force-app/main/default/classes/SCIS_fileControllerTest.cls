/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-05-2024
Trigger Name            :   SCIS_fileController
TestClass Name          :   SCIS_fileControllerTest
Connected Class         :   
@Description            :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */

@isTest
private without sharing class SCIS_fileControllerTest {
    
    /**
     * This test method verifies the retrieval of related files for a given record.
     */
    @isTest
    static void testGetRelatedFiles() {
        // Setup test data

        // Create a test Account record
        Account testAccount = new Account(Name = 'Test Account', Type = 'Funder');
        insert testAccount;
        
        // Create a test ContentVersion linked to the test Account
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'TestContentDocument',
            VersionData = Blob.valueOf('Test Content'), // Replace with actual file content
            PathOnClient = 'TestContentDocument.pdf'
        );
        insert testContentVersion;

        // Create a test ContentDocumentLink to link the ContentVersion to the test Account
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id LIMIT 1].ContentDocumentId,
            LinkedEntityId = testAccount.Id,
            ShareType = 'V'
        );
        insert testContentDocumentLink;

        // Test the getRelatedFiles method
        Test.startTest();
        List<ContentDocumentLink> files = SCIS_fileController.getRelatedFiles(testAccount.Id);
        Test.stopTest();
        
        // Assertion to verify that the returned list contains the expected ContentDocumentLink
        System.assertEquals(1, files.size(), 'There should be 1 ContentDocumentLink retrieved.');
        
        // Assert the properties of the ContentDocumentLink
        ContentDocumentLink returnedFile = files[0];
        //System.assertEquals(testContentVersion.ContentDocumentId, returnedFile.ContentDocumentId, 'ContentDocumentId should match.');
        // Since we can't directly access Title and FileType, we need to query ContentDocument to verify them
        ContentDocument cd = [SELECT Title, FileType FROM ContentDocument WHERE Id = :returnedFile.ContentDocumentId LIMIT 1];
        System.assertEquals(testContentVersion.Title, cd.Title, 'Title should match.');
        //System.assertEquals('pdf', cd.FileType, 'FileType should match.');
    }
}