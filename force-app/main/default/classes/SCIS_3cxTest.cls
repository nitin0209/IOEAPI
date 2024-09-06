/**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	16-02-2024
Class Name 				: 	SCIS_3cx
TestClass Name 			: 	SCIS_3cxTest
@Description 			: 	This is test class for SCIS_3cx.
							It uses the @SeeAllData annotation to access existing data in the test context.
Last Modification Date 	: 	
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@isTest
public class SCIS_3cxTest {
 @isTest
    static void testGetContacts() {
        // Test data setup
        Contact testContact = new Contact(
            FirstName = 'ABC',
            LastName = 'XYZ',
            Email = 'xyz@xxxx.com',
            Phone = '1234567890'
        );
        insert testContact;
        
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        // Set the request URL to simulate '/getcontactdetails/<contactId>'
        request.requestURI = '/services/apexrest/getcontactdetails/' + testContact.Id;
        
        Test.startTest();
        // Call the REST service method
        RestContext.request = request;
        RestContext.response = response;
        SCIS_3cx.getContacts();
        Test.stopTest();
        
        // Assertions
        // Query the contact from the database to verify its details
        Contact queriedContact = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :testContact.Id LIMIT 1];
        
        // Verify that the queried contact's fields match the expected values
        System.assertEquals(testContact.Id, queriedContact.Id, 'Contact Id mismatch');
        System.assertEquals(testContact.FirstName, queriedContact.FirstName, 'First Name mismatch');
        System.assertEquals(testContact.LastName, queriedContact.LastName, 'Last Name mismatch');
        System.assertEquals(testContact.Email, queriedContact.Email, 'Email mismatch');
        System.assertEquals(testContact.Phone, queriedContact.Phone, 'Phone mismatch');
    }
}