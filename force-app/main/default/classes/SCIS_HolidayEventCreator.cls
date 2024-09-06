/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	
Class Name 				: 	SCIS_HolidayEventCreator
TestClass Name 			: 	SCIS_HolidayEventCreatorTest
@Description 			: 	This class is used to create the holiday events.
Last Modification Date 	: 	
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */



public class SCIS_HolidayEventCreator {


    public static void createHolidayEvents() {
        //List<Event> holidayEvents = new List<Event>();
        List<appointment__c> holidayEvents = new List<appointment__c>();
        Date startDate = Date.today().addDays(1); // Start from today
		//Date startDate = Date.newInstance(2024, 4, 6);
        // Create events for Saturdays and Sundays for the next 365 days
        for (Integer i = 0; i < 365; i++) {
            Date currentDate = startDate.addDays(i);
            Datetime currentDateTime = Datetime.newInstance(currentDate.year(), currentDate.month(), currentDate.day(), 0, 0, 0);

            // Check if it's Saturday or Sunday
            if (currentDateTime.format('EEEE') == 'Saturday' || currentDateTime.format('EEEE') == 'Sunday') {
                appointment__c holidayEvent = new appointment__c(
                    Subject__c = 'Weekend Holiday',
                    Scheduled_Date_Time__c = currentDateTime,
                    Appointment_Type__c = 'Holiday',
                    //Surveyor__c = 'a0F2z000001gqEDEAY',
                    //Lead__c ='00QQz0000054zjaMAA',
                    Scheduled_End_Date_Time__c = currentDateTime.addHours(23).addMinutes(59), // End of the day
                    Name = 'Holiday'
                    //IsAllDayEvent = true
                );
                holidayEvents.add(holidayEvent);
            }
        }

        // Insert holiday events
        if (!holidayEvents.isEmpty()) {
            
            if (Schema.sObjectType.appointment__c.isCreateable()) {
   				insert holidayEvents;
			}
            //insert holidayEvents;
            
            System.debug('Holiday events created successfully!');
        } else {
            System.debug('No holiday events to create.');
        }
    }
}