/**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-05-2024
Class Name 				: 	LeadCallLogController
TestClass Name 			: 	LeadCallLogControllerTest
@Description 			: 	This class created for fetch the leads individual call logs details in leads separet tab.
Last Modification Date 	: 	
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

public class LeadCallLogController {
    public Lead lead { get; private set; }
    public List<Follow_Up_Details__c> callLogs { get; private set; }

    public LeadCallLogController(ApexPages.StandardController stdController) {
        this.lead = (Lead) stdController.getRecord();
        this.callLogs = getCallLogs();
    }

    private List<Follow_Up_Details__c> getCallLogs() {
        // Query the call logs for the specific lead
        return [
            SELECT CallDateTime__c, CallType__c, FromNumber__c, ToNumber__c, CallerName__c, CallDuration__c,
            CallStatus__c FROM Follow_Up_Details__c
            WHERE Lead_ID_Text__c = :lead.Id
        ];
    }
}