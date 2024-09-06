/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	04-12-2023
Class Name 				: 	SCIS_EPC_Data
TestClass Name 			: 	SCIS_EPC_DataTest
Connected				: 	SCIS_EPC_Data_helper
@Description 			: 	This class is used to fetch EPC data from EPC url provided. Ans show this data in Tab created in Lead Form.
							* @param uprn The Unique Property Reference Number (UPRN) for which EPC data is to be retrieved.
     						* @return A string indicating the status of execution.
Last Modification Date 	: 	16-04-2024
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							# 1Change : fetching two new field info into the lead and using these fields into the survey.
								fields - 1. potential-energy-rating
										2. current-energy-rating
************************************************************************************************************************************************** */



/**
 * Salesforce class to retrieve EPC (Energy Performance Certificate) data for a given UPRN (Unique Property Reference Number).
 * This class sends an HTTP GET request to the specified EPC service endpoint and updates Lead records with the retrieved EPC data.
 */
public class SCIS_EPC_Data {
    /**
     * Retrieves EPC data for the specified UPRN and updates Lead records with the retrieved data.
     * @param uprn The Unique Property Reference Number (UPRN) for which EPC data is to be retrieved.
     * @return A string indicating the status of execution.
     */
    Public static string getEpcData(string uprn){
        // Initialize variables
        string htmlEPC;
        string epcUrl= system.label.SCIS_EPC_URL;
        string epcWithUprn = epcUrl + uprn;
        String authHeader = system.label.SCIS_EPC_Auth_Header;
        list<lead> leadList = new list<lead>();
        list<lead> leadsToupdate = new list<lead>();
        string current_energy_rating;
        string potential_energy_rating;
         // Check if Lead object is accessible
         if (Schema.sObjectType.Lead.isAccessible()) {
             // Query for lead records based on the provided UPRN
            leadList = [SELECT id , name , uprn__c , EPC_Data__c
                   	from lead 
                   	where uprn__c =: uprn limit 1];
        }
        /*
        leadList = [SELECT id , name , uprn__c , EPC_Data__c
                   	from lead 
                   	where uprn__c =: uprn limit 1];
        */
        
        // Debug logs for debugging purposes
        system.debug('This is List : ' + leadList);    
        system.debug(epcWithUprn);
        system.debug(authHeader);
        
        // Create an HTTP request to fetch EPC data
        HttpRequest request = new HttpRequest();
        request.setEndpoint(epcWithUprn);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', authHeader);

        // Send HTTP request
        Http http = new Http();
        HttpResponse response = http.send(request);

         // Check the response status code
        if (response.getStatusCode() == 200) {
            // Process successful response
            String responseBody = response.getBody();
            system.debug('This is JSON response = '+ responseBody);
            
            // Parse and process EPC data
            SCIS_EPC_Data_helper epcData = new SCIS_EPC_Data_helper();
             htmlEPC = SCIS_EPC_Data_helper.generateHTMLTable(responseBody);
       		
            //# 1Change Start :
            JSONParser parser = JSON.createParser(responseBody);
            while (parser.nextToken() != null) {
                //system.debug('Entered in While Loop');
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'current-energy-rating') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    //addressVariable = system.json.stringify(parser.getText());
                    current_energy_rating = JSON.serialize(parser.getText());
                    system.debug('current_energy_rating'+current_energy_rating);

                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'potential-energy-rating') {
                    parser.nextToken(); // Move to the value of the 'address' field
                    //addressVariable = system.json.stringify(parser.getText());
                    potential_energy_rating = JSON.serialize(parser.getText());
                    system.debug('potential_energy_rating'+potential_energy_rating);

                }
            }
            
            // Update Lead records with retrieved EPC data
            for(lead ld : leadList ){
                if(ld.id != null){  
                    ld.EPC_Data__c = htmlEPC;
                    ld.is_EPC_Available__c = true;
                    ld.current_energy_rating__c = current_energy_rating ;
                    ld.potential_energy_rating__c = potential_energy_rating;
                    leadsToupdate.add(ld);
                }
            }
            	// Update Lead records if there are any to update
                if(! leadsToupdate.isEmpty() ){
                    database.update (leadsToupdate);
                }else{                   
                    system.debug('LeadsToUpdate list is Null');
                }
            
            
                  
        }else {
            // Log error if HTTP request fails
            System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
            System.debug('Response body: ' + response.getBody());
        }
		// Return execution status
        return 'Executed successfully';
    }

}




/*
public class SCIS_EPC_Data {
    @future
    public static void getEpcData(String addressVariable, string leadId) {
        String htmlEPC;
        String epcUrl = System.Label.SCIS_EPC_URL;
        String authHeader = System.Label.SCIS_EPC_Auth_Header;
        String encodedAddress = addressVariable.replaceAll(' ', '%20');

        List<Lead> leadList = [SELECT Id, Name, UPRN__c, EPC_Data__c
                                FROM Lead 
                                WHERE id =: leadId
                              ];

        System.debug('This is List : ' + leadList);
        System.debug(authHeader);

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', authHeader);

        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead ld : leadList) {
            //String epcWithUprn = epcUrl + ld.UPRN__c;
            String epcWithUprn = epcUrl + encodedAddress;
            system.debug('This is URL : '+ epcWithUprn );
            request.setEndpoint(epcWithUprn);

            HttpResponse response = new Http().send(request);

            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('This is JSON response = ' + responseBody);

                SCIS_EPC_Data_helper epcData = new SCIS_EPC_Data_helper();
                htmlEPC = SCIS_EPC_Data_helper.generateHTMLTable(responseBody);

                if (ld.Id != null) {
                    system.debug('This lead updated with EPC data : ' +ld.id);
                    ld.EPC_Data__c = htmlEPC;
                    ld.is_EPC_Available__c = true;
                    leadsToUpdate.add(ld);
                }
            } else {
                System.debug('HTTP Request failed with status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate);
            //return 'updated successfully !';
        } else {
            System.debug('LeadsToUpdate list is Null');
        }

       // return 'Executed successfully';
    }
}




*/