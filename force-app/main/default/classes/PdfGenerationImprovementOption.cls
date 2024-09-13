/* ***********************************************************************************************************************************8
* Developer Name: Sanket Teltumbade
* Title: Pdf Generation for design work (Improvement option evaluation )
* Date: September 12, 2024
* Description: this is the controller class for Improvement option evaluation pdf functionality 
* This class is used in  DesignWork_PDF_Improvement_Option

***********************************************************************************************************************************/







public with sharing class PdfGenerationImprovementOption {
    public Design_Work__c Designwork3 { get; set; }
    public String Address { get; set; } 
    
    // Store each field value from optioneering object into separate variables
    public Decimal currentSapRating { get; set; }    Public Decimal annualFuelSavings  { get; set; } 
    Public Decimal lifetimeFuelSavings  { get; set; } 
    Public Decimal sapCO2Emissions  { get; set; } 
    Public String spaceHeatingDemand  { get; set; } 
    Public Decimal capitalCost  { get; set; } 
    Public Decimal lifetimeCO2Savings  { get; set; } 
    Public Decimal carbonScoreEffect  { get; set; } 
    Public Decimal simplepayback { get; set; } 
    
    public PdfGenerationImprovementOption() {
        Id DesignworkId3 = ApexPages.currentPage().getParameters().get('id');
        if (DesignworkId3 != null) {
            Designwork3 = [ SELECT Id, Name,Date__c,Project_Reference__c, EV_Is_the_damp_or_mold_present__c,EV_Do_you_have_ventilation_installed__c, D_ventilation_inadequate_no_action_req__c,
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
        
        
        // Query the Optioneering__c object to get the required fields
        Optioneering__c optioneeringRecord = [SELECT 
                                              Current_SAP_rating__c, 
                                              Annual_fuel_savings__c, 
                                              Lifetime_fuel_savings__c, 
                                              sap_CO2emissions__c, 
                                              Space_heating_demand__c, 
                                              Capital_cost__c, 
                                              Lifetime_CO2_savings__c, 
                                              Carbon_score_effect__c ,Simple_payback__c
                                              FROM Optioneering__c 
                                              WHERE Id = 'a36UE0000003FFRYA2' //this should be updated with the survey id when relationship is created.
                                              ];
        
        // Store each field value into separate variables
        //currentSapRating = optioneeringRecord.Current_SAP_rating__c.intValue();
        currentSapRating = optioneeringRecord.Current_SAP_rating__c.intValue();
        annualFuelSavings = optioneeringRecord.Annual_fuel_savings__c;
        lifetimeFuelSavings = optioneeringRecord.Lifetime_fuel_savings__c;
        sapCO2Emissions = optioneeringRecord.sap_CO2emissions__c;
        spaceHeatingDemand = optioneeringRecord.Space_heating_demand__c;
        capitalCost = optioneeringRecord.Capital_cost__c;
        lifetimeCO2Savings = optioneeringRecord.Lifetime_CO2_savings__c;
        carbonScoreEffect = optioneeringRecord.Carbon_score_effect__c;
        simplepayback = optioneeringRecord.Simple_payback__c;
        // Now each of the fields has been stored into separate variables
        
        
        
        
        
        
        
        
        
        
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