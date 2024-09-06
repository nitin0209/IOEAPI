trigger SCIS_AppointmentTrigger on Appointment__c (before insert,before update) {
    if(trigger.isBefore && trigger.isInsert){
        SCIS_AppointmentTriggerHelper.assignSurveyorToLead(trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
        SCIS_AppointmentTriggerHelper.ifNotAcceptedAndEndTimeGreterThanNow(trigger.new);
    }
}