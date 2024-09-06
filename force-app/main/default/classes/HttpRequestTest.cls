public class HttpRequestTest {
    public static void sendHttpsRequest() {
        // Instantiate an HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(' https://bgtest.landregistry.gov.uk');
        req.setMethod('GET');
        
        // Instantiate an HTTP client
        Http http = new Http();
        
        // Send the request
        HttpResponse res = http.send(req);
        
        // Process the response
        if (res.getStatusCode() == 200) {
            System.debug('Successfully connected to the secure endpoint.');
        } else {
            System.debug('Failed to connect to the secure endpoint. Status code: ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }
}