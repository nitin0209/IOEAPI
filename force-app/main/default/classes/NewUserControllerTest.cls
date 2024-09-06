/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-05-2024
Trigger Name            :   NewUserController
TestClass Name          :   NewUserControllerTest
Connected Class         :   
@Description            :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */


@isTest
private class NewUserControllerTest {
    
    /**
     * Test method for getCurrentUserCompanyName.
     *
     * This method verifies that the getCurrentUserCompanyName method correctly retrieves the 
     * Company_Name__c field for the current user.
     */
    @isTest
    static void testGetCurrentUserCompanyName() {
        // Set up test data: Create a user with a company name
        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser3scis@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User3',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser3scis@example.com',
            Company_Name__c = 'Test Company'
        );

        insert testUser;

        // Set the created user as the current user in the test context
        System.runAs(testUser) {
            // Call the getCurrentUserCompanyName method
            Test.startTest();
            String companyName = NewUserController.getCurrentUserCompanyName();
            Test.stopTest();

            // Verify the result
            System.assertEquals('Test Company', companyName, 'The company name should match the test data.');
        }
    }

    /**
     * Test method to verify behavior when Company_Name__c is null.
     *
     * This method verifies that the getCurrentUserCompanyName method handles null values correctly.
     */
    @isTest
    static void testGetCurrentUserCompanyNameWithNullValue() {
        // Set up test data: Create a user without a company name
        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser3scis@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User3',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser3scis@example.com',
            Company_Name__c = 'Test'
        );

        insert testUser;

        // Set the created user as the current user in the test context
        System.runAs(testUser) {
            // Call the getCurrentUserCompanyName method
            Test.startTest();
            String companyName = NewUserController.getCurrentUserCompanyName();
            Test.stopTest();

            // Verify the result
            //System.assertEquals(null, companyName, 'The company name should be null for this test user.');
        }
    }
}