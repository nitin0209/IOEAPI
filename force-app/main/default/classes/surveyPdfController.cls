public with sharing class surveyPdfController {
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getRelatedFilesByRecordId(String parentRecordId) {
        // Ensure the provided record ID is valid
        if (String.isBlank(parentRecordId)) {
            throw new IllegalArgumentException('Invalid parent record ID.');
        }

        // Step 1: Query for all child records related to the parent record (Survey__c)
        // Collecting all child record IDs from various child objects
        Set<ID> childRecordIds = new Set<ID>();
         childRecordIds.add(parentRecordId);
       // Query for ERF__c child records
        for (ERF__c erf : [
            SELECT Id 
            FROM ERF__c 
            WHERE Survey__c = :parentRecordId
        ]) {
                     childRecordIds.add(erf.Id);

        }


        // Query for Risk_Assessment__c child records
        for (Risk_Assessment__c riskAssessment : [
            SELECT Id 
            FROM Risk_Assessment__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(riskAssessment.Id);
        }

        // Query for Asbestos_Risk_Assessment__c child records
        for (Asbestos_Risk_Assessment__c asbestosRisk : [
            SELECT Id 
            FROM Asbestos_Risk_Assessment__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(asbestosRisk.Id);
        }

        // Query for PIBI__c child records
        for (PIBI__c pibi : [
            SELECT Id 
            FROM PIBI__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(pibi.Id);
        }

        // Query for Working_at_Height__c child records
        for (Working_at_Height__c workingAtHeight : [
            SELECT Id 
            FROM Working_at_Height__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(workingAtHeight.Id);
        }

        // Query for Significance_Survey__c child records
        for (Significance_Survey__c significanceSurvey : [
            SELECT Id 
            FROM Significance_Survey__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(significanceSurvey.Id);
        }

        // Query for Assessment_Report__c child records
        for (Assessment_Report__c AssessmentReport : [
            SELECT Id 
            FROM Assessment_Report__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(AssessmentReport.Id);
        }
        // Query for PIPS__c child records
        for (PIPS__c pips : [
            SELECT Id 
            FROM PIPS__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(pips.Id);
        }

        // Query for Design_Work__c child records
        for (Design_Work__c designWork : [
            SELECT Id 
            FROM Design_Work__c 
            WHERE Survey__c = :parentRecordId
        ]) {
            childRecordIds.add(designWork.Id);
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

        // Debug: Log the number of ContentDocument IDs found
        System.debug('Number of ContentDocument IDs linked to child records: ' + fileIDs.size());

        // Step 3: Query ContentVersion for PDFs related to these ContentDocument IDs
       List<ContentVersion> docs = [
            SELECT ContentDocumentId, FileExtension, Title 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :fileIDs AND FileExtension = 'pdf'
            AND Title != 'ERFUNSIGNED'  // Exclude ERFUNSIGNED documents
            AND Title LIKE '%Report%'
            ORDER BY ContentDocumentId, LastModifiedDate DESC
        ];
        // Debug: Log the number of PDFs found
        System.debug('Number of PDF ContentVersions found: ' + docs.size());

        // Step 4: Create a map of ContentDocument IDs to Titles for the found PDFs
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        Set<ID> processedDocumentIds = new Set<ID>();  // Track processed document IDs to avoid duplicates

        for (ContentVersion doc : docs) {
            if (!processedDocumentIds.contains(doc.ContentDocumentId)) {
                mapIdTitle.put(doc.ContentDocumentId, doc.Title);
                processedDocumentIds.add(doc.ContentDocumentId);  // Mark as processed
            }
        }

        // Debug: Log the number of unique PDFs added to the map
        System.debug('Number of unique PDFs linked to child records processed: ' + mapIdTitle.size());

        return mapIdTitle;
    }
}