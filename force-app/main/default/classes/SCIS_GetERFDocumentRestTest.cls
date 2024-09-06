/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   21-05-2024
Trigger Name            :   SCIS_GetERFDocumentRest
TestClass Name          :   SCIS_GetERFDocumentRestTest
Connected Class         :   
Description             :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */


@isTest
public class SCIS_GetERFDocumentRestTest {

    @isTest
    static void testGetERFDocument() {
        // Create unique ERF record
        ERF__c erf = new ERF__c(Name = 'Test ERF ' + System.currentTimeMillis());
        insert erf;

        // Create ContentVersion (this will also create a ContentDocument)
        ContentVersion contentVer = new ContentVersion(
            Title = 'Test Document ' + System.currentTimeMillis(),
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test Data')
        );
        insert contentVer;

        // Fetch the ContentDocumentId from the newly inserted ContentVersion
        ContentVersion insertedContentVer = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVer.Id LIMIT 1];

        // Create ContentDocumentLink linking ContentDocument to ERF
        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = insertedContentVer.ContentDocumentId,
            LinkedEntityId = erf.Id
        );
        insert contentLink;

        // Set up the RestContext request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getERFDocument/' + erf.Id + '/' + contentVer.Title;
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST service method
        String response = SCIS_GetERFDocumentRest.getERFDocument();

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(200, RestContext.response.statusCode, 'Status code should be 200');
    }

    @isTest
    static void testGetERFDocument_NoDocumentLinked() {
        // Create unique ERF record
        ERF__c erf = new ERF__c(Name = 'Test ERF ' + System.currentTimeMillis());
        insert erf;

        // Set up the RestContext request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getERFDocument/' + erf.Id + '/NonExistingDocument';
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST service method
        String response = SCIS_GetERFDocumentRest.getERFDocument();

        // Assertions
        System.assertEquals('No document linked to the ERF record.', response, 'Response should indicate no document found');
        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
    }

    @isTest
    static void testGetERFDocument_InvalidERFId() {
        // Set up the RestContext request with invalid ERF ID
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/getERFDocument/invalidERFId/DocumentName';
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST service method
        String response = SCIS_GetERFDocumentRest.getERFDocument();

        // Assertions
        System.assertEquals('ERF record not found.', response, 'Response should indicate ERF record not found');
        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
    }
}