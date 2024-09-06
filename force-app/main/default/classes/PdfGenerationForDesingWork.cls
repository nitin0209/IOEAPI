public with sharing class PdfGenerationForDesingWork {
    public Design_Work__c Designwork { get; set; }
    public String Address { get; set; } // Ensure this is a public property
    public String Ventilation  { get; set; } 
    public decimal highRate  { get; set; } 
    
    public PdfGenerationForDesingWork() {
        Id DesignworkId = ApexPages.currentPage().getParameters().get('id');

        if (DesignworkId != null) {
            Designwork = [
                SELECT Id, Name, EV_Is_the_damp_or_mold_present__c, EV_Do_you_have_ventilation_installed__c, D_ventilation_inadequate_no_action_req__c,
                       dMEV_Gross_internal_area_of_the_property__c, dMEV_Number_of_single_bedrooms__c, dMEV_Number_of_double_bedrooms__c,
                       dMEV_Bedrooms_flow_result_litres__c, dMEV_Whole_dwelling_ventilation_rate__c, dMEV_Minimum_extract_ventilation_rate__c,
                       IEV_Gross_Internal_Area__c, IEV_Number_of_Bedrooms__c, IEV_Number_of_Habitable_Rooms__c, IEV_Number_of_Wet_Rooms__c,
                       IEV_Total_Required_Ventilator_Area__c, IEV_Excess_area_between_large_room__c, Number_of_Bedrooms__c, 
                       D_Confirm_ventilation_max_noise_level_30__c, D_Confirm_ventilation_all_fans__c, D_Confirm_design_includes_calculations__c,
                        EV_Is_there_sufficient_undercut__c, EV_Is_window_open_for_purge_ventilation__c,
                       dMEV_Gross_internal_area_flow_result__c, IEV_Ventilator_Area_for_floor_over_100__c, IEV_Ventilator_Area_for_floor_upto_100__c,
                      Date__c, Project_Reference__c, Address__c, Address__Street__s, Address__City__s, Address__PostalCode__s, 
                      Address__StateCode__s, Address__CountryCode__s, D_I_accept_the_evidence__c,EV_Action_Required_for_damp__c,EV_Action_Required_for_ventilation__c,
                       EV_Action_required_for_undercut__c,EV_Action_required_for_purge__c,dMEV_Advice_on_background_ventilation__c,Ventilation_adequate__c,D_Confirm_that_ventilation_system_sized__c,
                D_Confirm_that_ventilation_system_instle__c,D_requirements_for_combustion_appliances__c
                FROM Design_Work__c
                WHERE Id = :DesignworkId
                LIMIT 1
            ];
        }
        
         
           List<High_Rate__mdt> metadataRecords = [SELECT High_Rate_Value__c FROM High_Rate__mdt ];
        if (!metadataRecords.isEmpty()) {
            High_Rate__mdt metadataRecord = metadataRecords[0];
          //  High_Rate__mdt highRate = new High_Rate__mdt();
         decimal   highRate = metadataRecord.High_Rate_Value__c; // Fetch and store High_Rate__c field value
        }

        // Construct the address string
        Address = '';

        if (Designwork != null) {
            if (!String.isBlank(Designwork.Address__Street__s)) {
                Address += Designwork.Address__Street__s;
            }
            if (!String.isBlank(Designwork.Address__City__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork.Address__City__s;
            }
            if (!String.isBlank(Designwork.Address__PostalCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork.Address__PostalCode__s;
            }
            if (!String.isBlank(Designwork.Address__CountryCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork.Address__CountryCode__s;
            }
        }
           //Ventilation checkbox
        if((Designwork != null)){
            if((Designwork.Ventilation_adequate__c == true)){
                
                Ventilation= 'Ventilation Adequate';
                
            }
               else{
                   Ventilation= 'Ventilation Inadequate';
               }
            
        }
        
    }

    public PageReference generatePDFAndSave() {
        if (Designwork.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork ID provided.'));
            return null;
        }

        // Generate the PDF from the Visualforce page
        PageReference pdfPage = Page.Design_Work_Generate_PDF;
        pdfPage.getParameters().put('id', Designwork.Id);
        Blob pdfBlob;
        try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            // Handle exception
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
            return null;
        }

        // Store the PDF in Salesforce as ContentVersion
        ContentVersion cv = new ContentVersion();
        cv.Title = Designwork.Name + '_' + Designwork.Id + ' Ventilation Assessment.pdf';
        cv.PathOnClient = Designwork.Name + '_' + Designwork.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork.Id;
        cv.IsMajorVersion = true;
        insert cv;

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
    }
}