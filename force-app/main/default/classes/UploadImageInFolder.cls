/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   
Trigger Name            :   UploadImageInFolder
TestClass Name          :   
Connected Class         :   
@Description            :   * The UploadImageInFolder class provides a method to create a folder in Content Workspace 
 							* and upload images to that folder.
							* @param folderName The name of the folder where images will be uploaded.
     						* @param imageMap A map containing image names as keys and Base64 encoded image data as values.
Last Modification Date  :   
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The UploadImageInFolder class provides a method to create a folder in Content Workspace 
 * and upload images to that folder.
 */
public class UploadImageInFolder {
	/**
     * Method to create a folder in Content Workspace and add images to that folder.
     * @param folderName The name of the folder where images will be uploaded.
     * @param imageMap A map containing image names as keys and Base64 encoded image data as values.
     */
    public static void createFolderAndAddImages(String folderName, Map<String, String> imageMap) {
        // Get or create a ContentWorkspace representing the ContentFolder
        ContentWorkspace contentWorkspace;
        try {
             // Check if ContentWorkspace is accessible and retrieve existing workspace
            if (Schema.sObjectType.ContentWorkspace.isAccessible()) {
                 contentWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name = :folderName LIMIT 1];
            }
            // contentWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name = :folderName LIMIT 1];
        } catch (QueryException e) {
            // If the folder doesn't exist, create it
            contentWorkspace = new ContentWorkspace();
            contentWorkspace.Name = folderName;
            // Insert the ContentWorkspace record
            if (Schema.sObjectType.ContentWorkspace.isCreateable()) {
   				insert contentWorkspace;
			}
            // insert contentWorkspace;
        }

        // Insert the ContentWorkspaceDoc records in a separate context
        System.runAs(new User(Id = UserInfo.getUserId())) {
            // Loop through the images and add them to the folder
            for (String imageName : imageMap.keySet()) {
                String base64Image = imageMap.get(imageName);

                // Convert Base64 encoded string to Blob
                Blob imageBlob = EncodingUtil.base64Decode(base64Image);

                // Create a ContentVersion to hold the image
                ContentVersion contentVersion = new ContentVersion();
                contentVersion.Title = imageName;
                contentVersion.VersionData = imageBlob;
                contentVersion.PathOnClient = imageName;

                try {
                    // Insert the ContentVersion record
                    if (Schema.sObjectType.ContentVersion.isCreateable()) {
   						insert contentVersion;
					}
                    // insert contentVersion;

                    // Get the ContentDocumentId from the ContentVersion
                    Id contentDocumentId = contentVersion.ContentDocumentId;

                    if (contentDocumentId != null) {
                        // Create a ContentWorkspaceDoc to link the ContentDocument to the ContentFolder (ContentWorkspace)
                        ContentWorkspaceDoc contentWorkspaceDoc = new ContentWorkspaceDoc();
                        contentWorkspaceDoc.ContentDocumentId = contentDocumentId;
                        contentWorkspaceDoc.ContentWorkspaceId = contentWorkspace.Id;
                        // Insert the ContentWorkspaceDoc record
                        if (Schema.sObjectType.ContentWorkspaceDoc.isCreateable()) {
   							insert contentWorkspaceDoc;
						}
                        // insert contentWorkspaceDoc;
                    } else {
                        // Log an error if ContentDocumentId is null
                        System.debug('ContentDocumentId is null for image: ' + imageName);
                    }
                } catch (DmlException ex) {
                    // Log the error if the insertion fails
                    System.debug('Error inserting ContentVersion for image: ' + imageName + '. Error: ' + ex.getMessage());
                }
            }
        }
    }
}