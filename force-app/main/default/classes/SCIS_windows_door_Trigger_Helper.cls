/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   20-01-2024
Trigger Name            :   SCIS_windows_door_Trigger_Helper
TestClass Name          :   
Connected Class         :   
@Description            :   This trigger is used to connect windows and door with floor and room. 
							This trigger process information received from API.
							* @param doorList List of Window_And_Door__c records to be processed.
Last Modification Date  :   20-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The SCIS_windows_door_Trigger_Helper class provides functionality to attach windows and doors to rooms and floors.
 * It is used as a helper class in triggers to update window and door records.
 */
public class SCIS_windows_door_Trigger_Helper {
    /**
     * Method to attach windows and doors to rooms and floors.
     * @param doorList List of Window_And_Door__c records to be processed.
     */
    public static void attachWindowAndDoor(list<Window_And_Door__c> doorList){
        // Debug message to indicate the start of the method
        system.debug('Class started ! Windows and door list from trigger = ' + doorList);
        //set<id> idSet = new set<id>();
        list<Window_And_Door__c> doorsToAttach = new List<Window_And_Door__c>();
        // Initialize sets to store unique floor and room UIDs
        set<string> floorUidSet = new set<string>();
        set<string> roomUidSet = new set<string>();
        // Iterate through doorList to populate floorUidSet and roomUidSet
        for(Window_And_Door__c door : doorList){
            floorUidSet.add(door.Floor_Uid__c);
            roomUidSet.add(door.Room_uid__c);
        }
        // Debug messages to display unique floor and room UIDs
        system.debug('floorUidSet !! = '+ floorUidSet);
        system.debug('roomUidSet !! = '+ roomUidSet);
        // Initialize lists to store room and floor records
        list<room__c> roomList = new List<room__c>();
        // Query room records based on room UIDs
        if (Schema.sObjectType.room__c.isAccessible()) {
                roomList = [select id,name, uid__C
                                 from room__C
                                 where uid__C IN: roomUidSet];
            }       
        /*
        list<room__c> roomList = [select id,name, uid__C
                                 from room__C
                                 where uid__C IN: roomUidSet];
		*/
        
        list<floor__c> floorList = new List<floor__c>();
        // Query floor records based on floor UIDs
        if (Schema.sObjectType.floor__c.isAccessible()) {
               floorList = [select id,name, uid__C
                                 from floor__c
                                 where uid__C IN: floorUidSet];
            }
        /*
        list<floor__c> floorList = [select id,name, uid__C
                                 from floor__c
                                 where uid__C IN: floorUidSet];
		*/
        system.debug('roomList !! = '+ roomList);
        // Iterate through doorList to attach rooms and floors
        for(Window_And_Door__c doors : doorList ){
            for(room__c room : roomList){
                for(floor__c floor : floorList){
                    // If the room UID and floor UID of the door match those of a room and floor record, attach them
                    if(doors.Room_uid__c == room.uid__c && doors.Floor_Uid__c == floor.uid__c){
                    doors.Room__c = room.Id;
                    doors.Floor__c = floor.Id;
                	}
                }
                
                
            }
        }
        
       
    }
}