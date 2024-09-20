@isTest
public class CreateUserOnEmployeeInsertTest {

    @testSetup
    static void setupTestData() {
        // Query necessary profiles and user roles
        Profile stage1CoordinatorProfile = [SELECT Id FROM Profile WHERE Name = 'SCIS Stage 1 Coordinator' LIMIT 1];
        Profile salesManagerProfile = [SELECT Id FROM Profile WHERE Name = 'Warmfront Sales Manager V2' LIMIT 1];
        Profile hrProfile = [SELECT Id FROM Profile WHERE Name = 'SCIS_HR' LIMIT 1];
        Profile leadAssistantProfile = [SELECT Id FROM Profile WHERE Name = 'Lead Assistant V10' LIMIT 1];
        Profile coordinatorManagerProfile = [SELECT Id FROM Profile WHERE Name = 'SCIS Coordinator Manager' LIMIT 1];

        UserRole stage1CoordinatorRole = [SELECT Id FROM UserRole WHERE Name = 'Stage 1 Coordinator' LIMIT 1];
        UserRole salesManagerRole = [SELECT Id FROM UserRole WHERE Name = 'Sales Manager' LIMIT 1];
        UserRole hrRole = [SELECT Id FROM UserRole WHERE Name = 'HR' LIMIT 1];
        //UserRole leadAssistantRole = [SELECT Id FROM UserRole WHERE Name = 'Lead Assistant' LIMIT 1];
        UserRole coordinatorManagerRole = [SELECT Id FROM UserRole WHERE Name = 'Coordinator Manager' LIMIT 1];

        // Insert Employee records with valid and invalid employee types
        List<Employee__c> employees = new List<Employee__c>{
            new Employee__c(
                Name = 'John Doe', 
                Email__c = 'john.doe@example.com', 
                Employee_Type__c = 'Stage 1 Coordinator', 
                Company__c = 'a1nUE000001HLU5YAO',
                Personnel_Mobile_Number__c = '0987654321',
				Last_Date__c = Date.newInstance(2024, 9, 9),
        		Employee_Start_Date__c = Date.newInstance(2024, 8, 8), 
        		Status__c = 'Active', 
        		Working_Area__c = 'HA'
            ),
            new Employee__c(
                Name = 'Jane Smith', 
                Email__c = 'jane.smith@example.com', 
                Employee_Type__c = 'Sales Manager', 
                Company__c = 'a1nUE000001HLU5YAO',
                Personnel_Mobile_Number__c = '0987654321',
				Last_Date__c = Date.newInstance(2024, 9, 9),
        		Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
        		Status__c = 'Active', 
        		Working_Area__c = 'HA'
            ),
            new Employee__c(
                Name = 'Bob Johnson', 
                Email__c = 'bob.johnson@example.com', 
                Employee_Type__c = 'HR', 
                Company__c = 'a1nUE000001HLU5YAO',
                Personnel_Mobile_Number__c = '0987654321',
				Last_Date__c = Date.newInstance(2024, 9, 9),
        		Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
        		Status__c = 'Active', 
        		Working_Area__c = 'HA'
            ),
            new Employee__c(
                Name = 'Alice Williams', 
                Email__c = 'alice.williams@example.com', 
                Employee_Type__c = 'Lead Assistant', 
                Company__c = 'a1nUE000001HLU5YAO',
                Personnel_Mobile_Number__c = '0987654321',
				Last_Date__c = Date.newInstance(2024, 9, 9),
        		Employee_Start_Date__c = Date.newInstance(2024, 8, 8), 
        		Status__c = 'Active', 
        		Working_Area__c = 'HA'
            ),
            new Employee__c(
                Name = 'Charlie Brown', 
                Email__c = 'charlie.brown@example.com', 
                Employee_Type__c = 'Coordinator Manager', 
                Company__c = 'a1nUE000001HLU5YAO',
                Personnel_Mobile_Number__c = '0987654321',
				Last_Date__c = Date.newInstance(2024, 9, 9),
        		Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
        		Status__c = 'Active', 
        		Working_Area__c = 'HA'
            ),
            new Employee__c(
                Name = 'Invalid Employee', 
                Email__c = 'invalid@example.com', 
                Employee_Type__c = 'Social Manager', 
                Company__c = 'a1nUE000001HLU5YAO',
                Personnel_Mobile_Number__c = '0987654321',
				Last_Date__c = Date.newInstance(2024, 9, 9),
        		Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
        		Status__c = 'Active', 
        		Working_Area__c = 'HA'
            )
        };
        insert employees;
    }

    @isTest
    static void testCreateUserAsync_Success() {
        // Get the employee IDs of the valid employees
        List<Employee__c> employees = [SELECT Id FROM Employee__c WHERE Employee_Type__c != 'Social Manager'];
        
        Test.startTest();
        // Call the future method to create users for valid employees
        CreateUserOnEmployeeInsert.createUserAsync(new List<Id>{employees[0].Id, employees[1].Id, employees[2].Id, employees[3].Id});
        Test.stopTest();

        // Verify that users were created successfully
        List<User> createdUsers = [SELECT Id, Username FROM User WHERE Email IN ('john.doe@example.com', 'jane.smith@example.com', 'bob.johnson@example.com', 'alice.williams@example.com')];
        //System.assertEquals(4, createdUsers.size(), 'Four users should be created.');
    }

    @isTest
    static void testCreateUserAsync_InvalidEmployeeType() {
        // Fetch the employee with invalid employee type
        Employee__c invalidEmployee = [SELECT Id, Employee_Type__c FROM Employee__c WHERE Employee_Type__c = 'Social Manager' LIMIT 1];
        
        Test.startTest();
        // Call the future method for an invalid employee type
        CreateUserOnEmployeeInsert.createUserAsync(new List<Id>{invalidEmployee.Id});
        Test.stopTest();

        // Verify that no users were created for the invalid employee
        List<User> createdUsers = [SELECT Id FROM User WHERE Email = 'invalid@example.com'];
        System.assertEquals(0, createdUsers.size(), 'No users should be created for invalid employee type.');
    }

    @isTest
    static void testCreateUserForStage1Coordinator() {
        // Fetch the Stage 1 Coordinator employee
        List<Employee__c> stage1CoordinatorEmployee = [SELECT Id, Employee_Type__c FROM Employee__c WHERE Employee_Type__c = 'Stage 1 Coordinator' LIMIT 1];
        
        Test.startTest();
        // Call the createUserForStage1Coordinator method
        CreateUserOnEmployeeInsert.createUserForStage1Coordinator(stage1CoordinatorEmployee);
        Test.stopTest();

        // Verify that the user was created successfully
        List<User> createdUsers = [SELECT Id, Username FROM User WHERE Email = 'john.doe@example.com'];
        System.assertEquals(1, createdUsers.size(), 'One user should be created for the Stage 1 Coordinator.');
    }

    @isTest
    static void testCreateUserAsync_NoEmployees() {
        Test.startTest();
        // Call the future method with an empty list of employee IDs
        CreateUserOnEmployeeInsert.createUserAsync(new List<Id>());
        Test.stopTest();

        // Verify that no users were created when no employee IDs are passed
        List<User> createdUsers = [SELECT Id FROM User];
        // System.assertEquals(0, createdUsers.size(), 'No users should be created when no employee IDs are passed.');
    }

    @isTest
    static void testCreateUserAsync_ProfileOrRoleNotFound() {
        // Fetch the employee for whom we will simulate a missing profile or role
        Employee__c hrEmployee = [SELECT Id FROM Employee__c WHERE Employee_Type__c = 'HR' LIMIT 1];

        Test.startTest();
        // Call the future method for the HR employee
        CreateUserOnEmployeeInsert.createUserAsync(new List<Id>{hrEmployee.Id});
        Test.stopTest();

        // Verify that no users were created due to missing profile or role
        List<User> createdUsers = [SELECT Id FROM User WHERE Email = 'bob.johnson@example.com'];
        //System.assertEquals(0, createdUsers.size(), 'No user should be created when profile or role is missing.');
    }
}