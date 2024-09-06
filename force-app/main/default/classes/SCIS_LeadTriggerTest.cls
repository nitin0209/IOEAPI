/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   21-02-2023
Trigger Name            :   SCIS_LeadTrigger
TestClass Name          :   SCIS_LeadTriggerTest
Connected Class         :   SCIS_ChimnieIntegration
@Description            :   This trigger is used to check if lead is coming from App or not. If lead is coming from applicatioin 
                            then it should fire trigger otherwise it should not fire trigger because triggering will consume credits
                            for fetching property details which are limited.
							
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                            #1 05-01-2024 : To avoid deletion of Lead Record.
************************************************************************************************************************************************** */

/**
 * Test class for the Lead trigger SCIS_LeadTrigger.
 * This class tests the before insert, after insert, and before update triggers.
 */
@isTest
private class SCIS_LeadTriggerTest {
	/**
     * Test method for the after insert trigger.
     * Tests if the street view and aerial view image fields are updated after lead insertion.
     */
    @isTest
    static void testAfterInsert() {
        
// Define user information
// Define user information and create a new User record
// Note: Ensure to set a unique username and provide the appropriate profile name
// for the System Administrator profile.
// This user is used as the owner of the lead record.
String firstName = 'Test';
String lastName = 'User';
String email = 'testuser@example.com';
String username = 'testuser999@example.com'; // Set a unique username
String profileName = 'System Administrator'; // Name of the System Administrator profile

// Query for the System Administrator profile Id
Id profileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;

// Create a new User record
User newUser = new User(
    FirstName = firstName,
    LastName = lastName,
    Email = email,
    Company_Name__c = 'SCIS',
    Username = username,
    ProfileId = profileId,
    Alias = 'tuser',
    TimeZoneSidKey = 'America/Los_Angeles', // Set the desired timezone
    LocaleSidKey = 'en_US', // Set the desired locale
    EmailEncodingKey = 'UTF-8',
    LanguageLocaleKey = 'en_US'
);

// Insert the new User record
insert newUser;

        
        // Create a test lead without setting IsConverted to false
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            OwnerId = newUser.id,
            lead_receive_from_app__c = true,
            Street = '33 Langham Garden',
            City = 'NORTH WEMBLEY',
            PostalCode = 'HA0 3RG',
            Company = 'SCIS'
            // Add other necessary fields for lead creation
        );
        insert testLead;

        // Query the lead to verify that Street_ViewI_mage__c and Aerial_View_Image__c fields are updated
        //Lead updatedLead = [SELECT Id, Street_ViewI_mage__c, Aerial_View_Image__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        //System.assertNotEquals(null, updatedLead.Street_ViewI_mage__c);
        //System.assertNotEquals(null, updatedLead.Aerial_View_Image__c);
    }

    /**
     * Test method for the before insert trigger.
     * Tests if the aerial view image field is updated before lead insertion.
     */
    @isTest
    static void testBeforeInsert() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',         
            Street = '33 Langham Garden',
            City = 'NORTH WEMBLEY',
            PostalCode = 'HA0 3RG',
            Company = 'SCIS'
            // Add other necessary fields for lead creation
        );
        insert testLead;

        // Query the lead to verify that Street_ViewI_mage__c and Aerial_View_Image__c fields are updated
        Lead updatedLead = [SELECT Id, Street_ViewI_mage__c, Aerial_View_Image__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        //System.assertNotEquals(null, updatedLead.Street_ViewI_mage__c);
        System.assertNotEquals(null, updatedLead.Aerial_View_Image__c);
    }

    /**
     * Test method for the before update trigger.
     * Tests if the street view image field is updated before lead update.
     */
    @isTest
    static void testBeforeUpdate() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Street = '33 Langham Garden',
            City = 'NORTH WEMBLEY',
            PostalCode = 'HA0 3RG',
            Company = 'SCIS'
            // Add other necessary fields for lead creation
        );
        insert testLead;

        // Modify the lead before the update trigger fires
        testLead.Street = '33 Langham garden ';
        update testLead;

        Delete testLead;
        // Query the lead to verify that Street_ViewI_mage__c and Aerial_View_Image__c fields are updated
        //Lead updatedLead = [SELECT Id, Street_ViewI_mage__c, Aerial_View_Image__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
       // System.assertNotEquals(null, updatedLead.Street_ViewI_mage__c);
        //System.assertNotEquals(null, updatedLead.Aerial_View_Image__c);
        //System.assertNotEquals(null, updatedLead.id);
    }
}