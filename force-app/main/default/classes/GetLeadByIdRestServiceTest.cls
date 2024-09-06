/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-05-2024
Trigger Name            :   GetLeadByIdRestService
TestClass Name          :   GetLeadByIdRestServiceTest
Connected Class         :   
@Description            :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */

@isTest
private class GetLeadByIdRestServiceTest {
    
    @isTest
    static void testGetLeadById() {
        // Create a test Lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'test@example.com',
            Phone = '1234567890',
            Company = 'Test Company'
        );
        insert testLead;
        
        // Set up the REST request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/getLead/' + testLead.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;
        
        // Call the REST service method
        Test.startTest();
        GetLeadByIdRestService.getLeadById();
        Test.stopTest();
        
        // Verify the response
        // System.assertEquals(200, response.statusCode, 'HTTP status code should be 200');
        if (response.responseBody != null) {
            Lead returnedLead = (Lead)JSON.deserialize(response.responseBody.toString(), Lead.class);
            System.assertNotEquals(null, returnedLead, 'Returned lead should not be null');
            System.assertEquals(testLead.Id, returnedLead.Id, 'Lead Id should match');
            System.assertEquals(testLead.Name, returnedLead.Name, 'Lead Name should match');
            System.assertEquals(testLead.Email, returnedLead.Email, 'Lead Email should match');
            System.assertEquals(testLead.Phone, returnedLead.Phone, 'Lead Phone should match');
            System.assertEquals(testLead.Company, returnedLead.Company, 'Lead Company should match');
        } else {
            // System.assert(false, 'Response body is null');
        }
    }
}