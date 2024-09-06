public class EmployeeUpdateHandler {
    
    
    public  void relatedRecordupdation(List<Employee__c> newemployee , Map<Id,Employee__c> oldEmployee){
        
        
        If(!newemployee.IsEmpty()){
            
            Set <Id> EmployeeIds = new Set<Id> ();
            List<User_Log_In_Details__c> userLogingDetailsToBeUpdated = new List<User_Log_In_Details__c>();
            List<Installer__c> installerListToBeUpdated = new List<Installer__c>();
            
            For(Employee__c employee :newemployee){
                
                
                If(employee.Email__c != oldEmployee.get(employee.Id).Email__c || employee.Name!= oldEmployee.get(employee.Id).Name){
                    
                    EmployeeIds.add(employee.id);
                    
                    
                }
                
                //Updating user log in details email and name
                  List<User_Log_In_Details__c> userloginrecords = [SELECT Email__c ,Name FROM User_Log_In_Details__c WHERE Employee__c IN: EmployeeIds ];       

                If(!userloginrecords.IsEmpty()){
                    
                    For(User_Log_In_Details__c newUserLoginRecord :userloginrecords){
                        
                        newUserLoginRecord.Email__c =employee.Email__c;
                        newUserLoginRecord.Name = employee.Name;
                        userLogingDetailsToBeUpdated.add(newUserLoginRecord);
                    }
                    
                  
                    //Updating Installer email , name & phone number 
                    List<Installer__c> installerecords =[SELECT Email__c ,Name FROM Installer__c WHERE Employee2__c IN: EmployeeIds ];
                    
                    
                    If(!installerecords.IsEmpty()){
                           
                        For(Installer__c newInstallerRecord : installerecords){
                            
                            newInstallerRecord.Email__c =employee.Email__c;
                            newInstallerRecord.Phone__c = employee.Personnel_Mobile_Number__c;
                            newInstallerRecord.Name = employee.Name;
                            installerListToBeUpdated.add(newInstallerRecord);
                           }
          }

                }
                
        }
            Update userLogingDetailsToBeUpdated;
            Update installerListToBeUpdated;
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }

}