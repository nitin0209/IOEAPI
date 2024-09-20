public with sharing class PdfGenerationForDesignWorkMediumTermPlan {
    public Design_Work__c Designwork1 { get; set; }
    public String SurveyId { get; set; }
    public String Address { get; set; }
    public String measureValue { get; set; }
    public Decimal annualFuelSavings { get; set; }
    public Decimal simplepayback { get; set; }
    public Decimal lifetimeCO2Savings { get; set; }
    public Decimal lifetimeFuelSavings { get; set; }
    public Decimal carbonScoreEffect { get; set; }

    // Constructor now takes SurveyId instead of DesignWorkId
    public PdfGenerationForDesignWorkMediumTermPlan() {
      Id  DesignworkId1 = ApexPages.currentPage().getParameters().get('Id');
        
        if (DesignworkId1 != null) {
            Designwork1 = [SELECT Id, Name, Date__c, Survey__C, Project_Reference__c, Address__c, Address__Street__s, Address__City__s, Address__PostalCode__s, 
                           Address__StateCode__s, Address__CountryCode__s, D_I_accept_the_evidence__c, D_Confirm_ventilation_max_noise_level_30__c, 
                           D_Confirm_that_ventilation_system_sized__c, D_Confirm_ventilation_all_fans__c, D_Confirm_design_includes_calculations__c, 
                           D_Confirm_that_ventilation_system_instle__c, D_ventilation_inadequate_no_action_req__c, 
                           D_requirements_for_combustion_appliances__c, Survey__r.company_Name__c, Survey__r.Assigned_Coordinator__c, 
                           Survey__r.House_Type__c, Survey__r.Is_Listed__c ,PC_Constraints_imposed_by_local_planning__c,PC_Constraints_imposed_by_history__c,
                           PC_Constraints_imposed_by_the_location__c ,PC_Defects_requiring_repair__c ,PC_Other_defects_requiring_attention__c
                         FROM Design_Work__c WHERE Id = :DesignworkId1 LIMIT 1];
        }
        
          if (Designwork1 != null && Designwork1.Survey__c!=null) {
            
            SurveyId = Designwork1.Survey__c ;
            
        }

        if (Designwork1 != null) {
            // Build the address string
            Address = '';
            if (!String.isBlank(Designwork1.Address__Street__s)) {
                Address += Designwork1.Address__Street__s;
            }
            if (!String.isBlank(Designwork1.Address__City__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork1.Address__City__s;
            }
            if (!String.isBlank(Designwork1.Address__PostalCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork1.Address__PostalCode__s;
            }
            if (!String.isBlank(Designwork1.Address__CountryCode__s)) {
                if (!String.isBlank(Address)) Address += ', ';
                Address += Designwork1.Address__CountryCode__s;
            }

            // Fetch optioneering data
            List<Optioneering__c> optioneeringRecords = [SELECT id, Property_Owner__c, Annual_fuel_savings__c, 
                                                         Lifetime_fuel_savings__c, Lifetime_CO2_savings__c, 
                                                         Carbon_score_effect__c, Simple_payback__c 
                                                         FROM Optioneering__c 
                                                         WHERE Property_Owner__c = :SurveyId LIMIT 1];
            if (!optioneeringRecords.isEmpty()) {
                Optioneering__c optioneeringRecord = optioneeringRecords[0];
                annualFuelSavings = optioneeringRecord.Annual_fuel_savings__c;
                lifetimeFuelSavings = optioneeringRecord.Lifetime_fuel_savings__c;
                lifetimeCO2Savings = optioneeringRecord.Lifetime_CO2_savings__c;
                carbonScoreEffect = optioneeringRecord.Carbon_score_effect__c;
                simplepayback = optioneeringRecord.Simple_payback__c;
            }

            // Fetch appointment data for Measure__c
            List<Appointment__c> appointments = [SELECT Measure__c FROM Appointment__c WHERE Property__c = :SurveyId LIMIT 1];
            if (!appointments.isEmpty()) {
                Appointment__c appointment = appointments[0];
                measureValue = appointment.Measure__c;
            }
        } else {
            System.debug('No Designwork found for the given SurveyId');
        }
    }

  public PageReference generatePDFAndSave() {
    if (Designwork1 == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork found for the given Survey.'));
        return null;
    }

    // Generate the PDF from the Visualforce page
    PageReference pdfPage = Page.DesignWork_PDF_Medium_Term_Plan;
    pdfPage.getParameters().put('id', Designwork1.Id);

    Blob pdfBlob;
    try {
        System.debug('Attempting to get PDF content for Designwork Id: ' + Designwork1.Id);
        pdfBlob = pdfPage.getContentAsPDF();
        System.debug('PDF content retrieved successfully.');
    } catch (VisualforceException e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
        return null;
    }

    // Store the PDF as ContentVersion
    try {
        ContentVersion cv = new ContentVersion();
        cv.Title = Designwork1.Name + '_' + Designwork1.Id + '_Medium_Term_Plan.pdf';
        cv.PathOnClient = Designwork1.Name + '_' + Designwork1.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork1.Id;
        cv.IsMajorVersion = true;
        insert cv;
        System.debug('PDF successfully inserted as ContentVersion.');
    } catch (Exception e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving PDF as ContentVersion: ' + e.getMessage()));
        return null;
    }

    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
    return null;
}
}