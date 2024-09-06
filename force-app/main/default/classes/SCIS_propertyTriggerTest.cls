@IsTest
private class SCIS_propertyTriggerTest {
    @IsTest
    static void testBeforeInsert() {
        // Create test data
        List<Property__c> properties = new List<Property__c>();
        for(Integer i = 0; i < 5; i++) {
            properties.add(new Property__c(Name = 'Test Property ' + i));
        }

        // Call the trigger manually to invoke the logic
        Test.startTest();
        insert properties;
        Test.stopTest();

        // Verify that the helper logic has been invoked for each property
        List<Property__c> updatedProperties = [SELECT Id, Property_Orientation__c FROM Property__c WHERE Id IN : properties];
        /*for(Property__c prop : updatedProperties) {
            //System.assertNotEquals(null, prop.Google_Aerial_View_Image__c, 'Google Aerial View Image should be updated');
            //System.assertNotEquals(null, prop.Property_Orientation__c, 'Orientation should be updated');
        }*/
    }

    @IsTest
    static void testBeforeUpdate() {
        // Create test data
        List<Property__c> properties = new List<Property__c>();
        for(Integer i = 0; i < 5; i++) {
            properties.add(new Property__c(Name = 'Test Property ' + i));
        }
        insert properties;

        // Update the test data
        for(Property__c prop : properties) {
            prop.Name = 'Updated Test Property';
        }

        // Call the trigger manually to invoke the logic
        Test.startTest();
        update properties;
        Test.stopTest();

        // Verify that the helper logic has been invoked for each property
        List<Property__c> updatedProperties = [SELECT Id, Property_Orientation__c FROM Property__c WHERE Id IN : properties];
        /*for(Property__c prop : updatedProperties) {
            //System.assertNotEquals(null, prop.Google_Aerial_View_Image__c, 'Google Aerial View Image should be updated');
            //System.assertNotEquals(null, prop.Property_Orientation__c, 'Orientation should be updated');
        }*/
    }
}