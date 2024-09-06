/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   20-01-2024
Trigger Name            :   SCIS_windows_door_Trigger
TestClass Name          :   
Connected Class         :   
Description             :   This trigger is used to connect windows and door with floor and room. 
							This trigger process information received from API.
Last Modification Date  :   20-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

trigger SCIS_windows_door_Trigger on Window_And_Door__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        SCIS_windows_door_Trigger_Helper.attachWindowAndDoor(trigger.new);
    }
}