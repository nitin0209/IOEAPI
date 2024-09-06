public class userlogindetailscontroller {
   @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getUserLogInDetails(Date selectedDate) {
        List<Map<String, Object>> userDetailsList = new List<Map<String, Object>>();

        List<User_Log_In_Details__c> userDetails = [SELECT Id, Name, 
                                                         (SELECT Assigned_Postcode__c, CreatedDate, Postcode_Assignment_Start_Time__c FROM Postcode_Assignments__r WHERE Postcode_Assignment_Date__c = :selectedDate)
                                                         FROM User_Log_In_Details__c
                                                         WHERE Role__c = 'Lead Generator'];

        for (User_Log_In_Details__c user : userDetails) {
            Map<String, Object> userMap = new Map<String, Object>();
            userMap.put('Id', user.Id);
            userMap.put('Name', user.Name);
            List<Map<String, Object>> assignments = new List<Map<String, Object>>();
            for (Postcode_Assignment__c assignment : user.Postcode_Assignments__r) {
                Map<String, Object> assignmentMap = new Map<String, Object>();
                assignmentMap.put('Assigned_Postcode__c', assignment.Assigned_Postcode__c);
                assignmentMap.put('CreatedDate', assignment.CreatedDate);
                // Extract time portion from DateTime field
                String startTime = assignment.Postcode_Assignment_Start_Time__c != null ? assignment.Postcode_Assignment_Start_Time__c.format('HH:mm') : null;
                assignmentMap.put('Postcode_Assignment_Start_Time__c', startTime);
                assignments.add(assignmentMap);
            }
            userMap.put('Postcode_Assignments__r', assignments);
            userDetailsList.add(userMap);
        }

        return userDetailsList;
    }


    //for update - reassign
    @AuraEnabled
    public static void reassignLeadGenerator(String leadGeneratorId, String newPostcode) {
        // Query the Postcode_Assignment__c records for the given lead generator
        List<Postcode_Assignment__c> assignments = [SELECT Id, Assigned_Postcode__c,Postcode_Assignment_Start_Time__c
                                                     FROM Postcode_Assignment__c 
                                                     WHERE User_Log_In_Details__r.Id = :leadGeneratorId];
        System.debug('Assignments: ' + assignments);

        // Update the Assigned_Postcode__c field in each assignment record
        for (Postcode_Assignment__c assignment : assignments) {
            assignment.Assigned_Postcode__c = newPostcode;
        }

        // Update the assignments
        update assignments;
    }
    //assign logic
    @AuraEnabled(cacheable=true)
public static Map<String, Object> getPostcodeAssignmentDetails(String leadGeneratorId) {
    Map<String, Object> assignmentDetails = new Map<String, Object>();

    // Query Postcode Assignment object to fetch additional details
    Postcode_Assignment__c assignment = [SELECT Id, 
                                          User_Log_In_Details__c, 
                                          Postcode_Assignment_Date__c, 
                                          Assigned_Postcode__c, 
                                          Postcode_Assignment_Start_Time__c, 
                                          Postcode_Assignment_End_Time__c 
                                          FROM Postcode_Assignment__c 
                                          WHERE User_Log_In_Details__c = :leadGeneratorId 
                                          ORDER BY CreatedDate DESC LIMIT 1];

    if (assignment != null) {
        // Populate the details in the map
        assignmentDetails.put('userDetails', assignment.User_Log_In_Details__c);
        assignmentDetails.put('postcodeAssignmentDate', assignment.Postcode_Assignment_Date__c);
        assignmentDetails.put('assignedPostcode', assignment.Assigned_Postcode__c);
        assignmentDetails.put('postcodeAssignmentStartTime', assignment.Postcode_Assignment_Start_Time__c);
        assignmentDetails.put('postcodeAssignmentEndTime', assignment.Postcode_Assignment_End_Time__c);
    }

    return assignmentDetails;
}

//6.50 update the postcode 
@AuraEnabled
public static void updatePostcodeAssignment(String leadGeneratorId, String newPostcode) {
    // Query the Postcode_Assignment__c record for the given lead generator
    Postcode_Assignment__c assignment = [SELECT Id, Assigned_Postcode__c
                                         FROM Postcode_Assignment__c 
                                         WHERE User_Log_In_Details__r.Id = :leadGeneratorId limit 1];
    System.debug('Assignment: ' + assignment);

    // Update the Assigned_Postcode__c field
    if (assignment != null) {
        assignment.Assigned_Postcode__c = newPostcode;
        update assignment;
    } else {
        // Handle the scenario where no assignment is found
        throw new AuraHandledException('No Postcode Assignment found for the selected lead generator.');
    }
}

    //v2 to update time 
    // New method for creating Postcode Assignment record with time
@AuraEnabled
public static void createPostcodeAssignment(String leadGeneratorId, String newPostcode, String startTime, String endTime, String leadGeneratorName, Date selectedDate) {
    Postcode_Assignment__c assignment = new Postcode_Assignment__c();
    assignment.User_Log_In_Details__c = leadGeneratorId;
    assignment.Assigned_Postcode__c = '101010';
    assignment.Postcode_Assignment_Start_Time__c = DateTime.newInstance(selectedDate.year(), selectedDate.month(), selectedDate.day(), Integer.valueOf(startTime.substring(0, 2)), Integer.valueOf(startTime.substring(3, 5)), Integer.valueOf(startTime.substring(6, 8)));
    assignment.Postcode_Assignment_End_Time__c = DateTime.newInstance(selectedDate.year(), selectedDate.month(), selectedDate.day(), Integer.valueOf(endTime.substring(0, 2)), Integer.valueOf(endTime.substring(3, 5)), Integer.valueOf(endTime.substring(6, 8)));
    assignment.Name = leadGeneratorId;
    System.debug('================'+assignment.Name);
     System.debug('================'+leadGeneratorName);
    assignment.Postcode_Assignment_Date__c = selectedDate;
    insert assignment;
}


}