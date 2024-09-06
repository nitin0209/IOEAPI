/**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-05-2024
Class Name 				: 	TaskTrigger
TestClass Name 			: 	TaskTriggerTest
@Description 			: 	This trigger created for extract the call logs details in custom Follow_Up_Details__c object
							and split the data in required custom fields.
Last Modification Date 	: 	
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@isTest
private class TaskTriggerTest {

    @isTest
    static void testTaskTrigger() {
        // Create a test lead
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'SCIS');
        insert testLead;

        // Create a test task with '3CX PhoneSystem Call' subject
        Task testTask = new Task(
            Subject = '3CX PhoneSystem Call',
            Description = '01/15/2024 10:30 incoming from 1234567890 to 0987654321 John Doe (45 sec)',
            WhoId = testLead.Id
        );
        insert testTask;

        // Trigger should create a Follow_Up_Details__c record based on the test task
        List<Follow_Up_Details__c> createdCallLogs = [SELECT Id, Lead_ID_Text__c, CallDateTime__c, CallType__c,
                                                      FromNumber__c, ToNumber__c, CallerName__c, 
                                                      CallDuration__c FROM Follow_Up_Details__c];
        
        // Assertions
        System.assertEquals(1, createdCallLogs.size(), 'Follow_Up_Details__c record should be created');
        Follow_Up_Details__c createdCallLog = createdCallLogs[0];
        System.assertEquals(testLead.Id, createdCallLog.Lead_ID_Text__c, 'Lead ID should match');
        // System.assertEquals('01/15/2024 10:30', String.valueOf(createdCallLog.CallDateTime__c), 'Call date and time should match');
        // System.assertEquals('incoming', createdCallLog.CallType__c, 'Call type should be incoming');
        // System.assertEquals('from 1234567890', createdCallLog.FromNumber__c, 'From number should match');
        // System.assertEquals('to 0987654321', createdCallLog.ToNumber__c, 'To number should match');
        System.assertEquals('John Doe', createdCallLog.CallerName__c, 'Caller name should match');
       // System.assertEquals(45, createdCallLog.CallDuration__c, 'Call duration should match');
    }
}