@isTest
public class PdfControllerTest {

    @isTest
    static void testSavePdf() {
        // Step 1: Create a sample parent record (e.g., Account, Lead, or any sObject)
        Account testAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer'
        );
        insert testAccount;

        // Step 2: Prepare test data for the savePdf method
        String base64Data = 'JVBERi0xLjMKJcfs';  // Truncated Base64 for a test PDF file
        String fileName = 'TestFile.pdf';
        Id parentId = testAccount.Id;

        // Step 3: Call the savePdf method
        Test.startTest();
        PdfController.savePdf(base64Data, fileName, parentId);
        Test.stopTest();

        // Step 4: Verify that the ContentVersion was created
        List<ContentVersion> contentVersions = [
            SELECT Id, Title, PathOnClient
            FROM ContentVersion
            WHERE Title = :fileName
        ];
        System.assertEquals(1, contentVersions.size(), 'ContentVersion should be created.');
        System.assertEquals(fileName, contentVersions[0].Title, 'ContentVersion title should match.');
        System.assertEquals('/' + fileName, contentVersions[0].PathOnClient, 'PathOnClient should match the fileName.');

        // Step 5: Verify that the ContentDocumentLink was created and linked to the correct parent record
        List<ContentDocumentLink> contentDocumentLinks = [
            SELECT Id, LinkedEntityId, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :parentId
        ];
        System.assertEquals(1, contentDocumentLinks.size(), 'ContentDocumentLink should be created.');
        System.assertEquals(parentId, contentDocumentLinks[0].LinkedEntityId, 'LinkedEntityId should match the parent record.');
    }
}