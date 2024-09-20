public with sharing class PdfGenerationImprovementOption {
    public Design_Work__c Designwork3 { get; set; }
    public String Address { get; set; } 
    public string SurveyId  { get; set; }
  
    
    //variables for optioneering fetched fields
    public Decimal currentSapRating { get; set; }    
    public Decimal annualFuelSavings  { get; set; } 
    public Decimal lifetimeFuelSavings  { get; set; } 
    public Decimal sapCO2Emissions  { get; set; } 
    public Decimal capitalCost  { get; set; } 
    public Decimal lifetimeCO2Savings  { get; set; } 
    public Decimal carbonScoreEffect  { get; set; } 
    public Decimal simplepayback { get; set; } 
    public string RRN {get;set;}
    public Decimal SapRatingvalue {get; set;}

    //variables for IOE respoonse Fetched fields
    
    public Decimal eiRating { get; set; }
    
    
    // Declare variables to store the fetched field values from improvement option
    public String currentEnergyRating { get; set; }
    public Decimal currentTotalDeliveredEnergy { get; set; }
    public Decimal currentCO2Emissions { get; set; }
    public String currentSpaceHeatingDemand { get; set; }
    public Decimal currentTotalFuelCosts { get; set; }
    
    
    
    
    
    public PdfGenerationImprovementOption() {
        Id DesignworkId3 = ApexPages.currentPage().getParameters().get('id');
        if (DesignworkId3 != null) {
            Designwork3 = [ SELECT Id, Name, Date__c, Project_Reference__c, Survey__c,
                           Address__c, Address__Street__s, 
                           Address__City__s, Address__PostalCode__s,  Address__StateCode__s, 
                           Address__CountryCode__s   
                           FROM Design_Work__c WHERE Id = :DesignworkId3 LIMIT 1];
        }
        
         if (Designwork3 != null && Designwork3.Survey__c!=null) {
            
            SurveyId = Designwork3.Survey__c ;
            
        }
    system.debug('designwork id :' +Designwork3 );
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
        
        
        
    
    

     
        //Fetching fields from optioneering objects
        List<Optioneering__c> optioneeringRecords = [SELECT id, Property_Owner__c,
                                                      Current_SAP_rating__c, 
                                                      Annual_fuel_savings__c, 
                                                      Lifetime_fuel_savings__c, 
                                                      
                                                      Capital_cost__c, 
                                                      Lifetime_CO2_savings__c, 
                                                      Carbon_score_effect__c, 
                                                      Simple_payback__c,rrn__c,sap_SAP_Value__c 
                                                      FROM Optioneering__c 
                                                      WHERE Property_Owner__c =:SurveyId 
                                                      LIMIT 1];
        if (!optioneeringRecords.isEmpty()) {
            Optioneering__c optioneeringRecord = optioneeringRecords[0];
            currentSapRating = optioneeringRecord.Current_SAP_rating__c;
            annualFuelSavings = optioneeringRecord.Annual_fuel_savings__c;
            lifetimeFuelSavings = optioneeringRecord.Lifetime_fuel_savings__c;
            capitalCost = optioneeringRecord.Capital_cost__c;
            lifetimeCO2Savings = optioneeringRecord.Lifetime_CO2_savings__c;
            carbonScoreEffect = optioneeringRecord.Carbon_score_effect__c;
            simplepayback = optioneeringRecord.Simple_payback__c;
            RRN = optioneeringRecord.rrn__c;
            SapRatingvalue = optioneeringRecord.sap_SAP_Value__c;
       
        } else {
            System.debug('No optioneering record found for the given Survey Id');
        }
        
         
        
        
        
 // Method to fetch the IOE_Response__c record based on Survey Id and store values in variables

        // Query the IOE_Response__c object based on Survey__c = :surveyId
    List<IOE_Response__c> ioeResponseRecords = [SELECT  eiRating__c FROM IOE_Response__c WHERE Survey__c = :SurveyId LIMIT 1];
            if (!ioeResponseRecords.isEmpty()) {
                IOE_Response__c ioeResponseRecord = ioeResponseRecords[0];
               eiRating = ioeResponseRecord.eiRating__c;
            } else {
                System.debug('No IOE Response record found for the given Survey Id');
            }
        
        
         // Query the Improvement_Options__c object to fetch the required fields based on Survey__c = :surveyId
                List<Improvement_Options__c> improvementOptions = [SELECT 
                    Current_Energy_Rating__c,
                    Current_Total_Delivered_Energy_kWh_yr__c,
                    Current_CO2_emissions_CO2kg_yr__c,
                    Current_space_heating_demand__c,
                    Current_Total_Fuel_Costs_yr__c
                    FROM Improvement_Options__c 
                    WHERE Property_Owner__c = :SurveyId 
                    LIMIT 1];

                // Check if a record was returned
                if (!improvementOptions.isEmpty()) {
                    // Store the field values in the respective variables
                    currentEnergyRating = improvementOptions[0].Current_Energy_Rating__c;
                    currentTotalDeliveredEnergy = improvementOptions[0].Current_Total_Delivered_Energy_kWh_yr__c;
                    currentCO2Emissions = improvementOptions[0].Current_CO2_emissions_CO2kg_yr__c;
                    currentSpaceHeatingDemand = improvementOptions[0].Current_space_heating_demand__c;
                    currentTotalFuelCosts = improvementOptions[0].Current_Total_Fuel_Costs_yr__c;
                } else {
                    // Handle case when no record is found
                    System.debug('No Improvement Options record found for the given Survey Id.');
                }
        
        
        
        
        
    }


        public PageReference generatePDFAndSave() {
        if (Designwork3 == null || Designwork3.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork ID provided.'));
            return null;
        }
    
        PageReference pdfPage = Page.DesignWork_PDF_Improvement_Option;
        pdfPage.getParameters().put('id', Designwork3.Id);
        Blob pdfBlob;
        try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch (VisualforceException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
            return null;
        }
        
        ContentVersion cv = new ContentVersion();
        cv.Title = Designwork3.Name + '_' + Designwork3.Id + 'Improvement Evaluation Option.pdf';
        cv.PathOnClient = Designwork3.Name + '_' + Designwork3.Id + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = Designwork3.Id;
        cv.IsMajorVersion = true;
        insert cv;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'PDF generated and saved successfully.'));
        return null;
    }
}