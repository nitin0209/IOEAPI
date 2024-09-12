@isTest
public class SCISInstallationPDfControllerTest {

    @testSetup
    static void setupTestData() {
        // Create a test Installation__c record (parent)
        Installation__c installation = new Installation__c(Name = 'Test Installation');
        insert installation;

        // Create related Measure_Status__c, CWI__c, and LI__c records (children)
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

        // Create ContentVersion records representing PDFs
        ContentVersion contentVersionPDF1 = new ContentVersion(
            Title = 'Test PDF 1',
            PathOnClient = 'testpdf1.pdf',
            VersionData = Blob.valueOf('Test PDF 1 content'),
            IsMajorVersion = true
        );
        insert contentVersionPDF1;

        ContentVersion contentVersionPDF2 = new ContentVersion(
            Title = 'Test PDF 2',
            PathOnClient = 'testpdf2.pdf',
            VersionData = Blob.valueOf('Test PDF 2 content'),
            IsMajorVersion = true
        );
        insert contentVersionPDF2;

        // Link the ContentDocuments to the parent installation record using ContentDocumentLink
        ContentDocumentLink contentLinkPDF1 = new ContentDocumentLink(
            LinkedEntityId = installation.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionPDF1.Id LIMIT 1].ContentDocumentId,
            ShareType = 'I'
        );
        insert contentLinkPDF1;

        ContentDocumentLink contentLinkPDF2 = new ContentDocumentLink(
            LinkedEntityId = measureStatus.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionPDF2.Id LIMIT 1].ContentDocumentId,
            ShareType = 'I'
        );
        insert contentLinkPDF2;
    }

    @isTest
    static void testGetRelatedFilesByRecordId_ValidParentId() {
        // Retrieve the test Installation__c record
        Installation__c testInstallation = [SELECT Id FROM Installation__c LIMIT 1];

        Test.startTest();
        // Call the method with a valid parent record ID
        Map<ID, String> result = SCISInstallationPDfController.getRelatedFilesByRecordId(testInstallation.Id);
        Test.stopTest();

        // Validate the result
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(2, result.size(), 'There should be two PDF files linked to the installation and its related records.');
        //System.assert(result.containsValue('Test PDF 1'), 'The result should contain Test PDF 1.');
        //System.assert(result.containsValue('Test PDF 2'), 'The result should contain Test PDF 2.');
    }

    @isTest
    static void testGetRelatedFilesByRecordId_InvalidParentId() {
        Test.startTest();
        try {
            // Call the method with an invalid parent record ID (null)
            SCISInstallationPDfController.getRelatedFilesByRecordId(null);
            System.assert(false, 'An exception should have been thrown due to invalid parent ID.');
        } catch (IllegalArgumentException e) {
            // Expected exception due to invalid parent ID
            System.assertEquals('Invalid parent record ID.', e.getMessage(), 'Exception message should match.');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetRelatedFilesByRecordId_NoChildRecords() {
        // Create an Installation__c record without any child records
        Installation__c installationWithoutChildren = new Installation__c(Name = 'No Children Installation');
        insert installationWithoutChildren;

        Test.startTest();
        // Call the method with an installation having no related records
        Map<ID, String> result = SCISInstallationPDfController.getRelatedFilesByRecordId(installationWithoutChildren.Id);
        Test.stopTest();

        // Validate that no PDFs are returned
        System.assertEquals(0, result.size(), 'There should be no PDFs linked to the installation without children.');
    }
}