/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   19-02-2024
Trigger Name            :   SCIS_roomTriggerHelper
TestClass Name          :   SCIS_roomTriggerHelperTest
Connected Class         :   
@Description            :   This test class for SCIS_roomTriggerHelper.
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The SCIS_roomTriggerHelperTest class contains unit tests for the SCIS_roomTriggerHelper class.
 * This class verifies the functionality of attaching floors to rooms.
 */
@isTest
public class SCIS_roomTriggerHelperTest {
/**
* Tests the attachFloor method of the SCIS_roomTriggerHelper class.
* This method verifies that rooms are correctly attached to their respective floors.
*/
@isTest
    static void testAttachFloor() {
        // Test data setup
        Floor__c testFloor = new Floor__c(
            Name = 'Test Floor',
            uid__c = 'TestUID' // Replace with appropriate UID
        );
        insert testFloor;
        
        Room__c testRoom = new Room__c(
            Name = 'Test Room',
            Floor_uid__c = testFloor.uid__c // Ensure the room's floor UID matches the test floor's UID
            // Add other required fields if any
        );
        insert testRoom;
        
        // Create another floor to verify that the trigger helper handles rooms with different floor UIDs
        Floor__c anotherFloor = new Floor__c(
            Name = 'Another Floor',
            uid__c = 'AnotherUID' // Replace with appropriate UID
        );
        insert anotherFloor;
        
        Room__c anotherRoom = new Room__c(
            Name = 'Another Room',
            Floor_uid__c = anotherFloor.uid__c // Ensure the room's floor UID matches the another floor's UID
            // Add other required fields if any
        );
        insert anotherRoom;

        // Call the trigger helper method
        Test.startTest();
        SCIS_roomTriggerHelper.attachFloor([SELECT Id, Floor_uid__c FROM Room__c]);
        Test.stopTest();

        // Verify that the rooms were attached to the correct floors
        testRoom = [SELECT Id, Floor__c FROM Room__c WHERE Id = :testRoom.Id];
        System.assertNotEquals(null, testRoom.Floor__c, 'Floor should not be null');
        System.assertEquals(testFloor.Id, testRoom.Floor__c, 'Room should be attached to the correct floor');

        anotherRoom = [SELECT Id, Floor__c FROM Room__c WHERE Id = :anotherRoom.Id];
        System.assertNotEquals(null, anotherRoom.Floor__c, 'Floor should not be null');
        System.assertEquals(anotherFloor.Id, anotherRoom.Floor__c, 'Room should be attached to the correct floor');
    }
}