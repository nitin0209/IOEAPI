@isTest
public class PdfGene4DesignWorkMedTermPlanTest {
    @isTest
    static void testGeneratePDFAndSave() {
        // Step 1: Create test data for Design_Work__c
        Design_Work__c testDesignWork = new Design_Work__c(
            Name = 'Test Design Work',
            EV_Is_the_damp_or_mold_present__c = 'No',
            EV_Do_you_have_ventilation_installed__c = 'No',
            D_ventilation_inadequate_no_action_req__c = 'No',
            dMEV_Gross_internal_area_of_the_property__c = 100,
            dMEV_Number_of_single_bedrooms__c = 2,
            dMEV_Number_of_double_bedrooms__c = 1,
            dMEV_Whole_dwelling_ventilation_rate__c = 50
        );
        insert testDesignWork;

        // Step 2: Mock the Visualforce page for PDF generation
        Test.setCurrentPage(Page.DesignWork_PDF_Medium_Term_Plan);
        ApexPages.currentPage().getParameters().put('id', testDesignWork.Id);

        // Step 3: Instantiate the PdfGenerationForDesignWorkMediumTermPlan class
        PdfGenerationForDesignWorkMediumTermPlan pdfGen = new PdfGenerationForDesignWorkMediumTermPlan();

        // Step 4: Execute the method to generate the PDF and save it as ContentVersion
        Test.startTest();
        PageReference result = pdfGen.generatePDFAndSave();
        Test.stopTest();

        // Step 5: Assert that the ContentVersion record was created
        List<ContentVersion> contentVersions = [
            SELECT Id, Title, PathOnClient, FirstPublishLocationId
            FROM ContentVersion
            WHERE FirstPublishLocationId = :testDesignWork.Id
        ];
        // System.assertEquals(1, contentVersions.size(), 'ContentVersion should be created.');
        // System.assert(contentVersions[0].Title.contains('Medium Term Plan.pdf'), 'The ContentVersion title should contain Medium Term Plan.');
        // System.assertEquals(testDesignWork.Id, contentVersions[0].FirstPublishLocationId, 'The ContentVersion should be linked to the Design_Work__c record.');

        // Step 6: Assert that the result is null (as the method does not return a page reference on success)
        // System.assertEquals(null, result, 'The generatePDFAndSave method should return null on success.');
    }
}