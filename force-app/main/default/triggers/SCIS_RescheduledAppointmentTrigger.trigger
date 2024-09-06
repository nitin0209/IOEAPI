/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   12-06-2024
Trigger Name            :   SCIS_RescheduledAppointmentTrigger
TestClass Name          :   SCIS_RescheduledAppointmentTriggerTest
Connected Class         :   
@Description            :   This trigger execute when update the status of Install lead as rescheduled.
Last Modification Date  :   12-06-2024
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

trigger SCIS_RescheduledAppointmentTrigger on Appointment__c (after update) {
 // Collect the updated appointments
    List<Appointment__c> updatedAppointments = Trigger.new;
    Map<Id, Appointment__c> oldAppointmentMap = Trigger.oldMap;

    // Call the method to handle rescheduled appointments
    SCIS_Installer_Rescheduled_Appointment.handleAfterUpdate(updatedAppointments, oldAppointmentMap);
}