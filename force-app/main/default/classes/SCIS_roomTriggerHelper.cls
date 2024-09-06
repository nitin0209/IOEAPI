/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   20-01-2024
Trigger Name            :   SCIS_roomTriggerHelper
TestClass Name          :   SCIS_roomTriggerHelperTest
Connected Class         :   
@Description            :   This trigger is used to connect room with floor. This trigger process information received from API.
							* @param roomList The list of room records for which the floor needs to be attached.
Last Modification Date  :   20-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The SCIS_roomTriggerHelper class contains methods to assist with room-related triggers.
 */
public class SCIS_roomTriggerHelper {
    
    /**
     * Attaches the corresponding floor to the rooms based on the floor UID.
     * @param roomList The list of room records for which the floor needs to be attached.
     */
    public static void attachFloor(list<room__c> roomList){
        system.debug('Class started ! Room list from trigger = ' + roomList);
        //set<id> idSet = new set<id>();
        list<room__c> roomToAttch = new List<room__C>();
        set<string> uidSet = new set<string>();
        // Collect unique floor UIDs from the provided room records
        for(room__c room : roomList){
            uidSet.add(room.Floor_uid__c);
        }
        system.debug('uidSetfound !! = '+ uidSet);
        
        // Retrieve floor records based on the collected UIDs
        list<floor__C> floorList = new List<floor__C>();
        
        if (Schema.sObjectType.floor__C.isAccessible()) {
                floorList = [select id,name, uid__C
                                 from Floor__C
                                 where uid__C IN: uidSet];
            }
        /*
        list<floor__C> floorList = [select id,name, uid__C
                                 from Floor__C
                                 where uid__C IN: uidSet];
		*/
        system.debug('floorList !! = '+ floorList);
        // Attach floors to the corresponding rooms
        for(room__c room : roomList){
            system.debug('Entered into room loop');
            for(floor__c floor : floorList){
                system.debug('Entered into the Floor loop');
                if(room.Floor_uid__c == floor.uid__c){
                    room.Floor__c = floor.Id;
                    roomToAttch.add(room);
                    system.debug('roomToAttch');
                }else{
                    system.debug('floor id not found !!');
                }	
        	}
        }
        
    }
}