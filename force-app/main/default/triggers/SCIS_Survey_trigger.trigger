trigger SCIS_Survey_trigger on Survey__c (before insert,before update) {
    if(trigger.isBefore && ( trigger.isUpdate || trigger.isInsert) ){
        SCIS_survey_trigger_handler.changeOwnerToCoordinator(trigger.new);
    }
}