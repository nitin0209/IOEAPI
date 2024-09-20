public class ElmhurstRdsapRegisterController {
    public String responseData { get; set; }

    public void sendGetRequest() {
        try {
            HttpRequest req = new HttpRequest();
            Http http = new Http();

            // Set the request method and endpoint
            req.setMethod('GET');
            req.setEndpoint('https://rdsap-integration-api-staging.elmhurstenergy.net/api/R994/RegisterXml/I061-0001-000003');

            // Set the username and password for basic authentication
            String username = '311245362999';
            String password = '5bfac846aa90466bf65d93bb35473f19';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);

            // Set additional headers
            req.setHeader('Surveyor-Code', 'I061-0001');
            req.setHeader('Password', '5bfac846aa90466bf65d93bb35473f19');

            // Send the HTTP request
            HttpResponse res = http.send(req);

            // Process the response
            if (res.getStatusCode() == 200) {
                responseData = res.getBody();
                System.debug('Response: ' + responseData);
            } else {
                responseData = 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
                System.debug(responseData);
            }

        } catch (Exception e) {
            // Handle any exceptions
            responseData = 'Exception: ' + e.getMessage();
            System.debug(responseData);
        }
    }
}