@isTest
public class SCIS_CoordinatorControllerTest {
    @testSetup
    static void setup() {
        // Create test Users with different Coordinator Types
        User internalCoordinator = new User(
            FirstName = 'Internal',
            LastName = 'Coordinator',
            Email = 'internal@test.com',
            Username = 'internal@test.com.internal',
            Company_Name__c = 'SCIS',
            Coordinator_Type__c = 'Internal',
            Alias = 'intcoord',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LanguageLocaleKey = 'en_US'
        );

        User externalCoordinator = new User(
            FirstName = 'External',
            LastName = 'Coordinator',
            Email = 'external@test.com',
            Username = 'external@test.com.external',
            Company_Name__c = 'SCIS',
            Coordinator_Type__c = 'External',
            Alias = 'extcoord',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LanguageLocaleKey = 'en_US'
        );

        insert internalCoordinator;
        insert externalCoordinator;
    }

    @isTest
    static void testGetUsers() {
        Test.startTest();
        // Call the method from the controller
        List<User> users = SCIS_CoordinatorController.getUsers();
        Test.stopTest();

        // Assert the results
        // System.assertEquals(2, users.size(), 'Expected to retrieve 2 users.');
        System.assertEquals('Internal', users[0].Coordinator_Type__c, 'Expected the first user to be an internal coordinator.');
        // System.assertEquals('External', users[1].Coordinator_Type__c, 'Expected the second user to be an external coordinator.');
    }
}