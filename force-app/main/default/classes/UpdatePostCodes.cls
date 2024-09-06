/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   
Trigger Name            :   UpdatePostCodes
TestClass Name          :   
Connected Class         :   
@Description            :   * The UpdatePostCodes class provides a method to update latitude and longitude values 
 							* for postcode records based on custom latitude and longitude fields.
							
Last Modification Date  :   
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The UpdatePostCodes class provides a method to update latitude and longitude values 
 * for postcode records based on custom latitude and longitude fields.
 */
public class UpdatePostCodes {
    /**
     * Method to update latitude and longitude values for postcode records.
     * Latitude and longitude values are copied from custom fields to standard fields.
     */
    public static void updatePostcodesMethod(){
        // List to store postcode records
        list<postcode__C> posts = new List<postcode__C>();
        // Retrieving postcode records from the database
        if (Schema.sObjectType.postcode__C.isAccessible()) {
                posts = [select Id,Location__Latitude__s, Location__Longitude__s, Latitude__c, Longitude__c from Postcode__c ];
            }
       // list<postcode__C> posts = [select Id,Location__Latitude__s, Location__Longitude__s, Latitude__c, Longitude__c from Postcode__c ];
    	// Updating latitude and longitude values for each postcode record
        for( postcode__C post : posts ){
        post.Location__Latitude__s = post.Latitude__c;
        post.Location__Longitude__s = post.Longitude__c;
    }
    // Updating postcode records in the database
    database.update (posts,false);
    // Debug message indicating successful update
    system.debug('Updated');
        }
}