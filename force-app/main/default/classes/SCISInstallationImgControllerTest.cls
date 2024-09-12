@isTest
public class SCISInstallationImgControllerTest {

    @testSetup
    static void setupTestData() {
        // Create a test parent Installation record (assuming parent is an Installation__c)
        Installation__c installation = new Installation__c(Name = 'Test Installation');
        insert installation;

        // Create related Measure_Status__c records
        Measure_Status__c measureStatus = new Measure_Status__c(
            Name = 'Test Measure Status',
            Installation__c = installation.Id
        );
        insert measureStatus;

        // Create related CWI__c records
        CWI__c cwi = new CWI__c(
            Name = 'Test CWI',
            installation_Id__c = installation.Id
        );
        insert cwi;

        // Create related LI__c records
        LI__c li = new LI__c(
            Name = 'Test LI',
            installation_Id__c = installation.Id
        );
        insert li;

        // Create ContentDocument and ContentVersion related to the parent and child records
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'testimage.jpg',
            VersionData = Blob.valueOf('Test data'),
            IsMajorVersion = true
        );
        insert contentVersion;

        // Link the ContentDocument to the installation (parent record)
        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = installation.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId,
            ShareType = 'I'
        );
        insert contentLink;
    }

    @isTest
    static void testGetRelatedFilesByRecordId_ValidParentId() {
        // Retrieve the test installation record
        Installation__c testInstallation = [SELECT Id FROM Installation__c LIMIT 1];

        Test.startTest();
        // Call the method and pass the valid parent ID
        Map<Id, String> result = SCISInstallationImgController.getRelatedFilesByRecordId(testInstallation.Id);
        Test.stopTest();

        // Validate the results
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(1, result.size(), 'There should be one image returned.');
        System.assertEquals('Test Image', result.values()[0], 'The image title should match the created content.');
    }

    @isTest
    static void testGetRelatedFilesByRecordId_InvalidParentId() {
        Test.startTest();
        try {
            // Call the method with an invalid parent ID
            SCISInstallationImgController.getRelatedFilesByRecordId(null);
            System.assert(false, 'An exception should have been thrown due to invalid parent ID.');
        } catch (IllegalArgumentException e) {
            // Expected exception due to invalid parent ID
            System.assertEquals('Invalid parent record ID.', e.getMessage(), 'Exception message should match.');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetRelatedFilesByRecordId_NoChildRecords() {
        // Create an installation without any child records
        Installation__c installationWithoutChildren = new Installation__c(Name = 'No Children Installation');
        insert installationWithoutChildren;

        Test.startTest();
        // Call the method with an installation having no related records
        Map<Id, String> result = SCISInstallationImgController.getRelatedFilesByRecordId(installationWithoutChildren.Id);
        Test.stopTest();

        // Validate that no images are returned
        System.assertEquals(0, result.size(), 'There should be no images returned for an installation without child records.');
    }
}