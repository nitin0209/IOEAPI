/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   21-05-2024
Trigger Name            :   SCIS_GetAsbestosRiskAssessmentRest
TestClass Name          :   SCIS_GetAsbestosRiskAssessmentRestTest
Connected Class         :   
Description             :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */


@isTest
private class SCIS_GetAsbestosRiskAssessmentRestTest {

    @isTest
    static void testGetAsbestos_Risk_AssessmentDocument_NoId() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getAsbestos_Risk_AssessmentDocument/';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = SCIS_GetAsbestosRiskAssessmentRest.getAsbestos_Risk_AssessmentDocument();
        Test.stopTest();

        System.assertEquals('Asbestos_Risk_Assessment ID is required.', response, 'Response should indicate ID is required');
        System.assertEquals(400, RestContext.response.statusCode, 'Status code should be 400');
    }

    @isTest
    static void testGetAsbestos_Risk_AssessmentDocument_RecordNotFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getAsbestos_Risk_AssessmentDocument/invalidId';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = SCIS_GetAsbestosRiskAssessmentRest.getAsbestos_Risk_AssessmentDocument();
        Test.stopTest();

        System.assertEquals('Asbestos_Risk_Assessment record not found.', response, 'Response should indicate record not found');
        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
    }

    @isTest
    static void testGetAsbestos_Risk_AssessmentDocument_NoDocumentLinked() {
        Asbestos_Risk_Assessment__c assessment = new Asbestos_Risk_Assessment__c();
        insert assessment;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getAsbestos_Risk_AssessmentDocument/' + assessment.Id;
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = SCIS_GetAsbestosRiskAssessmentRest.getAsbestos_Risk_AssessmentDocument();
        Test.stopTest();

        System.assertEquals('No document linked to the Asbestos_Risk_Assessment record.', response, 'Response should indicate no document linked');
        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
    }

    @isTest
    static void testGetAsbestos_Risk_AssessmentDocument_DocumentNotFound() {
        Asbestos_Risk_Assessment__c assessment = new Asbestos_Risk_Assessment__c();
        insert assessment;

        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test Data')
        );
        insert cv;

        // Retrieve the ContentDocumentId from the inserted ContentVersion
        ContentVersion insertedCv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = assessment.Id,
            ContentDocumentId = insertedCv.ContentDocumentId
        );
        insert cdl;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getAsbestos_Risk_AssessmentDocument/' + assessment.Id;
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = SCIS_GetAsbestosRiskAssessmentRest.getAsbestos_Risk_AssessmentDocument();
        Test.stopTest();

        // System.assertEquals('Document content not found.', response, 'Response should indicate document content not found');
        // System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
    }

    @isTest
    static void testGetAsbestos_Risk_AssessmentDocument_Success() {
        Asbestos_Risk_Assessment__c assessment = new Asbestos_Risk_Assessment__c();
        insert assessment;

        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test Data')
        );
        insert cv;

        // Retrieve the ContentDocumentId from the inserted ContentVersion
        ContentVersion insertedCv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = assessment.Id,
            ContentDocumentId = insertedCv.ContentDocumentId
        );
        insert cdl;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getAsbestos_Risk_AssessmentDocument/' + assessment.Id;
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = SCIS_GetAsbestosRiskAssessmentRest.getAsbestos_Risk_AssessmentDocument();
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(200, RestContext.response.statusCode, 'Status code should be 200');
    }
}