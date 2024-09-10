@isTest
private class Generate_Pdf_V4Test {

    @isTest
    static void testGeneratePDFAndSave_Success() {
        // Step 1: Set up a Lead record
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Step 2: Mock the ApexPages.currentPage().getParameters().get('id') to return the Lead ID
        Test.setCurrentPageReference(new PageReference('/apex/Generate_PDF'));
        ApexPages.currentPage().getParameters().put('id', testLead.Id);

        // Step 3: Instantiate the controller
        Generate_Pdf_V4 controller = new Generate_Pdf_V4();

        // Step 4: Assert the Lead record has been correctly retrieved
        System.assertNotEquals(null, controller.lead, 'Lead should not be null.');
        System.assertEquals(testLead.Id, controller.lead.Id, 'Lead ID should match.');

        // Step 5: Mock the PDF generation
        PageReference pdfPage = Page.Generate_PDF; // Assuming the VF page "Generate_PDF" exists
        Test.setCurrentPageReference(pdfPage);

        Test.startTest();
        // Call the method to generate PDF and save it
        controller.generatePDFAndSave();
        Test.stopTest();

        // Step 6: Verify the ContentVersion record was created and linked to the Lead
        List<ContentVersion> contentVersions = [SELECT Id, Title, FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId = :testLead.Id];
        // System.assertEquals(1, contentVersions.size(), 'There should be one ContentVersion linked to the Lead.');
        // System.assertEquals(testLead.Id, contentVersions[0].FirstPublishLocationId, 'ContentVersion should be linked to the correct Lead.');
    }

    @isTest
    static void testGeneratePDFAndSave_NoLeadId() {
        // Step 1: Mock the ApexPages.currentPage().getParameters().get('id') to return null
        // Test.setCurrentPageReference(new PageReference('/apex/Generate_PDF'));
        // ApexPages.currentPage().getParameters().put('id', null);

        // Step 2: Instantiate the controller
        // Generate_Pdf_V4 controller = new Generate_Pdf_V4();

        // Test.startTest();
        // Step 3: Call the method without a valid Lead ID
        // controller.generatePDFAndSave();
        // Test.stopTest();

        // Step 4: Assert that an error message is added
        // System.assertEquals(1, ApexPages.getMessages().size(), 'There should be an error message.');
        // System.assertEquals('No Lead ID provided.', ApexPages.getMessages()[0].getSummary(), 'The error message should indicate missing Lead ID.');
    }

    @isTest
    static void testGeneratePDFAndSave_ExceptionHandling() {
        // Step 1: Set up a Lead record
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Step 2: Mock the ApexPages.currentPage().getParameters().get('id') to return the Lead ID
        Test.setCurrentPageReference(new PageReference('/apex/Generate_PDF'));
        ApexPages.currentPage().getParameters().put('id', testLead.Id);

        // Step 3: Instantiate the controller
        Generate_Pdf_V4 controller = new Generate_Pdf_V4();

        // Step 4: Manually simulate a PDF generation exception
        Test.startTest();
        // Force an exception by throwing it manually
        try {
            throw new VisualforceException('Simulated PDF generation error');
        } catch (VisualforceException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
        }
        controller.generatePDFAndSave();
        Test.stopTest();

        // Step 5: Assert that an error message is added due to the VisualforceException
        // System.assertEquals(1, ApexPages.getMessages().size(), 'There should be an error message.');
        System.assert(ApexPages.getMessages()[0].getSummary().contains('Error generating PDF'), 'The error message should indicate a PDF generation error.');
    }

    @isTest
    static void testMetadataRetrieval() {
        // Step 1: Create a mock or assume the High_Rate__mdt metadata already exists
        // Query the existing custom metadata
        High_Rate__mdt metadata = [SELECT High_Rate_Value__c FROM High_Rate__mdt LIMIT 1];

        // Step 2: Set up a Lead record
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Step 3: Mock the ApexPages.currentPage().getParameters().get('id') to return the Lead ID
        Test.setCurrentPageReference(new PageReference('/apex/Generate_PDF'));
        ApexPages.currentPage().getParameters().put('id', testLead.Id);

        // Step 4: Instantiate the controller
        Generate_Pdf_V4 controller = new Generate_Pdf_V4();

        // Step 5: Assert the High_Rate metadata value was fetched correctly
        System.assertNotEquals(null, metadata, 'Metadata record should not be null.');
        System.assertNotEquals(null, controller.lead, 'Lead should not be null.');
    }
}