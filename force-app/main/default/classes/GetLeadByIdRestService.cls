@RestResource(urlMapping='/getLead/')
global class GetLeadByIdRestService {

    @HttpGet
    global static Lead getLeadById() {
        // Retrieve the Lead Id from the request URL parameters
        String leadId = RestContext.request.requestURI.substring(
            RestContext.request.requestURI.lastIndexOf('/') + 1);
        
        // Query the Lead record from the database
        Lead leadRecord = [SELECT Id, Name, Email, Phone, Company 
                           FROM Lead 
                           WHERE Id = :leadId 
                           LIMIT 1];

        return leadRecord;
    }
}