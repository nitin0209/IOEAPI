public with sharing class SCISInstallationImgController {
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getRelatedFilesByRecordId(String parentRecordId) {
        if (String.isBlank(parentRecordId)) {
            throw new IllegalArgumentException('Invalid parent record ID.');
        }

        // Step 1: Collect all child record IDs
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
        System.debug('Measure_Status__c Child Record IDs: ' + childRecordIds);

        // Fetch CWI__c records
        for (CWI__c cwi : [
            SELECT Id 
            FROM CWI__c 
            WHERE installation_Id__c = :parentRecordId
        ]) {
            childRecordIds.add(cwi.Id);
        }
        System.debug('CWI__c Child Record IDs: ' + childRecordIds);

        // Fetch LI__c records
        for (LI__c li : [
            SELECT Id 
            FROM LI__c 
            WHERE installation_Id__c = :parentRecordId
        ]) {
            childRecordIds.add(li.Id);
        }
        System.debug('LI__c Child Record IDs: ' + childRecordIds);

        // Check if we have collected child record IDs
        if (childRecordIds.size() > 1) {
            System.debug('Child record IDs collected: ' + childRecordIds);
        } else {
            System.debug('No child records found.');
        }

        // Step 2: Query ContentDocumentLink for files linked to the collected child records
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

        System.debug('File IDs: ' + fileIDs);

        // Step 3: Query ContentVersion for images related to these ContentDocument IDs
        List<ContentVersion> docs = [
            SELECT ContentDocumentId, Id, FileExtension, Title 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :fileIDs 
            AND FileExtension IN ('jpg', 'jpeg', 'png', 'gif') // Filter for image file types
            ORDER BY ContentDocumentId, LastModifiedDate DESC
        ];

        System.debug('Content Versions Retrieved: ' + docs);

        // Step 4: Create a map of ContentDocument IDs to Titles for the found images
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (ContentVersion doc : docs) {
            mapIdTitle.put(doc.Id, doc.Title);
        }

        System.debug('Unique images linked to child records processed: ' + mapIdTitle.size());

        return mapIdTitle;
    }
}