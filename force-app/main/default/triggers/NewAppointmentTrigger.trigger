trigger NewAppointmentTrigger on Appointment__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        try {
            //AppointmentHandler.handleAfterInsert(Trigger.new);
        } catch (Exception e) {
            System.debug('Exception in NewAppointmentTrigger: ' + e.getMessage());
        }
    }
}