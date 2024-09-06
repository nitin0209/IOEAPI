/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   25-01-2024
Trigger Name            :   SCIS_EquipmentTriggerHelper
TestClass Name          :   
Connected Class         :   
@Description            :   This trigger is used to connect equipment with floor,room. This trigger process information received from API.
							* @param eqpList The list of equipment records to be attached to rooms.
Last Modification Date  :   25-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * Helper class for attaching equipment records to rooms.
 */
public class SCIS_EquipmentTriggerHelper {
    
    /**
     * Attaches equipment records to corresponding rooms.
     * 
     * @param eqpList The list of equipment records to be attached to rooms.
     */
    public static void attachEquipment(list<equipment__c> eqpList){
        // Debug message indicating the start of the class
        system.debug('Class started ! Equipment list from trigger = ' + eqpList);
        //set<id> idSet = new set<id>();
        // Initialize a list to store equipment records that need to be attached
        list<equipment__c> equipmentToAttch = new List<equipment__c>();
        set<string> uidSet = new set<string>();
        // Populate the set with unique room UIDs from the equipment list
        for(equipment__c eqp : eqpList){
            uidSet.add(eqp.room_uid__c);
        }
        // Initialize a list to store room records corresponding to the UIDs
        list<room__c> roomList = new List<room__c>();
        // Debug message indicating the presence of UID set
        system.debug('uidSetfound !! = '+ uidSet);
        // Check if the 'Room__c' object is accessible
        if (Schema.sObjectType.room__c.isAccessible()){
             // Query room records based on UID set
          	 roomList = [select id,name, uid__C
                                 from room__c
                                 where uid__C IN: uidSet];
        }
        /*
        list<room__c> roomList = [select id,name, uid__C
                                 from room__c
                                 where uid__C IN: uidSet];
		*/
        // Debug message indicating the retrieved room list
        system.debug('roomList !! = '+ roomList);
        // Iterate over each equipment record
        for(equipment__c eqp : eqpList){
            system.debug('Entered into eqp loop');
            // Iterate over each room record
            for(room__c room : roomList){
                system.debug('Entered into the room loop');
                // Check if equipment's room UID matches with room UID
                if(eqp.Room_Uid__c == room.uid__c ){
                    //room.Floor__c = floor.Id;
                    // Assign the room ID to equipment's room field
                    eqp.room__c = room.Id;
                    // Add equipment record to the list for attachment
                    equipmentToAttch.add(eqp);
                    system.debug('equipmentToAttch');
                }else{
                    system.debug('room id not found !!');
                }	
        	}
        }
        
    }
    
    
    
    
    /*
    public static void attachEquipmentToRoom(list<Equipment__c> eqpList){
        system.debug('Trigger executed/ entered !');
        set<string> floorUidSet = new set<string>();
        system.debug('floorUidSet '+floorUidSet);
        set<string> roomUidSet = new set<string>();
        system.debug('roomUidSet '+roomUidSet);
        list<floor__c> floorList = new list<floor__c>();
        list<room__c> roomList = new list<room__c>();
		list<Equipment__c> eqpToUpdate = new List<Equipment__c>();
        for(Equipment__c equ : eqpList){
            floorUidSet.add(equ.Floor_Uid__c);
            
            roomUidSet.add(equ.Room_Uid__c);
        }
        roomList =[select id,uid__c from room__c where Uid__c IN: roomUidSet  ];
        system.debug('roomList '+roomList);
        floorList =[select id,uid__C from floor__c where uid__c IN: floorUidSet];
        system.debug('floorList '+floorList);
        for(Equipment__c eqp : eqpList){
                for(room__c room :roomList ){
                    if(eqp.Room_Uid__c == room.uid__c ){
                        eqp.Room__c = room.Id;
                        system.debug('room id = '+ room.Id);
                        eqpToUpdate.add(eqp);
                    }
            	}
            
            
        }
        //update eqpToUpdate;
        system.debug('eqpToUpdate '+eqpToUpdate);
    } 
	*/
}