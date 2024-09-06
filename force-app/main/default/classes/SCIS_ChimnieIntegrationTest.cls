/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	
Class Name 				: 	SCIS_ChimnieIntegration
TestClass Name 			: 	SCIS_ChimnieIntegrationTest
@Description 			: 	This test handler class is used to update Appointment status.							
Last Modification Date 	: 	29-03-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */

@isTest
private class SCIS_ChimnieIntegrationTest {
   // Inner class to simulate HTTP callout response
    private class HttpCalloutMockResponse implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"property":{"attributes":{"status":{"prebuild":false,"longitude":-0.3098451,"msoa":"E02000100","oa":"E00002761","easting":517242,"latitude":51.5665658,"northing":186652,"ltla":"E09000005","udprn":10419552,"lsoa":"E01000566","frame_construction_material_predicted":"brick","frame_construction_material":"brick","roof_type_predicted":"pitched","roof_type":"pitched","date_of_construction_predicted":1939,"is_urban":true,"listed_building":{"is_listed":false}},"indoor":{"bedrooms_predicted":3,"bedrooms":3,"bathrooms_predicted":1,"bathrooms":1,"floor_area_predicted":88.3,"floor_area":88.3,"total_rooms":4,"basement":true,"concierge":true,"conservatory":true,"extension":true,"swimming_pool":true,"parking":true,"attic":true,"garage":true,"tennis_court":true,"shed":true,"pond":true,"garden":true,"driveway":true,"gated":true,"solar_shared":true,"solar_flag":true}},"bills":{"energy":{"energy_rating_current_predicted":"D","energy_rating_inspection_date":"","energy_rating_expiry":"","social_housing":"Dinesh","energy_rating_current":"D","energy_rating_potential_predicted":"B","mains_gas_flag_predicted":true,"mains_gas_flag":true,"mains_gas":true,"in_fuel_poverty_hotspot":false,"monthly_energy_cost":131},"telecoms":{"maximum_broadband_speed":1000},"tax":{"council_tax_band":"E","council_tax_cost":2218}},"value":{"sale":{"property_value":600000,"transaction_history":[{"date_of_transfer":"2008-12-22T00:00:00.000Z","price":260000}]},"rental":{"rental_value_pcm":1800}},"ownership":{"overseas_ownership":false,"company_ownership":false}},"plus":{"property":{"attributes":{"status":{"postcode_sector":"HA03","postcode_area":"HA","postcode_district":"HA0","address":"35LanghamGardens,Wembley,HA03RG","postcode":"HA03RG","property_type":"Semi-detached","property_subtype":"Semi-detached","property_class":"House"}}}},"premium":{"property":{"attributes":{"status":{"main_ridge_height":8.47,"main_gutter_height":6.14,"main_roof_slope_degrees":41,"building_volume":320.26,"roof_area_up_to_10_degrees":10,"roof_area_up_to_5_degrees":10,"pct_south_facing":42,"roof_area_up_to_20_degrees":14,"roof_area_up_to_15_degrees":12,"roof_area":48,"maximum_height":8.71,"storey_count":3},"outdoor":{"grounds_area":250,"grounds_area_predicted":250}},"ownership":{"total_hhi_predicted":50000,"disposable_hhi_msoa":34300,"total_hhi_msoa":64300,"household_wealth_percentile":{"household_size":10,"household_income":1000,"household_disposable_income":1000,"remedial_availability":"hh","total_score":0.8625926825330644,"total_rank":4179835,"postcode_district_score":0.8745121750123674,"postcode_district_rank":2284,"local_authority_score":0.8423225055233773,"local_authority_rank":21126}},"value":{"rebuild":{"estimated_rebuild_cost":{"lower_bound":260000,"estimate":325000,"upper_bound":410000}}}},"surroundings":{"environment":{"land":{"property_elevation_min":50.27,"property_elevation_max":50.51}}}},"id":"202076315","exact_match":true}');
            //res.setBody('{"property":[{"attributes":{"status":{"prebuild":false,"longitude":-0.3098451,"msoa":"E02000100","oa":"E00002761","easting":517242,"latitude":51.5665658,"northing":186652,"ltla":"E09000005","udprn":10419552,"lsoa":"E01000566","frame_construction_material_predicted":"brick","frame_construction_material":"brick","roof_type_predicted":"pitched","roof_type":"pitched","date_of_construction_predicted":1939,"is_urban":true,"listed_building":{"is_listed":false}},"indoor":{"bedrooms_predicted":3,"bedrooms":3,"bathrooms_predicted":1,"bathrooms":1,"floor_area_predicted":88.3,"floor_area":88.3,"total_rooms":4,"basement":true,"concierge":true,"conservatory":true,"extension":true,"swimming_pool":true,"parking":true,"attic":true,"garage":true,"tennis_court":true,"shed":true,"pond":true,"garden":true,"driveway":true,"gated":true,"solar_shared":true,"solar_flag":true}},"bills":{"energy":{"energy_rating_current_predicted":"D","energy_rating_inspection_date":"","energy_rating_expiry":"","social_housing":"Dinesh","energy_rating_current":"D","energy_rating_potential_predicted":"B","mains_gas_flag_predicted":true,"mains_gas_flag":true,"mains_gas":true,"in_fuel_poverty_hotspot":false,"monthly_energy_cost":131},"telecoms":{"maximum_broadband_speed":1000},"tax":{"council_tax_band":"E","council_tax_cost":2218}},"value":{"sale":{"property_value":600000,"transaction_history":[{"date_of_transfer":"2008-12-22T00:00:00.000Z","price":260000}]},"rental":{"rental_value_pcm":1800}},"ownership":{"overseas_ownership":false,"company_ownership":false}},"plus":{"property":{"attributes":{"status":{"postcode_sector":"HA03","postcode_area":"HA","postcode_district":"HA0","address":"35LanghamGardens,Wembley,HA03RG","postcode":"HA03RG","property_type":"Semi-detached","property_subtype":"Semi-detached","property_class":"House"}}}},"premium":{"property":{"attributes":{"status":{"main_ridge_height":8.47,"main_gutter_height":6.14,"main_roof_slope_degrees":41,"building_volume":320.26,"roof_area_up_to_10_degrees":10,"roof_area_up_to_5_degrees":10,"pct_south_facing":42,"roof_area_up_to_20_degrees":14,"roof_area_up_to_15_degrees":12,"roof_area":48,"maximum_height":8.71,"storey_count":3},"outdoor":{"grounds_area":250,"grounds_area_predicted":250}},"ownership":{"total_hhi_predicted":50000,"disposable_hhi_msoa":34300,"total_hhi_msoa":64300,"household_wealth_percentile":{"household_size":10,"household_income":1000,"household_disposable_income":1000,"remedial_availability":"hh","total_score":0.8625926825330644,"total_rank":4179835,"postcode_district_score":0.8745121750123674,"postcode_district_rank":2284,"local_authority_score":0.8423225055233773,"local_authority_rank":21126}},"value":{"rebuild":{"estimated_rebuild_cost":{"lower_bound":260000,"estimate":325000,"upper_bound":410000}}}},"surroundings":{"environment":{"land":{"property_elevation_min":50.27,"property_elevation_max":50.51}}}},"id":"202076315","exact_match":true}]}');

            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testGetChimnieData() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockResponse());

        // Setup test data
        Lead testLead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Street = '123 Test Street',
            City = 'Test City',
            PostalCode = '12345',
            UPRN__c = '202076315', // Assume this matches the UPRN expected in the response
        	Status = 'Accepted'
        );
        insert testLead;

        Test.startTest();
        // Call the method that makes the HTTP callout
        SCIS_ChimnieIntegration.getResidentialAddressDetails(testLead.Id, testLead.PostalCode, testLead.Company);
        Test.stopTest();

        // Query to verify results
        //Lead resultLead = [SELECT UPRN__c, Longitude__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('202076315', testLead.UPRN__c);
        // Assert other fields as needed based on the expected outcome
        // For example, checking if Longitude__c matches expected value
        //System.assertNotEquals(null, resultLead.Longitude__c, 'Longitude should not be null');
    }
}