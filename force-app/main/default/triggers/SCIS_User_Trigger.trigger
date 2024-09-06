/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   16-05-2024
Trigger Name            :   SCIS_User_Trigger
TestClass Name          :   SCIS_User_Trigger_Test
Connected Class         :   
@Description            :   This trigger is used for handling user triggers.
							
Last Modification Date  :   16-05-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */

trigger SCIS_User_Trigger on User (before insert) {
    if(trigger.isExecuting){
        if(trigger.isBefore && ( trigger.isInsert || trigger.isUpdate) ){
            SCIS_user_trigger_handler.showErrorWhenCompanyNameNull(trigger.new);
        }
    }
}