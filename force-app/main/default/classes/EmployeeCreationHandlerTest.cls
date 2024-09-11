@isTest
public class EmployeeCreationHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create a test Company__c record dynamically, ensuring it meets the lookup filter criteria for Employee__c
        Company__c company = new Company__c(
            Name = 'Test Company',
            Company_Type__c = 'Installer',  // Ensure this matches the filter criteria in Employee__c
            Email__c = 'company@test.com', 
            Phone_Number__c = '1234567890', 
            Working_Area__c = 'HA', 
            compnay_registration_number__c = '123456'
           // Status__c = 'Active'  // Assuming the Company must have an active status to meet the filter criteria
        );
        insert company;
    }

    @isTest
    static void testRelatedRecordCreation_Success() {
        // Query the dynamically created company to ensure we get the correct ID
        Company__c company = [SELECT Id FROM Company__c LIMIT 1];

        // Create new Employee__c records to test related record creation
        Employee__c emp1 = new Employee__c(
            Name = 'John Doe', 
            Email__c = 'john.doe@test.com', 
            Employment_Type__c = 'Full-Time',
            Employee_Type__c = 'Lead Installer',
            Personnel_Mobile_Number__c = '1234567890',
            Company__c = company.Id,  // Use the valid company ID
            Last_Date__c = Date.newInstance(2024, 9, 9),
            Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
            Status__c = 'Active', 
            Working_Area__c = 'HA'
        );

        Employee__c emp2 = new Employee__c(
            Name = 'Jane Smith', 
            Email__c = 'jane.smith@test.com', 
            Employment_Type__c = 'Full-Time',
            Employee_Type__c = 'Surveyor',
            Personnel_Mobile_Number__c = '1234567890',
            Company__c = company.Id,  // Use the valid company ID
            Last_Date__c = Date.newInstance(2024, 9, 9),
            Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
            Status__c = 'Active', 
            Working_Area__c = 'HA'
        );

        Employee__c emp3 = new Employee__c(
            Name = 'Mike Johnson', 
            Email__c = 'mike.johnson@test.com', 
            Employment_Type__c = 'Full-Time',
            Employee_Type__c = 'Assistant Installer',
            Personnel_Mobile_Number__c = '1234567890',
            Company__c = company.Id,  // Use the valid company ID
            Last_Date__c = Date.newInstance(2024, 9, 9),
            Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
            Status__c = 'Active', 
            Working_Area__c = 'HA'
        );

        List<Employee__c> employeeList = new List<Employee__c>{emp1, emp2, emp3};
        insert employeeList;

        // Simulate the trigger by calling the handler directly
        EmployeeCreationHandler handler = new EmployeeCreationHandler();

        Test.startTest();
        handler.relatedRecordCreation(employeeList);
        Test.stopTest();

        // Verify that User_Log_In_Details__c records were created
        List<User_Log_In_Details__c> userLogins = [SELECT Name, Email__c, Role__c, Employee__c FROM User_Log_In_Details__c WHERE Employee__c IN :employeeList];
        System.assertEquals(3, userLogins.size(), 'Three User_Log_In_Details__c records should be created');

        // Verify that Installer__c records were created only for the Lead Installer and Assistant Installer
        List<Installer__c> installers = [SELECT Name, Email__c, Role__c, Employee2__c FROM Installer__c WHERE Employee2__c IN :employeeList];
        System.assertEquals(2, installers.size(), 'Two Installer__c records should be created for Lead Installer and Assistant Installer');
        
        // Additional checks for each employee...
    }

    @isTest
    static void testRelatedRecordCreation_NoRelevantEmployeeType() {
        // Query the dynamically created company to ensure we get the correct ID
        Company__c company = [SELECT Id FROM Company__c LIMIT 1];

        // Create an Employee__c record that doesn't match the criteria for creating related records
        Employee__c emp = new Employee__c(
            Name = 'Chris Evans', 
            Email__c = 'chris.evans@test.com', 
            Employment_Type__c = 'Full-Time',
            Employee_Type__c = 'Social Manager',
            Personnel_Mobile_Number__c = '1234567890',
            Company__c = company.Id,  // Use the valid company ID
            Last_Date__c = Date.newInstance(2024, 9, 9),
            Employee_Start_Date__c = Date.newInstance(2024, 8, 8),
            Status__c = 'Active', 
            Working_Area__c = 'HA'
        );

        List<Employee__c> employeeList = new List<Employee__c>{emp};
        insert employeeList;

        // Simulate the trigger by calling the handler directly
        EmployeeCreationHandler handler = new EmployeeCreationHandler();

        Test.startTest();
        handler.relatedRecordCreation(employeeList);
        Test.stopTest();

        // Verify that no related User_Log_In_Details__c or Installer__c records were created
        List<User_Log_In_Details__c> userLogins = [SELECT Name FROM User_Log_In_Details__c WHERE Employee__c = :emp.Id];
        System.assertEquals(0, userLogins.size(), 'No User_Log_In_Details__c record should be created for non-matching employee type');

        List<Installer__c> installers = [SELECT Name FROM Installer__c WHERE Employee__c = :emp.Id];
        System.assertEquals(0, installers.size(), 'No Installer__c record should be created for non-matching employee type');
    }
}