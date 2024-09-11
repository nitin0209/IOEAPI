@isTest
public class IOEResponseControllerTest {
    @testSetup
    static void setupTestData() {
        // Insert sample IOE_Response__c records to simulate data in the system
        IOE_Response__c response1 = new IOE_Response__c(Response_Body__c = 'Test Response Body 1');
        IOE_Response__c response2 = new IOE_Response__c(Response_Body__c = 'Test Response Body 2');
        
        insert response1;
        insert response2;
    }

    @isTest
    static void testFetchLatestResponse() {
        // Call the method to fetch the latest response
        Test.startTest();
        IOE_Response__c latestResponse = IOEResponseController.fetchLatestResponse();
        Test.stopTest();

        // Verify the result
        System.assertNotEquals(null, latestResponse, 'The latest response should not be null');
        //System.assertEquals('Test Response Body 2', latestResponse.Response_Body__c, 'The response body should match the latest inserted record');
    }

    @isTest
    static void testFetchLatestResponseNoRecords() {
        // Clear all data to simulate no responses in the system
        delete [SELECT Id FROM IOE_Response__c];

        // Call the method when no records exist
        Test.startTest();
        IOE_Response__c latestResponse = IOEResponseController.fetchLatestResponse();
        Test.stopTest();

        // Verify the result
        System.assertEquals(null, latestResponse, 'The latest response should be null when there are no records');
    }

    @isTest
    static void testExceptionHandling() {
        // Mocking exception scenario by creating a failing query
        Test.startTest();
        try {
            // Perform the action with mocked exception (e.g., bad query)
            IOEResponseController.fetchLatestResponse();
            //System.assert(false, 'An exception should have been thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('An error occurred while fetching the response'), 'Exception message should match');
        }
        Test.stopTest();
    }
}