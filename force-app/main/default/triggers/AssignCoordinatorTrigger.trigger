/*
trigger AssignCoordinatorTrigger on Appointment__c (Before Insert, After Insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        System.debug('Before insert context');
        // RoundRobinCoordinator.assignCoordinator(Trigger.new, false);
        // AppointmentTriggerHandler.handleAfterInsert(trigger.new);
        AppointmentTriggerHandler.handleBeforeInsert(Trigger.new);
        
    } else if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('After insert context');
        // AppointmentTriggerHandler.handleAfterInsert(trigger.new);
        // RoundRobinCoordinator.assignCoordinator(Trigger.new, true);
        
        // Collect leave appointments
        List<Appointment__c> leaveAppointments = new List<Appointment__c>();
        for (Appointment__c appointment : Trigger.new) {
            if (appointment.Appointment_Type__c == 'Leave') {
                leaveAppointments.add(appointment);
            }
        }
        
        // Call WorkloadLeaveManager only if there are leave appointments
        if (!leaveAppointments.isEmpty()) {
            WorkloadLeaveManager.handleLeaveUpdate(leaveAppointments);
        }
    }
}
*/

trigger AssignCoordinatorTrigger on Appointment__c (Before Insert, After Insert, Before Update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        System.debug('Before insert context');
        AppointmentTriggerHandler.handleBeforeInsert(Trigger.new);
    } else if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('After insert context');
        // Uncomment and implement if you have logic for after insert
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        System.debug('Before update context');
        AppointmentTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}