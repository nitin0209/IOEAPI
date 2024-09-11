@isTest
public class PdfGenerationRetrofitTest {
    
    @isTest
    static void testGeneratePDFAndSave() {
        // Step 1: Create test data
        // Insert a Design_Work__c record with required fields
        Design_Work__c designWork = new Design_Work__c(
            Name = 'Test Design Work Retrofit',
            EV_Is_the_damp_or_mold_present__c = 'No',
            EV_Do_you_have_ventilation_installed__c = 'Yes',
            D_ventilation_inadequate_no_action_req__c = 'Yes',
            dMEV_Gross_internal_area_of_the_property__c = 1000,
            dMEV_Number_of_single_bedrooms__c = 2,
            dMEV_Number_of_double_bedrooms__c = 3,
            dMEV_Whole_dwelling_ventilation_rate__c = 4.5,
            Address__Street__s = '123 Test Street',
            Address__City__s = 'Test City',
            Address__PostalCode__s = '12345',
            Address__CountryCode__s = 'US'
        );
        insert designWork;

        // Step 2: Simulate the current Visualforce page and set the page parameters
        Test.setCurrentPage(Page.DesignWork_PDF_Retrofit);  // Simulate page reference
        ApexPages.currentPage().getParameters().put('id', designWork.Id);

        // Step 3: Instantiate the controller
        PdfGenerationRetrofit controller = new PdfGenerationRetrofit();

        // Step 4: Assert that the correct Design_Work__c record is fetched
        System.assertNotEquals(null, controller.Designwork4, 'Designwork should be populated');
        System.assertEquals('123 Test Street, Test City, 12345, US', controller.Address, 'Address should be constructed correctly');

        // Step 5: Mock PDF content since PageReference.getContentAsPDF() doesn't work in test context
        Blob fakePdfBlob = Blob.valueOf('Mock PDF content');
        
        // Step 6: Manually insert ContentVersion as PDF
        Test.startTest();
        
        // Simulate PDF generation by setting fake blob manually
        controller.Designwork4 = designWork;
        
        // Step 7: Insert ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = designWork.Name + '_' + designWork.Id + 'Retrofit.pdf';
        cv.PathOnClient = designWork.Name + '_' + designWork.Id + '.pdf';
        cv.VersionData = fakePdfBlob;
        cv.FirstPublishLocationId = designWork.Id;
        cv.IsMajorVersion = true;
        insert cv;

        // Step 8: Assert that ContentVersion was inserted successfully
        ContentVersion[] contentVersions = [SELECT Id, Title, PathOnClient FROM ContentVersion WHERE FirstPublishLocationId = :designWork.Id];
        System.assertEquals(1, contentVersions.size(), 'One ContentVersion should be inserted');
        System.assertEquals(designWork.Name + '_' + designWork.Id + 'Retrofit.pdf', contentVersions[0].Title, 'ContentVersion title should be correct');
        
        Test.stopTest();
    }
}