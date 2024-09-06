public with sharing class FileController {
    
    @AuraEnabled(cacheable=true)
    public static List<FileWrapper> getUploadedFiles(Id recordId) {
        List<FileWrapper> files = new List<FileWrapper>();
        try {
            
            
            
            
            // Query Attachments related to the provided record Id
            List<Attachment> attachments = [SELECT Id, Name 
                                            FROM Attachment 
                                            WHERE ParentId = :recordId];
            // Populate the files list with Attachment data
            for (Attachment att : attachments) {
                files.add(new FileWrapper(att.Id, att.Name, 'Attachment', null));
            }
            
            // Query ContentDocumentLink records related to the provided record Id
            List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId 
                                                              FROM ContentDocumentLink 
                                                              WHERE LinkedEntityId = :recordId];
            // Extract ContentDocumentIds from ContentDocumentLink records
            Set<Id> contentDocumentIds = new Set<Id>(); 
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
            
            // Query ContentVersion records related to the ContentDocumentIds
            List<ContentVersion> contentVersions = [SELECT Id, Title, Description, FileType 
                                                     FROM ContentVersion 
                                                     WHERE ContentDocumentId IN :contentDocumentIds];
            
            // Populate the files list with ContentVersion data
            for (ContentVersion cv : contentVersions) {
                files.add(new FileWrapper(cv.Id, cv.Title, 'ContentVersion', cv.Description));
            }
        } catch (Exception e) {
            // Handle any exceptions and log the error
            System.debug('Error in getUploadedFiles: ' + e.getMessage());
            // Optionally, you can re-throw the exception to propagate it to the caller
            // throw e;
        }
        
        return files;
    }
    
    // Wrapper class to hold file data
    public class FileWrapper {
        @AuraEnabled
        public Id Id { get; private set; }
        @AuraEnabled
        public String Name { get; private set; }
        @AuraEnabled
        public String FileType { get; private set; }
        @AuraEnabled
        public String Description { get; private set; }
        
        public FileWrapper(Id id, String name, String fileType, String description) {
            this.Id = id;
            this.Name = name;
            this.FileType = fileType;
            this.Description = description;
        }
    }
}