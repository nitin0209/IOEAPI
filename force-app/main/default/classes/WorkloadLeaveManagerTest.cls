@isTest
public class WorkloadLeaveManagerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test Users
        User testUser1 = new User(
            FirstName = 'Test', 
            LastName = 'Coordinator1', 
            Username = 'testcoordinator1@test.com', 
            Email = 'testcoordinator1@test.com', 
            Alias = 'tcoord1',
            Company_Name__c = 'Test Company',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id, 
            TimeZoneSidKey = 'America/New_York', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US'
        );
        insert testUser1;
        
        User testUser2 = new User(
            FirstName = 'Test', 
            LastName = 'Coordinator2', 
            Username = 'testcoordinator2@test.com', 
            Email = 'testcoordinator2@test.com', 
            Alias = 'tcoord2',
            Company_Name__c = 'Test Company',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id, 
            TimeZoneSidKey = 'America/New_York', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;

        // Create Coordinator_Workload__c records for the users
        Coordinator_Workload__c workload1 = new Coordinator_Workload__c(
            Name__c = testUser1.Id,
            Date__c = Date.today(),
            Capacity__c = 5
        );
        Coordinator_Workload__c workload2 = new Coordinator_Workload__c(
            Name__c = testUser2.Id,
            Date__c = Date.today(),
            Capacity__c = 10
        );
        insert new List<Coordinator_Workload__c>{workload1, workload2};

        // Create Appointment__c records for leave
        Appointment__c appointment1 = new Appointment__c(
            Appointment_Type__c = 'Leave',
            Assigned_Coordinator__c = testUser1.Id,
            Leave_Start_Date__c = Date.today(),
            Leave_End_Date__c = Date.today().addDays(2)
        );
        
        Appointment__c appointment2 = new Appointment__c(
            Appointment_Type__c = 'Leave',
            Assigned_Coordinator__c = testUser2.Id,
            Leave_Start_Date__c = Date.today(),
            Leave_End_Date__c = Date.today().addDays(1)
        );
        
        insert new List<Appointment__c>{appointment1, appointment2};
    }
    
    @isTest
    static void testHandleLeaveUpdate() {
        // Fetch test data
        List<Appointment__c> leaveAppointments = [
            SELECT Id, Appointment_Type__c, Assigned_Coordinator__c, Leave_Start_Date__c, Leave_End_Date__c 
            FROM Appointment__c
        ];
        
        // Call the method under test
        Test.startTest();
        WorkloadLeaveManager.handleLeaveUpdate(leaveAppointments);
        Test.stopTest();
        
        // Validate the results
        List<Coordinator_Workload__c> updatedWorkloads = [
            SELECT Name__c, Date__c, Capacity__c 
            FROM Coordinator_Workload__c
            WHERE Capacity__c = 0
        ];
        
        System.assertEquals(2, updatedWorkloads.size(), 'Two workloads should be updated.');
        
        for (Coordinator_Workload__c workload : updatedWorkloads) {
            System.assertEquals(0, workload.Capacity__c, 'Capacity should be set to 0 for leave dates.');
        }
    }
}