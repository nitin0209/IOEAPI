public with sharing class PdfGenerationForDesignWorkMediumTermPlan {
 public Design_Work__c Designwork1 { get; set; }
    
    public PdfGenerationForDesignWorkMediumTermPlan() {
        Id DesignworkId1 = ApexPages.currentPage().getParameters().get('id');
        if (DesignworkId1 != null) {
           Designwork1 = [ SELECT Id, Name, EV_Is_the_damp_or_mold_present__c,EV_Do_you_have_ventilation_installed__c, D_ventilation_inadequate_no_action_req__c,
                            dMEV_Gross_internal_area_of_the_property__c, dMEV_Number_of_single_bedrooms__c, dMEV_Number_of_double_bedrooms__c, dMEV_Whole_dwelling_ventilation_rate__c
                            FROM Design_Work__c WHERE Id = :DesignworkId1 LIMIT 1];
        }
    }
    
     public PageReference generatePDFAndSave() {
        if (Design_Work__c.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork ID provided.'));
            return null;
        }

        // Generate the PDF from the Visualforce page
       // PageReference pdfPage = Page.Design_Work_Generate_PDF_Ventilation;
        PageReference pdfPage = Page.DesignWork_PDF_Medium_Term_Plan;
       // PageReference pdfPage = Page.DesignWork_PDF_Intented_Outcomes;
       //PageReference pdfPage = Page.DesignWork_PDF_Improvement_Option;
        pdfPage.getParameters().put('id', Designwork1.Id);
        system.debug('DesignworkId1: ' + Designwork1.Id);
        Blob pdfBlob;
         try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            // Handle exception
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
            return null;
        }
        System.debug('PDF Blob created: ');

        // Store the PDF in Salesforce as ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = Designwork1.Name + '_' + Designwork1.Id + 'Medium Term Plan.pdf';
        cv.PathOnClient = Designwork1.Name + '_' + Designwork1.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork1.Id;
        cv.IsMajorVersion = true;
        insert cv;
		System.debug('Content Version Inserted: ');
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
	}
}