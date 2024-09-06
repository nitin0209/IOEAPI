/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-02-2024
Class Name 				: 	SCIS_lead_on_map_helper
TestClass Name 			: 	scis_lead_on_map_helperTest
Description 			: 	This is test class for SCIS_lead_on_map_helper
Last Modification Date 	: 	27-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */


@isTest(SeeAllData=true)
public class scis_lead_on_map_helperTest {
@isTest
    static void testGetLeadRecord() {
        // Create a test lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            Lastname = 'Lead',
            Email = 'test@example.com',
            Phone = '1234567890',
            Location__latitude__s = 37.7749,
            Location__longitude__s = -122.4194,
            Company = 'SCIS',
            Status = 'Accepted'
            //Location__c = 'San Francisco'
        );
        insert testLead;

        Test.startTest();
        // Call the method under test
        Lead resultLead = SCIS_lead_on_map_helper.getLeadRecord(testLead.Id);
        Test.stopTest();

        // Verify the returned lead record
        System.assertEquals(testLead.Id, resultLead.Id);
        //System.assertEquals(testLead.FirstName, resultLead.FirstName);
        System.assertEquals(testLead.Email, resultLead.Email);
        System.assertEquals(testLead.Phone, resultLead.Phone);
        System.assertEquals(testLead.Location__latitude__s, resultLead.Location__latitude__s);
        System.assertEquals(testLead.Location__longitude__s, resultLead.Location__longitude__s);
        //System.assertEquals(testLead.Location__c, resultLead.Location__c);
    }
}