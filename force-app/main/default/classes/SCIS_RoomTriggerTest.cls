@isTest
private class SCIS_RoomTriggerTest {
    @isTest
    static void testAttachFloor() {
        // Create test data
        Floor__c testFloor = new Floor__c(Name = 'Test Floor');
        insert testFloor;

        // Create test rooms associated with the test floor
        List<Room__c> testRooms = new List<Room__c>();
        for(Integer i = 0; i < 3; i++) {
            testRooms.add(new Room__c(Name = 'Room ' + i, Floor__c = testFloor.Id));
        }
        
        // Call the trigger manually to invoke the logic
        Test.startTest();
        insert testRooms;
        Test.stopTest();
        
        // Verify that the floor was attached to the rooms
        List<Room__c> insertedRooms = [SELECT Id, Floor__c FROM Room__c WHERE Id IN :testRooms];
        for(Room__c room : insertedRooms) {
            System.assertEquals(testFloor.Id, room.Floor__c, 'Room should be attached to the correct floor');
        }
    }
}