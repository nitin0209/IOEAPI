/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	01-02-2024
Class Name 				: 	SCIS_propertyTrigger
TestClass Name 			: 	SCIS_propertyTriggerTest
Description 			: 	This trigger is used to update chimine information below google aerial view image.
Last Modification Date 	: 	01-02-2024
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1 21-02-2024 added : SCIS_propertyTriggerHandler.createOrientationOfProperty(trigger.new);
************************************************************************************************************************************************** */

trigger SCIS_propertyTrigger on Property__c (before insert,before update) {
    if(trigger.isBefore && trigger.isInsert){
        
        SCIS_propertyTriggerHandler.updateGoogleAerialViewImage(trigger.new);
        //#1 21-02-2024 change start
        SCIS_propertyTriggerHandler.createOrientationOfProperty(trigger.new);
        //#1 21-02-2024 change start
    }
    if(trigger.isBefore && trigger.isUpdate){
        SCIS_propertyTriggerHandler.updateGoogleAerialViewImage(trigger.new);
        //#1 21-02-2024 change start
        SCIS_propertyTriggerHandler.createOrientationOfProperty(trigger.new);
        //#1 21-02-2024 change start
        
    }
}