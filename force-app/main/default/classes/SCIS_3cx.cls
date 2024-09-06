/**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	12-12-2023
Class Name 				: 	SCIS_3cx
TestClass Name 			: 	SCIS_3cxTest
@Description 			: 	This class is used for 3cx call Integration with salesforce. THis class functions are used to return the contact
							details of the provided phone number. Using this contact details we can get 3cx window directly on the contact form.
							@param return JSON string containing contact details.
Last Modification Date 	: 	12-12-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * RESTful web service class to retrieve contact details.
 * This class exposes an HTTP GET method to retrieve contact details based on the provided contact ID.
 */
@RestResource(urlMapping='/getcontactdetails/*')
global class SCIS_3cx {
    
    // HTTP GET method to retrieve contact details based on the provided contact ID.
	@HttpGet
    global static String getContacts() {
         // Obtain the incoming REST request
        RestRequest req = RestContext.request;
        // Extract the contact ID from the request URI
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		
        // Query for the contact details
        Contact contact = new Contact();
        if (Schema.sObjectType.Survey__c.isAccessible()) {
            	// Query the contact details if Survey__c object is accessible
                contact = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];
            }
        //Contact contact = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];

        // Create a JSON response
        Map<String, Object> contactDetails = new Map<String, Object>();
        contactDetails.put('Id', contact.Id);
        contactDetails.put('FirstName', contact.FirstName);
        contactDetails.put('LastName', contact.LastName);
        contactDetails.put('Email', contact.Email);
        contactDetails.put('Phone', contact.Phone);

        // Convert the map to JSON
        String jsonResponse = JSON.serialize(contactDetails);
		// Return the JSON response
        return jsonResponse;
    }
}