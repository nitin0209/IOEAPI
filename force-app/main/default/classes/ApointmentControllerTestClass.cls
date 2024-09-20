@IsTest
public class ApointmentControllerTestClass {
    //Creates the necessary data for testing the controller methods (Survey, Appointment, Employee, etc.).
    @TestSetup
    static void setupData() {
        // Create test data for Survey__c
        Survey__c survey = new Survey__c(
            Name = 'Test Survey',
            Does_this_property_require_Prep_Work__c = 'Yes',
            What_kind_of_prep_work_is_needed__c = null // Testing the validation
        );
        insert survey;

        // Create test data for Employee__c and User_Log_In_Details__c
        Employee__c employee = new Employee__c(
            Name = 'Test Employee',
            Employee_Type__c = 'Contractor',
            Contractor_type__c = 'Electrician',
            Is_contractor__c = true
        );
        insert employee;

        User_Log_In_Details__c loginDetail = new User_Log_In_Details__c(
            Name = 'Test Login Detail',
            Employee__c = employee.Id,
            Is_contractor__c = true
        );
        insert loginDetail;

        // Create test data for Lead
        Lead lead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company'
        );
        insert lead;
        
        // Create test data for Appointment__c
        Appointment__c appointment = new Appointment__c(
            Name = 'Test Appointment',
            Surveyor__c = loginDetail.Id,
            Scheduled_Date_Time__c = DateTime.now().addDays(1),
            Scheduled_End_Date_Time__c = DateTime.now().addDays(1).addHours(2)
        );
        insert appointment;
    }

    @IsTest
    static void testValidatePrepWorkMandatory() {
        List<Survey__c> surveys = [SELECT Id, Name, Does_this_property_require_Prep_Work__c, What_kind_of_prep_work_is_needed__c FROM Survey__c];

        Test.startTest();
        try {
            SCISAppointmentController.validatePrepWorkMandatory(surveys);
            System.assert(false, 'Expected an exception for missing prep work');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('The field "What kind of prep work is needed" is mandatory'));
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetPrepWorkStatus() {
        Survey__c survey = [SELECT Id FROM Survey__c LIMIT 1];

        Test.startTest();
        String prepWorkStatus = SCISAppointmentController.getPrepWorkStatus(survey.Id);
        Test.stopTest();

        System.assertEquals('Yes', prepWorkStatus, 'Prep work status should be Yes');
    }

    @IsTest
    static void testGetEmployeesForPrepWork() {
        Test.startTest();
        List<User_Log_In_Details__c> employees = SCISAppointmentController.getEmployeesForPrepWork('Electrician');
        Test.stopTest();

        System.assertNotEquals(0, employees.size(), 'Expected at least one contractor for the given type');
    }

    @IsTest
    static void testCreateAppointment() {
        Survey__c survey = [SELECT Id FROM Survey__c LIMIT 1];
        User_Log_In_Details__c loginDetail = [SELECT Id FROM User_Log_In_Details__c LIMIT 1];

        Test.startTest();
        try {
            String result = SCISAppointmentController.createAppointment('Electrician', DateTime.now().addDays(2), DateTime.now().addDays(2).addHours(2), survey.Id, loginDetail.Id);
            System.assert(result.contains('created successfully'), 'Appointment creation failed');
        } catch (Exception e) {
            System.assert(false, 'No exception should be thrown: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetPicklistValues() {
        Test.startTest();
        List<String> picklistValues = SCISAppointmentController.getPicklistValues('Survey__c', 'Does_this_property_require_Prep_Work__c');
        Test.stopTest();

        System.assert(picklistValues.size() > 0, 'Picklist values should not be empty');
    }
}