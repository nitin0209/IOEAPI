public with sharing class AppointmentController {
    
    /*@AuraEnabled(cacheable=true)
    public static List<User_Log_In_Details__c> getEmployeesForPrepWork(String installationType) {
        return [SELECT Id, Name, Is_contractor__c, Employee__r.Company_Name__c,Company_Name__c, Employee__r.Employee_Type__c,(Select Installation_Type__c From Appointments__r)
                FROM User_Log_In_Details__c
                WHERE Employee__r.Is_contractor__c = true
                AND Employee__r.Employee_Type__c = 'Contractor'];
    }
*/

public static void validatePrepWorkMandatory(List<Survey__c> surveys) {
    for (Survey__c survey : surveys) {
        // Check if Does_this_property_require_Prep_Work__c is 'Yes'
        if (survey.Does_this_property_require_Prep_Work__c == 'Yes') {
            // Check if What_kind_of_prep_work_is_needed__c is null or empty
            if (String.isBlank(survey.What_kind_of_prep_work_is_needed__c)) {
                // Add an error if the field is not populated
                survey.addError('The field "What kind of prep work is needed" is mandatory when "Does this property require Prep Work" is set to Yes.');
            }
        }
    }
}

//appointmentCreation component based on whether the value of Does_this_property_require_Prep_Work__c is "Yes".

@AuraEnabled(cacheable=true)
    public static String getPrepWorkStatus(Id surveyId) {
        Survey__c survey = [SELECT Does_this_property_require_Prep_Work__c FROM Survey__c WHERE Id = :surveyId LIMIT 1];
        return survey.Does_this_property_require_Prep_Work__c;
    }

@AuraEnabled(cacheable=true)
public static List<User_Log_In_Details__c> getEmployeesForPrepWork(String ContractorType) {
    // Step 1: Query Appointment__c records that match the selected Installation_Type__c
    /*List<Appointment__c> appointments = [SELECT Id, Surveyor__c 
                                         FROM Appointment__c 
                                         WHERE Installation_Type__c = :installationType];  //WHERE Installation_Type__c = :installationType
    
    List<Employee__c> employeeData = [SELECT Id, Contractor_type__c FROM Employee__c WHERE Contractor_type__c = :ContractorType];
    // Step 2: Collect the User_Log_In_Details__c IDs from the queried Appointment__c records
    Set<String> userLoginDetailIds = new Set<String>();
    for (Employee__c employees : employeeData) {
        if (employees.Contractor_type__c != null) {
            userLoginDetailIds.add(employees.Contractor_type__c);
        }
    }

    // Step 3: Query User_Log_In_Details__c records using the IDs from the Appointment__c records
    if (userLoginDetailIds.isEmpty()) {
        return new List<User_Log_In_Details__c>(); // Return an empty list if no related records found
    }
                        OR  */
    return [SELECT Id, Name, Is_contractor__c, Employee__r.Company_Name__c,Company_Name__c, Employee__r.Employee_Type__c,Employee__r.Contractor_type__c
    FROM User_Log_In_Details__c
    WHERE Employee__r.Contractor_type__c =: ContractorType
    AND Is_contractor__c = true
    AND Employee__r.Employee_Type__c = 'Contractor'];
}

//Error creating appointment: Script-thrown exception
@AuraEnabled
public static String createAppointment(String ContractorType, Datetime startDateTime, Datetime endDateTime, Id surveyUserId, Id userDetailId) {
    try {
        if (startDateTime == endDateTime) {
            throw new AuraHandledException('Error: Start DateTime and End DateTime cannot be the same.');
        }
        if (startDateTime.date() < System.today()) {
            throw new AuraHandledException('error: You cannot create an appointment in the past. Please select a future date.') ;
        }
        // Check if an appointment already exists for this Survey
        List<Appointment__c> overlappingAppointments = [SELECT Id,Scheduled_Date_Time__c,Scheduled_End_Date_Time__c FROM Appointment__c 
                                                    WHERE Surveyor__c = :userDetailId
                                                    AND (
                                                        (Scheduled_Date_Time__c < :endDateTime AND Scheduled_End_Date_Time__c > :startDateTime)
                                                    )
                                                    LIMIT 1];

    if (!overlappingAppointments.isEmpty()) {
        // If the employee has overlapping appointments, return an error message
          throw new AuraHandledException('error: The selected employee is already booked for the specified time period. Please choose another time.');
    }
    
        /*
        List<Appointment__c> existingDefineAppointments = [SELECT Id,Measure__c, (Select Define_Measures__c From Surveys__r WHERE Define_Measures__c INCLUDES (:defineMeasures)) FROM Appointment__c 
                                                     WHERE Property__c = :surveyUserId
                                                     ];

        if (!existingDefineAppointments.isEmpty()) {
            // If there is already an appointment for this Survey with the same Define_Measures__c, return an error
            return 'error: An appointment with the selected Define Measures already exists for this survey.';
        }
            */
        // Fetch Survey__c record based on surveyUserId
        List<Survey__c> surveyList = [SELECT Id, Name, Schemes__c, Lead__r.Id, Type_of_Scheme__c, Company_Name__c,User_Log_In_Details__r.Id,Address_of_Installation__c,Define_Measures__c,
        Address_of_Installation__Street__s, Address_of_Installation__City__s, Address_of_Installation__PostalCode__s, Address_of_Installation__StateCode__s, Address_of_Installation__CountryCode__s, Address_of_Installation__Latitude__s, Address_of_Installation__Longitude__s, Address_of_Installation__GeocodeAccuracy__s
                                      FROM Survey__c 
                                      WHERE Id = :surveyUserId 
                                      LIMIT 1];

        if (surveyList.isEmpty()) {
            throw new AuraHandledException('Survey record not found.');
        }

        Survey__c surveyUserDetail = surveyList[0];
        Lead leadDetail;
        if (surveyUserDetail.Lead__r != null) {
            leadDetail = surveyUserDetail.Lead__r; 
        }
        if(surveyUserDetail.User_Log_In_Details__r != null) {
            surveyUserDetail.User_Log_In_Details__r.Id = surveyUserDetail.User_Log_In_Details__r.Id;
        }
        /*
        List<String> newDefineMeasures = defineMeasures.split(';');
        for (Appointment__c existingAppointment : existingAppointments) {
            List<String> existingDefineMeasures = existingAppointment.Measure__c.split(';');
            for (String newMeasure : newDefineMeasures) {
                if (existingDefineMeasures.contains(newMeasure)) {
                    // Return an error if a duplicate Define_Measure__c is found
                    return 'error: Duplicate Define Measures (' + newMeasure + ') already exist on this survey.';
                }
            }
        }
        */
        // Create the appointment record
        Appointment__c appointment = new Appointment__c(
            Name = surveyUserDetail.Name,
            Appointment_type__c = 'Contract work',
            Installation_Type__c = ContractorType,
            Scheduled_Date_Time__c = startDateTime,
            Scheduled_End_Date_Time__c = endDateTime,
            Status__c = 'Pending',
            Lead__c = (leadDetail != null) ? leadDetail.Id : null,
            Property__c = surveyUserDetail.Id, 
            schemes__c = surveyUserDetail.Schemes__c,
            scheme_Type__c = surveyUserDetail.Type_of_Scheme__c,
            Company_Name__c = surveyUserDetail.Company_Name__c,
            Surveyor__c =  userDetailId,  //surveyUserDetail.User_Log_In_Details__r.Id
            Address__Street__s = surveyUserDetail.Address_of_Installation__Street__s,
            Address__City__s = surveyUserDetail.Address_of_Installation__City__s,
            Address__PostalCode__s = surveyUserDetail.Address_of_Installation__PostalCode__s,
            Address__StateCode__s = surveyUserDetail.Address_of_Installation__StateCode__s,
            Address__CountryCode__s = surveyUserDetail.Address_of_Installation__CountryCode__s,
            Address__Latitude__s = surveyUserDetail.Address_of_Installation__Latitude__s,
            Address__Longitude__s = surveyUserDetail.Address_of_Installation__Longitude__s,
            Address__GeocodeAccuracy__s = surveyUserDetail.Address_of_Installation__GeocodeAccuracy__s,
            Measure__c = surveyUserDetail.Define_Measures__c,
            //Measure__c = defineMeasures,   
            Survey_Submitted_Date_Time__c = system.today()
        );

        // Insert the appointment
        insert appointment;

        return 'Appointment ' + appointment.Name + ' created successfully.';
    } catch (Exception ex) {
        // Log and throw the exception to be caught by LWC
        System.debug('Error creating appointment: ' + ex.getMessage());
        throw new AuraHandledException('already Appointment is booked.');
    }
}

@AuraEnabled(cacheable=true)
public static List<String> getPicklistValues(String objectName, String fieldName) {
    List<String> picklistValues = new List<String>();
    Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
    Schema.DescribeSObjectResult describeSObjectResult = sObjectType.getDescribe();
    Schema.DescribeFieldResult fieldResult = describeSObjectResult.fields.getMap().get(fieldName).getDescribe();

    for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
        picklistValues.add(entry.getLabel());
    }
    return picklistValues;
}
}