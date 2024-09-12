/* Working fine 14 March 2024 */
/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   15-03-2024
Trigger Name            :   FileUploadToSurveyRest
TestClass Name          :   
Connected Class         :   
@Description            :   This class is used from app side to send survey images into the salesforce. 
							This API is used to delete the old images and save new survey images into the saleforce.
                            @param surveyId The ID of the survey record.
                            @param imageName The name of the image.
                            @param imageBase64 The base64-encoded image data.
                            @param isFirst Indicates whether it's the first image being uploaded.
                            @param fileType The type of the image file (e.g., 'jpg', 'pdf').
                            @return A map containing the status and message of the upload operation.
Last Modification Date  :   15-03-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1Change : 14 March 2024 : Updated code to delete the associated images with survey
							#2Change : 02 Apr 2024 : Creating public url for pdf
							#3Change : 30 Aug 2024 : Updated the code so that It should accept the other documents. Also if other documents are
										it should delete the previous documents and add new.
************************************************************************************************************************************************** */

@RestResource(urlMapping='/uploadFilesToSurvey/*')
global with sharing class FileUploadToSurveyRest {
    @HttpPost
    global static map<string,string> uploadsurveyImage(String surveyId, String imageName, String imageBase64, boolean isFirst, string fileType, boolean isOther) {  
        try {  
            system.debug('API call started');
            // Convert the base64 image data to a Blob
            Blob imageBlob = EncodingUtil.base64Decode(imageBase64);
            survey__c surveyRecord = new survey__c();
            system.debug('surveyId = ' +surveyId + ' imageName= '+ imageName + ' isFirst= '+ isFirst + ' fileType= '+ fileType + ' isOther= '+ IsOther );
            // Get the survey record
            if (Schema.sObjectType.Survey__c.isAccessible()) {
                surveyRecord = [SELECT Id FROM survey__c WHERE Id =: surveyId WITH SECURITY_ENFORCED LIMIT 1 ];
            }
			system.debug('surveyRecord '+ surveyRecord);
            // #1ChangeStart : 14 March 2024 : Updated code to delete the associated images with survey          
            List<ContentDocumentLink> contentDocumentLinksToDelete = new List<ContentDocumentLink>();
            List<ContentDocumentLink> contentDocumentLinkIds = new List<ContentDocumentLink>();
           // List<ContentDocumentLink> contentDocumentLinksToDeleteFirst = new List<ContentDocumentLink>();
            if(isFirst && !isOther){    	
                    if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
                 		
                        contentDocumentLinksToDelete = [SELECT Id ,ContentDocument.FileType
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :surveyId
                                                    AND ContentDocument.FileType =: fileType 
                                                    AND (NOT(ContentDocument.Title LIKE '%other_%')) 
                                                    AND ContentDocument.Title LIKE: '%'+imageName +'%'    WITH SECURITY_ENFORCED]; //AND ContentDocument.FileType ='jpg'];

                        system.debug('contentDocumentLinksToDelete = '+ contentDocumentLinksToDelete);
                    }
                // Create a list to hold the ContentDocumentLink Ids to be deleted
                    
                    for (ContentDocumentLink cdl : contentDocumentLinksToDelete) {
                        contentDocumentLinkIds.add(cdl);
                    }
                    
                    // Delete the ContentDocumentLinks
                if(Schema.sObjectType.ContentDocumentLink.isDeletable()){
                    delete contentDocumentLinkIds;
                    system.debug('delete contentDocumentLinkIds first line no 58 = '+ contentDocumentLinkIds );
                }
                    System.debug('All images associated with the Survey record have been deleted.');
            }
            //==================================================================================================================================================
            if(isFirst && isOther){    	
                    if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
                 		contentDocumentLinksToDelete = [SELECT Id ,ContentDocument.FileType
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :surveyId
                                                    AND ContentDocument.FileType =: fileType 
                                                    AND ContentDocument.Title Like '%other_%' WITH SECURITY_ENFORCED]; //AND ContentDocument.FileType ='jpg'];
            		system.debug('contentDocumentLinksToDelete 2 = '+ contentDocumentLinksToDelete );
                    }
                // Create a list to hold the ContentDocumentLink Ids to be deleted
                    
                    for (ContentDocumentLink cdl : contentDocumentLinksToDelete) {
                        contentDocumentLinkIds.add(cdl);
                    }
                    
                    // Delete the ContentDocumentLinks
                if(Schema.sObjectType.ContentDocumentLink.isDeletable()){
                    delete contentDocumentLinkIds;
                    system.debug('contentDocumentLinkIds with both TRUE = '+ contentDocumentLinkIds);
                }
                    System.debug('All images associated with the Survey record have been deleted.');
            }
            //=====================================================================================================================================
            
            system.debug('Entered into creating ContentVersion');
            
            // #1ChangeEnd : 14 March 2024 : Updated code to delete the associated images with survey

            // Create ContentVersion and ContentDocumentLink to associate the image with the survey

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
                system.debug('Content version inserted. line no 127');
			}

            //system.debug('content version inserted = CV ID = '+ cv.Id );
            ContentVersion cversion = new ContentVersion();
            if(Schema.sObjectType.ContentVersion.isAccessible()){
                cversion = [select id,contentDocumentId,PathOnClient from ContentVersion where id =: cv.Id limit 1];
                system.debug('Version Query result  = '+ cversion);
            }    
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.Id);
            //system.debug('This is Content DocumentId Of Content Version From Query = '+ cversion.ContentDocumentId);
            //system.debug('This is Path On Client Name = '+ cversion.PathOnClient);

            // Create ContentDocumentLink
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cversion.ContentDocumentId;
           	cdl.LinkedEntityId = surveyRecord.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                insert cdl; 
                system.debug('Line 149 : cd1 inserted.' + cdl);
            }    

            // #2Change Start : 02 Apr 2024 : Creating public url for pdf
            // Create ContentDistribution record for public link
            ContentDistribution contentDistribution = new ContentDistribution();
            contentDistribution.ContentVersionId = cv.Id;
            contentDistribution.Name = imageName + '_PublicLink'; // Name for the public link
            contentDistribution.PreferencesAllowOriginalDownload = false; // Allow original download
            contentDistribution.PreferencesLinkLatestVersion = true; // Link to latest version
            insert contentDistribution;
            system.debug('contentDistribution = '+ contentDistribution);
            
            // Retrieve the public URL
            String publicURL = '/' + contentDistribution.DistributionPublicUrl; // Public URL of the PDF
            contentDistribution cd2 = [select id,DistributionPublicUrl,ContentDocumentId
                                      from contentDistribution
                                      where ContentDocumentId =:cversion.ContentDocumentId ];
            
            // #2Change End: 02 Apr 2024 : Creating public url for pdf

            system.debug(cdl);
            system.debug('cdl created and ID is = '+ cdl.Id);
            map<string,string> responseMap = new map<string,string>();
            responseMap.put('status','200');
            responseMap.put('message','Image uploaded successfully.');
            responseMap.put('url',cd2.DistributionPublicUrl);
            //return 'Image uploaded successfully.';
            system.debug('responseMap = '+ responseMap);
            return responseMap;
        } catch (Exception e) {
            
            map<string,string> responseMap = new map<string,string>{'status' => '500', 'message' => e.getMessage()};
            return responseMap;
        }
    }
}



/* Not working

@RestResource(urlMapping='/uploadFilesToSurvey/*')
global with sharing class FileUploadToSurveyRest {

    global class FileData {
        global String fileName;
        global String base64Data;
        global String fileType;        
    }

    @HttpPost
    global static String uploadFiles(String surveyId, String fileDataJSON) {
        //return 'Files uploaded successfully.';
        system.debug('surveyId'+ surveyId);
        system.debug('fileDataJSON'+ fileDataJSON);
        try {
            List<FileData> fileList = (List<FileData>)JSON.deserialize(fileDataJSON, List<FileData>.class);
          
            system.debug('fileList'+fileList);
			
            Survey__c survey = [SELECT Id FROM Survey__c WHERE Id = :surveyId LIMIT 1];
            system.debug('survey'+survey);
            system.debug('survey Id'+ survey.Id);

            // Retrieve existing image ContentDocumentLinks associated with the survey
            Set<Id> existingImageContentDocumentIds = new Set<Id>();
            for (ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :survey.Id AND ContentDocument.FileType LIKE 'image/%']) {
                existingImageContentDocumentIds.add(cdl.ContentDocumentId);
            }

            // Delete existing image ContentDocumentLinks
            List<ContentDocumentLink> contentDocumentLinksToDelete = new List<ContentDocumentLink>();
            for (ContentDocumentLink cdl : [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :survey.Id AND ContentDocumentId IN :existingImageContentDocumentIds]) {
                contentDocumentLinksToDelete.add(cdl);
            }
            delete contentDocumentLinksToDelete;

            List<ContentVersion> contentVersions = new List<ContentVersion>();
            List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
            
            for (FileData fileData : fileList) {
                Blob fileBlob = EncodingUtil.base64Decode(fileData.base64Data);

                ContentVersion newContent = new ContentVersion();
                newContent.Title = fileData.fileName;
                system.debug('fileName'+fileData.fileName);

                if (fileData.fileType == 'jpeg') {
                    newContent.PathOnClient = fileData.fileName + '.jpeg'; // Assuming images will be saved as JPG
                } else if (fileData.fileType == 'image/png') {
                    newContent.PathOnClient = fileData.fileName + '.png'; // PNG files
                } else if (fileData.fileType == 'application/pdf') {
                    newContent.PathOnClient = fileData.fileName + '.pdf'; // PDF files
                } else {
                    // Handle other file types or throw an error for unsupported types
                    return 'Error: Unsupported file type.';
                }

                newContent.VersionData = fileBlob;
                contentVersions.add(newContent);
            }

            insert contentVersions;
            system.debug('Img inserted' + contentVersions);
            
            for (ContentVersion newContent : contentVersions) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                ContentVersion cversion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :newContent.Id LIMIT 1];

                cdl.ContentDocumentId = cversion.ContentDocumentId;
                cdl.LinkedEntityId = survey.Id;
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                contentDocumentLinks.add(cdl);
            }

            insert contentDocumentLinks;
            system.debug('Img inserted' + contentDocumentLinks);
            return 'Files uploaded successfully.';
            
        } catch(Exception ex) {
            return 'Error: ' + ex.getMessage();
        }
    }
}

*/

// 14 March 24 Working 
/*
@RestResource(urlMapping='/uploadFilesToSurvey/*')
global with sharing class FileUploadToSurveyRest {

    global class FileData {
        global String fileName;
        global String base64Data;
		global String fileType;
		global boolean isFirstImage;        
    }

    @HttpPost
    global static String uploadFiles(String surveyId, String fileDataJSON) {
        system.debug('surveyId'+ surveyId);
        system.debug('fileDataJSON'+ fileDataJSON);
        try {
            List<FileData> fileList = (List<FileData>)JSON.deserialize(fileDataJSON, List<FileData>.class);
          
            system.debug('fileList'+fileList);
			
            Survey__c survey = [SELECT Id FROM Survey__c WHERE Id = :surveyId LIMIT 1];
            system.debug('survey'+survey);
            system.debug('survey Id'+ survey.Id);

            List<ContentVersion> contentVersions = new List<ContentVersion>();
            List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
			
            // Create a ContentFolder to organize the files
        	//ContentFolder folder = new ContentFolder();
            //folder.Name = 'Test Apex Folder 30'; // Specify the folder name
            //DeveloperName = 'Dinesh Suryavanshi', // Specify a unique developer name
            //Type = 'Shared', // Adjust type as per your sharing requirements
            //folder.ParentContentFolderId = null; // Set a parent folder if needed
 
        	//insert folder;
            //system.debug('Folder Created' +   folder.Name);
            
            for (FileData fileData : fileList) {
                Blob fileBlob = EncodingUtil.base64Decode(fileData.base64Data);

                ContentVersion newContent = new ContentVersion();
                newContent.Title = fileData.fileName;
                system.debug('fileName'+fileData.fileName);

                if (fileData.fileType == 'jpeg') {
                    newContent.PathOnClient = fileData.fileName + '.jepg'; // Assuming images will be saved as JPG
                } else if (fileData.fileType == 'image/png') {
                    newContent.PathOnClient = fileData.fileName + '.png'; // PNG files
                } else if (fileData.fileType == 'application/pdf') {
                    newContent.PathOnClient = fileData.fileName + '.pdf'; // PDF files
                } else {
                    // Handle other file types or throw an error for unsupported types
                    return 'Error: Unsupported file type.';
                }

                newContent.VersionData = fileBlob;
                //newContent.FirstPublishLocationId = folder.Id;  // Associate with the created folder
                //system.debug('Folder Id' +  folder.Id);
                contentVersions.add(newContent);
                
            }

            insert contentVersions;
			system.debug('Img inserted' + contentVersions);
            
            for (ContentVersion newContent : contentVersions) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                ContentVersion cversion = [SELECT id, contentDocumentId FROM ContentVersion WHERE Id = :newContent.Id LIMIT 1];

                cdl.ContentDocumentId = cversion.ContentDocumentId;
                cdl.LinkedEntityId = survey.Id;
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                contentDocumentLinks.add(cdl);
            }

            insert contentDocumentLinks;
			system.debug('Img inserted' + contentDocumentLinks);
            return 'Files uploaded successfully.';
            
        } catch(Exception ex) {
            return 'Error: ' + ex.getMessage();
        }
    }
}

*/