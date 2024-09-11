@isTest
public class EmployeeUpdateHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create a test Company__c record dynamically
        Company__c company = new Company__c(
            Name = 'SCIS',
            Company_Type__c = 'Installer', 
            Email__c = 'abbc@xyz.com', 
            Phone_Number__c = '1234567890', 
            Working_Area__c = 'HA', 
            compnay_registration_number__c = '123456'
        );
        insert company;

        // Create two Employee__c records with related User_Log_In_Details__c and Installer__c records
        List<Employee__c> employees = new List<Employee__c>{
            new Employee__c(
                Name = 'John Doe', 
                Email__c = 'john.doe@example.com', 
                Personnel_Mobile_Number__c = '1234567890',
                Last_Date__c = Date.newInstance(2024, 9, 9),
                Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
                //Company__c = company.Id,
                Company__c = 'a1nUE000001HLU5YAO',
                Employee_Type__c = 'Lead Installer',
                Status__c = 'Active', 
                Working_Area__c = 'HA'
            ),
            new Employee__c(
                Name = 'Jane Smith', 
                Email__c = 'jane.smith@test.com',
                Personnel_Mobile_Number__c = '0987654321',
                Last_Date__c = Date.newInstance(2024, 9, 9),
                Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
                //Company__c = company.Id,
                Company__c = 'a1nUE000001HLU5YAO',
                Employee_Type__c = 'Lead Installer', 
                Status__c = 'Active', 
                Working_Area__c = 'HA'
            )
        };
        insert employees;

        // Create related User_Log_In_Details__c records for both employees
        List<User_Log_In_Details__c> userLogins = new List<User_Log_In_Details__c>{
            new User_Log_In_Details__c(Employee__c = employees[0].Id, Email__c = 'john.doe@test.com', Name = 'John Doe'),
            new User_Log_In_Details__c(Employee__c = employees[1].Id, Email__c = 'jane.smith@test.com', Name = 'Jane Smith')
        };
        insert userLogins;

        // Create related Installer__c records for both employees
        List<Installer__c> installers = new List<Installer__c>{
            new Installer__c(Employee2__c = employees[0].Id, Email__c = 'john.doe@test.com', Name = 'John Doe', Phone__c = '1234567890', Role__c = 'ABC'),
            new Installer__c(Employee2__c = employees[1].Id, Email__c = 'jane.smith@test.com', Name = 'Jane Smith', Phone__c = '0987654321', Role__c = 'XYZ')
        };
        insert installers;
    }

    @isTest
    static void testRelatedRecordupdation_Success() {
        // Retrieve the existing Employee__c records created in test setup
        List<Employee__c> existingEmployees = [SELECT Id, Name, Email__c, Personnel_Mobile_Number__c, Company__c FROM Employee__c];
        Employee__c emp1 = existingEmployees[0];
        Employee__c emp2 = existingEmployees[1];

        // Create updated versions of the employees
        Employee__c updatedEmp1 = new Employee__c(
            Id = emp1.Id, 
            Name = 'John Doe Updated', 
            Email__c = 'john.doe.updated@test.com',
            Personnel_Mobile_Number__c = '1111111111',
            Last_Date__c = Date.newInstance(2024, 9, 9),
            Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
            Company__c = emp1.Company__c,  
            Employee_Type__c = 'Assistant Installer', 
            Status__c = 'Active', 
            Working_Area__c = 'HA'
        );

        Employee__c updatedEmp2 = new Employee__c(
            Id = emp2.Id, 
            Name = 'Jane Smith Updated', 
            Email__c = 'jane.smith.updated@test.com',
            Personnel_Mobile_Number__c = '2222222222',
            Last_Date__c = Date.newInstance(2024, 9, 9),
            Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
            Company__c = emp2.Company__c,  
            Employee_Type__c = 'Assistant Installer', 
            Status__c = 'Active', 
            Working_Area__c = 'HA'
        );

        // Simulate the trigger by passing old and new values
        List<Employee__c> newEmpList = new List<Employee__c> { updatedEmp1, updatedEmp2 };
        Map<Id, Employee__c> oldEmpMap = new Map<Id, Employee__c> {
            emp1.Id => emp1,
            emp2.Id => emp2
        };

        // Instantiate the handler
        EmployeeUpdateHandler handler = new EmployeeUpdateHandler();

        // Run the test
        Test.startTest();
        handler.relatedRecordupdation(newEmpList, oldEmpMap);
        Test.stopTest();

        // Verify that the related User_Log_In_Details__c and Installer__c records were updated for both employees
        User_Log_In_Details__c updatedUserLog1 = [SELECT Email__c, Name FROM User_Log_In_Details__c WHERE Employee__c = :emp1.Id LIMIT 1];
        System.assertEquals('john.doe.updated@test.com', updatedUserLog1.Email__c, 'User login email for Employee 1 should be updated');
        System.assertEquals('John Doe Updated', updatedUserLog1.Name, 'User login name for Employee 1 should be updated');

        Installer__c updatedInstaller1 = [SELECT Email__c, Name, Phone__c FROM Installer__c WHERE Employee2__c = :emp1.Id LIMIT 1];
        System.assertEquals('john.doe.updated@test.com', updatedInstaller1.Email__c, 'Installer email for Employee 1 should be updated');
        System.assertEquals('John Doe Updated', updatedInstaller1.Name, 'Installer name for Employee 1 should be updated');
        System.assertEquals('1111111111', updatedInstaller1.Phone__c, 'Installer phone for Employee 1 should be updated');

        User_Log_In_Details__c updatedUserLog2 = [SELECT Email__c, Name FROM User_Log_In_Details__c WHERE Employee__c = :emp2.Id LIMIT 1];
        System.assertEquals('jane.smith.updated@test.com', updatedUserLog2.Email__c, 'User login email for Employee 2 should be updated');
        System.assertEquals('Jane Smith Updated', updatedUserLog2.Name, 'User login name for Employee 2 should be updated');

        Installer__c updatedInstaller2 = [SELECT Email__c, Name, Phone__c FROM Installer__c WHERE Employee2__c = :emp2.Id LIMIT 1];
        System.assertEquals('jane.smith.updated@test.com', updatedInstaller2.Email__c, 'Installer email for Employee 2 should be updated');
        System.assertEquals('Jane Smith Updated', updatedInstaller2.Name, 'Installer name for Employee 2 should be updated');
        System.assertEquals('2222222222', updatedInstaller2.Phone__c, 'Installer phone for Employee 2 should be updated');
    }
}