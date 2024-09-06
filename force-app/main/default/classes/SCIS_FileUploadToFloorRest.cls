/******************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   15-03-2024
Trigger Name            :   SCIS_FileUploadToFloorRest
TestClass Name          :   
Connected Class         :   
@Description            :   This class is used from app side to send floor images into the salesforce. 
							This API is used to delete the old images and save new floor images into the saleforce.
							* @param floorId The ID of the Floor record to which the image will be attached.
     						* @param imageName The name of the image.
     						* @param imageBase64 The base64 encoded image data.
     						* @param isFirst Boolean indicating whether this is the first image to be uploaded for the floor.
     						* @param fileType The type of the file being uploaded (e.g., 'jpg', 'pdf').
     						* @return A map containing status and message indicating the result of the upload.
Last Modification Date  :   15-03-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
***************************************************************************************************************************************** */
/**
 * RestResource class for uploading files to Floor records.
 * Handles the uploading of images to Floor records via REST API.
 */
@RestResource(urlMapping='/uploadFilesToFloor/*')
global with sharing class SCIS_FileUploadToFloorRest {
    /**
     * Uploads an image to the specified Floor record.
     * 
     * @param floorId The ID of the Floor record to which the image will be attached.
     * @param imageName The name of the image.
     * @param imageBase64 The base64 encoded image data.
     * @param isFirst Boolean indicating whether this is the first image to be uploaded for the floor.
     * @param fileType The type of the file being uploaded (e.g., 'jpg', 'pdf').
     * @return A map containing status and message indicating the result of the upload.
     */
    @HttpPost
    global static map<string,string> uploadFloorImage(String floorId, String imageName, String imageBase64, boolean isFirst, string fileType) {  
        try {
            // Convert the base64 image data to a Blob
            Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
            
            // Get the Floor record
            Floor__c floorRecord = new Floor__c();
            if (Schema.sObjectType.Floor__c.isAccessible()) {
                floorRecord = [SELECT Id FROM Floor__c WHERE Id =: floorId LIMIT 1];
            }
            // Floor__c floorRecord = [SELECT Id FROM Floor__c WHERE Id =: floorId LIMIT 1];
            
            // #1ChangeStart : 14 March 2024 : Updated code to delete the associated images with Floor
            
            if(isFirst){
                    List<ContentDocumentLink> contentDocumentLinksToDelete = [SELECT Id ,ContentDocument.FileType
                                                                         FROM ContentDocumentLink 
                                                                         WHERE LinkedEntityId = :FloorId
                                                                         AND ContentDocument.FileType =: fileType
                                                                          ]; 
                                                                          //AND ContentDocument.FileType ='jpg'];
                    // Create a list to hold the ContentDocumentLink Ids to be deleted
                    List<ContentDocumentLink> contentDocumentLinkIds = new List<ContentDocumentLink>();
                    for (ContentDocumentLink cdl : contentDocumentLinksToDelete) {
                        contentDocumentLinkIds.add(cdl);
                    }
                    
                    // Delete the ContentDocumentLinks
                    if(Schema.sObjectType.ContentDocumentLink.isDeletable()){
                    	delete contentDocumentLinkIds;
               	 	}
                	//delete contentDocumentLinkIds;
                    
                    System.debug('All images associated with the Floor record have been deleted.');
            }

            // Create ContentVersion and ContentDocumentLink to associate the image with the Floor
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
            //insert cv;
            //system.debug('content version inserted = CV ID = '+ cv.Id );            
            ContentVersion cversion = new ContentVersion();
            if(Schema.sObjectType.ContentVersion.isAccessible()){
                cversion = [select id,contentDocumentId,PathOnClient from ContentVersion where id =: cv.Id limit 1];
            }
            //ContentVersion cversion = [select id,contentDocumentId,PathOnClient from ContentVersion where id =: cv.Id limit 1];
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.Id);
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.ContentDocumentId);
            //system.debug('This is Path On Client Name = '+ cversion.PathOnClient);
            
            // Create ContentDocumentLink
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cversion.ContentDocumentId;
           	cdl.LinkedEntityId = FloorRecord.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                insert cdl; 
            } 
            //insert cdl;  
            //system.debug(cdl);
            //system.debug('cdl created and ID is = '+ cdl.Id);

            //return 'Image uploaded successfully.';
            map<string,string> responseMap = new map<string,string>();
            responseMap.put('status','200');
            responseMap.put('message','Image uploaded successfully.');
            
            //return 'Image uploaded successfully.';
            return responseMap;
            
            
        } catch (Exception e) {
            // Handle exceptions and return error response
            map<string,string> responseMap = new map<string,string>{'status' => '500', 'message' => e.getMessage()};
            return responseMap;
            //return 'Error: ' + e.getMessage();
        }
    }
}