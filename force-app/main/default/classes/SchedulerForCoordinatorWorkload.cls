public class SchedulerForCoordinatorWorkload implements Schedulable {
    public void execute(SchedulableContext context) {
        try {
            
            Date today = Date.today();
            Date firstOfMonth = Date.newInstance(today.year(), today.month(), 1);
            Date lastOfMonth = firstOfMonth.addMonths(1).addDays(-1);
        
            
            Set<Date> workdays = new Set<Date>();
            for (Date currentDate = firstOfMonth; currentDate <= lastOfMonth; currentDate = currentDate.addDays(1)) {
                DateTime dateTimeInstance = DateTime.newInstance(currentDate.year(), currentDate.month(), currentDate.day());
                String dayOfWeek = dateTimeInstance.format('EEEE'); 
                if (dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday') { 
                    workdays.add(currentDate);
                }
            }
             
            
            List<User> users = [SELECT Id FROM User WHERE Coordinator_Type__c IN ('Internal', 'External', 'Coordinator Manager')];
            Set<Id> userIds = new Set<Id>();
            for (User user : users) {
                userIds.add(user.Id);
            }
            
            
            List<Coordinator_Workload__c> existingWorkloads = [SELECT Id, Name__c, Date__c, Remaining_Capacity__c 
                                                               FROM Coordinator_Workload__c 
                                                               WHERE Name__c IN :userIds 
                                                               AND Date__c IN :workdays];
            Map<String, Coordinator_Workload__c> existingWorkloadMap = new Map<String, Coordinator_Workload__c>();
            for (Coordinator_Workload__c workload : existingWorkloads) {
                existingWorkloadMap.put(workload.Name__c + '-' + workload.Date__c, workload);
            }
            
            
            List<Coordinator_Workload__c> recordsToInsert = new List<Coordinator_Workload__c>();
            List<Coordinator_Workload__c> recordsToUpdate = new List<Coordinator_Workload__c>();
            for (Date workday : workdays) {
                for (User user : users) {
                    String entryKey = user.Id + '-' + workday;
                    Coordinator_Workload__c existingWorkload = existingWorkloadMap.get(entryKey);
                    if (existingWorkload != null) {
                        
                        existingWorkload.Remaining_Capacity__c = 15; 
                        recordsToUpdate.add(existingWorkload);
                    } else {
                        
                        Coordinator_Workload__c newWorkload = new Coordinator_Workload__c(
                            Name__c = user.Id,
                            Date__c = workday,
                            Remaining_Capacity__c = 15 
                        );
                        recordsToInsert.add(newWorkload);
                    }
                }
            }
            
            
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert;
            }
            
           
            if (!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }
            
            System.debug('SchedulerForCoordinatorWorkload executed successfully');
        } catch (Exception e) {
            System.debug('Error executing SchedulerForCoordinatorWorkload: ' + e.getMessage());
            
        }
    }
}