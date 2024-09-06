public class InstallerUpdateHandler {

    public void employeeUpdation(List<Installer__c> newinstaller, Map<Id, Installer__c> oldInsMap) {

        Set<Id> employeeIds = new Set<Id>();
        Set<Id> userlogindetailsIds = new Set<Id>();
        Map<Id, Employee__c> empRecordsMap = new Map<Id, Employee__c>();
        Map<Id, User_Log_In_Details__c> userRecordMap = new Map<Id, User_Log_In_Details__c>();
        List<Employee__c> empRecordsToBeUpdated = new List<Employee__c>();
        List<User_Log_In_Details__c> userRecordToBeUpdated = new List<User_Log_In_Details__c>();

        if (!newinstaller.isEmpty()) {

            for (Installer__c installer : newinstaller) {

                // Checking if oldInsMap contains installer.id to avoid NullPointerException
                Installer__c oldInstaller = oldInsMap.get(installer.Id);

                if (oldInstaller != null && (installer.Email__c != oldInstaller.Email__c || installer.Phone__c != oldInstaller.Phone__c)) {
                    employeeIds.add(installer.Employee2__c);
                }
            }

            // Updating Employee records
            if (!employeeIds.isEmpty()) {
                List<Employee__c> empRecords = [SELECT Id, Email__c, Personnel_Mobile_Number__c FROM Employee__c WHERE Id IN :employeeIds];

                for (Employee__c employeerec : empRecords) {
                    empRecordsMap.put(employeerec.Id, employeerec);
                }

                for (Installer__c inst : newinstaller) {
                    Employee__c EMP = empRecordsMap.get(inst.Employee2__c);
                    if (EMP != null) {
                        EMP.Email__c = inst.Email__c;
                        EMP.Personnel_Mobile_Number__c = inst.Phone__c;
                        empRecordsToBeUpdated.add(EMP);
                    }
                }

                update empRecordsToBeUpdated;
            }

            // Updating UserLogInDetails records
            for (Installer__c install : newinstaller) {
                if (install.Email__c != oldInsMap.get(install.Id).Email__c) {
                    userlogindetailsIds.add(install.User_Log_In_Details__c);
                }
            }

            if (!userlogindetailsIds.isEmpty()) {
                List<User_Log_In_Details__c> userLoginRecords = [SELECT Id, Email__c FROM User_Log_In_Details__c WHERE Id IN :userlogindetailsIds];

                for (User_Log_In_Details__c user : userLoginRecords) {
                    userRecordMap.put(user.Id, user);
                }

                for (Installer__c inst : newinstaller) {
                    User_Log_In_Details__c ULD = userRecordMap.get(inst.Id);
                    if (ULD != null) {
                        ULD.Email__c = inst.Email__c;
                        userRecordToBeUpdated.add(ULD);
                    }
                }

                update userRecordToBeUpdated;
            }
        }
    }
}