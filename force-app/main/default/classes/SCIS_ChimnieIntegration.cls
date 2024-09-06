/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	24-11-2023
Class Name 				: 	SCIS_ChimnieIntegration
TestClass Name 			: 	SCIS_ChimnieIntegrationTest
@Description 			: 	This class is used to fetch Property Details from chimnie API and Connect this data with lead Object. We first fetch 
							this property data and then this data is used in the component which is used on the lead view form- Right side 
							of the lead view form.'
							* @param address The residential address to query in the Chimnie API.
 							* @param fields The specific fields to request from the Chimnie API for the given address.
 							* @param leadId The Salesforce ID of the lead associated with this address, used for linking the property data.
Last Modification Date 	: 	24-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1 Modification on 17-12-23 Sunday for accomodating two HTTP request in the same code and
								updating code for inserting EPC data into Property Object instead of directly into the Lead.
							#2 Modification on 01-02-2024 for accomoding Updated fields in chimnie response into the property object.
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */



public class SCIS_ChimnieIntegration {

    // Method to get residential address details
   //@InvocableMethod(label='Chimeni data Pull' description='Store Chimnie Data on Lead')
   /**
 * Asynchronously fetches residential address details from the Chimnie API and stores the data in a custom Salesforce object.
 * This method is designed to be called as a future method to perform callouts to an external service and process the response asynchronously.
 *
 * @param address The residential address to query in the Chimnie API.
 * @param fields The specific fields to request from the Chimnie API for the given address.
 * @param leadId The Salesforce ID of the lead associated with this address, used for linking the property data.
 */
   @Future(callout=true)
    public static void  /* ChimnieResponse */ getResidentialAddressDetails( String address, String fields, string leadId) {
		string apiKey=system.label.chimnie_Api_Key;
        system.debug('Entered Into the Chimnie Class');
            
        try{
            
        //String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');
        //String apiUrl = 'https://api.chimnie.com/residential/address/10%20Downing%20St,%20London%20SW1A%202AA,%20United%20Kingdom?fields=plus%2C+premium&api_key=b36c4ee8-a86e-465d-bec0-be7eef84e48f';
		//String apiUrl = 'https://api.chimnie.com/residential/address/'+address+'?fields='+fields +'&api_key='+apiKey;
        String encodedAddress = address.replaceAll(' ', '%20');
        String apiUrl='https://api.chimnie.com/residential/address/'+encodedAddress+'?fields='+fields+'&api_key='+apiKey;
		//String apiUrl= 'https://api.chimnie.com/residential/address/37 Langham gardens,North wembley, HA0 3RG?fields=plus,prefix,property'+'&api_key='+apiKey;
        string addressVariable;
        string rawresponseString;
        string responseString;
        system.debug(apiUrl);
        system.debug('this is api url'+apiUrl);
       
        
        	String idUprn ;
            String postcodeSector ;
            String postcodeArea ;
            String uprn ;
            String lsoa ;
            String msoa ;
            String oa ;
            String postcode_district ;
            String ltla ;
            //String address1 ;
            String postcode ;
            String property_type ;
            String frame_construction_material ;
            String roof_type ;
            boolean is_urban ;
            boolean is_listed ;
            integer bedrooms ;
            integer bathrooms ;
            integer floor_area ;
            
            integer total_rooms ;
            boolean basement ;
            boolean concierge ;
            boolean conservatory ;
            boolean extension ;
            boolean swimming_pool ;
            boolean parking ;
            boolean attic ;
            boolean garage ;
            boolean tennis_court ;        
            
            boolean shed ;
            boolean pond ;
            boolean garden ;
            boolean driveway ;
            boolean gated ;
            integer grounds_area ;
            boolean solar_shared ;
            boolean solar_flag ;
            integer property_value ;
            integer rental_value_pcm ;            
            
            String council_tax_band ;
            integer council_tax_cost ;
            String energy_rating ;
            boolean mains_gas ;
            integer monthly_energy_cost ;
            String household_size ;
            integer household_income ;
            integer household_disposable_income ;
            String energy_rating_current ;
            String energy_rating_current_predicted;
            String remedial_availability ; 
            
            
            string energy_rating_inspection_date ;
            string energy_rating_expiry ;
            String social_housing ;
            
            boolean mains_gas_flag ;
            
            string energy_rating_potential_predicted; //Done
            boolean mains_gas_flag_predicted; // Done
            string frame_construction_material_predicted; //Done
            string roof_type_predicted; //Done
            string Construction_date_predicted; // Done
            integer bedrooms_predicted; // Done
            string bathrooms_predicted; // Done
            integer floor_area_predicted; // Done
            integer grounds_area_predicted; // Done
            integer total_hhi_predicted; // Done
            
            // #2 Start Variables for updated response
            integer main_ridge_height;				
            integer main_gutter_height;			
            integer main_roof_slope_degrees;		
            integer building_volume;		
            integer roof_area_up_to_10_degrees;		
            integer roof_area_up_to_5_degrees;	
            integer pct_south_facing;	
            integer roof_area_up_to_20_degrees;		
            integer roof_area_up_to_15_degrees;		
            integer roof_area;				
            integer maximum_height;								
            integer storey_count;	
        	// #2 End Variables for updated response
        
        system.debug('Working till declaration');
        
        
        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        
        // Set API key in headers for authentication
        request.setHeader('Authorization', 'Api-Key ' + apiKey);
        //request.setHeader(application/json);
        //--header 'Accept: application/json' \
  		//--header 'Authorization: Bearer b36c4ee8-a86e-465d-bec0-be7eef84e48f'
        
        
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            rawresponseString = response.getBody();
            system.debug('responseString='+rawresponseString);
            responseString = rawresponseString.replaceAll('\n','').replaceAll('\r','');
            //responseString = rawresponseString.replaceAll('\n','');
            system.debug('This is responseString = '+responseString);
            
            JSONParser parser = JSON.createParser(responseString);

           // return (ChimnieResponse) JSON.deserialize(responseString, ChimnieResponse.class);
           // ChimnieResponse res = (ChimnieResponse) JSON.deserialize(responseString, ChimnieResponse.class);
            
            //system.debug('This is addressVariable = '+addressVariable);
            

            system.debug('Working till http request and response');
            
            
            
            
            while (parser.nextToken() != null) {
                //system.debug('Entered in While Loop');
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'address') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    //addressVariable = system.json.stringify(parser.getText());
                    addressVariable = JSON.serialize(parser.getText());
                    system.debug('addressVariable'+addressVariable);

                }
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'id') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    idUprn = parser.getText();
                    system.debug('idUprn'+idUprn);


                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'postcode_Sector') {
                    parser.nextToken(); 
                    postcodeSector = parser.getText();
                    system.debug('postcodeSector'+postcodeSector);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'lsoa') {
                    parser.nextToken(); 
                    lsoa = parser.getText();
                    system.debug('lsoa'+lsoa);
                    

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'msoa') {
                    parser.nextToken(); 
                    msoa = parser.getText();
					system.debug('msoa'+msoa);                 

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'oa') {
                    parser.nextToken(); 
                    oa = parser.getText();
                    system.debug('oa'+oa);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'postcode_district') {
                    parser.nextToken(); 
                    postcode_district = parser.getText();
                    system.debug('postcode_district'+postcode_district);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'ltla') {
                    parser.nextToken(); 
                    ltla = parser.getText();
                    system.debug('ltla'+ltla);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'postcode') {
                    parser.nextToken(); 
                    postcode = parser.getText();
                    system.debug('postcode'+postcode);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'property_type') {
                    parser.nextToken(); 
                    property_type = parser.getText();
                    system.debug('property_type'+property_type);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'frame_construction_material') {
                    parser.nextToken(); 
                    frame_construction_material = parser.getText();
                    system.debug('frame_construction_material'+frame_construction_material);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'frame_construction_material_predicted') {
                    parser.nextToken(); 
                    frame_construction_material_predicted = parser.getText();
                    system.debug('frame_construction_material_predicted'+frame_construction_material_predicted);

                }
                
                
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_type') {
                    parser.nextToken(); 
                    roof_type = parser.getText();
                    system.debug('roof_type'+roof_type);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_type_predicted') {
                    parser.nextToken(); 
                    roof_type_predicted = parser.getText();
                    system.debug('roof_type_predicted'+roof_type_predicted);

                }
                
                
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'is_urban') {
                    parser.nextToken(); 
                    is_urban = parser.getBooleanValue();
                    system.debug('is_urban'+is_urban);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'is_listed') {
                    parser.nextToken(); 
                    is_listed = parser.getBooleanValue();
                    system.debug('is_listed'+is_listed);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'bedrooms') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			bedrooms = parser.getIntegerValue();
            			System.debug('bedrooms ' + bedrooms);
        				}
                    
                  //  bedrooms = parser.getIntegerValue();
                    system.debug('bedrooms'+bedrooms);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_hhi_predicted') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			total_hhi_predicted = parser.getIntegerValue();
            			System.debug('total_hhi_predicted ' + total_hhi_predicted);
        				}
                    
                  //  bedrooms = parser.getIntegerValue();
                    system.debug('total_hhi_predicted'+total_hhi_predicted);

                }
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'bedrooms_predicted') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			bedrooms_predicted = parser.getIntegerValue();
            			System.debug('bedrooms_predicted ' + bedrooms_predicted);
        				}
                    
                  //  bedrooms = parser.getIntegerValue();
                    system.debug('bedrooms_predicted'+bedrooms_predicted);

                }
 
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'bathrooms') {
                    parser.nextToken(); 
                    bathrooms = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			bathrooms = parser.getIntegerValue();
            			System.debug('bathrooms ' + bathrooms);
        				}
                    
                    system.debug('bathrooms'+bathrooms);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'floor_area') {
                    parser.nextToken(); 
                    floor_area = parser.getIntegerValue();
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			floor_area = parser.getIntegerValue();
            			System.debug('floor_area ' + floor_area);
        				}
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'floor_area_predicted') {
                    parser.nextToken(); 
                    floor_area_predicted = parser.getIntegerValue();
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			floor_area_predicted = parser.getIntegerValue();
            			System.debug('floor_area_predicted ' + floor_area_predicted);
        				}
                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'total_rooms') {
                    parser.nextToken(); 
                    total_rooms = parser.getIntegerValue();
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			total_rooms = parser.getIntegerValue();
            			System.debug('total_rooms ' + total_rooms);
        				}
                    
                    system.debug('total_rooms'+total_rooms);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'basement') {
                    parser.nextToken(); 
                    basement = parser.getBooleanValue(); 
                    system.debug('basement'+basement);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'concierge') {
                    parser.nextToken(); 
                    concierge = parser.getBooleanValue();
                    

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'conservatory') {
                    parser.nextToken(); 
                    conservatory = parser.getBooleanValue();
                    system.debug('conservatory'+conservatory);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'extension') {
                    parser.nextToken(); 
                    extension = parser.getBooleanValue();
                    system.debug('extension'+extension);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'swimming_pool') {
                    parser.nextToken(); 
                    swimming_pool = parser.getBooleanValue();
                    system.debug('swimming_pool'+swimming_pool);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'parking') {
                    parser.nextToken(); 
                    parking = parser.getBooleanValue();
                    system.debug('parking'+parking);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'attic') {
                    parser.nextToken(); 
                    attic = parser.getBooleanValue();
                    system.debug('attic'+attic);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'garage') {
                    parser.nextToken(); 
                    garage = parser.getBooleanValue();
                    system.debug('garage'+garage);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'tennis_court') {
                    parser.nextToken(); 
                    tennis_court = parser.getBooleanValue();
                    system.debug('tennis_court'+tennis_court);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'shed') {
                    parser.nextToken(); 
                    shed = parser.getBooleanValue();
                    system.debug('shed'+shed);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'pond') {
                    parser.nextToken(); 
                    pond = parser.getBooleanValue();
                    system.debug('pond'+pond);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'garden') {
                    parser.nextToken(); 
                    garden = parser.getBooleanValue();
                    system.debug('garden'+garden);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'driveway') {
                    parser.nextToken(); 
                    driveway = parser.getBooleanValue();
                    system.debug('driveway'+driveway);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'gated') {
                    parser.nextToken(); 
                    gated = parser.getBooleanValue();
                    system.debug('gated'+gated);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'grounds_area') {
                    parser.nextToken(); 
                    //grounds_area = parser.getIntegerValue();
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			grounds_area = parser.getIntegerValue();
            			System.debug('grounds_area ' + grounds_area);
        				}
                    
                    system.debug('grounds_area'+grounds_area);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'grounds_area_predicted') {
                    parser.nextToken(); 
                    //grounds_area_predicted = parser.getIntegerValue();
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			grounds_area = parser.getIntegerValue();
            			System.debug('grounds_area_predicted ' + grounds_area_predicted);
        				}
                    
                    system.debug('grounds_area_predicted'+grounds_area_predicted);

                }
                
                
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'solar_shared') {
                    parser.nextToken(); 
                    solar_shared = parser.getBooleanValue();
                    system.debug('solar_shared'+solar_shared);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'solar_flag') {
                    parser.nextToken(); 
                    solar_flag = parser.getBooleanValue();
                    system.debug('solar_flag'+solar_flag);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'property_value') {
                    parser.nextToken(); 
                   // property_value = parser.getIntegerValue();
                    property_value =  integer.valueOf(parser.getIntegerValue()) ;
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			//property_value =  integer.valueOf(parser.getIntegerValue()) ;
            			System.debug('property_value ' + property_value);
        				}
                    
                    system.debug('property_value'+property_value);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'rental_value_pcm') {
                    parser.nextToken(); 
                   // rental_value_pcm = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			rental_value_pcm = parser.getIntegerValue();
            			System.debug('rental_value_pcm ' + rental_value_pcm);
        				}
                    
                    system.debug('rental_value_pcm'+rental_value_pcm);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'council_tax_band') {
                    parser.nextToken(); 
                    council_tax_band = parser.getText();
                    system.debug('council_tax_band'+council_tax_band);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'council_tax_cost') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			council_tax_cost = parser.getIntegerValue();
            			System.debug('council_tax_cost ' + council_tax_cost);
        				}
                    
                    system.debug('council_tax_cost'+council_tax_cost);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'energy_rating_current') {
                    parser.nextToken(); 
                    energy_rating_current = parser.getText();
                    system.debug('energy_rating_current'+energy_rating_current);

                }
               if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'energy_rating_current_predicted') {
                    parser.nextToken(); 
                    energy_rating_current_predicted = parser.getText();
                    system.debug('energy_rating_current_predicted'+energy_rating_current_predicted);

                }
				
 
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'mains_gas') {
                    parser.nextToken(); 
                    mains_gas = parser.getBooleanValue();
                    system.debug('mains_gas'+mains_gas);

                }
                
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'monthly_energy_cost') {
                    parser.nextToken(); 
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
                        //monthly_energy_cost = parser.getIntegerValue();
                        
                        if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			monthly_energy_cost = parser.getIntegerValue();
            			System.debug('monthly_energy_cost ' + monthly_energy_cost);
        				}
                        
                        
                    }
                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'household_size') {
                    parser.nextToken(); 
                    household_size = parser.getText();
                    system.debug('household_size'+household_size);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'household_income') {
                    parser.nextToken(); 
                    //household_income = parser.getIntegerValue();
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			household_income = parser.getIntegerValue();
            			System.debug('household_income ' + household_income);
        				}
                    
                    
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'household_disposable_income') {
                    parser.nextToken(); 
                    //household_disposable_income = parser.getIntegerValue();
                    household_disposable_income = parser.getIntegerValue();

                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			//household_disposable_income = parser.getIntegerValue();
            			System.debug('household_disposable_income ' + household_disposable_income);
        				}
                    
                    system.debug('household_disposable_income'+household_disposable_income);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'remedial_availability') {
                    parser.nextToken(); 
                    remedial_availability = parser.getText();
                    system.debug('remedial_availability'+remedial_availability);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'energy_rating_inspection_date') {
                    parser.nextToken(); 
                    energy_rating_inspection_date = parser.getText();
                    system.debug('energy_rating_inspection_date'+energy_rating_inspection_date);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'energy_rating_expiry') {
                    parser.nextToken(); 
                    energy_rating_expiry = parser.getText();
                    system.debug('energy_rating_expiry'+energy_rating_expiry);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'social_housing') {
                    parser.nextToken(); 
                    social_housing = parser.getText();
                    system.debug('social_housing'+social_housing);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'mains_gas_flag') {
                    parser.nextToken(); 
                    mains_gas_flag = parser.getBooleanValue();
                    system.debug('mains_gas_flag'+mains_gas_flag);
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'mains_gas_flag_predicted') {
                    parser.nextToken(); 
                    mains_gas_flag_predicted = parser.getBooleanValue();
                    system.debug('mains_gas_flag_predicted'+mains_gas_flag_predicted);
                }
                
                // #2 Start parsing new field values
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'main_ridge_height') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			main_ridge_height = parser.getIntegerValue();
            			System.debug('main_ridge_height ' + main_ridge_height);
        				}
                    
                    system.debug('main_ridge_height'+main_ridge_height);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'main_gutter_height') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			main_gutter_height = parser.getIntegerValue();
            			System.debug('main_gutter_height ' + main_gutter_height);
        				}
                    
                    system.debug('main_gutter_height'+main_gutter_height);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'main_roof_slope_degrees') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			main_gutter_height = parser.getIntegerValue();
            			System.debug('main_roof_slope_degrees ' + main_roof_slope_degrees);
        				}
                    
                    system.debug('main_roof_slope_degrees'+main_roof_slope_degrees);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'building_volume') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			building_volume = parser.getIntegerValue();
            			System.debug('building_volume ' + building_volume);
        				}
                    
                    system.debug('building_volume'+building_volume);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_area_up_to_10_degrees') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			roof_area_up_to_10_degrees = parser.getIntegerValue();
            			System.debug('roof_area_up_to_10_degrees ' + roof_area_up_to_10_degrees);
        				}
                    
                    system.debug('roof_area_up_to_10_degrees'+roof_area_up_to_10_degrees);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_area_up_to_5_degrees') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			roof_area_up_to_5_degrees = parser.getIntegerValue();
            			System.debug('roof_area_up_to_5_degrees ' + roof_area_up_to_5_degrees);
        				}
                    
                    system.debug('roof_area_up_to_5_degrees'+roof_area_up_to_5_degrees);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_area_up_to_20_degrees') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			roof_area_up_to_20_degrees = parser.getIntegerValue();
            			System.debug('roof_area_up_to_20_degrees ' + roof_area_up_to_20_degrees);
        				}
                    
                    system.debug('roof_area_up_to_20_degrees'+roof_area_up_to_20_degrees);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_area_up_to_15_degrees') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			roof_area_up_to_15_degrees = parser.getIntegerValue();
            			System.debug('roof_area_up_to_15_degrees ' + roof_area_up_to_15_degrees);
        				}
                    
                    system.debug('roof_area_up_to_15_degrees'+roof_area_up_to_15_degrees);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'roof_area') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			roof_area = parser.getIntegerValue();
            			System.debug('roof_area ' + roof_area);
        				}
                    
                    system.debug('roof_area'+roof_area);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'maximum_height') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			roof_area = parser.getIntegerValue();
            			System.debug('maximum_height ' + maximum_height);
        				}
                    
                    system.debug('maximum_height'+maximum_height);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'storey_count') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			storey_count = parser.getIntegerValue();
            			System.debug('storey_count ' + storey_count);
        				}
                    
                    system.debug('storey_count'+storey_count);

                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'pct_south_facing') {
                    parser.nextToken(); 
                    //council_tax_cost = parser.getIntegerValue();
                    
                    if (parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT) {
            			pct_south_facing = parser.getIntegerValue();
            			System.debug('pct_south_facing ' + pct_south_facing);
        				}
                    
                    system.debug('pct_south_facing'+pct_south_facing);

                }
                
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'energy_rating_potential_predicted') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    //addressVariable = system.json.stringify(parser.getText());
                    energy_rating_potential_predicted = JSON.serialize(parser.getText());
                    system.debug('energy_rating_potential_predicted'+energy_rating_potential_predicted);

                }
                
                // #2 End parsing new field values
                
                
                
    
            }
            
            system.debug('while loop ended');
            
            
            /*
           
                //string addressVariable='37 Langham gardens,North wembley,HA0 3RG';
				// Split the address using comma as the delimiter
                List<String> addressParts = addressVariable.split(',');
                
                String streetString = addressParts[0].trim();
                String cityString = addressParts[1].trim();
                String countryAndPostalCodeString = addressParts[2].trim();
                
                // Split the country and postal code using space as the delimiter
                List<String> countryAndPostalCodeParts = countryAndPostalCodeString.split(' ');
                
                String countryString = countryAndPostalCodeParts[0].trim();
                String postalCodeString = countryAndPostalCodeParts[1].trim(); 


            */
            
            
            	/* lead leadRecord = [select id, name,city,street,postalCode,website
                                   from Lead 
                                   where city like: '%'+cityString+'%'  and street like: '%'+streetString+'%'  and postalCode like: '%'+postalCodeString+'%'
                                   limit 1];  */
            
            /*	
            lead leadRecord = [select id, name,city,street,postalCode,website,uprn__c
                                   ,Post_Code_Area__c,msoa__c,oa__c,postcode_district__c,ltla__c
                                   ,postcode__c,property_type__c,frame_construction_material__c
                                   ,roof_type__c,is_urban__c,Number_of_Bedroom__c
                                   ,Number_Of_Bathroom__c,floor_area__c,total_rooms__c,basement__c
                                   ,concierge__c,conservatory__c,extension__c,swimming_pool__c,parking__c
                                   ,attic__c,garage__c,tennis_court__c,shed__c,pond__c,garden__c
                                   ,driveway__c,grounds_area__c,property_value__c,rental_value_pcm__c
                                   ,Council_Tax_Band__c,council_tax_cost__c,energy_rating_current__c
                                   ,mains_gas_flag__c,monthly_energy_cost__c
                                   ,inspection_date__c,expiry_date__c
                                   from Lead 
                                   where id =: leadId  limit 1];
            
            	*/
            	
            
            	
            				
			property__C property = new property__C();
			
			property.name = idUprn;
			property.Lead__C = leadId;
            
        // Code Modification started 17/12/23 Sunday #1
        string htmlEPC;
        string epcUrl= system.label.SCIS_EPC_URL;
        string epcWithUprn = epcUrl + uprn;
        String authHeader = system.label.SCIS_EPC_Auth_Header;
		
		system.debug(epcWithUprn);
        system.debug(authHeader);
		
		HttpRequest request2 = new HttpRequest();
        request2.setEndpoint(epcWithUprn);
        request2.setMethod('GET');
        request2.setHeader('Accept', 'application/json');
        request2.setHeader('Authorization', authHeader);

        Http http2 = new Http();
        HttpResponse response2 = http.send(request2);
		
		if (response2.getStatusCode() == 200) {
            String responseBody = response2.getBody();
            system.debug('This is JSON response = '+ responseBody);
			
			SCIS_EPC_Data_helper epcData = new SCIS_EPC_Data_helper();
            htmlEPC = SCIS_EPC_Data_helper.generateHTMLTable(responseBody);
			
			}else {
            System.debug('HTTP Request failed with status code: ' + response2.getStatusCode());
            System.debug('Response2 body: ' + response2.getBody());
        }
            
            
            //This is part of modified code #1
            if(htmlEPC != Null){
                property.EPC_Data__c = htmlEPC;
            }
            
			
            system.debug('property instance initiated '+ leadId);
            
			if(idUprn != Null){
                property.uprn__c = idUprn;
            }
            if(postcodeArea != Null){
                property.Post_Code_Area__c = postcodeArea;
            }
            if(lsoa != Null){
                property.LSOA_Text__c = lsoa;
            }
            if(msoa != Null){
                property.msoa__c = msoa;
            }	
            if(oa != Null){
                property.oa__c = oa;
            }	
            if(postcode_district != Null){
                property.postcode_district__c = postcode_district;
            }	
            if(ltla != Null){
                property.ltla__c = ltla;
            }	
            if(postcode != Null){
                property.postcode__c = postcode;
            }	
            if(property_type != Null){
                property.property_type__c = property_type;
            }	
            if(frame_construction_material != Null){
                property.frame_construction_material__c = frame_construction_material;
            }	
            if(roof_type != Null){
                property.roof_type__c = roof_type;
            }	
            if(is_urban != Null){
                property.is_urban__c = is_urban;
            }	
            if(is_listed != Null){
                property.is_listed__c = boolean.valueOf(is_listed);
            }	
           	if(bedrooms != Null){
                property.Number_of_Bedroom__c = string.valueOf(bedrooms) ;
            }
            if(bathrooms != Null){
                property.Number_Of_Bathroom__c = string.valueOf(bathrooms);
            }	
            if(floor_area != Null){
                property.floor_area__c = floor_area;
            }
            if(total_rooms != Null){
                property.total_rooms__c = total_rooms;
            }	
            if(basement != Null){
                property.basement__c = boolean.valueOf(basement);
            }	
            if(concierge != Null){
                property.concierge__c = boolean.valueOf(concierge);
            }
            if(conservatory != Null){
                property.conservatory__c = boolean.valueOf(conservatory);
            }
            if(extension != Null){
                property.extension__c = boolean.valueOf(extension);
            }
            if(swimming_pool != Null){
                property.swimming_pool__c= boolean.valueOf(swimming_pool);
            }
            if(parking != Null){
                property.parking__c=boolean.valueOf(parking);
            }
            if(attic != Null){
                property.attic__c=boolean.valueOf(attic);
            }
            if(garage != Null){
                property.garage__c=boolean.valueOf(garage);
            }
            if(tennis_court != Null){
                property.tennis_court__c = boolean.valueOf(tennis_court);
            }
            if(shed != Null){
                property.shed__c= boolean.valueOf(shed);
            }
            if(pond != Null){
                property.pond__c=boolean.valueOf(pond);
            }
            if(garden != Null){
                property.garden__c=boolean.valueOf(garden);
            }
            if(driveway != Null){
                property.driveway__c=boolean.valueOf(driveway);
            }
            if(grounds_area != Null){
                property.grounds_area__c= grounds_area;
            }
            if(property_value != Null){
                property.property_value__c=property_value;
            }
            if(rental_value_pcm != Null){
                property.rental_value_pcm__c=rental_value_pcm;
            }
            if(council_tax_band != Null){
                property.Council_Tax_Band__c=council_tax_band;
            }
            if(council_tax_cost != Null){
                property.council_tax_cost__c=council_tax_cost;
            }
            if(energy_rating != Null){
                property.energy_rating_current__c = energy_rating;
            }	
            if(mains_gas != Null){
                property.mains_gas_flag__c =  boolean.valueOf(mains_gas);
            }	
            if(monthly_energy_cost != Null){
                property.monthly_energy_cost__c=monthly_energy_cost;
            }
            if(energy_rating_current_predicted != Null){
                property.energy_rating_current_predicted__c = energy_rating_current_predicted ;
            }	
            if(energy_rating_inspection_date != Null){
                property.inspection_date__c = energy_rating_inspection_date;
            }
            if(energy_rating_expiry != Null){
                property.expiry_date__c = energy_rating_expiry;
            }	
            
            if(energy_rating_potential_predicted != Null){
                property.energy_rating_potential_predicted__C = energy_rating_potential_predicted;
            }
            if(mains_gas_flag_predicted != Null){
                property.mains_gas_flag_predicted__c = mains_gas_flag_predicted;
            }
            if(frame_construction_material_predicted != Null){
                property.frame_construction_material_predicted__c = frame_construction_material_predicted;
            }
            if(roof_type_predicted != Null){
                property.roof_type_predicted__c = roof_type_predicted;
            }
            if(bedrooms_predicted != Null){
                property.bedrooms_predicted__c = bedrooms_predicted;
            }
            if(bathrooms_predicted != Null){
                property.bathrooms_predicted__c = bathrooms_predicted;
            }
            if(floor_area_predicted != Null){
                property.floor_area_predicted__C = floor_area_predicted;
            }
			if(grounds_area_predicted != Null){
                property.grounds_area_predicted__c = grounds_area_predicted;
            }
            if(total_hhi_predicted != Null){
                property.total_hhi_predicted__c = total_hhi_predicted;
            }
            // #2 Start storing
            if(main_ridge_height != Null){
                property.main_ridge_height__c = main_ridge_height;
            }
            if(main_gutter_height != Null){
                property.main_gutter_height__c = main_gutter_height;
            }
            if(main_roof_slope_degrees != Null){
                property.main_roof_slope_degrees__c = main_roof_slope_degrees;
            }
            if(building_volume != Null){
                property.building_volume__c = building_volume;
            }
            if(roof_area_up_to_10_degrees != Null){
                property.roof_area_up_to_10_degrees__c = roof_area_up_to_10_degrees;
            }
            if(roof_area_up_to_5_degrees != Null){
                property.roof_area_up_to_5_degrees__c = roof_area_up_to_5_degrees;
            }
            if(pct_south_facing != Null){
                property.pct_south_facing__c = pct_south_facing;
            }
            if(roof_area_up_to_20_degrees != Null){
                property.roof_area_up_to_20_degrees__c = roof_area_up_to_20_degrees;
            }
            if(roof_area_up_to_15_degrees != Null){
                property.roof_area_up_to_15_degrees__c = roof_area_up_to_15_degrees;
            }
            if(roof_area != Null){
                property.roof_area__c = roof_area;
            }
            if(maximum_height != Null){
                property.maximum_height__c = maximum_height;
            }
            if(storey_count != Null){
                property.storey_count__c = storey_count;
            }
            
            // #2 End Storing
            
            
            
            
            

			system.debug('Null Pointer check Run ');
           		 
            if (Schema.sObjectType.property__C.isCreateable()) {
   				database.insert(property);
			}
            //database.insert(property);
            system.debug('proerty Inserted  '+ property);
            //SCIS_EPC_Data.getEpcData(addressVariable,leadId);
            
            
            
            /*
            //update property;
            	system.debug('LEAD RECORD UPDATED FROM CLASS');
				system.debug('This is lead record = '+property);
				system.debug(' cityString'+cityString);
				system.debug(' streetString'+streetString);
				//system.debug(' postalCode'+postalCodeString);

				system.debug(' streetString'+streetString);
				system.debug(' cityString'+cityString);
				system.debug(' countryAndPostalCodeString'+countryAndPostalCodeString);

				//system.debug(property.street + property.city + property.postalCode); 

            
            */
            
            
            
            
            
            /*
            
            if(idUprn != Null){
                leadRecord.uprn__c = idUprn;
            }
            if(idUprn != Null){
                leadRecord.Post_Code_Area__c = postcodeArea;
            }
            if(lsoa != Null){
                leadRecord.LSOA_Text__c = lsoa;
            }
            if(msoa != Null){
                leadRecord.msoa__c = msoa;
            }	
            if(oa != Null){
                leadRecord.oa__c = oa;
            }	
            if(postcode_district != Null){
                leadRecord.postcode_district__c = postcode_district;
            }	
            if(ltla != Null){
                leadRecord.ltla__c = ltla;
            }	
            if(postcode != Null){
                leadRecord.postcode__c = postcode;
            }	
            if(property_type != Null){
                leadRecord.property_type__c = property_type;
            }	
            if(frame_construction_material != Null){
                leadRecord.frame_construction_material__c = frame_construction_material;
            }	
            if(roof_type != Null){
                leadRecord.roof_type__c = roof_type;
            }	
            if(is_urban != Null){
                leadRecord.is_urban__c = is_urban;
            }	
            if(is_listed != Null){
                leadRecord.is_listed__c = boolean.valueOf(is_listed);
            }	
           	if(bedrooms != Null){
                leadRecord.Number_of_Bedroom__c = string.valueOf(bedrooms) ;
            }
            if(bathrooms != Null){
                leadRecord.Number_Of_Bathroom__c = string.valueOf(bathrooms);
            }	
            if(floor_area != Null){
                leadRecord.floor_area__c = floor_area;
            }
            if(total_rooms != Null){
                leadRecord.total_rooms__c = total_rooms;
            }	
            if(basement != Null){
                leadRecord.basement__c = boolean.valueOf(basement);
            }	
            if(concierge != Null){
                leadRecord.concierge__c = boolean.valueOf(concierge);
            }
            if(conservatory != Null){
                leadRecord.conservatory__c = boolean.valueOf(conservatory);
            }
            if(extension != Null){
                leadRecord.extension__c = boolean.valueOf(extension);
            }
            if(swimming_pool != Null){
                leadRecord.swimming_pool__c= boolean.valueOf(swimming_pool);
            }
            if(parking != Null){
                leadRecord.parking__c=boolean.valueOf(parking);
            }
            if(attic != Null){
                leadRecord.attic__c=boolean.valueOf(attic);
            }
            if(garage != Null){
                leadRecord.garage__c=boolean.valueOf(garage);
            }
            if(tennis_court != Null){
                leadRecord.tennis_court__c = boolean.valueOf(tennis_court);
            }
            if(shed != Null){
                leadRecord.shed__c= boolean.valueOf(shed);
            }
            if(pond != Null){
                leadRecord.pond__c=boolean.valueOf(pond);
            }
            if(garden != Null){
                leadRecord.garden__c=boolean.valueOf(garden);
            }
            if(driveway != Null){
                leadRecord.driveway__c=boolean.valueOf(driveway);
            }
            if(grounds_area != Null){
                leadRecord.grounds_area__c= grounds_area;
            }
            if(property_value != Null){
                leadRecord.property_value__c=property_value;
            }
            if(rental_value_pcm != Null){
                leadRecord.rental_value_pcm__c=rental_value_pcm;
            }
            if(council_tax_band != Null){
                leadRecord.Council_Tax_Band__c=council_tax_band;
            }
            if(council_tax_cost != Null){
                leadRecord.council_tax_cost__c=council_tax_cost;
            }
            if(energy_rating != Null){
                leadRecord.energy_rating_current__c = energy_rating;
            }	
            if(mains_gas != Null){
                leadRecord.mains_gas_flag__c =  boolean.valueOf(mains_gas);
            }	
            if(monthly_energy_cost != Null){
                leadRecord.monthly_energy_cost__c=monthly_energy_cost;
            }
            if(energy_rating_current != Null){
                leadRecord.energy_rating_current__c=energy_rating_current ;
            }	
            if(energy_rating_inspection_date != Null){
                leadRecord.inspection_date__c = energy_rating_inspection_date;
            }
            if(energy_rating_expiry != Null){
                leadRecord.expiry_date__c = energy_rating_expiry;
            }	

			*/
            
            
           		 //update leadRecord;
            
            	
            
            

            
           
            
			} else {
            
                system.debug('Error Occured in Response ');
                // Handle error scenarios here
            //return null;
			}
        
            
        }catch(exception e)
		{
        system.debug(e.getmessage());
        system.debug(e.getLineNumber());
		}
            
            
     
    
    	
    }
    
    // Inner class to store response values
    /**
 	* Represents the response structure from the Chimnie API containing details about a residential address.
 	* This class can be used to deserialize the JSON response from the API call.
 	*/
    public class ChimnieResponse {
        public String id { get; set; }
        public String postcodeSector { get; set; }
        public String postcodeArea { get; set; }
        public String uprn { get; set; }
        public String lsoa { get; set; }
        public String msoa { get; set; }
        public String oa { get; set; }
        public String postcode_district { get; set; }
        public String ltla { get; set; }
        public String address { get; set; }
        public String postcode { get; set; }
        public String property_type { get; set; }
        public String frame_construction_material { get; set; }
        public String roof_type { get; set; }
        public boolean is_urban { get; set; }
        public boolean is_listed { get; set; }
        public integer bedrooms { get; set; }
        public integer bathrooms { get; set; }
        public integer floor_area { get; set; }

        public integer total_rooms { get; set; }
        public boolean basement { get; set; }
        public boolean concierge { get; set; }
        public boolean conservatory { get; set; }
        public boolean extension { get; set; }
        public boolean swimming_pool { get; set; }
        public boolean parking { get; set; }
        public boolean attic { get; set; }
        public boolean garage { get; set; }
        public boolean tennis_court { get; set; }        

        public boolean shed { get; set; }
        public boolean pond { get; set; }
        public boolean garden { get; set; }
        public boolean driveway { get; set; }
        public boolean gated { get; set; }
        public integer grounds_area { get; set; }
        public boolean solar_shared { get; set; }
        public boolean solar_flag { get; set; }
        public integer property_value { get; set; }
        public integer rental_value_pcm { get; set; }            

        public String council_tax_band { get; set; }
        public integer council_tax_cost { get; set; }
        public String energy_rating { get; set; }
        public boolean mains_gas { get; set; }
        public integer monthly_energy_cost { get; set; }
        public String household_size { get; set; }
        public integer household_income { get; set; }
        public integer household_disposable_income { get; set; }
        public String energy_rating_current { get; set; }
        public String energy_rating_current_predicted { get; set; }
        
        public String remedial_availability { get; set; }            
        
        public string energy_rating_inspection_date { get; set; }
        public string energy_rating_expiry { get; set; }
        public String social_housing { get; set; }
               
        public boolean mains_gas_flag { get; set; }
        
   		Public string energy_rating_potential_predicted { get; set; }
        Public boolean mains_gas_flag_predicted { get; set; }
        Public string frame_construction_material_predicted { get; set; }
        Public string roof_type_predicted { get; set; }
        Public string Construction_date_predicted { get; set; }
        Public string bedrooms_predicted { get; set; }
        Public string bathrooms_predicted { get; set; }
        Public integer floor_area_predicted { get; set; }
        Public integer grounds_area_predicted { get; set; }
        Public integer total_hhi_predicted { get; set; }
        
        // #2 Start Variables for updated response
        public integer main_ridge_height { get; set; }				
        public integer main_gutter_height { get; set; }			
        public integer main_roof_slope_degrees { get; set; }		
        public integer building_volume { get; set; }		
        public integer roof_area_up_to_10_degrees { get; set; }		
        public integer roof_area_up_to_5_degrees { get; set; }	
        public integer pct_south_facing { get; set; }	
        public integer roof_area_up_to_20_degrees { get; set; }		
        public integer roof_area_up_to_15_degrees { get; set; }		
        public integer roof_area { get; set; }				
        public integer maximum_height { get; set; }								
        public integer storey_count { get; set; }
        // #2 End Variables for updated response
        
        
            
        }    
            
              
         

}