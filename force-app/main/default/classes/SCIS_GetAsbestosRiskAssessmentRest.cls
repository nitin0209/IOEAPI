/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   08-04-2024
Trigger Name            :   
TestClass Name          :   SCIS_GetAsbestosRiskAssessmentRest
Connected Class         :   
@Description            :   This class is used to expose the Asbestos_Risk_Assessment document that is pdf to the requsting app.
							This class returns the pdf in the base64 format. THis base64 is used by app team.
Last Modification Date  :   08-04-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							@param Asbestos_Risk_AssessmentId = store Asbestos_Risk_Assessment id received from app in the restcontext
							@param base64 = to return the version data in the base64 format. 
************************************************************************************************************************************************** */


@RestResource(urlMapping='/getAsbestos_Risk_AssessmentDocument/*')
global with sharing class SCIS_GetAsbestosRiskAssessmentRest {

    @HttpGet
    global static String getAsbestos_Risk_AssessmentDocument() {
        RestRequest req = RestContext.request;
        String Asbestos_Risk_AssessmentId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        if(String.isBlank(Asbestos_Risk_AssessmentId)) {
            RestContext.response.statusCode = 400; // Bad Request
            return 'Asbestos_Risk_Assessment ID is required.';
        }

        List<Asbestos_Risk_Assessment__c> Asbestos_Risk_AssessmentRecords = [SELECT Id FROM Asbestos_Risk_Assessment__c WHERE Id = :Asbestos_Risk_AssessmentId LIMIT 1];
        if(Asbestos_Risk_AssessmentRecords.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'Asbestos_Risk_Assessment record not found.';
        }

        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :Asbestos_Risk_AssessmentId LIMIT 1];
        if(cdlList.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'No document linked to the Asbestos_Risk_Assessment record.';
        }

        ContentDocumentLink cld = cdlList[0];
        
        List<ContentVersion> cvList = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :cld.ContentDocumentId ORDER BY VersionNumber DESC LIMIT 1];
        if(cvList.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'Document content not found.';
        }

        ContentVersion cv = cvList[0];
        String base64 = EncodingUtil.base64Encode(cv.VersionData);
        
        RestContext.response.statusCode = 200; // OK
        return base64;
    }
}