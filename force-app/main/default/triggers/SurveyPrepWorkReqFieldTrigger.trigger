trigger SurveyPrepWorkReqFieldTrigger on Survey__c (before insert, before update) {
    AppointmentController.validatePrepWorkMandatory(Trigger.new);
}