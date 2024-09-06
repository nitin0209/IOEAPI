public with sharing class PdfGenerationProjectIntendedOutcome {
    public Design_Work__c Designwork2 { get; set; }
    public String Address { get; set; }
  //  public String energyReduction { get; set; }
    // public String internalComfort { get; set; }

    public PdfGenerationProjectIntendedOutcome() {
        Id DesignworkId2 = ApexPages.currentPage().getParameters().get('id');
        if (DesignworkId2 != null) {
            Designwork2 = [SELECT Id, Name, Date__c, Project_Reference__c, Address__c, Address__Street__s, Address__City__s, Address__PostalCode__s, 
                           Address__StateCode__s, Address__CountryCode__s, IO_Advisory_notes__c, IO_Reductions_in_energy_use__c, 
                           IO_Reductions_in_energy_use_Action__c, IO_Improvement_in_internal_comfort__c, IO_Improvement_in_internal_comfortAction__c, 
                           IO_Notes_from_the_customer__c, Survey__r.company_Name__c, Survey__r.Assigned_Coordinator__c ,Survey__r.House_Type__c,
                           Survey__r.Is_Listed__c ,Survey__r.Tenure_Type__c 
                           
                         FROM Design_Work__c WHERE Id = :DesignworkId2 LIMIT 1];
        }

        Address = '';

        if (Designwork2 != null) {
            if (!String.isBlank(Designwork2.Address__Street__s)) {
                Address += Designwork2.Address__Street__s;
            }
            if (!String.isBlank(Designwork2.Address__City__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork2.Address__City__s;
            }
            if (!String.isBlank(Designwork2.Address__PostalCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork2.Address__PostalCode__s;
            }
            if (!String.isBlank(Designwork2.Address__CountryCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork2.Address__CountryCode__s;
            }
        }

    // energyReduction = Designwork2.IO_Reductions_in_energy_use__c ? '☑ ' + Designwork2.IO_Reductions_in_energy_use_Action__c : '☐';
      //  internalComfort = Designwork2.IO_Improvement_in_internal_comfort__c ? '☑ ' + Designwork2.IO_Improvement_in_internal_comfortAction__c : '☐';
    }

    public PageReference generatePDFAndSave() {
        if (Designwork2.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork ID provided.'));
            return null;
        }

        PageReference pdfPage = Page.DesignWork_PDF_Intented_Outcomes;
        pdfPage.getParameters().put('id', Designwork2.Id);
        Blob pdfBlob;
        try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
            return null;
        }

        ContentVersion cv = new ContentVersion();
        cv.Title = Designwork2.Name + '_' + Designwork2.Id + 'Project Intended Outcomes.pdf';
        cv.PathOnClient = Designwork2.Name + '_' + Designwork2.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork2.Id;
        cv.IsMajorVersion = true;
        insert cv;

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
    }
}