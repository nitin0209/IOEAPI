/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	01-02-2024
Class Name 				: 	SCIS_AppointmentTriggerHelper
TestClass Name 			: 	SCIS_AppointmentTriggerHelperTest
@Description 			: 	This trigger handler class is used to update Appointment status.
							@param apnList The list of Appointment__c records for which surveyors need to be assigned.
Last Modification Date 	: 	08-02-2024
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */
/**
 * Helper class containing methods to assist with appointment triggers.
 * This class provides functionality to assign surveyors to leads and manage appointment status.
 */
public class SCIS_AppointmentTriggerHelper {
    public static void assignSurveyorToLead(list<appointment__C> apnList){
        /**
     * Assigns surveyors to leads based on the provided list of appointments.
     * @param apnList The list of Appointment__c records for which surveyors need to be assigned.
     */
    } 
    /**
     * Checks appointment status and updates as necessary if end time is greater than current time.
     * @param apnList The list of Appointment__c records to check and update.
     */
    public static void ifNotAcceptedAndEndTimeGreterThanNow(list<appointment__C> apnList){
        
        list<lead> leadList = new list<lead>();
        // Set to hold lead Ids for appointment records needing status updates
        set<id> leadIdSet = new set<id>();
        // Iterate through the provided appointment list
        for(appointment__C apn : apnList){
            // Check if appointment end time is earlier than current time and status is 'Accepted'
            if(apn.Scheduled_End_Date_Time__c < system.now() && apn.Status__c == 'Accepted'){
                // Update appointment status to 'Applied For Reschedule'
                apn.Status__c = 'Applied For Reschedule';
                // Add lead Id to the set for status update
                leadIdSet.add(apn.Lead__c);
            }
             // Check if appointment end time is earlier than current time and status is 'Survey In-Progress'
            if(apn.Scheduled_End_Date_Time__c < system.now() && apn.Status__c == 'Survey In-Progress'){
                 // Update appointment status to 'Survey Incomplete'
                apn.Status__c = 'Survey Incomplete';
            }
        }
    }
}