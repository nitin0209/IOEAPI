@isTest
public class SchedulerForCoordinatorWorkloadTest {

    @testSetup
    static void setupTestData() {
        // Create test users with different coordinator types
        User internalCoordinator = new User(
            FirstName = 'Internal',
            LastName = 'Coordinator',
            Email = 'internal@example.com',
            Username = 'internal@example.com.internal',
            Alias = 'intcoord',
            Company_Name__c = 'SCIS',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            Coordinator_Type__c = 'Internal',
            IsActive = true
        );
        
        User externalCoordinator = new User(
            FirstName = 'External',
            LastName = 'Coordinator',
            Email = 'external@example.com',
            Username = 'external@example.com.external',
            Alias = 'extcoord',
            Company_Name__c = 'SCIS',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            Coordinator_Type__c = 'External',
            IsActive = true
        );

        User managerCoordinator = new User(
            FirstName = 'Manager',
            LastName = 'Coordinator',
            Email = 'manager@example.com',
            Username = 'manager@example.com.manager',
            Alias = 'mgrcoord',
            Company_Name__c = 'SCIS',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            Coordinator_Type__c = 'Coordinator Manager',
            IsActive = true
        );
        
        insert new List<User>{internalCoordinator, externalCoordinator, managerCoordinator};
    }

    @isTest
    static void testSchedulerExecution() {
        // Start test context
        Test.startTest();

        // Simulate the scheduler execution by invoking the schedulable class
        SchedulerForCoordinatorWorkload scheduler = new SchedulerForCoordinatorWorkload();
        String jobId = System.schedule('Test Scheduler', '0 0 12 * * ?', scheduler); // Schedules job to run daily at noon
        
        Test.stopTest();
        
        // Validate that the Coordinator_Workload__c records were inserted or updated
        List<Coordinator_Workload__c> workloads = [SELECT Id, Name__c, Date__c, Remaining_Capacity__c 
                                                   FROM Coordinator_Workload__c 
                                                   WHERE Remaining_Capacity__c = 15];
        
        System.assertNotEquals(0, workloads.size(), 'Coordinator workloads should be inserted or updated');
        System.assertEquals(15, workloads[0].Remaining_Capacity__c, 'Remaining Capacity should be 15');
    }
}