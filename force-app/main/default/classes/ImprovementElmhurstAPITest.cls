@IsTest
public class ImprovementElmhurstAPITest {

    @IsTest
    static void testCalculateAssessment() {
        // Mock HTTP response for the external API call
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "success"}');
        
        // Start mocking HTTP calls
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method you are testing
        String result = ImprovementElmhurstAPI.calculateAssessment();
        
        // Verify the result
        System.assertEquals('{"response": "success"}', result, 'The response should match the mock response.');
    }
    
    @IsTest
    static void testAssessmentRequestClass() {
        // Test AssessmentRequest class
        ImprovementElmhurstAPI.AssessmentRequest request = new ImprovementElmhurstAPI.AssessmentRequest();
        request.inputXmlBase64 = 'base64EncodedString';
        request.rdsapGuid = 'guid123';
        request.calculationType = 'type1';
        request.integratorReference = 'ref123';
        
        // Test the inner Recommendation class
        ImprovementElmhurstAPI.Recommendation recommendation = new ImprovementElmhurstAPI.Recommendation();
        recommendation.item = 'Item1';
        recommendation.name = 'Recommendation1';
        recommendation.selected = true;
        recommendation.sapRating = 80;
        recommendation.eiRating = 75;
        recommendation.capitalCost = 1000;
        recommendation.fuelCostSaving = 100;
        recommendation.paybackPeriod = 10.5;
        recommendation.coEmissionsSaving = 200;
        recommendation.carbonCostEffectiveness = 150;
        
        // Add recommendation to the list in request
        request.recommendations = new List<ImprovementElmhurstAPI.Recommendation>();
        request.recommendations.add(recommendation);
        
        // Verify that the values are correctly set
        System.assertEquals('base64EncodedString', request.inputXmlBase64);
        System.assertEquals('guid123', request.rdsapGuid);
        System.assertEquals('type1', request.calculationType);
        System.assertEquals('ref123', request.integratorReference);
        System.assertEquals(1, request.recommendations.size());
        
        // Verify the recommendation values
        System.assertEquals('Item1', request.recommendations[0].item);
        System.assertEquals('Recommendation1', request.recommendations[0].name);
        System.assertEquals(true, request.recommendations[0].selected);
        System.assertEquals(80, request.recommendations[0].sapRating);
        System.assertEquals(75, request.recommendations[0].eiRating);
        System.assertEquals(1000, request.recommendations[0].capitalCost);
        System.assertEquals(100, request.recommendations[0].fuelCostSaving);
        System.assertEquals(10.5, request.recommendations[0].paybackPeriod);
        System.assertEquals(200, request.recommendations[0].coEmissionsSaving);
        System.assertEquals(150, request.recommendations[0].carbonCostEffectiveness);
    }
    
    // Mock class to simulate HTTP callout responses
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;

        public MockHttpResponseGenerator(HttpResponse response) {
            this.mockResponse = response;
        }

        public HttpResponse respond(HttpRequest req) {
            return mockResponse;
        }
    }
}