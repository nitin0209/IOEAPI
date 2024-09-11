@IsTest
public class ImprovementEvaluatorControllerTest {
    @IsTest
    static void testImprovementEvaluatorController() {
        // Mock the API response using a static resource or a sample response string
        String mockApiResponse = '{"status": "success", "data": {"key1": "value1", "key2": "value2"}}';
        
        // Create a mock class that returns the expected API response
        Test.startTest();
        ImprovementElmhurstAPIMock mock = new ImprovementElmhurstAPIMock(mockApiResponse);
        Test.setMock(HttpCalloutMock.class, mock);

        // Instantiate the controller
        ImprovementEvaluatorController controller = new ImprovementEvaluatorController();

        // Verify the response body is correctly set
        System.assertNotEquals(null, controller.responseBody, 'The responseBody should not be null after the API call.');
        System.assertEquals(mockApiResponse, controller.responseBody, 'The responseBody should match the mocked API response.');

        // Test the getFormattedResponseBody method
        String formattedResponse = controller.getFormattedResponseBody();
        System.assert(formattedResponse.contains('value1'), 'The formatted response should contain "value1".');
        System.assert(formattedResponse.contains('value2'), 'The formatted response should contain "value2".');
        // System.assert(formattedResponse.startsWith('{\n  "status":'), 'The formatted response should be pretty-printed JSON.');
        Test.stopTest();
    }

    // Mock class to simulate the API response
    public class ImprovementElmhurstAPIMock implements HttpCalloutMock {
        private String response;

        public ImprovementElmhurstAPIMock(String mockResponse) {
            this.response = mockResponse;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(response);
            res.setStatusCode(200);
            return res;
        }
    }
}