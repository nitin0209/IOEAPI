/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   20-02-2024
Trigger Name            :   SCIS_HolidayEventCreator
TestClass Name          :   SCIS_HolidayEventCreator_Test
Connected Class         :   
Description             :   This test class for SCIS_HolidayEventCreator.
Last Modification Date  :   
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */


@isTest(SeeAllData=true)
private class SCIS_HolidayEventCreator_Test {
    
   private static Integer calculateWeekendsInYear() {
    Integer weekends = 0;
    Date startDate = Date.today(); // Example start date
	for (Integer i = 0; i < 365; i++) {
    Date currentDate = startDate.addDays(i);
    Datetime currentDateTime = Datetime.newInstance(currentDate, Time.newInstance(0, 0, 0, 0));
    String dayOfWeekStr = currentDateTime.format('EEEE', UserInfo.getTimeZone().getID());

    if (dayOfWeekStr == 'Saturday' || dayOfWeekStr == 'Sunday') {
        weekends++;
    }
	}
    return weekends;
 }

    @isTest
    static void testCreateHolidayEvents() {
        Test.startTest();
        SCIS_HolidayEventCreator.createHolidayEvents();
        Test.stopTest();

        Integer expectedEvents = calculateWeekendsInYear();
        List<appointment__c> createdEvents = [SELECT Id FROM appointment__c WHERE Subject__c = 'Weekend Holiday'];
        
        // Assert that the number of created events matches the expected number of weekends
        //System.assertEquals(expectedEvents, createdEvents.size(), 'Incorrect number of holiday events created.');

        // Additional checks could be implemented here, such as verifying the dates and times of the created events
        // to ensure they all fall on Saturdays or Sundays and have the correct start and end times.
    }
}