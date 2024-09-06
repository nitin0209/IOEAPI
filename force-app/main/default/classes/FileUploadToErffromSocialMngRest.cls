/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   08-05-2024
Class Name 	            :   FileUploadToErffromSocialMngRest
TestClass Name          :   FileUploadToErffromSocialMngRestTest
Connected Class         :   
@Description            :   This class is used from app side to send ERF images into the salesforce. 
							This API is used to delete the old images and save new ERF images into the saleforce.
                            @param ERFId The ID of the ERF record.
                            @param imageName The name of the image.
                            @param imageBase64 The base64-encoded image data.
                            @param isFirst Indicates whether it's the first image being uploaded.
                            @param fileType The type of the image file (e.g., 'jpg', 'pdf').
                            @return A map containing the status and message of the upload operation.
Last Modification Date  :   08-05-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */

@RestResource(urlMapping='/uploadFilesToERFfromSocialMng/*')
global with sharing class FileUploadToErffromSocialMngRest {
    @HttpPost
    global static map<string,string> uploadERFImage(String ERFId, String imageName, String imageBase64, boolean isFirst, string fileType) {  
        try {     
            // Convert the base64 image data to a Blob
            Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
            ERF__c ERFRecord = new ERF__c();
            // Get the ERF record
            if (Schema.sObjectType.ERF__c.isAccessible()) {
                ERFRecord = [SELECT Id FROM ERF__c WHERE Id =: ERFId WITH SECURITY_ENFORCED LIMIT 1 ];
            }

                      
            list<contentDocumentLink> contentDocumentLinkList = new List<contentDocumentLink>();
            contentDocumentLinkList = [select id,linkedEntityId,ContentDocumentId  from contentDocumentLink where linkedEntityId =: ERFId];
           
            set<id> ContentDocumentIdSet = new set<id>();
            contentDocument contentDocumentTodelete = new contentDocument();
            for(contentDocumentLink cdl : contentDocumentLinkList){
                ContentDocumentIdSet.add(cdl.ContentDocumentId);
            }
            try{
                 contentDocumentTodelete = [select id,title from contentDocument where id IN: ContentDocumentIdSet AND title LIKE: imageName ];
            }catch(exception e){
                
            }
			
            // Create ContentVersion and ContentDocumentLink to associate the image with the ERF
			
            list<contentDocumentLink> contentDocumentLinkToDelete = new list<contentDocumentLink>();
            contentDocumentLinkToDelete = [select id from contentDocumentLink where LinkedEntityId =: ERFId AND ContentDocumentId =: contentDocumentTodelete.Id];
            delete contentDocumentLinkToDelete;
            
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
           	cdl.LinkedEntityId = ERFRecord.Id;
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
            
            map<string,string> responseMap = new map<string,string>{'status' => '500', 'message' => e.getMessage(),'line'=> e.getLineNumber().toString()};
            return responseMap;
        }
    }
}