/**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-05-2024
Class Name 				: 	LeadCallLogController
TestClass Name 			: 	LeadCallLogControllerTest
@Description 			: 	
Last Modification Date 	: 	
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

@isTest
private class LeadCallLogControllerTest {
    @isTest
    static void testLeadCallLogController() {
        // Create a test lead
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'SCIS');
        insert testLead;

        // Create test call logs related to the test lead
        List<Follow_Up_Details__c> testCallLogs = new List<Follow_Up_Details__c>{
            new Follow_Up_Details__c(
                Lead_ID_Text__c = testLead.Id,
                CallDateTime__c = System.now(),
                CallType__c = 'Incoming',
                FromNumber__c = '1234567890',
                ToNumber__c = '0987654321',
                CallerName__c = 'John Doe',
                CallDuration__c = '30',
                CallStatus__c = 'Answered'
            )
            // Add more test call logs as needed
        };
        insert testCallLogs;

        // Instantiate the controller with the test lead
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
        LeadCallLogController controller = new LeadCallLogController(stdController);
        Test.stopTest();

        // Verify that the controller's lead property is set correctly
        System.assertEquals(testLead.Id, controller.lead.Id, 'Controller lead should match test lead');

        // Verify that the controller's callLogs property contains the expected call logs
        List<Follow_Up_Details__c> expectedCallLogs = [
            SELECT CallDateTime__c, CallType__c, FromNumber__c, ToNumber__c, CallerName__c, CallDuration__c, CallStatus__c
            FROM Follow_Up_Details__c
            WHERE Lead_ID_Text__c = :testLead.Id
        ];
        System.assertEquals(expectedCallLogs.size(), controller.callLogs.size(), 'Number of call logs should match');
        for (Integer i = 0; i < expectedCallLogs.size(); i++) {
            Follow_Up_Details__c expectedCallLog = expectedCallLogs[i];
            Follow_Up_Details__c actualCallLog = controller.callLogs[i];
            System.assertEquals(expectedCallLog.CallDateTime__c, actualCallLog.CallDateTime__c, 'Call date and time should match');
            System.assertEquals(expectedCallLog.CallType__c, actualCallLog.CallType__c, 'Call type should match');
            System.assertEquals(expectedCallLog.FromNumber__c, actualCallLog.FromNumber__c, 'From number should match');
            System.assertEquals(expectedCallLog.ToNumber__c, actualCallLog.ToNumber__c, 'To number should match');
            System.assertEquals(expectedCallLog.CallerName__c, actualCallLog.CallerName__c, 'Caller name should match');
            System.assertEquals(expectedCallLog.CallDuration__c, actualCallLog.CallDuration__c, 'Call duration should match');
            System.assertEquals(expectedCallLog.CallStatus__c, actualCallLog.CallStatus__c, 'Call status should match');
        }
    }
}