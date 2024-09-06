/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-02-2024
Class Name 				: 	Trial_LeadAddressGenerator
TestClass Name 			: 	Trial_LeadAddressGeneratorTest
Description 			: 	This is test class for Trial_LeadAddressGenerator
Last Modification Date 	: 	28-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */



@isTest
public class Trial_LeadAddressGeneratorTest {
@isTest
    static void testCheckAddress() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>();
        for(Integer i = 0; i < 5; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test' + i,
                LastName = 'Lead' + i,
                City = 'City' + i,
                Street = 'Street' + i,
                PostalCode = 'PostalCode' + i,
                Company = 'SCIS',
                Status = 'Accepted'
            ));
        }
        insert testLeads;

        Test.startTest();
        // Call the method under test
        Trial_LeadAddressGenerator.checkAddress(testLeads);
        Test.stopTest();

        // Add assertions as needed to verify the behavior of the method
        // For example, you could assert that the debug logs contain expected values
        // or query the leads to ensure their addresses are correctly formatted.
    }
}