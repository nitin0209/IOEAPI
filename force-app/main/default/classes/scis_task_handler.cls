public class scis_task_handler {
    public static void createRelatedFollowupDetails(list<task> taskList){
        List<Follow_Up_Details__c> newCallLogs = new List<Follow_Up_Details__c>();

    // Collect all WhoIds to query Lead names
    Set<Id> whoIds = new Set<Id>();
    for(Task t : taskList) {
        if(t.Subject == '3CX PhoneSystem Call' && t.WhoId != null) {
            whoIds.add(t.WhoId);
        }
    }

    // Map to store WhoId to Lead Name
    Map<Id, String> leadNamesMap = new Map<Id, String>();

    // Query Lead names using WhoId
    if (!whoIds.isEmpty()) {
        for (Lead lead : [SELECT Id, Name FROM Lead WHERE Id IN :whoIds]) {
            leadNamesMap.put(lead.Id, lead.Name);
        }
    }

    for(Task t : taskList) {
        if(t.Subject == '3CX PhoneSystem Call') { // Adjust the condition based on your criteria
            String comments = t.Description; // Assuming the comments are in the Description field

            try {
                // Extract the date and time part
                String callDateTimeStr = comments.substring(0, 16);

                // Extract the call status and type
                String[] parts = comments.split(' ');
                String callStatus = parts[2];

                // Extract from and to numbers
                String fromNumber = comments.substring(comments.indexOf('from') + 5, comments.indexOf('to') - 1).trim();
                String toPart = comments.substring(comments.indexOf('to') + 3, comments.indexOf(' ', comments.indexOf('to') + 3)).trim();

                // Extract caller name including both parts (Shell, Lottiee)
                String callerNameWithSuffix = comments.substring(comments.indexOf(' ', comments.indexOf('to') + 3) + 1, comments.lastIndexOf('(') - 1).trim();
                // Remove the suffix and comma (e.g., " (SCIS)")
                // String callerName = callerNameWithSuffix.substring(0, callerNameWithSuffix.lastIndexOf(',')).trim();

                // Extract call duration
                String callDuration = comments.substring(comments.lastIndexOf('(') + 1, comments.lastIndexOf(')')).trim();

               
                // Convert the date and time string to a DateTime object
                // Expected format: MM/dd/yyyy HH:mm
                Date callDate = Date.valueOf(callDateTimeStr.substring(6, 10) + '-' + callDateTimeStr.substring(0, 2) + '-' + callDateTimeStr.substring(3, 5));
                Time callTime = Time.newInstance(Integer.valueOf(callDateTimeStr.substring(11, 13)), Integer.valueOf(callDateTimeStr.substring(14, 16)), 0, 0);
                DateTime callDateTime = DateTime.newInstance(callDate, callTime);

                // Create new Follow_Up_Details__c record
                Follow_Up_Details__c callLog = new Follow_Up_Details__c();
                
                
                callLog.CallDateTime__c = callDateTime; // Set the DateTime field
                callLog.CallType__c = t.CallType;  // Set the CallType to only "outgoing" or "incoming"
                callLog.CallStatus__c = callStatus;  // Set the call status like "Answered"
                callLog.FromNumber__c = fromNumber;
                callLog.ToNumber__c = toPart;
                callLog.CallerName__c = leadNamesMap.get(t.WhoId);
                callLog.CallDuration__c = callDuration;
                callLog.Lead_ID_Text__c = t.WhoId;
                callLog.Name = leadNamesMap.get(t.WhoId);
                // callLog.Lead_Name__c = leadNamesMap.get(t.WhoId); // Set the lead name from the map

                newCallLogs.add(callLog);
            } catch(Exception e) {
                // Handle parsing errors
                System.debug('Error parsing Task description: ' + e.getMessage());
            }
        }
    }
	
        
        
    if(!newCallLogs.isEmpty()) {
        insert newCallLogs;
    }
    }
}