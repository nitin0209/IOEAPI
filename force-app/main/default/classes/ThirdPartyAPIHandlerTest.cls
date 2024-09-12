@isTest
public class ThirdPartyAPIHandlerTest {

    @isTest
    static void testGetAPIResponse() {
        // Start the test execution
        Test.startTest();

        // Call the method to be tested
        ThirdPartyAPIHandler.ThirdPartyResponse response = ThirdPartyAPIHandler.getAPIResponse();

        // Stop the test execution
        Test.stopTest();

        // Validate that the response is not null
        System.assertNotEquals(null, response, 'The API response should not be null.');

        // Validate the CO2emissions value
        System.assertEquals(1104.1353589857226, response.CO2emissions, 'CO2emissions should match the expected value.');
    }
}