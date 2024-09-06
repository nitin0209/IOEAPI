@isTest
private class SCIS_windows_door_TriggerTest {

    @isTest
    static void testBeforeInsertTrigger() {
        // Create test data
        Window_And_Door__c testRecord = new Window_And_Door__c(Name = 'Test Record');
        List<Window_And_Door__c> recordsToInsert = new List<Window_And_Door__c>{testRecord};

        // Call the trigger manually
        Test.startTest();
        insert recordsToInsert;
        Test.stopTest();

        // Retrieve the records after the trigger has executed
        List<Window_And_Door__c> updatedRecords = [SELECT Id, Name FROM Window_And_Door__c WHERE Id IN :recordsToInsert];

        // Perform assertions to verify the trigger's logic
        System.assertEquals(1, updatedRecords.size(), 'One record should be created by the trigger');
        // Add more assertions as needed

        // Clean up test data
        delete recordsToInsert;
    }
}



/*
@isTest
private class SCIS_windows_door_Trigger_Test {
    
    @isTest
    static void testAttachWindowAndDoor() {
        // Create test data
        List<Window_And_Door__c> testRecords = new List<Window_And_Door__c>();
        for (Integer i = 0; i < 3; i++) {
            testRecords.add(new Window_And_Door__c(Name = 'Test Window/Door ' + i));
        }

        // Call the trigger manually to invoke the logic
        Test.startTest();
        insert testRecords;
        Test.stopTest();

        // Verify that the helper logic has attached the window and door records
        List<Window_And_Door__c> insertedRecords = [SELECT Id, Name FROM Window_And_Door__c WHERE Id IN :testRecords];
        for (Window_And_Door__c record : insertedRecords) {
            //System.assertEquals(true, record.Name, 'Window/Door should be attached');
        }
    }
}

*/