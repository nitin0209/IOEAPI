public with sharing class ResponseCodeService {
    @AuraEnabled(cacheable=true)
    public static Integer getResponseCode() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://bgtest.landregistry.gov.uk'); 
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Return the HTTP status code
        return res.getStatusCode();
    }
}