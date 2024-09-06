global class SwaggerImprovementEvaluatorIntegration {
	global void SendSwaggerDataMethod(String requestBody){
        String endpoint = 'https://virtserver.swaggerhub.com/ABHIJEETSAWARKAR/Swagger/1.0.0';
        //String apiKey = 'de90b528-5975-461b-87b2-b22e24c90fc9';
         requestBody = '{ "inputXmlBase64": "string", "rdsapGuid": "string","recommendations": [{"item": "A","name": "string","selected": true,"sapRating": 0,"eiRating": 0,"capitalCost": 0,"fuelCostSaving": 0,"paybackPeriod": 0,"coEmissionsSaving": 0,"carbonCostEffectiveness": 0}],"calculationType": "Cumulative","integratorReference": "string" }';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        //req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf()));
        req.setBody(requestBody);
 
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Order created successfully
            String responseBody = res.getBody();
            System.debug('Response: ' + responseBody);
        } else {
            // Handle error
            System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
        }
    }
}