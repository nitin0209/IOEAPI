public class DummyDataForEmployee {
    
    
    public void dummyData(){
       /* List<Employee__c> testemployee = new List<Employee__c>();
        Map<Id ,Employee__c> oldemp = new Map<Id ,Employee__c>();
        Employee__c emp = new Employee__c();
        emp.id = 'a1vUE000000DsH7YAK';
        emp.Name ='Sanket Test';
        emp.Email__c = 'sanketteltumbade4@gmail.com';
    
        testemployee.add(emp);
        oldemp.put(emp.id , emp);
        System.debug(emp);
        Update testemployee;
     EmployeeUpdateHandler obj = new EmployeeUpdateHandler();
     obj.relatedRecordupdation(testemployee ,oldemp);
    }
    */
        
        List<Installer__c> insta = new List<Installer__c>();
        Map<Id ,Installer__c> oldins = new Map<Id ,Installer__c>();
        
             Installer__c ins = new Installer__c();
                ins.Id = 'a1zUE000004MnkXYAS';
                ins.Email__c = 'sanketteltumbade4@gmail.com';
                ins.Phone__c = '7887370441';
               insta.add(ins);
               oldins.put(ins.id ,ins);
        Update insta;
        InstallerUpdateHandler inst = new InstallerUpdateHandler();
        inst.employeeUpdation(insta, oldins);
        
}
}