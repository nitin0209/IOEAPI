public with sharing class SCISInstallationImgPdfController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Map<ID, String>> getRelatedFilesByRecordId(String parentRecordId) {
        if (String.isBlank(parentRecordId)) {
            throw new IllegalArgumentException('Invalid parent record ID.');
        }

        // Collect all related record IDs, including the parent
        Set<ID> relatedRecordIds = new Set<ID>();
        relatedRecordIds.add(parentRecordId);

        // Fetch related Measure_Status__c, CWI__c, and LI__c records
        for (Measure_Status__c measureStat : [SELECT Id FROM Measure_Status__c WHERE Installation__c = :parentRecordId]) {
            relatedRecordIds.add(measureStat.Id);
        }

        for (CWI__c cwi : [SELECT Id FROM CWI__c WHERE installation_Id__c = :parentRecordId]) {
            relatedRecordIds.add(cwi.Id);
        }

        for (LI__c li : [SELECT Id FROM LI__c WHERE installation_Id__c = :parentRecordId]) {
            relatedRecordIds.add(li.Id);
        }

        // If no child records were found, there's no need to continue
        if (relatedRecordIds.size() <= 1) {
            return new Map<String, Map<ID, String>>(); // Return an empty map if only parent ID is present
        }

        // Query ContentDocumentLink to get related ContentDocumentIds
        List<ContentDocumentLink> documentLinks = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId IN :relatedRecordIds
        ];

        Set<ID> contentDocumentIds = new Set<ID>();
        for (ContentDocumentLink link : documentLinks) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        // Query the latest ContentVersion records associated with these ContentDocumentIds
        List<ContentDocument> documents = [
            SELECT Id, LatestPublishedVersionId, FileType, Title 
            FROM ContentDocument 
            WHERE Id IN :contentDocumentIds 
            AND FileType IN ('PDF', 'JPG', 'JPEG', 'PNG', 'GIF')
        ];

        // Separate PDFs and images into two different maps
        Map<ID, String> pdfMap = new Map<ID, String>();
        Map<ID, String> imageMap = new Map<ID, String>();

        for (ContentDocument doc : documents) {
            if (doc.FileType.equalsIgnoreCase('PDF')) {
                pdfMap.put(doc.LatestPublishedVersionId, doc.Title);
            } else {
                imageMap.put(doc.LatestPublishedVersionId, doc.Title);
            }
        }

        // Create a result map to hold both maps
        Map<String, Map<ID, String>> result = new Map<String, Map<ID, String>>();
        result.put('pdfs', pdfMap);
        result.put('images', imageMap);

        return result;
    }
}