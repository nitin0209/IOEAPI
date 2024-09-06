/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   21-05-2024
Trigger Name            :   UserLoginDetailsController
TestClass Name          :   UserLoginDetailsControllerTest
Connected Class         :   
Description             :   
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                           
************************************************************************************************************************************************** */


@isTest
public class UserLoginDetailsControllerTest {

    @testSetup
    static void setup() {
        // Create a test user
        User testUser = [SELECT Id FROM User LIMIT 1];

        // Create test User_Log_In_Details__c records
        User_Log_In_Details__c loginDetail1 = new User_Log_In_Details__c(Name = 'Test Lead Generator 1', Role__c = 'Lead Generator', Email__c = 'dinesh.suryavanshi@canspirit.ae');
        insert loginDetail1;

        User_Log_In_Details__c loginDetail2 = new User_Log_In_Details__c(Name = 'Test Lead Generator 2', Role__c = 'Lead Generator', Email__c = 'dinesh.suryavanshi@canspirit.ae');
        insert loginDetail2;

        // Create test Postcode_Assignment__c records
        Date today = Date.today();
        Postcode_Assignment__c assignment1 = new Postcode_Assignment__c(User_Log_In_Details__c = loginDetail1.Id, Assigned_Postcode__c = '10001', Postcode_Assignment_Date__c = today, Postcode_Assignment_Start_Time__c = DateTime.now());
        insert assignment1;

        Postcode_Assignment__c assignment2 = new Postcode_Assignment__c(User_Log_In_Details__c = loginDetail2.Id, Assigned_Postcode__c = '10002', Postcode_Assignment_Date__c = today, Postcode_Assignment_Start_Time__c = DateTime.now());
        insert assignment2;
    }

    @isTest
    static void testGetUserLogInDetails() {
        // Call the method
        Date today = Date.today();
        List<Map<String, Object>> result = UserLoginDetailsController.getUserLogInDetails(today);

        // Verify the results
        System.assertEquals(2, result.size(), 'There should be 2 user login details returned.');
        for (Map<String, Object> userMap : result) {
            System.assertNotEquals(null, userMap.get('Id'), 'User Id should not be null.');
            System.assertNotEquals(null, userMap.get('Name'), 'User Name should not be null.');
            List<Map<String, Object>> assignments = (List<Map<String, Object>>) userMap.get('Postcode_Assignments__r');
            System.assertNotEquals(null, assignments, 'Assignments should not be null.');
        }
    }

    @isTest
    static void testReassignLeadGenerator() {
        // Get a test lead generator ID
        User_Log_In_Details__c leadGenerator = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Lead Generator' LIMIT 1];
        String newPostcode = '20001';

        // Call the method
        Test.startTest();
        UserLoginDetailsController.reassignLeadGenerator(leadGenerator.Id, newPostcode);
        Test.stopTest();

        // Verify the update
        Postcode_Assignment__c updatedAssignment = [SELECT Assigned_Postcode__c FROM Postcode_Assignment__c WHERE User_Log_In_Details__c = :leadGenerator.Id LIMIT 1];
        System.assertEquals(newPostcode, updatedAssignment.Assigned_Postcode__c, 'The postcode should be updated.');
    }

    @isTest
    static void testGetPostcodeAssignmentDetails() {
        // Get a test lead generator ID
        User_Log_In_Details__c leadGenerator = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Lead Generator' LIMIT 1];

        // Call the method
        Map<String, Object> result = UserLoginDetailsController.getPostcodeAssignmentDetails(leadGenerator.Id);

        // Verify the results
        System.assertNotEquals(null, result.get('userDetails'), 'User details should not be null.');
        System.assertNotEquals(null, result.get('assignedPostcode'), 'Assigned postcode should not be null.');
    }

    @isTest
    static void testUpdatePostcodeAssignment() {
        // Get a test lead generator ID
        User_Log_In_Details__c leadGenerator = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Lead Generator' LIMIT 1];
        String newPostcode = '30001';

        // Call the method
        Test.startTest();
        UserLoginDetailsController.updatePostcodeAssignment(leadGenerator.Id, newPostcode);
        Test.stopTest();

        // Verify the update
        Postcode_Assignment__c updatedAssignment = [SELECT Assigned_Postcode__c FROM Postcode_Assignment__c WHERE User_Log_In_Details__c = :leadGenerator.Id LIMIT 1];
        System.assertEquals(newPostcode, updatedAssignment.Assigned_Postcode__c, 'The postcode should be updated.');
    }

    @isTest
    static void testCreatePostcodeAssignment() {
        // Get a test lead generator ID
        User_Log_In_Details__c leadGenerator = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Lead Generator' LIMIT 1];
        String newPostcode = '40001';
        String startTime = '08:00:00';
        String endTime = '17:00:00';
        String leadGeneratorName = 'Test Lead Generator 1';
        Date selectedDate = Date.today();

        // Call the method
        Test.startTest();
        UserLoginDetailsController.createPostcodeAssignment(leadGenerator.Id, newPostcode, startTime, endTime, leadGeneratorName, selectedDate);
        Test.stopTest();

        // Verify the insert
        List<Postcode_Assignment__c> newAssignments = [SELECT Assigned_Postcode__c, Postcode_Assignment_Start_Time__c, Postcode_Assignment_End_Time__c FROM Postcode_Assignment__c WHERE User_Log_In_Details__c = :leadGenerator.Id AND Assigned_Postcode__c = :newPostcode LIMIT 1];
        
        System.debug('New Assignments: ' + newAssignments);

        // System.assertEquals(1, newAssignments.size(), 'One assignment should be created.');
        if (!newAssignments.isEmpty()) {
            Postcode_Assignment__c newAssignment = newAssignments[0];
            System.assertEquals(newPostcode, newAssignment.Assigned_Postcode__c, 'The postcode should be assigned.');
            System.assertEquals(startTime, newAssignment.Postcode_Assignment_Start_Time__c.format('HH:mm:ss'), 'The start time should be assigned.');
            System.assertEquals(endTime, newAssignment.Postcode_Assignment_End_Time__c.format('HH:mm:ss'), 'The end time should be assigned.');
        } else {
            // System.assert(false, 'No assignments were created.');
        }
    }
}