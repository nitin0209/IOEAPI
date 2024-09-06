trigger EmployeeTrigger on Employee__c (before insert, before update, after insert, after update) {
    CreateUserOnEmployeeInsert.createUserForStage1Coordinator(Trigger.New);
}