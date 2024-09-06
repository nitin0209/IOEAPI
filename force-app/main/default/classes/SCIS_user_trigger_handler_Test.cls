/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-05-2024
Trigger Name            :   SCIS_user_trigger_handler
TestClass Name          :   SCIS_user_trigger_handler_Test
Connected Class         :   
@Description            :   @param userList List of User records to validate.
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */

@isTest
private class SCIS_user_trigger_handler_Test {
    
    @isTest
    static void testShowErrorWhenCompanyNameNull() {
        // Create a list of users with various conditions
        List<User> userList = new List<User>();
        
        // User without Company_Name__c
        User user1 = new User(
            Username = 'testuser1@example.com',
            LastName = 'Test',
            Email = 'testuser1@example.com',
            Alias = 'test1',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        userList.add(user1);
        
        // User with empty Company_Name__c
        User user2 = new User(
            Username = 'testuser2@example.com',
            LastName = 'Test',
            Email = 'testuser2@example.com',
            Alias = 'test2',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            Company_Name__c = ''
        );
        userList.add(user2);

        // User with valid Company_Name__c
        User user3 = new User(
            Username = 'testuser3@example.com',
            LastName = 'Test',
            Email = 'testuser3@example.com',
            Alias = 'test3',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            Company_Name__c = 'Test Company'
        );
        userList.add(user3);
        
        // Insert the users
        Test.startTest();
        try {
            insert userList;
        } catch (DmlException e) {
            // Expected to catch an exception due to addError calls
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
        
        // Verify the errors
        for (User usr : userList) {
            if (usr.Company_Name__c == null || usr.Company_Name__c == '') {
                System.assertEquals(1, usr.getErrors().size(), 'User should have an error');
                System.assertEquals('Please enter company name. Name is case sensitive.', usr.getErrors()[0].getMessage(), 'Error message should match');
            } else {
                // System.assertEquals(0, usr.getErrors().size(), 'User should not have an error');
            }
        }
    }
}