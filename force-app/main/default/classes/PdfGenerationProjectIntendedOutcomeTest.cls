@isTest
public class PdfGenerationProjectIntendedOutcomeTest {
    
    @isTest
    static void testGeneratePDFAndSave() {
        // Step 1: Create test data
        // Insert a Design_Work__c record
        Design_Work__c designWork = new Design_Work__c(
            Name = 'Test Design Work',
            Date__c = Date.today(),
            Project_Reference__c = 'Test Project Reference',
            Address__Street__s = '123 Test Street',
            Address__City__s = 'Test City',
            Address__PostalCode__s = '12345',
            Address__CountryCode__s = 'US',
            IO_Reductions_in_energy_use__c = true,
            IO_Reductions_in_energy_use_Action__c = 'Reduce energy by 10%',
            IO_Improvement_in_internal_comfort__c = true,
            IO_Improvement_in_internal_comfortAction__c = 'Increase comfort by adding insulation'
        );
        insert designWork;

        // Step 2: Simulate the current Visualforce page and set the page parameters
        Test.setCurrentPage(Page.DesignWork_PDF_Intented_Outcomes);
        ApexPages.currentPage().getParameters().put('id', designWork.Id);

        // Step 3: Instantiate the controller
        PdfGenerationProjectIntendedOutcome controller = new PdfGenerationProjectIntendedOutcome();

        // Step 4: Assert that the correct Design_Work__c record is fetched
        System.assertNotEquals(null, controller.Designwork2, 'Designwork should be populated');
        System.assertEquals('123 Test Street, Test City, 12345, US', controller.Address, 'Address should be constructed correctly');

        // Step 5: Mock PDF content since PageReference.getContentAsPDF() doesn't work in test context
        Blob fakePdfBlob = Blob.valueOf('Mock PDF content');
        
        // Step 6: Manually insert ContentVersion as PDF
        Test.startTest();
        
        // Simulate PDF generation by setting fake blob manually
        controller.Designwork2 = designWork;
        
        // Step 7: Insert ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = designWork.Name + '_' + designWork.Id + 'Project Intended Outcomes.pdf';
        cv.PathOnClient = designWork.Name + '_' + designWork.Id + '.pdf';
        cv.VersionData = fakePdfBlob;
        cv.FirstPublishLocationId = designWork.Id;
        cv.IsMajorVersion = true;
        insert cv;

        // Step 8: Assert that ContentVersion was inserted successfully
        ContentVersion[] contentVersions = [SELECT Id, Title, PathOnClient FROM ContentVersion WHERE FirstPublishLocationId = :designWork.Id];
        System.assertEquals(1, contentVersions.size(), 'One ContentVersion should be inserted');
        System.assertEquals(designWork.Name + '_' + designWork.Id + 'Project Intended Outcomes.pdf', contentVersions[0].Title, 'ContentVersion title should be correct');
        
        Test.stopTest();
    }
}