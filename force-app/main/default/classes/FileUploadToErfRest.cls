/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   21-03-2024
Trigger Name            :   FileUploadToERFRest
TestClass Name          :   FileUploadToERFRestTest
Connected Class         :   
@Description            :   This class is used from app side to send ERF images into the salesforce. 
							This API is used to delete the old images and save new ERF images into the saleforce.
                            @param ERFId The ID of the ERF record.
                            @param imageName The name of the image.
                            @param imageBase64 The base64-encoded image data.
                            @param isFirst Indicates whether it's the first image being uploaded.
                            @param fileType The type of the image file (e.g., 'jpg', 'pdf').
                            @return A map containing the status and message of the upload operation.
Last Modification Date  :   21-03-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1Change : 21 March 2024 : Updated code to delete the associated images with ERF
							#2Change : 08 Aug 2024 : Updated the code to create contentDocument clone to Survey record.
							#3Change : 30 Aug 2024 : Updated the code so that we can accept child_benefit_certificate
************************************************************************************************************************************************** */

@RestResource(urlMapping='/uploadFilesToERF/*')
global with sharing class FileUploadToErfRest {
    @HttpPost
    global static map<string,string> uploadERFImage(String ERFId, String imageName, String imageBase64, boolean isFirst, string fileType) {  
        try {     
            // Convert the base64 image data to a Blob
            Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
            ERF__c ERFRecord = new ERF__c();
            // Get the ERF record
            if (Schema.sObjectType.ERF__c.isAccessible()) {
                ERFRecord = [SELECT Id,Survey__r.id FROM ERF__c WHERE Id =: ERFId WITH SECURITY_ENFORCED LIMIT 1 ];
            }

            List<ContentDocumentLink> contentDocumentLinksToDelete = new List<ContentDocumentLink>();
            List<ContentDocumentLink> contentDocumentLinkIds = new List<ContentDocumentLink>();
            if(isFirst){
                	
                    if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
                        
                        if(imageName == 'ERF' || imageName == 'ERFUNSIGNED'){
                            contentDocumentLinksToDelete = [SELECT Id ,ContentDocument.FileType
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :ERFId
                                                    AND ContentDocument.FileType =: fileType 
                                                    AND ContentDocument.title =: imageName WITH SECURITY_ENFORCED]; 
            		
                        }
                        if(imageName == 'child_benefit_certificate'){
                            contentDocumentLinksToDelete = [SELECT Id ,ContentDocument.FileType
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :ERFId
                                                    AND ContentDocument.FileType =: fileType
                                                    AND ContentDocument.title =: imageName WITH SECURITY_ENFORCED]; 
            		
                        }

                    }
                // Create a list to hold the ContentDocumentLink Ids to be deleted
                    
                    for (ContentDocumentLink cdl : contentDocumentLinksToDelete) {
                        contentDocumentLinkIds.add(cdl);
                    }
                    
                    // Delete the ContentDocumentLinks
                if(Schema.sObjectType.ContentDocumentLink.isDeletable()){
                    delete contentDocumentLinkIds;
                }
                    System.debug('All images associated with the ERF record have been deleted.');
            }
            
            

            // Create ContentVersion and ContentDocumentLink to associate the image with the ERF

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
            
            
            
            ContentVersion cvErf = new ContentVersion();   
            cvErf.Title = imageName;
                        if(fileType == 'jpg'){
                            cvErf.PathOnClient = imageName + '.jpg';
                        }else if (fileType == 'pdf'){
                            cvErf.PathOnClient = imageName + '.pdf';
                        }
                cvErf.VersionData = imageBlob;
            if (Schema.sObjectType.ContentVersion.isCreateable()) {
   				insert cvErf;
			}
            
            

            //system.debug('content version inserted = CV ID = '+ cv.Id );
            ContentVersion cversion = new ContentVersion();
            ContentVersion cversionerf = new ContentVersion();
            if(Schema.sObjectType.ContentVersion.isAccessible()){
                cversion = [select id,contentDocumentId,PathOnClient from ContentVersion where id =: cv.Id limit 1];
                cversionerf = [select id,contentDocumentId,PathOnClient from ContentVersion where id =: cvErf.Id limit 1];
            }    
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.Id);
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.ContentDocumentId);
            //system.debug('This is Path On Client Name = '+ cversion.PathOnClient);

            // Create ContentDocumentLink
            ContentDocumentLink cdl = new ContentDocumentLink();
            ContentDocumentLink cdlerf = new ContentDocumentLink();
            
            cdl.ContentDocumentId = cversion.ContentDocumentId;
            cdlerf.ContentDocumentId = cversionerf.ContentDocumentId;
            
           	cdl.LinkedEntityId = ERFRecord.Id;
            cdlerf.LinkedEntityId = ERFRecord.Survey__c;
            
            cdlerf.ShareType = 'V';
            cdl.ShareType = 'V';
            
            cdl.Visibility = 'AllUsers';
            cdlerf.Visibility = 'AllUsers';
            
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                insert cdl;
                //insert cdlerf;
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