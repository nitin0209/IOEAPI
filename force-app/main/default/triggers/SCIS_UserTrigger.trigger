/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   02-08-2024
Trigger Name            :   SCIS_UserTrigger
TestClass Name          :   
Connected Class         :   SCIS_userTriggerHandlerClass
@Description            :   This is user trigger.
Last Modification Date  :   02-08-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */

trigger SCIS_UserTrigger on User (before insert,before update,after insert,after update) {
    
        if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
            SCIS_userTriggerHandlerClass.updateUserLoginDetails(trigger.new);
        }
    
}