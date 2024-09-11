@isTest
public class HttpRequestTestTest {
    
    // Mock class to simulate HTTP responses
    public class MockHttpResponse implements HttpCalloutMock {
        
        // Implement the respond method
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake HTTP response
            HttpResponse res = new HttpResponse();
            
            // Set the fake response's status and body
            res.setStatusCode(200); // Simulating a success response
            res.setBody('{"message":"Successfully connected to the secure endpoint."}');
            
            return res;
        }
    }
    
    @isTest
    static void testSendHttpsRequest() {
        // Set the mock class to be used
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        // Start test context
        Test.startTest();
        
        // Call the method we want to test
        HttpRequestTest.sendHttpsRequest();
        
        // End test context
        Test.stopTest();
        
        // Add assertions here if needed
        // Since we are using debug logs to verify, we can optionally verify logs or check callout status if required
    }
}