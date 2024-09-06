public class RoundRobinCoordinator {
    public static void assignCoordinator(List<Appointment__c> appointments, Boolean isAfterInsert) {
        System.debug('AssignCoordinator method started');

        // Query internal and external coordinators
        List<User> internalCoordinators = [SELECT Id, Name, Coordinator_Type__c, Available_Capacity__c, Order__c
                                           FROM User 
                                           WHERE Coordinator_Type__c = 'Internal' 
                                           AND IsActive = true
                                           ORDER BY LastModifiedDate];

        List<User> externalCoordinators = [SELECT Id, Name, Coordinator_Type__c, Order__c
                                           FROM User 
                                           WHERE Coordinator_Type__c = 'External' 
                                           AND IsActive = true
                                           ORDER BY LastModifiedDate];

        Integer numInternalCoordinators = internalCoordinators.size();
        Integer numExternalCoordinators = externalCoordinators.size();
        System.debug('Number of active internal coordinators: ' + numInternalCoordinators);
        System.debug('Number of active external coordinators: ' + numExternalCoordinators);

        // Categorize internal coordinators by their order
        List<User> user1 = new List<User>();
        List<User> user2 = new List<User>();
        List<User> user3 = new List<User>();

        for (User usr : internalCoordinators) {
            if (usr.Available_Capacity__c > 0 && usr.Order__c == 1) {
                user1.add(usr);
                System.debug('Added internal coordinator to user1: ' + usr.Name);
            } else if (usr.Available_Capacity__c > 0 && usr.Order__c == 2) {
                user2.add(usr);
                System.debug('Added internal coordinator to user2: ' + usr.Name);
            } else if (usr.Available_Capacity__c > 0 && usr.Order__c == 3) {
                user3.add(usr);
                System.debug('Added internal coordinator to user3: ' + usr.Name);
            }
        }

        // Initialize variables for assigning coordinators
        List<Appointment__c> appointmentsToUpdate = new List<Appointment__c>();
        Boolean internalAssigned = false;

        if (numInternalCoordinators > 0) {
            Integer rr = Integer.valueOf(appointments[0].Round_Robin_Counter__c);
            Integer modValue = Math.mod(rr, numInternalCoordinators);
            List<Appointment__c> appointmentsToUpdateInternal = new List<Appointment__c>();
            
            for (Appointment__c app : appointments) {
                internalAssigned = assignInternalCoordinator(app, user1, user2, user3);
                if (internalAssigned) {
                    appointmentsToUpdateInternal.add(app);
                    System.debug('Assigned internal coordinator to appointment: ' + app.Name);
                }
            }
            
            if (!appointmentsToUpdateInternal.isEmpty()) {
                update appointmentsToUpdateInternal;
                System.debug('Updated appointments with internal coordinators');
            }
        }

        if (!internalAssigned) {
            // Categorize external coordinators by their order
            List<User> extUser1 = new List<User>();
            List<User> extUser2 = new List<User>();
            List<User> extUser3 = new List<User>();

            for (User usr : externalCoordinators) {
                if (usr.Available_Capacity__c > 0 && usr.Order__c == 1) {
                    extUser1.add(usr);
                    System.debug('Added external coordinator to extUser1: ' + usr.Name);
                } else if (usr.Available_Capacity__c > 0 && usr.Order__c == 2) {
                    extUser2.add(usr);
                    System.debug('Added external coordinator to extUser2: ' + usr.Name);
                } else if (usr.Available_Capacity__c > 0 && usr.Order__c == 3) {
                    extUser3.add(usr);
                    System.debug('Added external coordinator to extUser3: ' + usr.Name);
                }
            }

            List<Appointment__c> appointmentsToUpdateExternal = new List<Appointment__c>();
            for (Appointment__c app : appointments) {
                if (assignExternalCoordinator(app, extUser1, extUser2, extUser3)) {
                    appointmentsToUpdateExternal.add(app);
                    System.debug('Assigned external coordinator to appointment: ' + app.Name);
                }
            }
            
            if (!appointmentsToUpdateExternal.isEmpty()) {
                update appointmentsToUpdateExternal;
                System.debug('Updated appointments with external coordinators');
            }
        }
    }

    public static Boolean assignInternalCoordinator(Appointment__c app, List<User> user1, List<User> user2, List<User> user3) {
        if (!user1.isEmpty()) {
            app.Assigned_coordinator__c = user1[0].Id;
            app.Assigned_coordinator_name__c = user1[0].Name;
            updateCoordinatorWorkloadCapacity(user1[0].Id, -1);
            System.debug('Assigned internal coordinator from user1: ' + user1[0].Name);
            return true;
        } else if (!user2.isEmpty()) {
            app.Assigned_coordinator__c = user2[0].Id;
            app.Assigned_coordinator_name__c = user2[0].Name;
            updateCoordinatorWorkloadCapacity(user2[0].Id, -1);
            System.debug('Assigned internal coordinator from user2: ' + user2[0].Name);
            return true;
        } else if (!user3.isEmpty()) {
            app.Assigned_coordinator__c = user3[0].Id;
            app.Assigned_coordinator_name__c = user3[0].Name;
            updateCoordinatorWorkloadCapacity(user3[0].Id, -1);
            System.debug('Assigned internal coordinator from user3: ' + user3[0].Name);
            return true;
        }
        return false;
    }

    public static Boolean assignExternalCoordinator(Appointment__c app, List<User> extUser1, List<User> extUser2, List<User> extUser3) {
        if (!extUser1.isEmpty()) {
            app.Assigned_coordinator__c = extUser1[0].Id;
            app.Assigned_coordinator_name__c = extUser1[0].Name;
            updateCoordinatorWorkloadCapacity(extUser1[0].Id, -1);
            System.debug('Assigned external coordinator from extUser1: ' + extUser1[0].Name);
            return true;
        } else if (!extUser2.isEmpty()) {
            app.Assigned_coordinator__c = extUser2[0].Id;
            app.Assigned_coordinator_name__c = extUser2[0].Name;
            updateCoordinatorWorkloadCapacity(extUser2[0].Id, -1);
            System.debug('Assigned external coordinator from extUser2: ' + extUser2[0].Name);
            return true;
        } else if (!extUser3.isEmpty()) {
            app.Assigned_coordinator__c = extUser3[0].Id;
            app.Assigned_coordinator_name__c = extUser3[0].Name;
            updateCoordinatorWorkloadCapacity(extUser3[0].Id, -1);
            System.debug('Assigned external coordinator from extUser3: ' + extUser3[0].Name);
            return true;
        }
        return false;
    }

    public static void updateCoordinatorWorkloadCapacity(Id userId, Integer capacityChange) {
    List<Coordinator_Workload__c> workloads = [SELECT Id, Remaining_Capacity__c, Capacity__c 
                                              FROM Coordinator_Workload__c 
                                              WHERE Name = :userId 
                                              AND Date__c = :System.today()]; // Adjust date filter as needed

    if (!workloads.isEmpty()) {
        Coordinator_Workload__c workload = workloads[0];
        System.debug('Current Remaining Capacity for coordinator: ' + userId + ' is ' + workload.Remaining_Capacity__c);
        
        // Update Remaining Capacity
        workload.Remaining_Capacity__c += capacityChange;
        
        // Ensure Remaining Capacity does not go below zero
        if (workload.Remaining_Capacity__c < 0) {
            workload.Remaining_Capacity__c = 0;
        }

        // Calculate the new Capacity based on Remaining Capacity
        workload.Capacity__c = workload.Remaining_Capacity__c;

        System.debug('Updated Remaining Capacity for coordinator: ' + userId + ' to ' + workload.Remaining_Capacity__c);
        System.debug('Updated Capacity for coordinator: ' + userId + ' to ' + workload.Capacity__c);

        update workload;
    } else {
        System.debug('No Coordinator_Workload__c record found for user: ' + userId);
    }
}

}