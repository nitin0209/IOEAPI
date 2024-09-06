/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   21-03-2024
Class Name	            :   SCIS_user_trigger_handler
TestClass Name          :   SCIS_user_trigger_handlerTest
Connected Class         :   
@Description            :   This class is used for handling user triggers.
							1. showErrorWhenCompanyNameNull : This method is created to show the error when Admin is trying to create
							user and if he forgets to add company_name then it will show error.
							This approach is used because, when trying to make this required from user object then it is asking for Formula and 
							set default value to this field which is not in the requirement. We cannot set default value.
Last Modification Date  :   16-05-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */

public class SCIS_user_trigger_handler {
    public static void showErrorWhenCompanyNameNull(list<user>userList){
        
        try{
            // check user access
            if(schema.sObjectType.user.isAccessible() ){
            for(user usr : userList){
            // check if Company_Name__c is null or empty
            if(usr.Company_Name__c == '' || usr.Company_Name__c == null ){
                //show error
                usr.Company_Name__c.addError('Please enter company name. Name is case sensitive.');
            	}
        	}
        }else{
            for(user usr : userList ){
                // show error if user has no access 
                usr.addError('You donot have access!');
            }
        }  
            
        }catch(exception e){
            system.debug('Error : '+ e.getMessage());
        }        
    }

}