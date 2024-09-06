/*public with sharing class SCIS_LeadPDFController {
    @AuraEnabled
    public static String generatePDF(Id leadId) {
        // Retrieve the Lead record
        Lead lead;
        try {
            lead = [SELECT Id, Name, Company, Email, Phone, Status FROM Lead WHERE Id = :leadId LIMIT 1];
        } catch (QueryException e) {
            throw new AuraHandledException('No Lead record found for the provided ID.');
        }

        // Create PDF content
        String pdfContent = 'Lead Details\n\n';
        pdfContent += 'Name: ' + lead.Name + '\n';
        pdfContent += 'Company: ' + lead.Company + '\n';
        pdfContent += 'Email: ' + lead.Email + '\n';
        pdfContent += 'Phone: ' + lead.Phone + '\n';
        pdfContent += 'Status: ' + lead.Status + '\n';

        // Convert content to Blob
        Blob pdfBlob = Blob.valueOf(pdfContent);

        // Store the PDF in Salesforce as ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Lead_' + lead.Name + '.pdf';
        cv.PathOnClient = 'Lead_' + lead.Name + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = lead.Id;
        insert cv;

        // Query the ContentDocumentId from ContentVersion
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        // Create ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        //cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = lead.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;

        // Return the ContentDocumentId for further processing (e.g., download link)
        return cv.ContentDocumentId;
    }
}*/

public with sharing class SCIS_LeadPDFController {
    public Id leadId { get; set; }

    public SCIS_LeadPDFController() {}

    public PageReference generatePDFAndSave() {
        if (leadId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Lead ID provided.'));
            return null;
        }

        // Generate the PDF from the Visualforce page
        PageReference pdfPage = Page.Generate_PDF;
        pdfPage.getParameters().put('id', leadId);
        Blob pdfBlob = pdfPage.getContentAsPDF();
        System.debug('PDF Blob created: ' + pdfBlob.toString());

        // Store the PDF in Salesforce as ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Lead_' + leadId + '.pdf';
        cv.PathOnClient = 'Lead_' + leadId + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = leadId;
        insert cv;
		System.debug('Content Version Inserted: ' + pdfBlob.toString());
        // Query the ContentDocumentId from ContentVersion
        //cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        
        // Create ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        //cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = leadId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;

        // Return the ContentDocumentId for further processing (e.g., download link)
        //return cdl.ContentDocumentId;
        // Fetch the ContentDocumentId from the inserted ContentVersion
        /*List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        if (contentVersions.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No PDF found for the provided Lead ID.'));
            return null;
        }

        // Optionally, you can redirect to the Lead record page or display a success message
        PageReference leadPage = new PageReference('/' + leadId);
        leadPage.setRedirect(true);*/
        return pdfPage;
    }
}