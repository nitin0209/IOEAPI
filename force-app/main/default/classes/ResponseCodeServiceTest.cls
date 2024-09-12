@isTest
public class ResponseCodeServiceTest {

    // Mock class to simulate the HTTP response
    public class MockHttpResponse implements HttpCalloutMock {
        // Implement this method to return a fake response
        public HttpResponse respond(HttpRequest req) {
            // Create a fake HttpResponse
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200); // Simulate a successful response
            res.setBody('Success');
            return res;
        }
    }

    @isTest
    static void testGetResponseCode() {
        // Step 1: Set the mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        // Step 2: Call the method in test context
        Test.startTest();
        Integer responseCode = ResponseCodeService.getResponseCode();
        Test.stopTest();

        // Step 3: Assert the response code
        System.assertEquals(200, responseCode, 'The response code should be 200');
    }
}