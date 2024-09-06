/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	27-02-2024
Class Name 				: 	SCIS_EquipmentTrigger
TestClass Name 			: 	SCIS_EquipmentTriggerTest
Description 			: 	This is test class for SCIS_EquipmentTrigger
Last Modification Date 	: 	27-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */


@isTest
public class SCIS_EquipmentTriggerTest {
@isTest
    static void testBeforeInsertTrigger() {
        // Create test data
        List<Equipment__c> equipmentList = new List<Equipment__c>();
        for(Integer i = 0; i < 5; i++) {
            equipmentList.add(new Equipment__c(/* Populate required fields */));
        }
        
        Test.startTest();
        // Insert the test records to fire the trigger
        insert equipmentList;
        Test.stopTest();
        
        // Add assertions as needed
    }

    @isTest
    static void testBeforeUpdateTrigger() {
        // Create test data
        List<Equipment__c> equipmentList = new List<Equipment__c>();
        for(Integer i = 0; i < 5; i++) {
            equipmentList.add(new Equipment__c(
                Name = 'Table'
                /* Populate required fields */));
        }
        insert equipmentList;
        
        // Modify some records
        for(Equipment__c equip : equipmentList) {
            // Modify fields to trigger update
            equip.Name = 'Chair';
        }

        Test.startTest();
        // Update the records to fire the trigger
        update equipmentList;
        Test.stopTest();
        
        // Add assertions as needed
    }
}