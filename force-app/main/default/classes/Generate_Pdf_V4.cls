public with sharing class Generate_Pdf_V4 {
 public Lead lead { get; set; }
    
    public Generate_Pdf_V4() {
        Id leadId = ApexPages.currentPage().getParameters().get('id');
        if (leadId != null) {
            lead = [SELECT Id, Name, Company, Email, Phone, Status, Website, Declined_By__c, Who_is_on_Benefit__c, current_energy_rating__c,
                            potential_energy_rating__c, Type_of_heating__c, assigned_Lead_Assistant__c, Date_Of_Birth__c, do_you_know_how_old_the_insulation_is__c, 
                            Do_you_know_if_there_is_wall_insulation__c, Does_property_work_require_a_contractor__c, Prep_Work__c, Dwelling_Type__c, EPC_Data__c, 
                            other_gas_supplier__c, other_electricity_suppliers__c 
                            FROM Lead WHERE Id = :leadId LIMIT 1];
            
            
            
            
            
            
            
        }   List<High_Rate__mdt> metadataRecords = [SELECT High_Rate_Value__c FROM High_Rate__mdt ];
        if (!metadataRecords.isEmpty()) {
            High_Rate__mdt metadataRecord = metadataRecords[0];
          //  High_Rate__mdt highRate = new High_Rate__mdt();
         decimal   highRate = metadataRecord.High_Rate_Value__c; // Fetch and store High_Rate__c field value
        }
    }
    
   public PageReference generatePDFAndSave() {
        if (lead.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Lead ID provided.'));
            return null;
        } 

        // Generate the PDF from the Visualforce page
        PageReference pdfPage = Page.Generate_PDF;
        pdfPage.getParameters().put('id', lead.Id);
        system.debug('LeadId: ' + lead.Id);
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
        cv.Title = lead.Name + '_' + lead.Id + '.pdf';
        cv.PathOnClient = lead.Name + '_' + lead.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = lead.Id;
        cv.IsMajorVersion = true;
        insert cv;
		System.debug('Content Version Inserted: ');
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
	}
}