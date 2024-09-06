/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   23-03-2024
Trigger Name            :   FileUploadToAssessment_ReportRest
TestClass Name          :   FileUploadToAssessment_ReportRestTest
Connected Class         :   
@Description            :   This class is used from app side to send Assessment_Report images into the salesforce. 
							This API is used to delete the old images and save new Assessment_Report images into the saleforce.
                            @param Assessment_ReportId The ID of the Assessment_Report record.
                            @param imageName The name of the image.
                            @param imageBase64 The base64-encoded image data.
                            @param isFirst Indicates whether it's the first image being uploaded.
                            @param fileType The type of the image file (e.g., 'jpg', 'pdf').
                            @return A map containing the status and message of the upload operation.
Last Modification Date  :   21-03-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1Change : 23 March 2024 : Updated code to delete the associated images with Assessment_Report
************************************************************************************************************************************************** */

@RestResource(urlMapping='/uploadFilesToAssessment_Report/*')
global with sharing class SCIS_FileUploadToAssessment_ReportRest {
    @HttpPost
    global static map<string,string> uploadAssessment_ReportImage(String Assessment_ReportId, String imageName, String imageBase64, boolean isFirst, string fileType) {  
        try {     
            // Convert the base64 image data to a Blob
            Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
            Assessment_Report__c Assessment_ReportRecord = new Assessment_Report__c();
            // Get the Assessment_Report record
            if (Schema.sObjectType.Assessment_Report__c.isAccessible()) {
                Assessment_ReportRecord = [SELECT Id FROM Assessment_Report__c WHERE Id =: Assessment_ReportId WITH SECURITY_ENFORCED LIMIT 1 ];
            }

                      
            if(isFirst){
                	List<ContentDocumentLink> contentDocumentLinksToDelete = new List<ContentDocumentLink>();
                    if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
                 		contentDocumentLinksToDelete = [SELECT Id ,ContentDocument.FileType
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :Assessment_ReportId
                                                    AND ContentDocument.FileType =: fileType WITH SECURITY_ENFORCED]; //AND ContentDocument.FileType ='jpg'];
            		}
                // Create a list to hold the ContentDocumentLink Ids to be deleted
                    List<ContentDocumentLink> contentDocumentLinkIds = new List<ContentDocumentLink>();
                    for (ContentDocumentLink cdl : contentDocumentLinksToDelete) {
                        contentDocumentLinkIds.add(cdl);
                    }
                    
                    // Delete the ContentDocumentLinks
                if(Schema.sObjectType.ContentDocumentLink.isDeletable()){
                    delete contentDocumentLinkIds;
                }
                    System.debug('All images associated with the Assessment_Report record have been deleted.');
            }
            
            

            // Create ContentVersion and ContentDocumentLink to associate the image with the Assessment_Report

            ContentVersion cv = new ContentVersion();   
            cv.Title = imageName;
                        if(fileType == 'jpg'){
                            cv.PathOnClient = imageName + '.jpg';
                        }else if (fileType == 'pdf'){
                            cv.PathOnClient = imageName + '.pdf';
                        }
                cv.VersionData = imageBlob;
            if (Schema.sObjectType.ContentVersion.isCreateable()) {
   				insert cv;
			}

            //system.debug('content version inserted = CV ID = '+ cv.Id );
            ContentVersion cversion = new ContentVersion();
            if(Schema.sObjectType.ContentVersion.isAccessible()){
                cversion = [select id,contentDocumentId,PathOnClient from ContentVersion where id =: cv.Id limit 1];
            }    
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.Id);
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.ContentDocumentId);
            //system.debug('This is Path On Client Name = '+ cversion.PathOnClient);

            // Create ContentDocumentLink
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cversion.ContentDocumentId;
           	cdl.LinkedEntityId = Assessment_ReportRecord.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                insert cdl; 
            }             
            //system.debug(cdl);
            //system.debug('cdl created and ID is = '+ cdl.Id);
            map<string,string> responseMap = new map<string,string>();
            responseMap.put('status','200');
            responseMap.put('message','Image uploaded successfully.');
            
            //return 'Image uploaded successfully.';
            return responseMap;
        } catch (Exception e) {
            
            map<string,string> responseMap = new map<string,string>{'status' => '500', 'message' => e.getMessage()};
            return responseMap;
        }
    }
}