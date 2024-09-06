@IsTest
public class AddVanControllerTest {
    
    @IsTest
    static void testSaveVanSuccess() {
        // Set up test data
        String vanName = 'Test Van';
        String licensePlate = 'ABC123';
        String status = 'Active';

        // Call the method under test
        Test.startTest();
        String result = AddVanController.saveVan(vanName, licensePlate, status);
        Test.stopTest();

        // Verify the result
        System.assertEquals('success', result, 'The van should be saved successfully.');

        // Verify that the van record was inserted
        Van__c insertedVan = [SELECT Name, License_Plate__c, Status__c FROM Van__c WHERE Name = :vanName LIMIT 1];
        System.assertEquals(vanName, insertedVan.Name, 'Van name should match the input.');
        System.assertEquals(licensePlate, insertedVan.License_Plate__c, 'License plate should match the input.');
        System.assertEquals(status, insertedVan.Status__c, 'Status should match the input.');
    }

    @IsTest
    static void testSaveVanException() {
        // Set up invalid data to trigger an exception (e.g., duplicate license plate)
        Van__c existingVan = new Van__c(Name = 'Existing Van', License_Plate__c = 'DUPLICATE123', Status__c = 'Active');
        insert existingVan;

        String vanName = 'New Van';
        String licensePlate = 'DUPLICATE123';  // Duplicate license plate to trigger an exception
        String status = 'Inactive';

        // Call the method under test
        Test.startTest();
        String result;
        try {
            result = AddVanController.saveVan(vanName, licensePlate, status);
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AuraHandledException e) {
            // Verify that the exception was thrown with the correct message
            System.assert(e.getMessage().contains('Error saving van'), 'Exception message should indicate error saving van.');
        }
        Test.stopTest();
    }
}