/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   20-01-2024
Trigger Name            :   SCIS_RoomTrigger
TestClass Name          :   
Connected Class         :   
Description             :   This trigger is used to connect room with floor. This trigger process information received from API.
Last Modification Date  :   20-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */



trigger SCIS_RoomTrigger on Room__c (before insert) {
    if(trigger.isInsert && trigger.isBefore){
        SCIS_roomTriggerHelper.attachFloor(trigger.new);
    }
}