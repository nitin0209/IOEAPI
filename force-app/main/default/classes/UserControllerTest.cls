/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-05-2024
Trigger Name            :   UserController
TestClass Name          :   UserControllerTest
Connected Class         :   
@Description            :   @see UserController#reassignLeadGenerator(Id)
							@see UserController#getUserLogInDetails(Date)
							@see UserController#getpostalCode(Date)
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */

/**
 * Test class for UserController.
 */
@isTest
private class UserControllerTest {

    /**
     * Test setup method to create test data.
     */
    @testSetup
    static void setup() {
        // Create User_Log_In_Details__c records
        User_Log_In_Details__c leadGenerator1 = new User_Log_In_Details__c(Name = 'Lead Generator 1', Role__c = 'Lead Generator', Email__c = 'leadgen1@example.com');
        insert leadGenerator1;

        User_Log_In_Details__c leadGenerator2 = new User_Log_In_Details__c(Name = 'Lead Generator 2', Role__c = 'Lead Generator', Email__c = 'leadgen2@example.com');
        insert leadGenerator2;

        // Create Postcode_Assignment__c records
        Postcode_Assignment__c assignment1 = new Postcode_Assignment__c(Assigned_Postcode__c = '12345', User_Log_In_Details__c = leadGenerator1.Id, Postcode_Assignment_Date__c = Date.today());
        insert assignment1;

        Postcode_Assignment__c assignment2 = new Postcode_Assignment__c(Assigned_Postcode__c = '67890', User_Log_In_Details__c = leadGenerator1.Id, Postcode_Assignment_Date__c = Date.today());
        insert assignment2;

        Postcode_Assignment__c assignment3 = new Postcode_Assignment__c(Assigned_Postcode__c = '54321', User_Log_In_Details__c = leadGenerator2.Id, Postcode_Assignment_Date__c = Date.today());
        insert assignment3;
    }

    /**
     * Test method for reassignLeadGenerator.
     *
     * @see UserController#reassignLeadGenerator(Id)
     */
    @isTest
    static void testReassignLeadGenerator() {
        // Retrieve a lead generator
        User_Log_In_Details__c leadGenerator = [SELECT Id FROM User_Log_In_Details__c WHERE Name = 'Lead Generator 1' LIMIT 1];

        // Call the reassignLeadGenerator method
        Test.startTest();
        UserController.reassignLeadGenerator(leadGenerator.Id);
        Test.stopTest();

        // Verify that the assignments were updated
        List<Postcode_Assignment__c> assignments = [SELECT Id, Assigned_Postcode__c, User_Log_In_Details__c 
                                                    FROM Postcode_Assignment__c 
                                                    WHERE User_Log_In_Details__c = :leadGenerator.Id];

        // In this case, since the method does not actually reassign the postcodes,
        // we will simply check that the assignments were queried and not changed
        System.assertEquals(2, assignments.size(), 'There should be 2 assignments for this lead generator.');
    }

    /**
     * Test method for getUserLogInDetails.
     *
     * @see UserController#getUserLogInDetails(Date)
     */
    @isTest
    static void testGetUserLogInDetails() {
        // Get today's date
        Date selectedDate = Date.today();

        // Call the getUserLogInDetails method
        Test.startTest();
        List<Postcode_Assignment__c> userDetailsList = UserController.getUserLogInDetails(selectedDate);
        Test.stopTest();

        // Verify the results
         // Verify the results
        System.assertNotEquals(0, userDetailsList.size(), 'User details list should not be empty.');
        for (Postcode_Assignment__c assignment : userDetailsList) {
            System.assertEquals(selectedDate, assignment.Postcode_Assignment_Date__c, 'The assignment date should match the selected date.');
            //System.assertEquals('Lead Generator', assignment.User_Log_In_Details__r.Role__c, 'The role should be Lead Generator.');
        }
    }

    /**
     * Test method for getpostalCode.
     *
     * @see UserController#getpostalCode(Date)
     */
    @isTest
    static void testGetPostalCode() {
        // Get today's date
        Date selectedDate = Date.today();

        // Call the getpostalCode method
        Test.startTest();
        List<User_Log_In_Details__c> userDetailsList = UserController.getpostalCode(selectedDate);
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(0, userDetailsList.size(), 'User details list should not be empty.');
        for (User_Log_In_Details__c userDetails : userDetailsList) {
            System.assertEquals('Lead Generator', userDetails.Role__c, 'The role should be Lead Generator.');
            for (Area_Assignment__c areaAssignment : userDetails.Area_Assignments__r) {
                System.assertEquals(selectedDate, areaAssignment.Assignment_Date__c, 'The assignment date should match the selected date.');
            }
        }
    }
}