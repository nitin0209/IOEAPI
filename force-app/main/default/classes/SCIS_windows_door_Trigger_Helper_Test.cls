/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-02-2024
Trigger Name            :   SCIS_windows_door_Trigger_Helper
TestClass Name          :   SCIS_windows_door_Trigger_Helper_Test
Connected Class         :   
@Description            :   This test class for SCIS_windows_door_Trigger_Helper.
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The SCIS_windows_door_Trigger_Helper_Test class provides unit tests for the SCIS_windows_door_Trigger_Helper class.
 * It tests the functionality of the attachWindowAndDoor method.
 */
@isTest
public class SCIS_windows_door_Trigger_Helper_Test {

    /**
     * Method to test the attachWindowAndDoor functionality.
     * It verifies that a door is attached to the correct room and floor.
     */
    @isTest
    static void testAttachWindowAndDoor() {
        // Test data setup
        // Create a test floor
        Floor__c testFloor = new Floor__c(
            Name = 'Test Floor',
            uid__c = 'TestFloorUID' // Replace with appropriate UID
        );
        insert testFloor;
        // Create a test room associated with the test floor
        Room__c testRoom = new Room__c(
            Name = 'Test Room',
            Floor_uid__c = testFloor.uid__c // Ensure the room's floor UID matches the test floor's UID
            // Add other required fields if any
        );
        insert testRoom;
        // Create a test door associated with the test room and floor
        Window_And_Door__c testDoor = new Window_And_Door__c(
            Name = 'Test Door',
            Room_uid__c = testRoom.uid__c, // Ensure the door's room UID matches the test room's UID
            Floor_Uid__c = testFloor.uid__c // Ensure the door's floor UID matches the test floor's UID
            // Add other required fields if any
        );
        insert testDoor;

        // Call the trigger helper method
        Test.startTest();
        SCIS_windows_door_Trigger_Helper.attachWindowAndDoor(new List<Window_And_Door__c>{testDoor});
        Test.stopTest();

        // Verify that the door was attached to the correct room and floor
        testDoor = [SELECT Id, Room__c, Floor__c FROM Window_And_Door__c WHERE Id = :testDoor.Id];
        System.assertNotEquals(null, testDoor.Room__c, 'Room should not be null');
        System.assertNotEquals(null, testDoor.Floor__c, 'Floor should not be null');
        System.assertEquals(testRoom.Id, testDoor.Room__c, 'Door should be attached to the correct room');
        System.assertEquals(testFloor.Id, testDoor.Floor__c, 'Door should be attached to the correct floor');
    }
}