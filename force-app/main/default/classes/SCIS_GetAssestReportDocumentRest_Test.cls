/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   21-05-2024
Trigger Name            :   SCIS_GetAssessmentReportDocumentRest
TestClass Name          :   SCIS_GetAssestReportDocumentRest_Test
Connected Class         :   
Description             :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */


@isTest
public class SCIS_GetAssestReportDocumentRest_Test {

    @isTest
    static void testGetAssessmentReportDocument() {
        // Create test data
        Assessment_Report__c testAssessmentReport = new Assessment_Report__c();
        insert testAssessmentReport;

        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test document content'),
            PathOnClient = 'testDocument.txt'
        );
        insert testContentVersion;

        ContentDocumentLink testCDL = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id].ContentDocumentId,
            LinkedEntityId = testAssessmentReport.Id,
            ShareType = 'V'
        );
        insert testCDL;

        Test.startTest();
        // Call the REST service
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/getAssesmentReportDocument/' + testAssessmentReport.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;
        SCIS_GetAssessmentReportDocumentRest.getAssesmentReportDocument();
        Test.stopTest();

        // Verify response
        System.assertEquals(200, RestContext.response.statusCode, 'Expected status code 200');
        
        // Assert response body if not null
        if (RestContext.response.responseBody != null) {
            System.assertNotEquals(null, RestContext.response.responseBody.toString(), 'Expected non-null response body');
        } else {
            System.debug('Response body is null.'); // Debug message for null response body
        }
    }

}