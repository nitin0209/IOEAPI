@isTest
public class RecordCountControllerTest {
    
    @isTest
    static void testGetRecordCount() {
        // Step 1: Create test data
        // Insert a few Survey__c records, some with Status__c = 'Approved by Coordinator' and others with different statuses
        List<Survey__c> surveys = new List<Survey__c>();
        surveys.add(new Survey__c(Status__c = 'Approved by Coordinator'));
        surveys.add(new Survey__c(Status__c = 'Approved by Coordinator'));
        surveys.add(new Survey__c(Status__c = 'Survey Pending'));
        surveys.add(new Survey__c(Status__c = 'Survey In-Progress'));
        insert surveys;

        // Step 2: Instantiate the controller
        RecordCountController controller = new RecordCountController();
        
        // Step 3: Call the method to get the record count
        Test.startTest();
        Integer count = controller.getRecordCount();
        Test.stopTest();
        
        // Step 4: Assert that the record count is correct (only 2 records should match the condition)
        System.assertEquals(2, count, 'The count of surveys with Status__c = "Approved by Coordinator" should be 2');
    }
}