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
    
    //Room Highrates
    public decimal bathroomHighRate  { get; set; }
    public decimal kitchenHighRate  { get; set; }
    public decimal utilityHighRate  { get; set; }
    public decimal wcHighRate  { get; set; }
    
    // Declare separate variables for each extract rate in liters per second (LPS)
    Public Decimal bathroomExtractRateLPS { get; set; }
    Public Decimal bedroomExtractRateLPS { get; set; }
    Public Decimal diningExtractRateLPS { get; set; }
    Public Decimal kitchenCookerHoodExtractToOutsideLPS{ get; set; }
    Public Decimal kitchenCookerHoodNotExtractOutsideLPS{ get; set; }
    Public Decimal kitchenWithDiningAreaLPS { get; set; }
    Public Decimal remainingHabitableRoomLPS{ get; set; }
    Public Decimal utilityExtractRateLPS { get; set; }
    Public Decimal wcExtractRateLPS { get; set; }
    
    // Declare separate variables for each minimum required area in mm²
    Public Decimal bathroomRequiredAreaMM2 { get; set; }
    Public Decimal bedroomRequiredAreaMM2 { get; set; }
    Public Decimal diningRequiredAreaMM2{ get; set; }
    Public Decimal kitchenCookerHoodExtractToOutsideAreaMM2{ get; set; }
    Public Decimal kitchenCookerHoodNotExtractOutsideAreaMM2 { get; set; }
    Public Decimal kitchenWithDiningAreaAreaMM2 { get; set; }
    Public Decimal remainingHabitableRoomAreaMM2 { get; set; }
    Public Decimal utilityRequiredAreaMM2 { get; set; }
    Public Decimal wcRequiredAreaMM2 { get; set; }
    
    
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
        
        
        // Query the high rate custom metadata records
        List<High_Rate__mdt> metadataRecords = [
            SELECT DeveloperName, High_Rate_Value__c 
            FROM High_Rate__mdt 
            WHERE DeveloperName IN ('Bathroom_High_Rate', 'Kitchen_High_Rate', 'Utility_High_Rate', 'WC_High_Rate')
        ];
        
        // Loop through the records and assign the values to separate variables
        if (!metadataRecords.isEmpty()) {
            for (High_Rate__mdt metadataRecord : metadataRecords) {
                // Assign values based on DeveloperName
                if (metadataRecord.DeveloperName == 'Bathroom_High_Rate') {
                    bathroomHighRate = metadataRecord.High_Rate_Value__c;
                } else if (metadataRecord.DeveloperName == 'Kitchen_High_Rate') {
                    kitchenHighRate = metadataRecord.High_Rate_Value__c;
                } else if (metadataRecord.DeveloperName == 'Utility_High_Rate') {
                    utilityHighRate = metadataRecord.High_Rate_Value__c;
                } else if (metadataRecord.DeveloperName == 'WC_High_Rate') {
                    wcHighRate = metadataRecord.High_Rate_Value__c;
                }
            }
        }
        
        // Debug the individual high rate values
        System.debug('Bathroom High Rate: ' + bathroomHighRate);
        System.debug('Kitchen High Rate: ' + kitchenHighRate);
        System.debug('Utility High Rate: ' + utilityHighRate);
        System.debug('WC High Rate: ' + wcHighRate);
        
        
        
        
        
        
        // Query the required extraxt and minimum required area custom metadata records
        List<Required_Extract_Rate__mdt> requiredextractmetadataRecord1 = [
            SELECT DeveloperName, Required_Extract_Rate_liter_per_second__c, Minimum_Required_areas_mm2__c 
            FROM Required_Extract_Rate__mdt 
            WHERE DeveloperName IN ('bathroom', 'Bedroom', 'Dining', 'Kitchen_cooker_hood_extract_to_outside', 
                                    'Kitchen_cooker_hood_not_extract_outside', 'Kitchen_with_dining_area', 
                                    'Remaining_habitable_room', 'Utility', 'WC')
        ];
        
        // Loop through the records and assign the values to separate variables
        if (!metadataRecords.isEmpty()) {
            for (Required_Extract_Rate__mdt metadataRecord1 : requiredextractmetadataRecord1) {
                // Assign values based on DeveloperName for Extract Rates and Minimum Areas
                if (metadataRecord1.DeveloperName == 'bathroom') {
                    bathroomExtractRateLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    bathroomRequiredAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Bedroom') {
                    bedroomExtractRateLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    bedroomRequiredAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Dining') {
                    diningExtractRateLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    diningRequiredAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Kitchen_cooker_hood_extract_to_outside') {
                    kitchenCookerHoodExtractToOutsideLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    kitchenCookerHoodExtractToOutsideAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Kitchen_cooker_hood_not_extract_outside') {
                    kitchenCookerHoodNotExtractOutsideLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    kitchenCookerHoodNotExtractOutsideAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Kitchen_with_dining_area') {
                    kitchenWithDiningAreaLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    kitchenWithDiningAreaAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Remaining_habitable_room') {
                    remainingHabitableRoomLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    remainingHabitableRoomAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'Utility') {
                    utilityExtractRateLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    utilityRequiredAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
                else if (metadataRecord1.DeveloperName == 'WC') {
                    wcExtractRateLPS = metadataRecord1.Required_Extract_Rate_liter_per_second__c;
                    wcRequiredAreaMM2 = metadataRecord1.Minimum_Required_areas_mm2__c;
                }
            }
        }
        
        // Debug the individual extract rate and required area values
        System.debug('Bathroom Required Extract Rate LPS: ' + bathroomExtractRateLPS + ', Minimum Required Area MM²: ' + bathroomRequiredAreaMM2);
        System.debug('Bedroom Required Extract Rate LPS: ' + bedroomExtractRateLPS + ', Minimum Required Area MM²: ' + bedroomRequiredAreaMM2);
        System.debug('Dining Required Extract Rate LPS: ' + diningExtractRateLPS + ', Minimum Required Area MM²: ' + diningRequiredAreaMM2);
        System.debug('Kitchen Cooker Hood Extract to Outside LPS: ' + kitchenCookerHoodExtractToOutsideLPS + ', Minimum Required Area MM²: ' + kitchenCookerHoodExtractToOutsideAreaMM2);
        System.debug('Kitchen Cooker Hood Not Extract Outside LPS: ' + kitchenCookerHoodNotExtractOutsideLPS + ', Minimum Required Area MM²: ' + kitchenCookerHoodNotExtractOutsideAreaMM2);
        System.debug('Kitchen with Dining Area Required Extract Rate LPS: ' + kitchenWithDiningAreaLPS + ', Minimum Required Area MM²: ' + kitchenWithDiningAreaAreaMM2);
        System.debug('Remaining Habitable Room Required Extract Rate LPS: ' + remainingHabitableRoomLPS + ', Minimum Required Area MM²: ' + remainingHabitableRoomAreaMM2);
        System.debug('Utility Required Extract Rate LPS: ' + utilityExtractRateLPS + ', Minimum Required Area MM²: ' + utilityRequiredAreaMM2);
        System.debug('WC Required Extract Rate LPS: ' + wcExtractRateLPS + ', Minimum Required Area MM²: ' + wcRequiredAreaMM2);
        
        
        
        
        
        
         Kitchencookerhoodyes =  [SELECT COUNT()  FROM Room__c WHERE does_the_cooker_hood_extract_externally__c = 'Yes' AND Survey__c = :SurveyId];
         KitchencookerhoodNo =  [SELECT COUNT()  FROM Room__c WHERE does_the_cooker_hood_extract_externally__c = 'No' AND Survey__c = :SurveyId];
         Airbrick =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Air brick' AND Survey__c = :SurveyId];
         Atticloft =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Attic/loft' AND Survey__c = :SurveyId];
         Bathroom =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Bathroom' AND Survey__c = :SurveyId];
         Closet =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Closet' AND Survey__c = :SurveyId];
         Diningroom =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Dining room' AND Survey__c = :SurveyId];
         Garage =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Garage' AND Survey__c = :SurveyId];
         Hall =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Hall' AND Survey__c = :SurveyId];
         Livingroom =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Living room' AND Survey__c = :SurveyId];
         Primarybedroom =  [SELECT COUNT()  FROM Room__c WHERE Type__c = '	Primary bedroom' AND Survey__c = :SurveyId];
         Stairway =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Stairway' AND Survey__c = :SurveyId];
         Study =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Study' AND Survey__c = :SurveyId];
         Toilet =  [SELECT COUNT() FROM Room__c WHERE Type__c = 'Toilet' AND Survey__c = :SurveyId];
         Utility =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Utility' AND Survey__c = :SurveyId];
         Other =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Other' AND Survey__c = :SurveyId];
         kitchen =  [SELECT COUNT()  FROM Room__c WHERE Type__c = 'Kitchen' AND Survey__c = :SurveyId];
        
        
        
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