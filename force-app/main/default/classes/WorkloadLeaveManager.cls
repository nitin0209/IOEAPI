public class WorkloadLeaveManager {
    
    public static void handleLeaveUpdate(List<Appointment__c> leaveAppointments) {
        
        Set<Id> userIds = new Set<Id>();
        Set<Date> leaveDates = new Set<Date>();
        
        // Collect User Ids and Leave Dates from the leave appointments
        System.debug('Starting to collect user IDs and leave dates...');
        for (Appointment__c appointment : leaveAppointments) {
            if (appointment.Appointment_Type__c == 'Leave' && appointment.Assigned_Coordinator__c != null) {
                userIds.add(appointment.Assigned_Coordinator__c);
                leaveDates.add(appointment.Leave_Start_Date__c);
                leaveDates.add(appointment.Leave_End_Date__c);
                System.debug('Collected Leave Appointment: User ID = ' + appointment.Assigned_Coordinator__c + 
                             ', Start Date = ' + appointment.Leave_Start_Date__c + 
                             ', End Date = ' + appointment.Leave_End_Date__c);
            }
        }
        
        if (userIds.isEmpty() || leaveDates.isEmpty()) {
            System.debug('No leave appointments to process.');
            return;
        }
        
        // Query Coordinator_Workload__c records for the given users and dates
        System.debug('Querying Coordinator_Workload__c records...');
        List<Coordinator_Workload__c> workloads = [SELECT Id, Name__c, Date__c, Capacity__c 
                                                  FROM Coordinator_Workload__c 
                                                  WHERE Name__c IN :userIds 
                                                  AND Date__c IN :leaveDates];
        
        Map<String, Coordinator_Workload__c> workloadMap = new Map<String, Coordinator_Workload__c>();
        for (Coordinator_Workload__c workload : workloads) {
            String key = workload.Name__c + '-' + workload.Date__c;
            workloadMap.put(key, workload);
            System.debug('Workload Record: User ID = ' + workload.Name__c + 
                         ', Date = ' + workload.Date__c + 
                         ', Capacity = ' + workload.Capacity__c);
        }
        
        List<Coordinator_Workload__c> updatedWorkloads = new List<Coordinator_Workload__c>();
        
        for (Appointment__c appointment : leaveAppointments) {
            if (appointment.Appointment_Type__c == 'Leave' && appointment.Assigned_Coordinator__c != null) {
                Date startDate = appointment.Leave_Start_Date__c;
                Date endDate = appointment.Leave_End_Date__c;
                Id userId = appointment.Assigned_Coordinator__c;
                
                // Iterate over all dates in the leave range
                for (Date currentDate = startDate; currentDate <= endDate; currentDate = currentDate.addDays(1)) {
                    String key = userId + '-' + currentDate;
                    if (workloadMap.containsKey(key)) {
                        Coordinator_Workload__c workload = workloadMap.get(key);
                        System.debug('Processing Workload: User ID = ' + userId + 
                                     ', Date = ' + currentDate + 
                                     ', Current Capacity = ' + workload.Capacity__c);
                        if (workload.Capacity__c > 0) {
                            workload.Capacity__c = 0; // Set capacity to 0 for the leave dates
                            updatedWorkloads.add(workload);
                            System.debug('Updated Workload: User ID = ' + userId + 
                                         ', Date = ' + currentDate + 
                                         ', New Capacity = ' + workload.Capacity__c);
                        }
                    } else {
                        System.debug('No matching workload record found for User ID = ' + userId + 
                                     ' and Date = ' + currentDate);
                    }
                }
            }
        }
        
        // Update Coordinator_Workload__c records
        if (!updatedWorkloads.isEmpty()) {
            System.debug('Updating Coordinator_Workload__c records...');
            update updatedWorkloads;
            System.debug('Updated ' + updatedWorkloads.size() + ' Coordinator_Workload__c records.');
        } else {
            System.debug('No Coordinator_Workload__c records were updated.');
        }
        
        System.debug('WorkloadLeaveManager executed successfully.');
    }
}