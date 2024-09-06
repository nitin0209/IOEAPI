@isTest
public class EmployeeHandlerTest {

    @isTest
    static void testHandleEmployeeInsert() {
        // Create a test company
        Company__c testCompany = new Company__c(
            Name = 'SCIS',
            Is_Installer__c = true,
            Working_Area__c = 'HA',
            Email__c = 'scis@gmail.com',
            Phone_Number__c = '7208147489',
            compnay_registration_number__c = 'abc - 111',
            Company_Type__c = 'Installer',
            Joining_Date__c = Date.newInstance(2024, 6, 3)
        );
        insert testCompany;
        
        // Create test employee data with unique values
        Employee__c emp1 = new Employee__c(
            Is_Installer__c = true,
            Name = 'John Doe', 
            Employee_Type__c = 'Lead Installer', 
            Email__c = 'john.doe@example.com', 
            Personnel_Mobile_Number__c = '1234567890',
            Employee_Start_Date__c = System.today().addDays(-1), 
            Last_Date__c = System.today().addDays(1),
            NI_Number__c = 'AA586846C',
            Company__c = testCompany.Id,  
            Date_of_Birth__c = Date.newInstance(1990, 1, 1), 
            Employee_ID__c = 'EMP001',  
            Status__c = 'Active', 
            Working_Area__c = 'HA', 
            Working_Post_Town__c = 'HA',
            Company_Mobile_Number__c = '1234567890'
        );

        Test.startTest();
        // Insert employees to trigger the before insert logic
        insert emp1;
        Test.stopTest();
        
        // Verify that Installer records were created
        List<Installer__c> installers = [SELECT Id, Name, Email__c, Phone__c, Employee__c, Role__c FROM Installer__c];
        
        System.assertEquals(1, installers.size(), 'One Installer record should be created.');
        System.assertEquals('John Doe', installers[0].Name);
        System.assertEquals('Lead Installer', installers[0].Role__c);
    }

    // Add other test methods as needed for update, delete, status change scenarios
    @isTest
    static void testHandleEmployeeUpdate() {
        
          Company__c testCompany = new Company__c(
            Name = 'SCIS',
            Is_Installer__c = true,
            Working_Area__c = 'HA',
            Email__c = 'scis@gmail.com',
            Phone_Number__c = '7208147489',
            compnay_registration_number__c = 'abc - 111',
            Company_Type__c = 'Installer',
            Joining_Date__c = Date.newInstance(2024, 6, 3)
        );
        insert testCompany;
        // Retrieve test employees
 Employee__c emp1 = new Employee__c(
            Is_Installer__c = true,
            Name = 'John Doe', 
            Employee_Type__c = 'Lead Installer', 
            Email__c = 'john.doe@example.com', 
            Personnel_Mobile_Number__c = '1234567890',
            Employee_Start_Date__c = System.today().addDays(-1), 
            Last_Date__c = System.today().addDays(1),
            NI_Number__c = 'AA586846C',
            Company__c = testCompany.Id,  
            Date_of_Birth__c = Date.newInstance(1990, 1, 1), 
            Employee_ID__c = 'EMP001',  
            Status__c = 'Active', 
            Working_Area__c = 'HA', 
            Working_Post_Town__c = 'HA',
            Company_Mobile_Number__c = '1234567890'
        );
        insert emp1;
        List<Employee__c> listEMp= new list<Employee__c>();

        // Update test employees
        
            emp1.Email__c = 'example33@gmail.com.com';
            emp1.Personnel_Mobile_Number__c = '9999999999';
        listEMp.add(emp1);
        update emp1;
        
        // Call the handleEmployeeUpdate method
        Test.startTest();
        EmployeeHandler.handleEmployeeUpdate(listEMp);
        Test.stopTest();

}
}