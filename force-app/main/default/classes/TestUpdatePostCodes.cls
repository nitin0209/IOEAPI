/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-02-2024
Class Name 				: 	UpdatePostCodes
TestClass Name 			: 	UpdatePostCodes_Test
Description 			: 	This is test class for UpdatePostCodes
Last Modification Date 	: 	28-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */


@isTest
private class TestUpdatePostCodes {

    // Utility method to create test Postcode__c records
    private static List<Postcode__c> createTestPostcodes(Integer count) {
        List<Postcode__c> posts = new List<Postcode__c>();
        for(Integer i = 0; i < count; i++) {
            posts.add(new Postcode__c(
                Latitude__c = Math.random(), // Example latitude value
                Longitude__c = Math.random() // Example longitude value
            ));
        }
        insert posts;
        return posts;
    }
    
    @isTest
    static void testUpdatePostcodesMethod() {
        // Create test data
        List<Postcode__c> testPosts = createTestPostcodes(5);
        
        // Ensure the test data is as expected before method execution
        for(Postcode__c post : testPosts) {
            System.assertEquals(null, post.Location__Latitude__s, 'Initial Latitude should be null');
            System.assertEquals(null, post.Location__Longitude__s, 'Initial Longitude should be null');
        }
        
        // Start test execution context
        Test.startTest();
        
        // Call the method under test
        UpdatePostCodes.updatePostcodesMethod();
        
        // Stop test execution context
        Test.stopTest();
        
        // Re-query the Postcode__c records to verify updates
        testPosts = [SELECT Id, Location__Latitude__s, Location__Longitude__s, Latitude__c, Longitude__c FROM Postcode__c];
        
        // Assert that Location__Latitude__s and Location__Longitude__s are correctly updated
        for(Postcode__c post : testPosts) {
            System.assertNotEquals(null, post.Location__Latitude__s, 'Latitude should be updated');
            System.assertNotEquals(null, post.Location__Longitude__s, 'Longitude should be updated');
            System.assertEquals(post.Latitude__c, post.Location__Latitude__s, 'Location__Latitude__s should match Latitude__c');
            System.assertEquals(post.Longitude__c, post.Location__Longitude__s, 'Location__Longitude__s should match Longitude__c');
        }
    }
}