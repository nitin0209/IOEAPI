/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   08-04-2024
Trigger Name            :   SCIS_GetPIBIDocumentRest
TestClass Name          :   SCIS_GetPIBIDocumentRest_Test
Connected Class         :   
@Description            :   This class is used to expose the PIBI document that is pdf to the requsting app.
							This class returns the pdf in the base64 format. THis base64 is used by app team.
Last Modification Date  :   26-08-2024
Last Modified By        :   ADITYA MORE
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							@param pibiId = store PIBI id received from app in the restcontext
							@param base64 = to return the version data in the base64 format. 
							#Change1 : Updated the API so that it should fetch data using both id and Title.
							#Change2 : Updated the API so that it should fetch data using both id and Title where Title will have
							%20 so it should remove for Title search if title contains spaces Line no.41 and commented 40.
************************************************************************************************************************************************** */







@RestResource(urlMapping='/getPIBIDocument/*')
global with sharing class SCIS_GetPIBIDocumentRest {

    @HttpGet
    global static String getPIBIDocument() {
        //RestRequest req = RestContext.request;
        
	RestRequest req = RestContext.request;
        
	// Splitting the requestURI by slashes
	String requestURI = req.requestURI;
	String[] parts = requestURI.split('/');

	// Ensure the parts array has enough elements before extracting parameters
	String pibiId = (parts.size() >= 2) ? parts[parts.size() - 2] : null; // Second to last part of the URI
	//String pibiName = (parts.size() >= 1) ? parts[parts.size() - 1] : null; // Last part of the URI
	
        // #Change2 Start
        String pibiName = (parts.size() >= 1) ? parts[parts.size() - 1].replace('%20', ' ') : null;
     // #Change2  End By Aditya More
   
        
        //String pibiId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        if(String.isBlank(pibiId)) {
            RestContext.response.statusCode = 400; // Bad Request
            return 'pibi ID is required.';
        }

        List<pibi__c> pibiRecords = [SELECT Id FROM pibi__c WHERE Id = :pibiId LIMIT 1];
        if(pibiRecords.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'pibi record not found.';
        }

        //List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :pibiId LIMIT 1];
        
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :pibiId];
        
        
        list<id> idList = new list<id>();
        for(ContentDocumentLink cld2 : cdlList ){
            idList.add(cld2.ContentDocumentId);
        }
        
        if(cdlList.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'No document linked to the pibi record.';
        }
		System.debug('pibiName = '+ pibiName);
        ContentDocumentLink cld = cdlList[0];
        
        List<ContentVersion> cvList = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId IN: idList AND Title LIKE: pibiName ORDER BY VersionNumber DESC LIMIT 1];


        
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

@RestResource(urlMapping='/getPIBIDocument/*')
global with sharing class SCIS_GetPIBIDocumentRest {

    @HttpGet
    global static String getPIBIDocument() {
        RestRequest req = RestContext.request;
        String pibiId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        if(String.isBlank(pibiId)) {
            RestContext.response.statusCode = 400; // Bad Request
            return 'PIBI ID is required.';
        }

        List<PIBI__c> pibiRecords = [SELECT Id FROM PIBI__c WHERE Id = :pibiId LIMIT 1];
        if(pibiRecords.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'PIBI record not found.';
        }

        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :pibiId LIMIT 1];
        if(cdlList.isEmpty()) {
            RestContext.response.statusCode = 404; // Not Found
            return 'No document linked to the PIBI record.';
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

*/

/*
// 05-April-2024 this code not returing cv.version data only
@RestResource(urlMapping='/getPIBIDocument/*')
global with sharing class SCIS_GetPIBIDocumentRest {

    @HttpGet
    global static String getPIBIDocument() {
        string base64;
        RestRequest req = RestContext.request;
        String pibiId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        //return pibiId;
        // Retrieve the PIBI record
        PIBI__c pibiRecords = [SELECT Id, Name FROM PIBI__c WHERE id =: pibiId LIMIT 1];
		system.debug('pibiRecords' + pibiRecords);
		ContentDocumentLink cld = [select id,LinkedEntityId from ContentDocumentLink where LinkedEntityId=: pibiRecords.id  ];
		system.debug('cld' + cld);
        //ContentVersion cv = [select id,contentDocumentId  from ContentVersion where contentDocumentId =: cld.ContentDocumentId limit 1];
		ContentVersion cv = [SELECT Id, ContentDocumentId,VersionNumber FROM ContentVersion WHERE ContentDocumentId = :cld.ContentDocumentId ORDER BY VersionNumber DESC LIMIT 1];
        system.debug('cv data' + cv.VersionData);
        base64 = EncodingUtil.base64Encode(cv.VersionData);
        system.debug('Base 64 part 1 = '+ base64);
        system.debug('Cv.id = '+ cv.Id);
        if(pibiRecords != null){
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


 /* if (pibiRecords != null) {
            // Retrieve the Document attached to the PIBI record
            Document document = [SELECT Id, Body FROM Document WHERE Id = :pibiRecords.PDF_Document__c LIMIT 1];
            if (document != null && document.Body != null) {
                // Convert Document Body to base64
                return EncodingUtil.base64Encode(document.Body);
            }
        } */