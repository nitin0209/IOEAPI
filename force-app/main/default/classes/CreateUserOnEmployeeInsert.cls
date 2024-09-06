public class CreateUserOnEmployeeInsert {

    @future
    public static void createUserAsync(List<Id> employeeIds) {
        List<User> usersToCreate = new List<User>();

        // Query the Employee__c records
        List<Employee__c> employees = [
            SELECT Id, Name, Email__c, Employee_Type__c, Company_Name__c 
            FROM Employee__c 
            WHERE Id IN :employeeIds
        ];
        
        System.debug('Queried Employees: ' + employees);

        for (Employee__c emp : employees) {
            String profileName;
            String userRoleName;

            System.debug('Processing Employee: ' + emp.Name + ', Employee_Type__c: ' + emp.Employee_Type__c);

 
            switch on emp.Employee_Type__c {
                when 'Stage 1 Coordinator' {
                    profileName = 'SCIS Stage 1 Coordinator';
                    userRoleName = 'Stage 1 Coordinator';
                }
                when 'Sales Manager' {
                    profileName = 'Warmfront Sales Manager V2';
                    userRoleName = 'Sales Manager';
                }
                when 'HR' {
                    profileName = 'SCIS_HR';
                    userRoleName = 'HR';
                }
                when 'Lead Assistant' {
                    profileName = 'Lead Assistant V10';
                    userRoleName = 'Lead Assistant';
                }
                when 'Coordinator Manager' {
                    profileName = 'SCIS Coordinator Manager';
                    userRoleName = 'Coordinator Manager';
                }
                when else {
                    System.debug('Skipping Employee: ' + emp.Name + ' with Employee_Type__c: ' + emp.Employee_Type__c);
                    continue; 
                }
            }

            System.debug('Employee: ' + emp.Name + ', ProfileName: ' + profileName + ', UserRoleName: ' + userRoleName);

            
            Id profileId;
            try {
                profileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
                System.debug('Profile ID found: ' + profileId + ' for ProfileName: ' + profileName);
            } catch (Exception e) {
                System.debug('Profile "' + profileName + '" not found for Employee: ' + emp.Name);
                continue; 
            }

        
            Id userRoleId;
            try {
                userRoleId = [SELECT Id FROM UserRole WHERE Name = :userRoleName LIMIT 1].Id;
                System.debug('UserRole ID found: ' + userRoleId + ' for UserRoleName: ' + userRoleName);
            } catch (Exception e) {
                System.debug('UserRole "' + userRoleName + '" not found for Employee: ' + emp.Name);
                continue; 
            }

        
            String aliasName = (emp.Name.length() >= 8) ? emp.Name.substring(0, 8) : emp.Name;

            System.debug('Creating User record for Employee: ' + emp.Name);

            User newUser = new User(
                //FirstName = emp.Name,
                LastName = emp.Name,  
                Username = emp.Email__c + '.coord', 
                Email = emp.Email__c,
                Alias = aliasName,
                ProfileId = profileId,  
                TimeZoneSidKey = 'Africa/Bissau', 
                LocaleSidKey = 'en_GB', 
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US', 
                UserRoleId = userRoleId, 
               // Working_Area__c = emp.Working_Area__c,
                Company_Name__c = emp.Company_Name__c 
            );

            System.debug('User record created: ' + newUser);
            usersToCreate.add(newUser);
        }

        System.debug('Total Users to create: ' + usersToCreate.size());

       
        if (!usersToCreate.isEmpty()) {
            try {
                insert usersToCreate;
                System.debug('Users successfully inserted: ' + usersToCreate);
            } catch (DmlException e) {
                System.debug('Error creating Users: ' + e.getMessage());
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    System.debug('DML Index: ' + i + ', Status Code: ' + e.getDmlStatusCode(i) + ', Message: ' + e.getDmlMessage(i));
                }
            }
        } else {
            System.debug('No Users to insert.');
        }
    }

    public static void createUserForStage1Coordinator(List<Employee__c> employees) {
        List<Id> employeeIds = new List<Id>();
        
        for (Employee__c emp : employees) {
            if (emp.Employee_Type__c != null) {
                employeeIds.add(emp.Id);
            } else {
                System.debug('Employee ' + emp.Name + ' has a null Employee_Type__c and will be skipped.');
            }
        }

        System.debug('Employee IDs to process: ' + employeeIds);
        
        if (!employeeIds.isEmpty()) {
            createUserAsync(employeeIds); 
        } else {
            System.debug('No Employee IDs to process.');
        }
    }
}