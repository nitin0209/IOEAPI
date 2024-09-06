public class EmployeeHandler {
    public static void handleEmployeeInsert(List<Employee__c> newEmployees) {
        Set<Id> processedEmployeeIds = new Set<Id>();
        List<Installer__c> installersToInsert = new List<Installer__c>();
        //list<Employee__c> empList = new list<Employee__c>();
        set<id> empIdSet = new set<id>();
        for(Employee__c emp  : newEmployees){
            empIdSet.add(emp.Id);
        }
        
        
        System.debug('Entering handleEmployeeInsert method');
        
        for (Employee__c emp : newEmployees) {
            // Check if the Employee record hasn't been processed in this transaction
            if (!processedEmployeeIds.contains(emp.Id)) {
                if (emp.Employee_Type__c == 'Lead Installer' || emp.Employee_Type__c == 'Assistant Installer') {
                    System.debug('Creating Installer record for Employee: ' + emp.Name);
                    Installer__c installer = new Installer__c();
                    installer.Employee2__c = emp.Id; 
                    installer.Name = emp.Name; 
                    installer.Email__c = emp.Email__c; 
                    installer.Phone__c = emp.Personnel_Mobile_Number__c;
                    installer.Role__c = emp.Employee_Type__c;
                    installer.Installer_Working_Area__c= emp.Working_Area__c;
                   

                    /*
                    // To check related user exists
                    List<User> userDetails = [SELECT Id FROM User_Log_In_Details__c WHERE ContactId = :emp.Id LIMIT 1];
                    if (!userDetails.isEmpty()) {
                        installer.User_Log_In_Details__c = userDetails[0].Id;
                    }
					*/
                    installersToInsert.add(installer);
                }
                // Add the Employee record ID to the processed set
                processedEmployeeIds.add(emp.Id);
            }
        }
        
        list<User_Log_In_Details__c> userLogInList = new list<User_Log_In_Details__c>();
        userLogInList = [select id,employee__C from User_Log_In_Details__c where employee__C IN: empIdSet ];
        list<Installer__c> installerList = new list<Installer__c>();
        installerList = [select id, employee__c from Installer__c where employee__c IN: empIdSet ];
        
        
        if (!installersToInsert.isEmpty()) {
            System.debug('Inserting Installer records');
            
            //insert installersToInsert;  
        } else {
            System.debug('No Installer records to insert');
        }
    }
    
    public static void handleEmployeeUpdate(List<Employee__c> updatedEmployees) {
        System.debug('Entering handleEmployeeUpdate method');
        
        Set<Id> processedEmployeeIds = new Set<Id>();
        for (Employee__c emp : updatedEmployees) {
            processedEmployeeIds.add(emp.Id);
        }
        
        List<Installer__c> updateInstaller = new List<Installer__c>();
        
        List<Employee__c> empData = [SELECT Id, Name, Email__c, Personnel_Mobile_Number__c, Employee_Type__c 
                                     FROM Employee__c 
                                     WHERE Id IN :processedEmployeeIds 
                                     AND (Employee_Type__c = 'Lead Installer' OR Employee_Type__c = 'Assistant Installer')];
        
        if (!empData.isEmpty()) {
            List<Installer__c> getInstaller = [SELECT Id, Name, Email__c, Phone__c, Employee2__c 
                                               FROM Installer__c 
                                               WHERE Employee2__c IN :processedEmployeeIds];
            
            if (getInstaller.size() > 0) {
                for (Installer__c inst : getInstaller) {
                    for (Employee__c emp : empData) {
                        if (inst.Employee2__c == emp.Id) {
                            inst.Name = emp.Name; 
                            inst.Email__c = emp.Email__c; 
                            inst.Phone__c = emp.Personnel_Mobile_Number__c;
                            
                            // To check usr records exist or not
                            List<User> userDetails = [SELECT Id FROM User WHERE ContactId = :emp.Id LIMIT 1];
                            if (!userDetails.isEmpty()) {
                                inst.User_Log_In_Details__c = userDetails[0].Id;
                            }

                            updateInstaller.add(inst);
                        }
                    }
                }
            }
        }
        
        if (!updateInstaller.isEmpty()) {
            System.debug('Updating Installer records');
            update updateInstaller;  
        } else {
            System.debug('No Installer records to update');
        }
    }
}