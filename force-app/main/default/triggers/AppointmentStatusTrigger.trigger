trigger AppointmentStatusTrigger on Appointment__c (before insert, after update, after insert) {

    if (Trigger.isAfter && Trigger.isInsert) {
        try {
            AppointmentHandler.handleAfterInsert(Trigger.new);
        } catch (Exception e) {
            System.debug('Exception in NewAppointmentTrigger: ' + e.getMessage());
        }
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        try {
            AppointmentStatusHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            DeclineStatusAppointmentHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            
            // Collect the updated appointments
            List<Appointment__c> updatedAppointments = Trigger.new;
            Map<Id, Appointment__c> oldAppointmentMap = Trigger.oldMap;

            // Call the method to handle rescheduled appointments
            SCIS_Installer_Rescheduled_Appointment.handleAfterUpdate(updatedAppointments, oldAppointmentMap);

        } catch (Exception e) {
            System.debug('Exception in AppointmentStatusTrigger: ' + e.getMessage());
        }
    }
}