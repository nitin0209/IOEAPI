/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   25-01-2024
Trigger Name            :   SCIS_EquipmentTrigger
TestClass Name          :   SCIS_EquipmentTriggerTest
Connected Class         :   
Description             :   This trigger is used to connect equipment with floor,room. This trigger process information received from API.
Last Modification Date  :   25-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

trigger SCIS_EquipmentTrigger on Equipment__c (before insert,before update) {
    if(trigger.isbefore && trigger.isInsert){
        system.debug('Trigger started for insert ');
        //SCIS_EquipmentTriggerHelper.attachEquipmentToRoom(trigger.new);
        SCIS_EquipmentTriggerHelper.attachEquipment(trigger.new);
    }
    
    if(trigger.isbefore && trigger.isUpdate){
        //SCIS_EquipmentTriggerHelper.attachEquipmentToRoom(trigger.old);
        SCIS_EquipmentTriggerHelper.attachEquipment(trigger.new);
        system.debug('Trigger started for update ');
    }
}