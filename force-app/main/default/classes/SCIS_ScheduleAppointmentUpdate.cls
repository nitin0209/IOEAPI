/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   
Trigger Name            :   SCIS_ScheduleAppointmentUpdate
TestClass Name          :   SCIS_ScheduleAppointmentUpdateTest
Connected Class         :   
@Description            :   * Global class responsible for scheduling appointment updates.
 							* Implements the Schedulable interface to execute scheduled updates.
							* @param sc The SchedulableContext object containing information about the schedule context.
Last Modification Date  :   
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * Global class responsible for scheduling appointment updates.
 * Implements the Schedulable interface to execute scheduled updates.
 */
global class SCIS_ScheduleAppointmentUpdate implements Schedulable  {
    /**
     * Implements the execute method required by the Schedulable interface.
     * Retrieves a list of appointments and invokes a helper method to update them.
     * @param sc The SchedulableContext object containing information about the schedule context.
     */
	global void execute(SchedulableContext sc) {
      // Initialize a list to hold appointment records
      list<appointment__C> apnList = new list<appointment__C>();
      // Query for appointment records if accessible
      if (Schema.sObjectType.appointment__C.isAccessible()) {
                apnList = [select id,name,Appointment_Type__c,Reason_For_Rescheduling__c,Reject_Reason__c,Scheduled_Date_Time__c,Scheduled_End_Date_Time__c,Lead__c,Status__c from appointment__C]; 
            }
      // apnList = [select id,name,Appointment_Type__c,Reason_For_Rescheduling__c,Reject_Reason__c,Scheduled_Date_Time__c,Scheduled_End_Date_Time__c,Lead__c,Status__c from appointment__C];  
        // Invoke the helper method to update appointments
        SCIS_AppointmentTriggerHelper.ifNotAcceptedAndEndTimeGreterThanNow(apnList);  
   }
}