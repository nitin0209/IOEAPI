@isTest
private class SCIS_StreetViewImage_Test {

    @isTest
    static void testShowStreetViewImage() {
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

        // Create a list of leads to pass to the invocable method
        List<Lead> leadList = new List<Lead>{testLead};

        // Call the invocable method
        Test.startTest();
        SCIS_StreetViewImage.showStreetViewImage(leadList);
        Test.stopTest();

        // Query the lead to verify that the Street_ViewI_mage__c and Aerial_View_Image__c fields are updated
        Lead updatedLead = [SELECT Id, Street_ViewI_mage__c, Aerial_View_Image__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        System.assertNotEquals(null, updatedLead.Street_ViewI_mage__c);
        System.assertNotEquals(null, updatedLead.Aerial_View_Image__c);
    }

    @isTest
    static void testShowStreetViewImageBeforeUpdate() {
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

        // Create a list of leads to pass to the method
        List<Lead> leadList = new List<Lead>{testLead};

        // Call the method
        Test.startTest();
        SCIS_StreetViewImage.showStreetViewImageBeforeUpdate(leadList);
        Test.stopTest();

        // Query the lead to verify that the Street_ViewI_mage__c and Aerial_View_Image__c fields are updated
        Lead updatedLead = [SELECT Id, Street_ViewI_mage__c, Aerial_View_Image__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        System.assertNotEquals(null, updatedLead.Street_ViewI_mage__c);
        System.assertNotEquals(null, updatedLead.Aerial_View_Image__c);
    }
}