public with sharing class WavFileController {
    @AuraEnabled(cacheable=true)
    public static String getWavFileUrl(Id recordId) {
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocument.LatestPublishedVersionId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];
        
        if (!cdlList.isEmpty()) {
            ContentDocumentLink cdl = cdlList[0];
            String wavFileUrl = '/sfc/servlet.shepherd/version/download/' + cdl.ContentDocument.LatestPublishedVersionId;
            return wavFileUrl;
        }
        return null;
    }
}