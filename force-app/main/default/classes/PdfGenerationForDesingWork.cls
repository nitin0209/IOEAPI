/* ***********************************************************************************************************************************8
 * Developer Name: Sanket Teltumbade
 * Title: Pdf Generation for design work (Ventilation assessment)
 * Date: September 12, 2024
 * Description: this is the controller class for ventilation assessment pdf functionality 
 * This class is used in  Design_Work_Generate_PDF visualforce page  

 ***********************************************************************************************************************************/






public with sharing class PdfGenerationForDesingWork {
    public Design_Work__c Designwork { get; set; }
    public String Address { get; set; } // Ensure this is a public property
    public String Ventilation  { get; set; } 
    public decimal highRate  { get; set; } 
    public decimal Requiredextractrate  { get; set; } 
    Public Integer Kitchencookerhoodyes { get; set; } 
    Public Integer KitchencookerhoodNo { get; set; } 
    public string SurveyId  { get; set; }
    Public Integer Airbrick { get; set; } 
    Public Integer Atticloft { get; set; } 
    Public Integer Bathroom { get; set; } 
    Public Integer Closet { get; set; } 
    Public Integer Diningroom { get; set; } 
    Public Integer Garage { get; set; } 
    Public Integer Hall { get; set; } 
    Public Integer Livingroom { get; set; } 
    Public Integer Primarybedroom { get; set; } 
    Public Integer Stairway { get; set; } 
    Public Integer Toilet { get; set; } 
    Public Integer Utility { get; set;} 
    Public Integer Other { get; set; } 
    Public Integer kitchen { get; set; } 
    Public Integer Study { get; set; } 



    
    
    
    
    
    public PdfGenerationForDesingWork() {
        Id DesignworkId = ApexPages.currentPage().getParameters().get('id');
        set<Id>DesignSurveyids= new set<id>();
        if (DesignworkId != null) {
            Designwork = [
                SELECT Id, Name, EV_Is_the_damp_or_mold_present__c, EV_Do_you_have_ventilation_installed__c, D_ventilation_inadequate_no_action_req__c,Survey__c,
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
    if (Designwork != null) {
        
        SurveyId = Designwork.Survey__c ;
        
    }
        
        
        List<High_Rate__mdt> metadataRecords = [SELECT High_Rate_Value__c FROM High_Rate__mdt ];
        if (!metadataRecords.isEmpty()) {
            High_Rate__mdt metadataRecord = metadataRecords[0];
            //  High_Rate__mdt highRate = new High_Rate__mdt();
            decimal   highRate = metadataRecord.High_Rate_Value__c; // Fetch and store High_Rate__c field value
        }
        
        List<Required_Extract_Rate__mdt> metadataRecords1 = [SELECT Required_Extract_Rate_liter_per_second__c FROM Required_Extract_Rate__mdt ];
        if (!metadataRecords1.isEmpty()) {
            Required_Extract_Rate__mdt metadataRecord1 = metadataRecords1[0];
            
            decimal   Requiredextractrate  = metadataRecord1.Required_Extract_Rate_liter_per_second__c; // Fetch and store High_Rate__c field value
        }
        
                Integer Kitchencookerhoodyes = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE does_the_cooker_hood_extract_externally__c = 'Yes' AND Survey__c = :SurveyId][0].get('total');
                Integer KitchencookerhoodNo = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE does_the_cooker_hood_extract_externally__c = 'No' AND Survey__c = :SurveyId][0].get('total');
                Integer Airbrick = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Air brick' AND Survey__c = :SurveyId][0].get('total');
                Integer Atticloft = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Attic/loft' AND Survey__c = :SurveyId][0].get('total');
                Integer Bathroom = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Bathroom' AND Survey__c = :SurveyId][0].get('total');
                Integer Closet = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Closet' AND Survey__c = :SurveyId][0].get('total');
                Integer Diningroom = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Dining room' AND Survey__c = :SurveyId][0].get('total');
                Integer Garage = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Garage' AND Survey__c = :SurveyId][0].get('total');
                Integer Hall = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Hall' AND Survey__c = :SurveyId][0].get('total');
                Integer Livingroom = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Living room' AND Survey__c = :SurveyId][0].get('total');
                Integer Primarybedroom = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = '	Primary bedroom' AND Survey__c = :SurveyId][0].get('total');
                Integer Stairway = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Stairway' AND Survey__c = :SurveyId][0].get('total');
                Integer Study = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Study' AND Survey__c = :SurveyId][0].get('total');
                Integer Toilet = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Toilet' AND Survey__c = :SurveyId][0].get('total');
                Integer Utility = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Utility' AND Survey__c = :SurveyId][0].get('total');
                Integer Other = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Other' AND Survey__c = :SurveyId][0].get('total');
                Integer kitchen = (Integer) [SELECT COUNT(Id) total FROM Room__c WHERE Type__c = 'Kitchen' AND Survey__c = :SurveyId][0].get('total');

        
        
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