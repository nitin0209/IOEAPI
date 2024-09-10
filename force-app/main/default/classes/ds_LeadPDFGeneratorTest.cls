@isTest
public class ds_LeadPDFGeneratorTest {

    @testSetup
    static void setupTestData() {
        // Create a test Lead record with EPC_Data__c (Rich Text Field)
        Lead lead = new Lead(LastName = 'Test Lead', Company = 'Test Company', EPC_Data__c = '<p>Sample Rich Text Data</p>');
        insert lead;
    }
    
    @isTest
    static void testGenerateAndAttachPDF_Success() {
        // Retrieve the test Lead created in test setup
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        Test.startTest();
        // Call the method to generate and attach the PDF
        ds_LeadPDFGenerator.generateAndAttachPDF(testLead.Id);
        Test.stopTest();
        
        // Verify that the attachment was created
        Attachment attachment = [SELECT Id, Name, ContentType, ParentId FROM Attachment WHERE ParentId = :testLead.Id LIMIT 1];
        System.assertNotEquals(null, attachment, 'Attachment should have been created');
        System.assertEquals('LeadRichText.pdf', attachment.Name, 'Attachment name should be LeadRichText.pdf');
        System.assertEquals('application/pdf', attachment.ContentType, 'Content type should be application/pdf');
        System.assertEquals(testLead.Id, attachment.ParentId, 'Attachment should be associated with the correct Lead');
    }

    @isTest
    static void testGenerateAndAttachPDF_NoEPCData() {
        // Create a Lead without EPC_Data__c (null rich text field)
        Lead leadNoEPCData = new Lead(LastName = 'No EPC Data', Company = 'Test Company');
        insert leadNoEPCData;

        Test.startTest();
        try {
            ds_LeadPDFGenerator.generateAndAttachPDF(leadNoEPCData.Id);
            System.assert(false, 'Expected an exception for null EPC_Data__c');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Lead record or Rich Text Field is null.', e.getMessage(), 'Exception message should be correct');
        }
        Test.stopTest();
    }
}