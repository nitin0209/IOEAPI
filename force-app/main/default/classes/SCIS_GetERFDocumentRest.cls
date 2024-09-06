/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   05-04-2024
Trigger Name            :   SCIS_GetERFDocumentRest
TestClass Name          :   
Connected Class         :   
@Description            :   This class is used to expose the ERF document that is pdf to the requsting app.
							This class returns the pdf in the base64 format. THis base64 is used by app team.
Last Modification Date  :   05-04-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							@param erfId = store erf id received from app in the restcontext
							@param base64 = to return the version data in the base64 format. 
************************************************************************************************************************************************** */


@RestResource(urlMapping='/getERFDocument/*')
global with sharing class SCIS_GetERFDocumentRest {

    @HttpGet
    global static String getERFDocument() {
        //RestRequest req = RestContext.request;
        
	RestRequest req = RestContext.request;
        
	// Splitting the requestURI by slashes
	String requestURI = req.requestURI;
	String[] parts = requestURI.split('/');

	// Ensure the parts array has enough elements before extracting parameters
	String erfId = (parts.size() >= 2) ? parts[parts.size() - 2] : null; // Second to last part of the URI
	String erfName = (parts.size() >= 1) ? parts[parts.size() - 1] : null; // Last part of the URI

     
   
        
        //String erfId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        if(String.isBlank(erfId)) {
            RestContext.response.statusCode = 400; // Bad Request
            return 'ERF ID is required.';
        }

        List<ERF__c> erfRecords = [SELECT Id FROM ERF__c WHERE Id = :erfId LIMIT 1];
        if(erfRecords.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'ERF record not found.';
        }

        //List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :erfId LIMIT 1];
        
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :erfId];
        
        
        list<id> idList = new list<id>();
        for(ContentDocumentLink cld2 : cdlList ){
            idList.add(cld2.ContentDocumentId);
        }
        
        if(cdlList.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'No document linked to the ERF record.';
        }

        ContentDocumentLink cld = cdlList[0];
        
        List<ContentVersion> cvList = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId IN: idList AND Title LIKE: erfName ORDER BY VersionNumber DESC LIMIT 1];


        
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
@RestResource(urlMapping='/getERFDocument/*')
global with sharing class SCIS_GetERFDocumentRest {

    @HttpGet
    global static String getERFDocument() {
        string base64;
        RestRequest req = RestContext.request;
        String erfId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        //return erfId;
        // Retrieve the ERF record
        ERF__c erfRecord = [SELECT Id, Name FROM ERF__c WHERE id =: erfId LIMIT 1];
		system.debug('erfRecord' + erfRecord);
		ContentDocumentLink cld = [select id,LinkedEntityId from ContentDocumentLink where LinkedEntityId=: erfRecord.id  ];
		system.debug('cld' + cld);
        //ContentVersion cv = [select id,contentDocumentId  from ContentVersion where contentDocumentId =: cld.ContentDocumentId limit 1];
		ContentVersion cv = [SELECT Id, ContentDocumentId,VersionNumber FROM ContentVersion WHERE ContentDocumentId = :cld.ContentDocumentId ORDER BY VersionNumber DESC LIMIT 1];
        system.debug('cv data' + cv.VersionData);
        base64 = EncodingUtil.base64Encode(cv.VersionData);
        system.debug('Base 64 part 1 = '+ base64);
        system.debug('Cv.id = '+ cv.Id);
        if(erfRecord != null){
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


 /* if (erfRecord != null) {
            // Retrieve the Document attached to the ERF record
            Document document = [SELECT Id, Body FROM Document WHERE Id = :erfRecord.PDF_Document__c LIMIT 1];
            if (document != null && document.Body != null) {
                // Convert Document Body to base64
                return EncodingUtil.base64Encode(document.Body);
            }
        } */