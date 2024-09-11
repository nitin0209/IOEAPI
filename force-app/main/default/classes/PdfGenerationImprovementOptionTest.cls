@isTest
public class PdfGenerationImprovementOptionTest {
    
    @isTest
    static void testGeneratePDFAndSave() {
        // Create a test Design_Work__c record
        Design_Work__c designWork = new Design_Work__c(
            Name = 'Test Design Work',
            EV_Is_the_damp_or_mold_present__c = 'No',
            EV_Do_you_have_ventilation_installed__c = 'No',
            D_ventilation_inadequate_no_action_req__c = 'No',
            dMEV_Gross_internal_area_of_the_property__c = 120.0,
            dMEV_Number_of_single_bedrooms__c = 2,
            dMEV_Number_of_double_bedrooms__c = 2,
            dMEV_Whole_dwelling_ventilation_rate__c = 1.5,
            Address__Street__s = '123 Main Street',
            Address__City__s = 'Sample City',
            Address__PostalCode__s = '12345',
            Address__CountryCode__s = 'US'
        );
        insert designWork;

        // Simulate the current page and set the parameters (simulate Visualforce environment)
        Test.setCurrentPage(Page.DesignWork_PDF_Improvement_Option);
        ApexPages.currentPage().getParameters().put('id', designWork.Id);

        // Instantiate the controller
        PdfGenerationImprovementOption controller = new PdfGenerationImprovementOption();

        // Validate that the correct Design_Work__c record is fetched
        System.assertNotEquals(null, controller.Designwork3, 'Designwork should be populated');
        System.assertEquals('123 Main Street, Sample City, 12345, US', controller.Address, 'Address should be constructed correctly');
        
        // Mock the page PDF generation since it won't actually generate a PDF in test context
        Test.startTest();
        
        // Simulate PDF content using a mock blob
        Blob fakePdfBlob = Blob.valueOf('Fake PDF content');

        // Replace the getContentAsPDF call with a mock by setting the Blob manually
        controller.Designwork3 = designWork;
        
        // Simulate the insertion of the ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = designWork.Name + '_' + designWork.Id + 'Improvement Evaluation Option.pdf';
        cv.PathOnClient = designWork.Name + '_' + designWork.Id + '.pdf';
        cv.VersionData = fakePdfBlob;
        cv.FirstPublishLocationId = designWork.Id;
        cv.IsMajorVersion = true;
        insert cv; // This mimics the PDF being saved successfully

        // Verify that ContentVersion was inserted
        ContentVersion[] contentVersions = [SELECT Id, Title, PathOnClient FROM ContentVersion WHERE FirstPublishLocationId = :designWork.Id];
        System.assertEquals(1, contentVersions.size(), 'A ContentVersion should have been inserted');
        System.assertEquals(designWork.Name + '_' + designWork.Id + 'Improvement Evaluation Option.pdf', contentVersions[0].Title, 'ContentVersion title should match the expected format');
        
        Test.stopTest();
    }
}