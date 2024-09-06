/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-02-2024
Class Name 				: 	SCIS_ScheduleAppointmentUpdate
TestClass Name 			: 	SCIS_ScheduleAppointmentUpdateTest
@Description 			: 	This is test class for SCIS_ScheduleAppointmentUpdate
							* @param apnList The list of appointment records to process.
Last Modification Date 	: 	28-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */


/**
 * Test class for SCIS_ScheduleAppointmentUpdate class.
 * Provides test methods to verify the functionality of the scheduled appointment update process.
 */
@isTest
public class SCIS_ScheduleAppointmentUpdateTest {
/**
* Inner class to simulate the behavior of the appointment trigger helper.
*/
 public class MockAppointmentTriggerHelper {
     	/**
         * Simulates the behavior of the appointment trigger helper method.
         * Updates the status of appointments if certain conditions are met.
         * @param apnList The list of appointment records to process.
         */
        public void ifNotAcceptedAndEndTimeGreterThanNow(List<Appointment__c> apnList) {
            for (Appointment__c apn : apnList) {
                // Simulate the behavior of the helper method
                if (apn.Status__c != 'Accepted' && apn.Scheduled_End_Date_Time__c < DateTime.now()) {
                    apn.Status__c = 'Applied For Reschedule';
                }
            }
            // Update the list
            update apnList;
        }
    }
    /**
     * Test method to verify the functionality of the scheduled appointment update process.
     */
    @isTest
    static void testScheduleAppointmentUpdate() {
        // Create test data: appointment records
        List<Appointment__c> appointments = new List<Appointment__c>();
        // Add appointment records to the list
        // Populate appointment records with relevant data
        
        // Insert the appointment records
        insert appointments;
        
        // Schedule the job
        Test.startTest();
        String jobId = System.schedule('Test SCIS_ScheduleAppointmentUpdate', '0 0 0 15 2 ?', new SCIS_ScheduleAppointmentUpdate());
        Test.stopTest();
        
        // Assertions to ensure the job is scheduled
        System.assertNotEquals(null, jobId, 'Job should be scheduled.');
        
        // Optionally, query and verify the updated appointment records
    }
}