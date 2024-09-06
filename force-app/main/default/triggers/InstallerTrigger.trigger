trigger InstallerTrigger on Installer__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            InstallerHandler.syncInstallerToEmployee(Trigger.new);
        }
    }
}