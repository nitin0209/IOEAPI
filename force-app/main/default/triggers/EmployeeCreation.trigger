trigger EmployeeCreation on Employee__c (After Insert,After Update) {
    
    If(Trigger.IsAfter && Trigger.IsInsert){
        
        EmployeeCreationHandler.relatedRecordCreation(Trigger.new);
     }
    
    If (Trigger.IsAfter && Trigger.IsUpdate){
        
        EmployeeUpdateHandler.relatedRecordupdation(Trigger.new , Trigger.oldMap);
        
        }
}