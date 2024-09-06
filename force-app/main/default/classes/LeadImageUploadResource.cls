/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	10-11-2023
Class Name 				: 	LeadImageUploadResource
TestClass Name 			: 	LeadImageUploadResourcetTest
@Description 			: 	'This class is used to upload images captured from the Lead Generator Application Developed using PHP and iOS.
							In Lead Generator class we need to capture image, so this class is used to store captured images to Lead Object in salesforce.
							@param leadId The ID of the lead record.
							@param imageName The name of the image.
							@param imageBase64 The base64-encoded image data.
							@param return a map containing the status and message of the upload operation.'
Last Modification Date 	: 	10-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@RestResource(urlMapping='/leadImageUpload/*')
global with sharing class LeadImageUploadResource {
    @HttpPost
    global static String uploadLeadImage(String leadId, String imageName, String imageBase64) {  
        try {
            // Convert the base64 image data to a Blob
            Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
            Lead leadRecord = new Lead();
            // Get the Lead record
            if (Schema.sObjectType.Lead.isAccessible()) {
                leadRecord = [SELECT Id FROM Lead WHERE Id = :leadId LIMIT 1];
            }
            //Lead leadRecord = [SELECT Id FROM Lead WHERE Id = :leadId LIMIT 1];

            // Create ContentVersion and ContentDocumentLink to associate the image with the Lead
            ContentVersion cv = new ContentVersion();
            cv.Title = imageName;
            cv.PathOnClient = imageName + '.jpg';
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
           	cdl.LinkedEntityId = leadRecord.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                insert cdl; 
            }
            //insert cdl;  
            //system.debug(cdl);
            //system.debug('cdl created and ID is = '+ cdl.Id);

            return 'Image uploaded successfully.';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}