/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   
Trigger Name            :   Trial_LeadAddressGenerator
TestClass Name          :   
Connected Class         :   
@Description            :   * The Trial_LeadAddressGenerator class provides a method to generate addresses for leads.
 							* It retrieves lead records and constructs addresses using street, city, and postal code fields.
							* @param leadList The list of lead records for which addresses need to be generated.
Last Modification Date  :   
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The Trial_LeadAddressGenerator class provides a method to generate addresses for leads.
 * It retrieves lead records and constructs addresses using street, city, and postal code fields.
 */
public class Trial_LeadAddressGenerator {
    /**
     * Method to generate addresses for leads based on their street, city, and postal code fields.
     * @param leadList The list of lead records for which addresses need to be generated.
     */
    public static void checkAddress(list<lead> leadList){
        // Debug message indicating entry into the class
        system.debug('Entered Into the Class');
        string address;
       
        set<id> idset = new set<id>();
        // Extracting lead Ids from the list
        for(lead ld : leadList){
            idset.add(ld.Id);
        }
        system.debug('THis is set of ID'+ idSet);
        
        List<lead> leadToFetch = new List<lead>();
        // Retrieving lead records from the database
        if (Schema.sObjectType.lead.isAccessible()) {
                leadToFetch = [SELECT Id, Name, City,Street,PostalCode 
                                  from lead
                                 where id IN: idSet limit 1];
            }
        /*
        List<lead> leadToFetch = [SELECT Id, Name, City,Street,PostalCode 
                                  from lead
                                 where id IN: idSet limit 1];
        */
        system.debug('THis is list of Leads'+ leadToFetch);
        // Constructing addresses for each lead
        for(lead ld1 : leadToFetch){
            address = ld1.street + ','+ld1.City +','+ ld1.PostalCode;
            system.debug('This is address = '+address);
        }
    }
}