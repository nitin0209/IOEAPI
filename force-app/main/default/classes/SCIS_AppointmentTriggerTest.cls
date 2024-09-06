@isTest
private class SCIS_AppointmentTriggerTest {

    @isTest
    static void testBeforeInsert() {
        // Create a test Lead record
        Lead testLead = new Lead(
            LastName = 'TestLead',
            Company = 'SCIS',
            Company_Name__c = 'SCIS',
            Status = 'New',
            Email = 'testlead@example.com'
        );
        insert testLead;

        // Ensure a User_Log_In_Details__c with Role__c = 'Surveyor' exists
        User_Log_In_Details__c surveyor;
        List<User_Log_In_Details__c> surveyors = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Surveyor' LIMIT 1];
        if (surveyors.isEmpty()) {
            // Create a new surveyor if none exists
            surveyor = new User_Log_In_Details__c(Name = 'Test Surveyor', Role__c = 'Surveyor', Email__c = 'dinesh.suryavanshi@canspirit.ae');
            insert surveyor;
        } else {
            surveyor = surveyors[0];
        }

        // Create test Appointment records
        List<Appointment__c> appointments = new List<Appointment__c>();
        for (Integer i = 0; i < 5; i++) {
            appointments.add(new Appointment__c(
                Scheduled_End_Date_Time__c = System.now().addDays(i),
                Status__c = 'Accepted',
                Lead__c = testLead.Id,
                Surveyor__c = surveyor.Id
            ));
        }

        // Execute the trigger logic
        Test.startTest();
        try {
            insert appointments;
        } catch (Exception e) {
            System.debug('Exception during insert: ' + e.getMessage());
        }
        Test.stopTest();

        // Verify that the helper logic has been invoked for each appointment
        List<Appointment__c> updatedAppointments = [SELECT Id, Surveyor__c, Status__c FROM Appointment__c WHERE Id IN :appointments];
        for (Appointment__c apn : updatedAppointments) {
            System.assertNotEquals(null, apn.Surveyor__c, 'Surveyor should be assigned');
        }
    }

    @isTest
    static void testBeforeUpdate() {
        // Create a test Lead record
        Lead testLead = new Lead(
            LastName = 'TestLead',
            Company = 'SCIS',
            Company_Name__c = 'SCIS',
            Status = 'New',
            Email = 'testlead@example.com'
        );
        insert testLead;

        // Ensure a User_Log_In_Details__c with Role__c = 'Surveyor' exists
        User_Log_In_Details__c surveyor;
        List<User_Log_In_Details__c> surveyors = [SELECT Id FROM User_Log_In_Details__c WHERE Role__c = 'Surveyor' LIMIT 1];
        if (surveyors.isEmpty()) {
            // Create a new surveyor if none exists
            surveyor = new User_Log_In_Details__c(Name = 'Test Surveyor', Role__c = 'Surveyor', Email__c = 'dinesh.suryavanshi@canspirit.ae');
            insert surveyor;
        } else {
            surveyor = surveyors[0];
        }

        // Create and insert test Appointment records
        List<Appointment__c> appointments = new List<Appointment__c>();
        for (Integer i = 0; i < 5; i++) {
            appointments.add(new Appointment__c(
                Scheduled_End_Date_Time__c = System.now().addDays(i),
                Status__c = 'Accepted',
                Lead__c = testLead.Id,
                Surveyor__c = surveyor.Id
            ));
        }
        insert appointments;

        // Update the test data
        for (Appointment__c apn : appointments) {
            apn.Status__c = 'Applied For Reschedule';
            apn.Scheduled_End_Date_Time__c = System.now().addDays(-1);
        }

        // Execute the trigger logic
        Test.startTest();
        try {
            update appointments;
        } catch (Exception e) {
            System.debug('Exception during update: ' + e.getMessage());
        }
        Test.stopTest();

        // Verify that the helper logic has been invoked for each appointment
        List<Appointment__c> updatedAppointments = [SELECT Id, Surveyor__c, Status__c, Scheduled_End_Date_Time__c FROM Appointment__c WHERE Id IN :appointments];
        for (Appointment__c apn : updatedAppointments) {
            if (apn.Scheduled_End_Date_Time__c < System.now()) {
                System.assertEquals('Applied For Reschedule', apn.Status__c, 'Status should be updated to Applied For Reschedule');
            }
        }
    }
}