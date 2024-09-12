/***************************************************************************************************************************************************
 
* Title: SCIS Survey File Controller
 * Developer: Nitin Mane
 * Date: 11th September 2024
 * Description: This class fetches related files (images or PDFs) by a given parent record ID.
 *              It gathers child record IDs from various custom objects linked to the Survey record
 *              and retrieves the relevant ContentDocumentLinks and ContentVersions based on the specified file type.
 * 
 *****************************************************************************************************************************************************/

public with sharing class SCISSurveyFileController {
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getRelatedFilesByRecordId(String parentRecordId, Boolean isImage) {
        // Ensure the provided record ID is valid
        if (String.isBlank(parentRecordId)) {
            throw new IllegalArgumentException('Invalid parent record ID.');
        }

        // Step 1: Collect all child record IDs from various child objects
        Set<ID> childRecordIds = new Set<ID>();
        childRecordIds.add(parentRecordId);

        // Query child records from different objects and add their IDs to the set
        childRecordIds.addAll(getChildRecordIds(parentRecordId));

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

        // Step 3: Query ContentVersion based on file type (image or PDF)
        List<ContentVersion> docs;
        if (isImage) {
            // Query for image file types
            docs = [
                SELECT ContentDocumentId, Id, FileExtension, Title 
                FROM ContentVersion 
                WHERE ContentDocumentId IN :fileIDs 
                AND FileExtension IN ('jpg', 'jpeg', 'png', 'gif')
                ORDER BY ContentDocumentId, LastModifiedDate DESC
            ];
        } else {
            // Query for PDF file types
            docs = [
                SELECT ContentDocumentId, Id, FileExtension, Title 
                FROM ContentVersion 
                WHERE ContentDocumentId IN :fileIDs 
                AND FileExtension = 'pdf'
                AND Title != 'ERFUNSIGNED'  // Exclude ERFUNSIGNED documents
                ORDER BY ContentDocumentId, LastModifiedDate DESC
            ];
        }

        // Create a map of ContentDocument IDs to Titles for the found files
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        Set<ID> processedDocumentIds = new Set<ID>();  // Track processed document IDs to avoid duplicates

        for (ContentVersion doc : docs) {
            if (!processedDocumentIds.contains(doc.ContentDocumentId)) {
                mapIdTitle.put(doc.Id, doc.Title);
                processedDocumentIds.add(doc.ContentDocumentId);  // Mark as processed
            }
        }

        return mapIdTitle;
    }

    // Helper method to get child record IDs from various objects
    private static Set<ID> getChildRecordIds(String parentRecordId) {
        Set<ID> childRecordIds = new Set<ID>();

        // Add ERF__c child records
        for (ERF__c erf : [SELECT Id FROM ERF__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(erf.Id);
        }

        // Add Risk_Assessment__c child records
        for (Risk_Assessment__c riskAssessment : [SELECT Id FROM Risk_Assessment__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(riskAssessment.Id);
        }

        // Add Asbestos_Risk_Assessment__c child records
        for (Asbestos_Risk_Assessment__c asbestosRisk : [SELECT Id FROM Asbestos_Risk_Assessment__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(asbestosRisk.Id);
        }

        // Add PIBI__c child records
        for (PIBI__c pibi : [SELECT Id FROM PIBI__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(pibi.Id);
        }

        // Add Working_at_Height__c child records
        for (Working_at_Height__c workingAtHeight : [SELECT Id FROM Working_at_Height__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(workingAtHeight.Id);
        }

        // Add Significance_Survey__c child records
        for (Significance_Survey__c significanceSurvey : [SELECT Id FROM Significance_Survey__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(significanceSurvey.Id);
        }

        // Add Assessment_Report__c child records
        for (Assessment_Report__c AssessmentReport : [SELECT Id FROM Assessment_Report__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(AssessmentReport.Id);
        }

        // Add PIPS__c child records
        for (PIPS__c pips : [SELECT Id FROM PIPS__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(pips.Id);
        }

        // Add Design_Work__c child records
        for (Design_Work__c designWork : [SELECT Id FROM Design_Work__c WHERE Survey__c = :parentRecordId]) {
            childRecordIds.add(designWork.Id);
        }

        return childRecordIds;
    }
}