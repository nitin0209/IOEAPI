/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	22-11-2023
Class Name 				: 	scis_lead_on_map_helper
TestClass Name 			: 	scis_lead_on_map_helperTest
@Description 			: 	'This class is used to upload images captured from the Lead Generator Application Developed using PHP and iOS.
							In Lead Generator class we need to capture image, so this class is used to store captured images to Lead Object in salesforce.'
							 * @param leadId The Id of the Lead record to retrieve.
Last Modification Date 	: 	22-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The SCIS_lead_on_map_helper class provides methods to retrieve Lead records for displaying on a map.
 */
public with sharing class SCIS_lead_on_map_helper {
    /**
     * Retrieves a Lead record by its Id.
     * @param leadId The Id of the Lead record to retrieve.
     * @return The Lead record corresponding to the provided Id.
     */
    @AuraEnabled(cacheable=true)
    public static Lead getLeadRecord(String leadId) {
        //lead ld = new lead();
        return [SELECT Id, Name, Email, Phone , Location__latitude__s, Location__longitude__s ,Location__c
                FROM Lead
                WHERE Id = :leadId];
    }

}