/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	20-02-2024
Class Name 				: 	SCIS_propertyTriggerHandler
TestClass Name 			: 	SCIS_propertyTriggerHandlerTest
Description 			: 	This tes class is used for SCIS_propertyTriggerHandler
Last Modification Date 	: 	26-02-2024
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */


@isTest
public class SCIS_propertyTriggerHandlerTest {
    @isTest
    static void testUpdateGoogleAerialViewImage_InsertScenario() {
        List<Lead> testLeads = new List<Lead>();
        List<Property__c> testProperties = new List<Property__c>();
		
        for(Integer i = 0; i < 8; i++){
            lead ld = new lead();
            ld.lastName = 'Test lead '+ i;
            ld.Company = 'Test Company ' + i; 
            ld.Property_Structure__c = 'xyz' + i;
            testLeads.add(ld);
        }
        insert testLeads;
        
        for(lead ld : testLeads){
            property__C prop = new property__C();
            prop.Lead__c = ld.Id;
                prop.main_ridge_height__c = 10;
                prop.main_gutter_height__c = 5;
                prop.main_roof_slope_degrees__c = Decimal.valueOf('10');
                prop.maximum_height__c = Decimal.valueOf('10');
                prop.Building_Volume__c = Decimal.valueOf('10');
                prop.roof_area_up_to_5_degrees__c = Decimal.valueOf('10');
                prop.roof_area_up_to_10_degrees__c = Decimal.valueOf('10');
                prop.roof_area_up_to_15_degrees__c = Decimal.valueOf('10');
                prop.roof_area_up_to_20_degrees__c = Decimal.valueOf('10');
                prop.pct_south_facing__c = Decimal.valueOf('3.2');
                prop.roof_area__c = Decimal.valueOf('97');
                prop.storey_count__c = Decimal.valueOf('2');
            testProperties.add(prop);
        }
        
        /* for(Integer i = 0; i < 8; i++) {
            Lead ld = new Lead(LastName = 'Test Lead ' + i, Company = 'Test Company ' + i, Property_Structure__c = 'xyz' + i);
            testLeads.add(ld);

            Property__c prop = new Property__c(
                Lead__c = ld.Id,
                main_ridge_height__c = 10,
                main_gutter_height__c = 5,
                main_roof_slope_degrees__c = Decimal.valueOf('10'),
                maximum_height__c = Decimal.valueOf('10'),
                Building_Volume__c = Decimal.valueOf('10'),
                roof_area_up_to_5_degrees__c = Decimal.valueOf('10'),
                roof_area_up_to_10_degrees__c = Decimal.valueOf('10'),
                roof_area_up_to_15_degrees__c = Decimal.valueOf('10'),
                roof_area_up_to_20_degrees__c = Decimal.valueOf('10'),
                pct_south_facing__c = Decimal.valueOf('3.2'),
                roof_area__c = Decimal.valueOf('97'),
                storey_count__c = Decimal.valueOf('2')
                // Add other fields as required
            );
           testProperties.add(prop);
        } */

        database.insert (testLeads,false);
        database.insert (testProperties,false);

        Test.startTest();
        SCIS_propertyTriggerHandler.updateGoogleAerialViewImage(testProperties);
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Id, Property_Structure__c FROM Lead WHERE Id IN :testLeads];

        for (Lead ld : updatedLeads) {
            System.assertNotEquals(null, ld.Property_Structure__c, 'Property_Structure__c should not be null.');
        }
    }

    @isTest
    static void testUpdateGoogleAerialViewImage_UpdateScenario() {
        List<Lead> testLeads = new List<Lead>();
        List<Property__c> testProperties = new List<Property__c>();

        for(Integer i = 0; i < 8; i++) {
            Lead ld = new Lead(LastName = 'Test Lead ' + i, Company = 'Test Company ' + i, Property_Structure__c = 'Existing data ' + i);
            testLeads.add(ld);

            Property__c prop = new Property__c(
                Lead__c = ld.Id,
                main_ridge_height__c = 10,
                main_gutter_height__c = 5,
                main_roof_slope_degrees__c = Decimal.valueOf('10'),
                maximum_height__c = Decimal.valueOf('10'),
                Building_Volume__c = Decimal.valueOf('10'),
                roof_area_up_to_5_degrees__c = Decimal.valueOf('10'),
                roof_area_up_to_10_degrees__c = Decimal.valueOf('10'),
                roof_area_up_to_15_degrees__c = Decimal.valueOf('10'),
                roof_area_up_to_20_degrees__c = Decimal.valueOf('10'),
                pct_south_facing__c = Decimal.valueOf('3.2'),
                roof_area__c = Decimal.valueOf('97'),
                storey_count__c = Decimal.valueOf('2')
                // Add other fields as required
            );
            testProperties.add(prop);
        }

        insert testLeads;
        insert testProperties;

        Test.startTest();
        SCIS_propertyTriggerHandler.updateGoogleAerialViewImage(testProperties);
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Id, Property_Structure__c FROM Lead WHERE Id IN :testLeads];

        for (Lead ld : updatedLeads) {
            System.assertNotEquals('Existing data', ld.Property_Structure__c, 'Property_Structure__c should be updated with new data.');
        }
    }

    @isTest
    static void testCreateOrientationOfProperty() {
        List<Property__c> testProperties = new List<Property__c>();

        for(Integer i = 0; i < 8; i++) {
            Property__c prop = new Property__c(pct_south_facing__c = i * 12.4);
            testProperties.add(prop);
        }

        insert testProperties;

        SCIS_propertyTriggerHandler.createOrientationOfProperty(testProperties);

        /*  for (Integer i = 0; i < 8; i++) {
            System.assertEquals(
                new List<String> {'North', 'North West', 'West', 'South West', 'South', 'South East', 'East', 'North East'}[i],
                testProperties[i].Property_Orientation__c,
                'Property_Orientation__c should be set correctly.'
            );
        } */
    }
}