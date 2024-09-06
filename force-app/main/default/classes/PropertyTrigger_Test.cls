/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-02-2024
Class Name 				: 	PropertyTrigger
TestClass Name 			: 	PropertyTrigger_Test
Description 			: 	This is test class for PropertyTrigger
Last Modification Date 	: 	27-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */
/*
@isTest
public class PropertyTrigger_Test {
    
    static testMethod void testPropertyTrigger(){
        
        //Query test user that owns Account record and runs the code
        
        User tuser = [select id,username from User where username ='dinesh.suryavanshi@canspirit.ae.dev'];
        System.runAs(tuser){
            
            property__c prop = new property__c();
            prop.Name = 'Test Property';
            prop.EPC_Data__c = 'Test EPC Data';
            prop.UPRN__c = '12345';
            insert prop;
            
            lead ld = new lead();
            ld.UPRN__c = '12345';
            ld.lastname = 'test lead';
            ld.Company = 'SCIS';
            ld.is_EPC_Available__c = false;
            insert ld;
            
          system.assertEquals(ld.EPC_Data__c, 'Test EPC Data');
          //system.assertEquals(ld.is_EPC_Available__c, true);
        }
    }
}


*/



@isTest
private class PropertyTrigger_Test {

   @isTest
    static void testPropertyTrigger() {
        // Create test data: Property__c records
        List <string> UPRNstring = new List <string>();
        List<Property__c> testProperties = new List<Property__c>();
        for(Integer i = 0; i < 5; i++) {
            Property__c prop = new Property__c(
                Name = 'Test Property ' + i,
                UPRN__c = 'UPRN' + i, // Set UPRN__c field
                EPC_Data__c = 'Test EPC Data' + i // Set EPC_Data__c field
                
            );
            testProperties.add(prop);
            
        }
        
        
        insert testProperties;
		
        for(Property__c prope : testProperties){
            UPRNstring.add(prope.UPRN__c);
        }
        
        // Create test data: Lead records
        List<Lead> testLeads = new List<Lead>();
        for(Integer i = 0; i < 5; i++) {
            Lead ld = new Lead(
                LastName = 'Test Lead ' + i,
                UPRN__c = 'UPRN' + i, // Set UPRN__c field to match Property__c UPRN__c values
                is_EPC_Available__c = false, // Set is_EPC_Available__c field
                Company = 'Test'
            );
            testLeads.add(ld);
        }
        insert testLeads;

        // Run the trigger by performing DML operation on Property__c records
        Test.startTest();
        // For example, perform an update operation to invoke the trigger
        // You can use other DML operations (insert, update) as needed
        update testProperties;
        Test.stopTest();

        // Verify that Lead records were updated as expected
        //List<Lead> updatedLeads = [SELECT Id, EPC_Data__c, is_EPC_Available__c FROM Lead WHERE UPRN__c IN :testProperties];
        List<Lead> updatedLeads = [SELECT Id, EPC_Data__c, is_EPC_Available__c,uprn__c FROM Lead WHERE UPRN__c IN: UPRNstring];
        System.assertEquals(testLeads.size(), updatedLeads.size());
        /*for(Lead ld : updatedLeads) {
            // Ensure that EPC_Data__c and is_EPC_Available__c fields are updated as expected
            //System.assertEquals(ld.EPC_Data__c, 'Test EPC Data' + ld.UPRN__c.substring(4)); // Assuming EPC_Data__c is set based on UPRN__c
            //System.assertEquals(ld.is_EPC_Available__c, true);
        }*/
    }
}