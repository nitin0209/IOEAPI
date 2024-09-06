/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	10-11-2023
Class Name 				: 	SCIS_AppointmentBatch
TestClass Name 			: 	
@Description 			: 	'Salesforce class to handle batch processing of Appointment records.
							 Implements Database.Batchable and Schedulable interfaces.
							 This class is responsible for assigning surveyors to leads, checking appointment status, and updating records accordingly.
							 @param sc The SchedulableContext for the job.
     						 @param BC The BatchableContext for the job.
      						 @return The query locator for Appointment records.
							 @param apnList The list of Appointment records to process.
Last Modification Date 	: 	10-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */

//This class is responsible for assigning surveyors to leads, checking appointment status, and updating records accordingly.
public class SCIS_AppointmentBatch implements Database.Batchable<sObject>, Schedulable {

    /**
     * Invoked by the scheduler to start the batch job.
     * This method retrieves a batch of Appointment records to process.
     * @param sc The SchedulableContext for the job.
     */
    public void execute(SchedulableContext sc) {
        // Assign surveyors to leads before starting the batch job
        SCIS_AppointmentTriggerHelper.assignSurveyorToLead([SELECT Id FROM Appointment__c ]);
        // Start the batch job with a batch size of 200
        Database.executeBatch(new SCIS_AppointmentBatch(), 200); 
    }
	 /**
     * Retrieves the query locator for the batch job.
     * This method specifies the query to retrieve Appointment records for processing.
     * @param BC The BatchableContext for the job.
     * @return The query locator for Appointment records.
     */
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator('SELECT Id, Scheduled_End_Date_Time__c, Status__c, Lead__c FROM Appointment__c');
    }
	/**
     * Executes the batch job for a batch of Appointment records.
     * This method processes each Appointment record, checks status, and updates as necessary.
     * @param BC The BatchableContext for the job.
     * @param apnList The list of Appointment records to process.
     */
    public void execute(Database.BatchableContext BC, List<Appointment__c> apnList) {
        // Perform checks and updates for each Appointment record
        SCIS_AppointmentTriggerHelper.ifNotAcceptedAndEndTimeGreterThanNow(apnList);
        update apnList;
    }

    /**
     * Finalizes the batch job execution.
     * This method is invoked after all batches are processed.
     * @param BC The BatchableContext for the job.
     */
    public void finish(Database.BatchableContext BC) {
       // Any cleanup or finalization logic can be added here
    }
}