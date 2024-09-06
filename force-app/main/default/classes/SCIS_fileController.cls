public class SCIS_fileController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getRelatedFiles(Id recordId) {
        return [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :recordId];
    }
}