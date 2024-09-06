trigger installerUpdate on Installer__c (After Update) {
    
    
    
    If(Trigger.IsAfter && Trigger.IsUpdate){

        InstallerUpdateHandler.employeeUpdation(Trigger.new , Trigger.oldMap);
        
    }
}