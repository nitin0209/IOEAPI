public class EmployeeCreationHandler {
    
    
    public void relatedRecordCreation(List<Employee__c> newemployee){
        
        
      If(!newemployee.IsEmpty()){
            
      List<User_Log_In_Details__c> userListToBeInserted = new List<User_Log_In_Details__c>();
      List<Installer__c> installerListToBeInserted = new List<Installer__c>();    
            
            For (Employee__c employee : newemployee){
 If(employee.Employment_Type__c == 'Surveyor' || employee.Employment_Type__c =='Lead Generator'|| employee.Employment_Type__c =='Lead Installer'
  || employee.Employment_Type__c =='Assistant Installer'||employee.Employment_Type__c =='Social Manager' ) {
        
               User_Log_In_Details__c newUser =new User_Log_In_Details__c();
                newUser.Name = employee.Name;
                newUser.Email__c = employee.Email__c;
                newUser.Employee__c = employee.Id;
                newUser.Role__c = employee.Employee_Type__c;
                userListToBeInserted.add(newUser);
        }        
                
    If( employee.Employment_Type__c =='Assistant Installer'|| employee.Employment_Type__c =='Lead Installer'){
                    
                      Installer__c newInstaller = new Installer__c();
                      newInstaller.Name = employee.Name ;
                      newInstaller.Role__c = employee.Employee_Type__c;
                      newInstaller.Email__c = employee.Email__c;
                      newInstaller.Employee__c = employee.Id;
                     installerListToBeInserted.add(newInstaller);
                }
                }
            
            Insert userListToBeInserted;
            Insert installerListToBeInserted;
        }
        

        
        
        
        
    }
    

}