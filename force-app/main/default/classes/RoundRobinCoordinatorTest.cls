@isTest
public class RoundRobinCoordinatorTest {

    @testSetup
    static void setupTestData() {
        // Create a Profile for the user
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create internal coordinators with available capacity and order
        User internalCoordinator1 = new User(
            FirstName = 'Internal',
            LastName = 'Coordinator1',
            Email = 'internal1@example.com',
            Username = 'internal1@example.com.internal',
            Alias = 'int1',
            Company_Name__c = 'SCIS',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = userProfile.Id,
            LanguageLocaleKey = 'en_US',
            Coordinator_Type__c = 'Internal',
            Order__c = 1,
            IsActive = true
        );
        insert internalCoordinator1;

        // Create Coordinator_Workload__c for the internal coordinator
        Coordinator_Workload__c workload1 = new Coordinator_Workload__c(
            Name__c = internalCoordinator1.Id,  // Using the internalCoordinator1 Id
            Remaining_Capacity__c = 3,  // Assuming there is capacity
            Capacity__c = 3,
            Date__c = Date.today()
        );
        insert workload1;

        // Create sample appointments with necessary fields populated
        Appointment__c appointment1 = new Appointment__c(
            Name = 'Appointment 1',
            Status__c = 'Scheduled',  // Example of a necessary field for the trigger logic
            Assigned_coordinator__c = null
        );
        
        Appointment__c appointment2 = new Appointment__c(
            Name = 'Appointment 2',
            Status__c = 'Scheduled',  // Example of a necessary field for the trigger logic
            Assigned_coordinator__c = null
        );

        insert new List<Appointment__c> { appointment1, appointment2 };
    }

    @isTest
    static void testAssignCoordinator_Internal() {
        // Retrieve the test data
        List<Appointment__c> appointments = [SELECT Id, Name FROM Appointment__c];
        
        Test.startTest();
        
        // Call the method to assign coordinators
        RoundRobinCoordinator.assignCoordinator(appointments, true);
        
        Test.stopTest();
        
        // Validate that coordinators were assigned correctly
        appointments = [SELECT Id, Assigned_coordinator__c, Assigned_coordinator_name__c FROM Appointment__c];
        
        System.assertNotEquals(null, appointments[0].Assigned_coordinator__c, 'Coordinator should be assigned to Appointment 1');
        System.assertNotEquals(null, appointments[1].Assigned_coordinator__c, 'Coordinator should be assigned to Appointment 2');
    }
}