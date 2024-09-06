public class InstallerHandler {
    public static void syncInstallerToEmployee(List<Installer__c> newInstallers) {
        List<Employee__c> employeesToUpdate = new List<Employee__c>();
        
        for (Installer__c installer : newInstallers) {
            try {
                String empId = installer.Employee2__c;
                System.debug('Processing Installer ID: ' + installer.Id + ' with Employee2__c: ' + empId);

                if (empId != null) {
                    List<Employee__c> employees = [SELECT Id, Email__c, Personnel_Mobile_Number__c 
                                                   FROM Employee__c 
                                                   WHERE Id = :empId LIMIT 1];

                    System.debug('Queried Employees: ' + employees);
                    if (!employees.isEmpty()) {
                        Employee__c employee = employees[0];
                        System.debug('Found Employee: ' + employee.Id);

                        // Update fields in the Employee record
                        employee.Email__c = installer.Email__c;
                        employee.Personnel_Mobile_Number__c = installer.Phone__c;
                        employeesToUpdate.add(employee);
                    } else {
                        System.debug('No Employee found for Installer ID: ' + installer.Id);
                    }
                } else {
                    System.debug('Installer does not have an Employee2__c value: ' + installer.Id);
                }
            } catch (QueryException e) {
                System.debug('QueryException occurred for Installer ID: ' + installer.Id + ' - ' + e.getMessage());
            }
        }

        // Update Employee records
        if (!employeesToUpdate.isEmpty()) {
            try {
                update employeesToUpdate;
                System.debug('Updated Employee records: ' + employeesToUpdate);
            } catch (DmlException e) {
                System.debug('DmlException occurred: ' + e.getMessage());
            }
        } else {
            System.debug('No Employee records to update');
        }
    }
}