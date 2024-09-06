public with sharing class PdfGenerationImprovementOption {
 public Design_Work__c Designwork3 { get; set; }
 public String Address { get; set; } 
    public PdfGenerationImprovementOption() {
        Id DesignworkId3 = ApexPages.currentPage().getParameters().get('id');
        if (DesignworkId3 != null) {
           Designwork3 = [ SELECT Id, Name, EV_Is_the_damp_or_mold_present__c,EV_Do_you_have_ventilation_installed__c, D_ventilation_inadequate_no_action_req__c,
                            dMEV_Gross_internal_area_of_the_property__c, dMEV_Number_of_single_bedrooms__c, dMEV_Number_of_double_bedrooms__c, dMEV_Whole_dwelling_ventilation_rate__c,
          Address__c, Address__Street__s, Address__City__s, Address__PostalCode__s,  Address__StateCode__s, Address__CountryCode__s   FROM Design_Work__c WHERE Id = :DesignworkId3 LIMIT 1];
        }
        Address = '';

        if (Designwork3 != null) {
            if (!String.isBlank(Designwork3.Address__Street__s)) {
                Address += Designwork3.Address__Street__s;
            }
            if (!String.isBlank(Designwork3.Address__City__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork3.Address__City__s;
            }
            if (!String.isBlank(Designwork3.Address__PostalCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork3.Address__PostalCode__s;
            }
            if (!String.isBlank(Designwork3.Address__CountryCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork3.Address__CountryCode__s;
            }
    }
    }
    
     public PageReference generatePDFAndSave() {
        if (Design_Work__c.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork ID provided.'));
            return null;
        }

        // Generate the PDF from the Visualforce page
       // PageReference pdfPage = Page.Design_Work_Generate_PDF_Ventilation;
        //PageReference pdfPage = Page.DesignWork_PDF_Medium_Term_Plan;
       //PageReference pdfPage = Page.DesignWork_PDF_Intented_Outcomes;
       PageReference pdfPage = Page.DesignWork_PDF_Improvement_Option;
        pdfPage.getParameters().put('id', Designwork3.Id);
        system.debug('DesignworkId1: ' + Designwork3.Id);
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
        cv.Title = Designwork3.Name + '_' + Designwork3.Id + 'Improvement Evaluation Option.pdf';
        cv.PathOnClient = Designwork3.Name + '_' + Designwork3.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork3.Id;
        cv.IsMajorVersion = true;
        insert cv;
		System.debug('Content Version Inserted: ');
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
	}
}