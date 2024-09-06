/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   08-04-2024
Trigger Name            :   SCIS_GetAssessmentReportDocumentRest
TestClass Name          :   
Connected Class         :   
@Description            :   This class is used to expose the Assessment Report document that is pdf to the requsting app.
							This class returns the pdf in the base64 format. THis base64 is used by app team.
Last Modification Date  :   08-04-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							@param assesmentReportId = store assesment report id received from app in the restcontext
							@param base64 = to return the version data in the base64 format. 
************************************************************************************************************************************************** */


@RestResource(urlMapping='/getAssesmentReportDocument/*')
global with sharing class SCIS_GetAssessmentReportDocumentRest {

    @HttpGet
    global static String getAssesmentReportDocument() {
        RestRequest req = RestContext.request;
        String assesmentReportId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        if(String.isBlank(assesmentReportId)) {
            RestContext.response.statusCode = 400; // Bad Request
            return 'Assesment Report ID is required.';
        }

        List<Assessment_Report__c> assessmentReportRecords = [SELECT Id FROM Assessment_Report__c WHERE Id = :assesmentReportId LIMIT 1];
        if(assessmentReportRecords.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'Assesment Report record not found.';
        }

        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :assesmentReportId LIMIT 1];
        if(cdlList.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'No document linked to the Assesment Report record.';
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



/*
// 05-April-2024 this code not returing cv.version data only
@RestResource(urlMapping='/getAssesmentReportDocument/*')
global with sharing class SCIS_GetAssessmentReportDocumentRest {

    @HttpGet
    global static String getAssesmentReportDocument() {
        string base64;
        RestRequest req = RestContext.request;
        String assesmentReportId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        //return assesmentReportId;
        // Retrieve the Assesment Report record
        Assessment_Report__c assessmentReportRecords = [SELECT Id, Name FROM Assessment_Report__c WHERE id =: assesmentReportId LIMIT 1];
		system.debug('assessmentReportRecords' + assessmentReportRecords);
		ContentDocumentLink cld = [select id,LinkedEntityId from ContentDocumentLink where LinkedEntityId=: assessmentReportRecords.id  ];
		system.debug('cld' + cld);
        //ContentVersion cv = [select id,contentDocumentId  from ContentVersion where contentDocumentId =: cld.ContentDocumentId limit 1];
		ContentVersion cv = [SELECT Id, ContentDocumentId,VersionNumber FROM ContentVersion WHERE ContentDocumentId = :cld.ContentDocumentId ORDER BY VersionNumber DESC LIMIT 1];
        system.debug('cv data' + cv.VersionData);
        base64 = EncodingUtil.base64Encode(cv.VersionData);
        system.debug('Base 64 part 1 = '+ base64);
        system.debug('Cv.id = '+ cv.Id);
        if(assessmentReportRecords != null){
            system.debug(EncodingUtil.base64Encode(cv.VersionData));
            system.debug('Base 64 = '+ base64);
            //return EncodingUtil.base64Encode(cv.VersionData);
            return base64;
        }else{
            // If no document found or there's an error, return null
            return null;
        }	
  
    }
}

*/


 /* if (assessmentReportRecords != null) {
            // Retrieve the Document attached to the Assesment Report record
            Document document = [SELECT Id, Body FROM Document WHERE Id = :assessmentReportRecords.PDF_Document__c LIMIT 1];
            if (document != null && document.Body != null) {
                // Convert Document Body to base64
                return EncodingUtil.base64Encode(document.Body);
            }
        } */