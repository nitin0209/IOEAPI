public class PdfGenerationRetrofit {
    
     public Design_Work__c Designwork4 { get; set; }
 public String Address { get; set; } 
    public PdfGenerationRetrofit() {
        Id DesignworkId4 = ApexPages.currentPage().getParameters().get('id');
        if (DesignworkId4 != null) {
           Designwork4 = [ SELECT Id, Name,  Date__c,Survey__r.Assigned_Coordinator__c,Survey__r.Define_Measures__c,EV_Is_the_damp_or_mold_present__c,EV_Action_Required_for_damp__c,EV_Do_you_have_ventilation_installed__c,
       EV_Action_Required_for_ventilation__c,EV_Is_there_sufficient_undercut__c,EV_Action_required_for_undercut__c,EV_Is_window_open_for_purge_ventilation__c,EV_Action_required_for_purge__c, dMEV_Gross_internal_area_of_the_property__c, dMEV_Number_of_single_bedrooms__c, dMEV_Number_of_double_bedrooms__c, dMEV_Whole_dwelling_ventilation_rate__c,
       VU_Advisory_notes__c, D_Confirm_ventilation_max_noise_level_30__c,D_Confirm_that_ventilation_system_sized__c,D_Confirm_design_includes_calculations__c,D_Confirm_that_ventilation_system_instle__c,
         D_Confirm_ventilation_all_fans__c,                 
        Address__c, Address__Street__s, Address__City__s, Address__PostalCode__s,  Address__StateCode__s, Address__CountryCode__s   FROM Design_Work__c WHERE Id = :DesignworkId4 LIMIT 1];
        }
        Address = '';

        if (Designwork4 != null) {
            if (!String.isBlank(Designwork4.Address__Street__s)) {
                Address += Designwork4.Address__Street__s;
            }
            if (!String.isBlank(Designwork4.Address__City__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork4.Address__City__s;
            }
            if (!String.isBlank(Designwork4.Address__PostalCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork4.Address__PostalCode__s;
            }
            if (!String.isBlank(Designwork4.Address__CountryCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork4.Address__CountryCode__s;
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
       PageReference pdfPage = Page.DesignWork_PDF_Retrofit;
        pdfPage.getParameters().put('id', Designwork4.Id);
        system.debug('DesignworkId1: ' + Designwork4.Id);
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
        cv.Title = Designwork4.Name + '_' + Designwork4.Id + 'Retrofit.pdf';
        cv.PathOnClient = Designwork4.Name + '_' + Designwork4.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork4.Id;
        cv.IsMajorVersion = true;
        insert cv;
		System.debug('Content Version Inserted: ');
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
	}
    
    

}