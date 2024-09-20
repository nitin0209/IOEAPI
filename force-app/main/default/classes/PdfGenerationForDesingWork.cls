/***********************************************************************************************************************************
* Developer Name: Sanket Teltumbade
* Title: Pdf Generation for design work (Ventilation assessment)
* Date: September 12, 2024
* Description: this is the controller class for ventilation assessment pdf functionality 
* This class is used in Design_Work_Generate_PDF visualforce page  
***********************************************************************************************************************************/

public with sharing class PdfGenerationForDesingWork {
    public Design_Work__c Designwork { get; set; }
    public String Address { get; set; }
    public String Ventilation { get; set; }

    // Room Highrates
    public decimal bathroomHighRate { get; set; }
    public decimal kitchenHighRate { get; set; }
    public decimal utilityHighRate { get; set; }
    public decimal wcHighRate { get; set; }

    // Declare separate variables for each extract rate in liters per second (LPS)
    public Decimal bathroomExtractRateLPS { get; set; }
    public Decimal bedroomExtractRateLPS { get; set; }
    public Decimal diningExtractRateLPS { get; set; }
    public Decimal kitchenCookerHoodExtractToOutsideLPS { get; set; }
    public Decimal kitchenCookerHoodNotExtractOutsideLPS { get; set; }
    public Decimal kitchenWithDiningAreaLPS { get; set; }
    public Decimal remainingHabitableRoomLPS { get; set; }
    public Decimal utilityExtractRateLPS { get; set; }
    public Decimal wcExtractRateLPS { get; set; }

    // Declare separate variables for each minimum required area in mm²
    public Decimal bathroomRequiredAreaMM2 { get; set; }
    public Decimal bedroomRequiredAreaMM2 { get; set; }
    public Decimal diningRequiredAreaMM2 { get; set; }
    public Decimal kitchenCookerHoodExtractToOutsideAreaMM2 { get; set; }
    public Decimal kitchenCookerHoodNotExtractOutsideAreaMM2 { get; set; }
    public Decimal kitchenWithDiningAreaAreaMM2 { get; set; }
    public Decimal remainingHabitableRoomAreaMM2 { get; set; }
    public Decimal utilityRequiredAreaMM2 { get; set; }
    public Decimal wcRequiredAreaMM2 { get; set; }

    // Room count variables
    public Integer Kitchencookerhoodyes { get; set; }
    public Integer KitchencookerhoodNo { get; set; }
    public Integer Airbrick { get; set; }
    public Integer Atticloft { get; set; }
    public Integer Bathroom { get; set; }
    public Integer Closet { get; set; }
    public Integer Diningroom { get; set; }
    public Integer Garage { get; set; }
    public Integer Hall { get; set; }
    public Integer Livingroom { get; set; }
    public Integer Primarybedroom { get; set; }
    public Integer Stairway { get; set; }
    public Integer Study { get; set; }
    public Integer Toilet { get; set; }
    public Integer Utility { get; set; }
    public Integer Other { get; set; }
    public Integer kitchen { get; set; }
    
    public string SurveyId { get; set; }

    public PdfGenerationForDesingWork() {
        // Retrieve Design Work record
        Id DesignworkId = ApexPages.currentPage().getParameters().get('id');
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
            SurveyId = Designwork.Survey__c;
        }

        // Query room counts based on SurveyId
        if (SurveyId != null) {
            Kitchencookerhoodyes = [SELECT COUNT() FROM Room__c WHERE does_the_cooker_hood_extract_externally__c = 'Yes' AND Survey__c = :SurveyId];
            KitchencookerhoodNo = [SELECT COUNT() FROM Room__c WHERE does_the_cooker_hood_extract_externally__c = 'No' AND Survey__c = :SurveyId];
            Airbrick = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Air brick' AND Survey__c = :SurveyId];
            Atticloft = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Attic/loft' AND Survey__c = :SurveyId];
            Bathroom = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Bathroom' AND Survey__c = :SurveyId];
            Closet = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Closet' AND Survey__c = :SurveyId];
            Diningroom = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Dining room' AND Survey__c = :SurveyId];
            Garage = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Garage' AND Survey__c = :SurveyId];
            Hall = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Hall' AND Survey__c = :SurveyId];
            Livingroom = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Living room' AND Survey__c = :SurveyId];
            Primarybedroom = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Primary bedroom' AND Survey__c = :SurveyId];
            Stairway = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Stairway' AND Survey__c = :SurveyId];
            Study = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Study' AND Survey__c = :SurveyId];
            Toilet = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Toilet' AND Survey__c = :SurveyId];
            Utility = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Utility' AND Survey__c = :SurveyId];
            Other = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Other' AND Survey__c = :SurveyId];
            kitchen = [SELECT COUNT() FROM Room__c WHERE Type__c = 'Kitchen' AND Survey__c = :SurveyId];
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

        // Query the required extract and minimum required area custom metadata records
        List<Required_Extract_Rate__mdt> requiredExtractMetadataRecords = [
            SELECT DeveloperName, Required_Extract_Rate_liter_per_second__c, Minimum_Required_areas_mm2__c 
            FROM Required_Extract_Rate__mdt 
            WHERE DeveloperName IN ('bathroom', 'Bedroom', 'Dining', 'Kitchen_cooker_hood_extract_to_outside', 
                                    'Kitchen_cooker_hood_not_extract_outside', 'Kitchen_with_dining_area', 
                                    'Remaining_habitable_room', 'Utility', 'WC')
        ];
        
        // Loop through the records and assign the values to separate variables
        if (!requiredExtractMetadataRecords.isEmpty()) {
            for (Required_Extract_Rate__mdt metadataRecord : requiredExtractMetadataRecords) {
                if (metadataRecord.DeveloperName == 'bathroom') {
                    bathroomExtractRateLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    bathroomRequiredAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Bedroom') {
                    bedroomExtractRateLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    bedroomRequiredAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Dining') {
                    diningExtractRateLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    diningRequiredAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Kitchen_cooker_hood_extract_to_outside') {
                    kitchenCookerHoodExtractToOutsideLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    kitchenCookerHoodExtractToOutsideAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Kitchen_cooker_hood_not_extract_outside') {
                    kitchenCookerHoodNotExtractOutsideLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    kitchenCookerHoodNotExtractOutsideAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Kitchen_with_dining_area') {
                    kitchenWithDiningAreaLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    kitchenWithDiningAreaAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Remaining_habitable_room') {
                    remainingHabitableRoomLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    remainingHabitableRoomAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'Utility') {
                    utilityExtractRateLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    utilityRequiredAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                } else if (metadataRecord.DeveloperName == 'WC') {
                    wcExtractRateLPS = metadataRecord.Required_Extract_Rate_liter_per_second__c;
                    wcRequiredAreaMM2 = metadataRecord.Minimum_Required_areas_mm2__c;
                }
            }
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

        // Ventilation check
        if (Designwork != null) {
            Ventilation = Designwork.Ventilation_adequate__c ? 'Ventilation Adequate' : 'Ventilation Inadequate';
        }
    }

    public PageReference generatePDFAndSave() {
        if (Designwork.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Designwork ID provided.'));
            return null;
        }

        List<ContentVersion> contentVersions = new List<ContentVersion>();

        // Generate Ventilation Assessment PDF
        try {
            PageReference pdfPage1 = Page.Design_Work_Generate_PDF;
            pdfPage1.getParameters().put('id', Designwork.Id);
            Blob pdfBlob1 = pdfPage1.getContentAsPDF();
            ContentVersion cv1 = new ContentVersion();
            cv1.Title = Designwork.Name + '_Ventilation_Assessment.pdf';
            cv1.PathOnClient = Designwork.Name + '_Ventilation_Assessment.pdf';
            cv1.VersionData = pdfBlob1;
            cv1.FirstPublishLocationId = Designwork.Id;
            cv1.IsMajorVersion = true;
            contentVersions.add(cv1);
        } catch (VisualforceException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating Ventilation Assessment PDF: ' + e.getMessage()));
        }

        // Generate PDFs using other controllers
        try {
            // Call PdfGenerationProjectIntendedOutcome controller's method
            PdfGenerationProjectIntendedOutcome projectOutcomeCtrl = new PdfGenerationProjectIntendedOutcome();
            projectOutcomeCtrl.generatePDFAndSave();

            // Call PdfGenerationImprovementOption controller's method
            PdfGenerationImprovementOption improvementOptionCtrl = new PdfGenerationImprovementOption();
            improvementOptionCtrl.generatePDFAndSave();

            // Call PdfGenerationRetrofit controller's method
            PdfGenerationRetrofit retrofitCtrl = new PdfGenerationRetrofit();
            retrofitCtrl.generatePDFAndSave();

            // Call PdfGenerationForDesignWorkMediumTermPlan controller's method
         PdfGenerationForDesignWorkMediumTermPlan mediumTermPlanCtrl = new PdfGenerationForDesignWorkMediumTermPlan();
            mediumTermPlanCtrl.generatePDFAndSave();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDFs from other controllers: ' + e.getMessage()));
        }

        // Insert the ContentVersion records for Ventilation Assessment
        if (!contentVersions.isEmpty()) {
            insert contentVersions;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Ventilation Assessment PDF generated and saved successfully.'));
        }

        return null;
    }
}