public with sharing class SCISInstallationImgPdfVisualController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Map<ID, String>> getRelatedFilesByRecordId(String parentRecordId) {
        if (String.isBlank(parentRecordId)) {
            throw new IllegalArgumentException('Invalid parent record ID.');
        }

        // Collect all child record IDs
        Set<ID> childRecordIds = new Set<ID>();
        childRecordIds.add(parentRecordId);

        // Fetch Measure_Status__c records
        for (Measure_Status__c measureStat : [
            SELECT Id 
            FROM Measure_Status__c 
            WHERE Installation__c = :parentRecordId
        ]) {
            childRecordIds.add(measureStat.Id);
        }

        // Fetch CWI__c records
        for (CWI__c cwi : [
            SELECT Id 
            FROM CWI__c 
            WHERE installation_Id__c = :parentRecordId
        ]) {
            childRecordIds.add(cwi.Id);
        }

        // Fetch LI__c records
        for (LI__c li : [
            SELECT Id 
            FROM LI__c 
            WHERE installation_Id__c = :parentRecordId
        ]) {
            childRecordIds.add(li.Id);
        }

        // Query ContentDocumentLink for files linked to the collected child records
        List<ContentDocumentLink> files = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId IN :childRecordIds
        ];

        // Collect all ContentDocument IDs linked to child records
        Set<ID> fileIDs = new Set<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }

        // Query ContentVersion for PDFs and images related to these ContentDocument IDs
        List<ContentVersion> docs = [
            SELECT ContentDocumentId, Id, FileExtension, Title 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :fileIDs 
            AND FileExtension IN ('pdf', 'jpg', 'jpeg', 'png', 'gif') 
            ORDER BY ContentDocumentId, LastModifiedDate DESC
        ];

        // Separate PDFs and images into two different maps
        Map<ID, String> pdfMap = new Map<ID, String>();
        Map<ID, String> imageMap = new Map<ID, String>();
        
        for (ContentVersion doc : docs) {
            if (doc.FileExtension == 'pdf') {
                pdfMap.put(doc.Id, doc.Title);
            } else {
                imageMap.put(doc.Id, doc.Title);
            }
        }

        // Create a result map to hold both maps
        Map<String, Map<ID, String>> result = new Map<String, Map<ID, String>>();
        result.put('pdfs', pdfMap);
        result.put('images', imageMap);

        return result;
    }

    // Method to be used by Visualforce pages
    public Map<String, Map<ID, String>> getFiles(String parentRecordId) {
        if (String.isBlank(parentRecordId)) {
            throw new IllegalArgumentException('Invalid parent record ID.');
        }
        return getRelatedFilesByRecordId(parentRecordId);
    }
}