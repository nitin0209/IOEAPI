@isTest
public class SCISInstallImgPdfVisualControllerTest {

    @testSetup
    static void setupTestData() {
        // Create a test parent Installation record
        Installation__c installation = new Installation__c(Name = 'Test Installation');
        insert installation;

        // Create related Measure_Status__c, CWI__c, and LI__c records
        Measure_Status__c measureStatus = new Measure_Status__c(
            Name = 'Test Measure Status',
            Installation__c = installation.Id
        );
        insert measureStatus;

        CWI__c cwi = new CWI__c(
            Name = 'Test CWI',
            installation_Id__c = installation.Id
        );
        insert cwi;

        LI__c li = new LI__c(
            Name = 'Test LI',
            installation_Id__c = installation.Id
        );
        insert li;

        // Create ContentVersion records representing a PDF and an image
        ContentVersion contentVersionPDF = new ContentVersion(
            Title = 'Test PDF',
            PathOnClient = 'testpdf.pdf',
            VersionData = Blob.valueOf('Test PDF content'),
            IsMajorVersion = true
        );
        insert contentVersionPDF;

        ContentVersion contentVersionImage = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'testimage.jpg',
            VersionData = Blob.valueOf('Test Image content'),
            IsMajorVersion = true
        );
        insert contentVersionImage;

        // Link the ContentDocuments to the parent installation record using ContentDocumentLink
        ContentDocumentLink contentLinkPDF = new ContentDocumentLink(
            LinkedEntityId = installation.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionPDF.Id LIMIT 1].ContentDocumentId,
            ShareType = 'I'
        );
        insert contentLinkPDF;

        ContentDocumentLink contentLinkImage = new ContentDocumentLink(
            LinkedEntityId = installation.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionImage.Id LIMIT 1].ContentDocumentId,
            ShareType = 'I'
        );
        insert contentLinkImage;
    }

    @isTest
    static void testGetRelatedFilesByRecordId_ValidParentId() {
        // Retrieve the test Installation record
        Installation__c testInstallation = [SELECT Id FROM Installation__c LIMIT 1];

        Test.startTest();
        // Call the method with a valid parent record ID
        Map<String, Map<ID, String>> result = SCISInstallationImgPdfVisualController.getRelatedFilesByRecordId(testInstallation.Id);
        Test.stopTest();

        // Validate the result
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.containsKey('pdfs'), 'The result should contain a PDF map.');
        System.assert(result.containsKey('images'), 'The result should contain an image map.');

        // Validate PDFs
        Map<ID, String> pdfMap = result.get('pdfs');
        System.assertEquals(1, pdfMap.size(), 'There should be one PDF returned.');
        System.assertEquals('Test PDF', pdfMap.values()[0], 'The PDF title should match the created content.');

        // Validate images
        Map<ID, String> imageMap = result.get('images');
        System.assertEquals(1, imageMap.size(), 'There should be one image returned.');
        System.assertEquals('Test Image', imageMap.values()[0], 'The image title should match the created content.');
    }

    @isTest
    static void testGetRelatedFilesByRecordId_InvalidParentId() {
        Test.startTest();
        try {
            // Call the method with an invalid parent record ID
            SCISInstallationImgPdfVisualController.getRelatedFilesByRecordId(null);
            System.assert(false, 'An exception should have been thrown due to invalid parent ID.');
        } catch (IllegalArgumentException e) {
            // Expected exception due to invalid parent ID
            System.assertEquals('Invalid parent record ID.', e.getMessage(), 'Exception message should match.');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetRelatedFilesByRecordId_NoChildRecords() {
        // Create an Installation record without any child records
        Installation__c installationWithoutChildren = new Installation__c(Name = 'No Children Installation');
        insert installationWithoutChildren;

        Test.startTest();
        // Call the method with an installation having no related records
        Map<String, Map<ID, String>> result = SCISInstallationImgPdfVisualController.getRelatedFilesByRecordId(installationWithoutChildren.Id);
        Test.stopTest();

        // Validate that no PDFs or images are returned
        System.assert(result.get('pdfs').isEmpty(), 'There should be no PDFs returned.');
        System.assert(result.get('images').isEmpty(), 'There should be no images returned.');
    }

    @isTest
    static void testGetFilesMethod() {
        // Retrieve the test Installation record
        Installation__c testInstallation = [SELECT Id FROM Installation__c LIMIT 1];

        // Create an instance of the controller
        SCISInstallationImgPdfVisualController controller = new SCISInstallationImgPdfVisualController();

        Test.startTest();
        // Call the getFiles method
        Map<String, Map<ID, String>> result = controller.getFiles(testInstallation.Id);
        Test.stopTest();

        // Validate the result
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.containsKey('pdfs'), 'The result should contain a PDF map.');
        System.assert(result.containsKey('images'), 'The result should contain an image map.');
    }
}