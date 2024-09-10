@isTest
public class SCIS_LeadPDFControllerTest {
    @isTest
    static void testGeneratePDFAndSave() {
        // Step 1: Create and insert a Lead record
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Step 2: Mock the Visualforce page for PDF generation
        Test.startTest();
        Test.setCurrentPage(Page.Generate_PDF);
        ApexPages.currentPage().getParameters().put('id', testLead.Id);

        // Step 3: Instantiate the SCIS_LeadPDFController class and set leadId
        SCIS_LeadPDFController pdfController = new SCIS_LeadPDFController();
        pdfController.leadId = testLead.Id;

        // Mock the PDF generation by using a dummy PDF data string
        String dummyBase64PdfData = EncodingUtil.base64Encode(Blob.valueOf('Dummy PDF Content'));
        
        // Use a utility method or mock to simulate savePdf behavior
        // For simplicity, we're directly testing the logic that follows the PDF generation
        pdfController.generatePDFAndSave();

        // Step 4: Assert that the ContentVersion record was created
        List<ContentVersion> contentVersions = [
            SELECT Id, Title, PathOnClient, FirstPublishLocationId, ContentDocumentId
            FROM ContentVersion
            WHERE FirstPublishLocationId = :testLead.Id
        ];
        System.assertEquals(1, contentVersions.size(), 'ContentVersion should be created.');
        System.assert(contentVersions[0].Title.contains('Lead_' + testLead.Id + '.pdf'), 'The ContentVersion title should contain the Lead ID.');
        System.assertEquals(testLead.Id, contentVersions[0].FirstPublishLocationId, 'The ContentVersion should be linked to the Lead record.');

        // Assert that the ContentDocumentLink record was created
        List<ContentDocumentLink> contentDocumentLinks = [
            SELECT Id, ContentDocumentId, LinkedEntityId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :testLead.Id
        ];
        System.assertEquals(1, contentDocumentLinks.size(), 'ContentDocumentLink should be created.');
        System.assertEquals(testLead.Id, contentDocumentLinks[0].LinkedEntityId, 'The ContentDocumentLink should be linked to the Lead record.');
        System.assertEquals('V', contentDocumentLinks[0].ShareType, 'ShareType should be set to View.');
        System.assertEquals('AllUsers', contentDocumentLinks[0].Visibility, 'Visibility should be set to AllUsers.');

        // Assert that no errors were added
        System.assertEquals(0, ApexPages.getMessages().size(), 'There should be no error messages.');
        
        Test.stopTest();
    }

    @isTest
    static void testGeneratePDFAndSave_NoLeadId() {
        // Instantiate the SCIS_LeadPDFController class without setting leadId
        SCIS_LeadPDFController pdfController = new SCIS_LeadPDFController();
        
        // Execute the generatePDFAndSave method
        Test.startTest();
        PageReference resultPage = pdfController.generatePDFAndSave();
        Test.stopTest();

        // Assert that an error message was added
        System.assertEquals(1, ApexPages.getMessages().size(), 'There should be one error message.');
        System.assertEquals('No Lead ID provided.', ApexPages.getMessages()[0].getSummary(), 'The error message should indicate missing Lead ID.');

        // Assert that the result page reference is null
        System.assertEquals(null, resultPage, 'The result page reference should be null when Lead ID is not provided.');
    }
}