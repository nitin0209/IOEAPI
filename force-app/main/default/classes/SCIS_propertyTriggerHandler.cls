/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	01-02-2024
Class Name 				: 	SCIS_propertyTriggerHandler
TestClass Name 			: 	SCIS_propertyTriggerHandlerTest
@Description 			: 	This trigger handler class is used to update chimine information below google aerial view image.
							* @param propList The list of Property records for which the Aerial View Image field needs to be updated.
Last Modification Date 	: 	21-02-2024
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1 21-02-2024 : updateGoogleAerialViewImage method added.
							
************************************************************************************************************************************************** */

/**
 * The SCIS_propertyTriggerHandler class contains methods to handle triggers related to the Property object.
 */
public class SCIS_propertyTriggerHandler {
    
     /**
     * Updates the Aerial View Image field on associated Lead records based on Property information.
     * @param propList The list of Property records for which the Aerial View Image field needs to be updated.
     */
    public static void updateGoogleAerialViewImage(list<property__c> propList){
        //string addToAerialImage;
        
        //SCIS_propertyTriggerHandler.createOrientationOfProperty(propList);
        
        set<id> LeadIdSet = new set<id>();
        map<id,id> leadMap = new map<id,id>();
        boolean ifInsert;
        //boolean ifUpdate;
        
        // Collect Lead Ids from the provided Property records
        for(property__c prop : propList){
            LeadIdSet.add(prop.lead__C);
            //leadMap.put(prop.id,prop.Lead__c);
        }
        // Retrieve Lead records related to the provided Property records
        list<lead> leadList = new list<lead>();
        list<lead> leadsToUpdate = new list<lead>();
        if (Schema.sObjectType.lead.isAccessible()) {
                 leadList=[select id,Aerial_View_Image__c,Property_Structure__c from lead where id IN: leadIdSet];
            }
        // leadList=[select id,Aerial_View_Image__c,Property_Structure__c from lead where id IN: leadIdSet];
        
        // Update Lead records with Property information
        for(property__C prop : propList){
            for(lead ld : leadList){
                if(ld.id == prop.Lead__c){
                    if(ld.Property_Structure__c == null){
                        ifInsert = true;
                    }
                    string addToAerialImage;
                    addToAerialImage = (	'Height of Main Ridge  = '+ prop.main_ridge_height__c +
                                        	'\n Height of Main Gutter = '+ prop.main_gutter_height__c + 
                                        	'\n Slope of Main Roof (in Degrees) = '+ prop.main_roof_slope_degrees__c +
                                        	'\n Maximum Building Height = '+ prop.maximum_height__c + 
                                        	'\n Building Volume = '+ prop.Building_Volume__c + 
                                        	'\n Roof Area with up to 5-Degree Slope  = '+ prop.roof_area_up_to_5_degrees__c + 
                                        	'\n Roof Area with up to 10-Degree Slope  = '+ prop.roof_area_up_to_10_degrees__c + 
                                        	'\n Roof Area with up to 15-Degree Slope 	= '+ prop.roof_area_up_to_15_degrees__c +
                                        	'\n Roof Area with up to 20-Degree Slope 	= '+ prop.roof_area_up_to_20_degrees__c +
                                        	'\n Percentage South Facing = '+ prop.pct_south_facing__c + 
                                        	'\n Total Roof Area = '+ prop.roof_area__c +
                                        	'\n Number of Storeys = '+ prop.storey_count__c);
                    ld.Property_Structure__c = addToAerialImage;
                    leadsToUpdate.add(ld);
                    
                }
            }
        }
        update leadsToUpdate;
        /*
        // Insert or update Lead records based on condition
        if(ifInsert == true){
            if(leadsToUpdate.isEmpty()){
                update leadsToUpdate;
            }
            
        }else{
            update leadsToUpdate;
        } 
		*/
        
    }

    
    // #1 21-02-2024 change start
    /**
     * Creates the orientation of the Property based on the percentage of South facing.
     * @param propList The list of Property records for which the orientation needs to be determined.
     */
    public static void createOrientationOfProperty(list<property__c> propList){
        for(property__c prop : propList){
            
            if(prop.pct_south_facing__c != null){
                Decimal degrees = prop.pct_south_facing__c * 3.6;
                if((degrees > 0 && degrees <= 22.5) || ( degrees >= 337.5 && degrees <= 360) ){
                	prop.Property_Orientation__c = 'South';
                }else if(degrees > 22.5 && degrees <= 67.5){
                    prop.Property_Orientation__c = 'South West';
                }
                else if(degrees > 67.5 && degrees <= 112.5 ){
                    prop.Property_Orientation__c = 'West';
                }else if(degrees > 112.5 && degrees <= 157.5 ){
                    prop.Property_Orientation__c = 'North West';
                }else if(degrees > 157.5 && degrees <= 202.5 ){
                    prop.Property_Orientation__c = 'North';
                }else if(degrees > 202.5 && degrees <= 247.5 ){
                    prop.Property_Orientation__c = 'North East';
                }else if(degrees > 247.5 && degrees <= 292.5 ){
                    prop.Property_Orientation__c = 'East';
                }else if(degrees > 292.5 && degrees <= 337.5 ){
                    prop.Property_Orientation__c = 'South East';
                }
            }
            
        }        
    }
    // #1 21-02-2024 change end
}