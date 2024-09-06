/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   19-02-2024
Trigger Name            :   SCIS_EquipmentTriggerHelper
TestClass Name          :   SCIS_EquipmentTriggerHelper_Test
Connected Class         :   
@Description            :   This test class for SCIS_EquipmentTriggerHelper.
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * Test class for SCIS_EquipmentTriggerHelper class.
 * Ensure proper attachment of equipment records to rooms.
 */
@isTest
public class SCIS_EquipmentTriggerHelper_Test {
/**
* Test method to validate the attachEquipment method.
*/
@isTest
    static void testAttachEquipment() {
        // Test data setup
        Room__c testRoom = new Room__c(
            Name = 'Test Room',
            uid__c = 'TestRoomUID' // Replace with appropriate UID
        );
        insert testRoom;
        
        Equipment__c testEquipment = new Equipment__c(
            Name = 'Test Equipment',
            Room_uid__c = testRoom.uid__c // Ensure the equipment's room UID matches the test room's UID
            // Add other required fields if any
        );
        insert testEquipment;

        // Call the trigger helper method
        Test.startTest();
        SCIS_EquipmentTriggerHelper.attachEquipment([SELECT Id, Room_uid__c FROM Equipment__c]);
        Test.stopTest();

        // Verify that the equipment was attached to the correct room
        testEquipment = [SELECT Id, Room__c FROM Equipment__c WHERE Id = :testEquipment.Id];
        System.assertNotEquals(null, testEquipment.Room__c, 'Room should not be null');
        System.assertEquals(testRoom.Id, testEquipment.Room__c, 'Equipment should be attached to the correct room');
    }
}