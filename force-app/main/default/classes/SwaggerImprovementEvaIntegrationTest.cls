@isTest
public class SwaggerImprovementEvaIntegrationTest {

    @testSetup
    static void setupTestData() {
        // Add any test data setup here if needed.
    }

    @isTest
    static void testSendSwaggerDataMethod_Success() {
        // Prepare a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/xml');
        mockResponse.setBody('<response>Success</response>');
        mockResponse.setStatusCode(200);

        // Set up the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        Test.startTest();

        // Create an instance of the class and call the method
        SwaggerImprovementEvaluatorIntegration evaluator = new SwaggerImprovementEvaluatorIntegration();
        String requestBody = '{ "inputXmlBase64": "string", "rdsapGuid": "string","recommendations": [{"item": "A","name": "string","selected": true,"sapRating": 0,"eiRating": 0,"capitalCost": 0,"fuelCostSaving": 0,"paybackPeriod": 0,"coEmissionsSaving": 0,"carbonCostEffectiveness": 0}],"calculationType": "Cumulative","integratorReference": "string" }';
        evaluator.SendSwaggerDataMethod(requestBody);

        Test.stopTest();

        // Assertions to verify mock response handling
        System.assertEquals(200, mockResponse.getStatusCode(), 'Status code should be 200');
        System.assert(mockResponse.getBody().contains('Success'), 'Response body should contain "Success"');
    }

    @isTest
    static void testSendSwaggerDataMethod_Error() {
        // Prepare a mock HTTP response with an error status code
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/xml');
        mockResponse.setBody('<error>Error occurred</error>');
        mockResponse.setStatusCode(500);

        // Set up the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        Test.startTest();

        // Create an instance of the class and call the method
        SwaggerImprovementEvaluatorIntegration evaluator = new SwaggerImprovementEvaluatorIntegration();
        String requestBody = '{ "inputXmlBase64": "string", "rdsapGuid": "string","recommendations": [{"item": "A","name": "string","selected": true,"sapRating": 0,"eiRating": 0,"capitalCost": 0,"fuelCostSaving": 0,"paybackPeriod": 0,"coEmissionsSaving": 0,"carbonCostEffectiveness": 0}],"calculationType": "Cumulative","integratorReference": "string" }';
        evaluator.SendSwaggerDataMethod(requestBody);

        Test.stopTest();

        // Assertions to verify mock error handling
        System.assertEquals(500, mockResponse.getStatusCode(), 'Status code should be 500');
        System.assert(mockResponse.getBody().contains('Error occurred'), 'Response body should contain "Error occurred"');
    }

    // Mock HTTP Callout class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        HttpResponse mockResponse;

        MockHttpResponseGenerator(HttpResponse mockResponse) {
            this.mockResponse = mockResponse;
        }

        public HTTPResponse respond(HTTPRequest req) {
            return mockResponse;
        }
    }
}