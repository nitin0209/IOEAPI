public class AppointmentTriggerHandler {
    public static void handleBeforeInsert(List<Appointment__c> newAppointments) {
        System.debug('Entered handleBeforeInsert method');

        List<Appointment__c> surveyAppointments = new List<Appointment__c>();
        for (Appointment__c appointment : newAppointments) {
            if (appointment.Appointment_Type__c == 'Survey') {
                surveyAppointments.add(appointment);
            }
        }

        if (surveyAppointments.isEmpty()) {
            System.debug('No appointments with Appointment_Type__c = Survey.');
            return; 
        }

        Set<Date> appointmentDatesSet = new Set<Date>();
        for (Appointment__c appointment : surveyAppointments) {
            if (!appointment.isHoliday__c) {
                appointmentDatesSet.add(appointment.Scheduled_Date_Time__c.date());
                System.debug('Appointment ID: ' + appointment.Id + ', Scheduled Date: ' + appointment.Scheduled_Date_Time__c.date());
            }
        }

        List<Coordinator_workload__c> availableWorkload = [SELECT Id, Name, Name__c, Date__c, Capacity__c 
                                                           FROM Coordinator_Workload__c 
                                                           WHERE Capacity__c > 0 
                                                           AND Date__c IN :appointmentDatesSet
                                                          ];
        System.debug('Available Workloads: ' + availableWorkload);

        Map<Id, Coordinator_workload__c> workloadMap = new Map<Id, Coordinator_workload__c>();
        for (Coordinator_workload__c workload : availableWorkload) {
            if (workload.Name__c != null) {
                workloadMap.put(workload.Name__c, workload);
                System.debug('Workload ID: ' + workload.Id + ', User ID: ' + workload.Name__c + ', Capacity: ' + workload.Capacity__c);
            }
        }
        System.debug('Workload Map: ' + workloadMap);

        List<User> internalUsers = [SELECT Id FROM User WHERE Id IN :workloadMap.keySet() AND Coordinator_Type__c = 'Internal'];
        List<User> externalUsers = [SELECT Id FROM User WHERE Id IN :workloadMap.keySet() AND Coordinator_Type__c = 'External'];
        List<User> managerUsers = [SELECT Id FROM User WHERE Id IN :workloadMap.keySet() AND Coordinator_Type__c = 'Coordinator Manager'];

        System.debug('Internal Users: ' + internalUsers);
        System.debug('External Users: ' + externalUsers);
        System.debug('Manager Users: ' + managerUsers);

        List<Appointment__c> oldRecords = [SELECT Round_Robin_Sequence__c 
                                           FROM Appointment__c 
                                           WHERE Round_Robin_Sequence__c != null 
                                           ORDER BY Round_Robin_Sequence__c DESC 
                                           LIMIT 1];
        System.debug('Old Records: ' + oldRecords);

        Integer lastIndex = oldRecords.isEmpty() ? -1 : Integer.valueOf(oldRecords[0].Round_Robin_Sequence__c);
        System.debug('Last Index: ' + lastIndex);

        List<Coordinator_workload__c> workloadsToUpdate = new List<Coordinator_workload__c>();

        for (Appointment__c appointment : surveyAppointments) {
            Boolean assigned = false;

            if (!internalUsers.isEmpty() && !assigned) {
                Integer index = Math.mod(lastIndex + 1, internalUsers.size());
                Id assignedUserId = internalUsers[index].Id;
                Coordinator_workload__c assignedWorkload = workloadMap.get(assignedUserId);

                if (assignedWorkload != null && assignedWorkload.Capacity__c > 0) {
                    appointment.Assigned_Coordinator__c = assignedUserId;
                    appointment.Round_Robin_Sequence__c = lastIndex + 1;
                    assignedWorkload.Capacity__c = assignedWorkload.Capacity__c - 1;
                    workloadsToUpdate.add(assignedWorkload);
                    lastIndex = index;
                    assigned = true;
                } else {
                    internalUsers.remove(index); 
                }
            }

            if (!externalUsers.isEmpty() && !assigned) {
                Integer index = Math.mod(lastIndex + 1, externalUsers.size());
                Id assignedUserId = externalUsers[index].Id;
                Coordinator_workload__c assignedWorkload = workloadMap.get(assignedUserId);

                if (assignedWorkload != null && assignedWorkload.Capacity__c > 0) {
                    appointment.Assigned_Coordinator__c = assignedUserId;
                    appointment.Round_Robin_Sequence__c = lastIndex + 1;
                    assignedWorkload.Capacity__c = assignedWorkload.Capacity__c - 1;
                    workloadsToUpdate.add(assignedWorkload);
                    lastIndex = index;
                    assigned = true;
                } else {
                    externalUsers.remove(index); 
                }
            }

            if (!managerUsers.isEmpty() && !assigned) {
                Integer index = Math.mod(lastIndex + 1, managerUsers.size());
                Id assignedUserId = managerUsers[index].Id;
                Coordinator_workload__c assignedWorkload = workloadMap.get(assignedUserId);

                // Always assign to Manager Users, regardless of their capacity
                if (assignedWorkload != null) {
                    appointment.Assigned_Coordinator__c = assignedUserId;
                    appointment.Round_Robin_Sequence__c = lastIndex + 1;
                    // No capacity check for Manager Users
                    workloadsToUpdate.add(assignedWorkload);
                    lastIndex = index;
                    assigned = true;
                } else {
                    managerUsers.remove(index); 
                }
            }

            if (!assigned) {
                System.debug('No available users to assign to Appointment ID: ' + appointment.Id);
            }
        }

        if (!workloadsToUpdate.isEmpty()) {
            update workloadsToUpdate;
        }

        System.debug('Exiting handleBeforeInsert method');
    }

    public static void handleBeforeUpdate(List<Appointment__c> updatedAppointments, Map<Id, Appointment__c> oldMap) {
    System.debug('Entered handleBeforeUpdate method');

    if (updatedAppointments == null || oldMap == null) {
        System.debug('Updated appointments list or oldMap is null.');
        return;
    }
	//calling reschedule method 
        handleRescheduledAppointments(updatedAppointments, oldMap);
        
    List<Appointment__c> declinedAppointments = new List<Appointment__c>();

    for (Appointment__c appointment : updatedAppointments) {
        if (appointment != null && appointment.Id != null && oldMap.containsKey(appointment.Id)) {
            Appointment__c oldAppointment = oldMap.get(appointment.Id);

            // Check if Scheduled_Date_Time__c has changed and update Status__c to Rescheduled
            if (oldAppointment != null && appointment.Scheduled_Date_Time__c != oldAppointment.Scheduled_Date_Time__c) {
                appointment.Status__c = 'Rescheduled';
                System.debug('Scheduled date/time changed, status set to Rescheduled for ID: ' + appointment.Id);
            }

            // Ensure oldAppointment is not null and check for status change to Declined
            if (oldAppointment != null && appointment.Status__c == 'Declined' && oldAppointment.Status__c != 'Declined') {
                if (appointment.Assigned_Coordinator__c != null) {
                    declinedAppointments.add(appointment);
                    System.debug('Appointment status changed to Declined and has an assigned coordinator for ID: ' + appointment.Id);
                } else {
                    System.debug('Appointment status changed to Declined but no assigned coordinator for ID: ' + appointment.Id);
                }
            } else {
                System.debug('No status change to Declined or oldAppointment is null for ID: ' + appointment.Id);
            }
        } else {
            System.debug('Skipped appointment due to null ID or missing from oldMap: ' + (appointment != null ? appointment.Id : 'null appointment'));
        }
    }

    if (declinedAppointments.isEmpty()) {
        System.debug('No appointments with status changed to Declined and assigned coordinator.');
        return;
    }

    Set<Id> declinedCoordinatorIds = new Set<Id>();
    for (Appointment__c declinedAppointment : declinedAppointments) {
        if (declinedAppointment != null && declinedAppointment.Assigned_Coordinator__c != null) {
            declinedCoordinatorIds.add(declinedAppointment.Assigned_Coordinator__c);
            System.debug('Coordinator to be removed: ' + declinedAppointment.Assigned_Coordinator__c);
        } else {
            System.debug('Declined appointment is null or no assigned coordinator to remove for ID: ' + (declinedAppointment != null ? declinedAppointment.Id : 'null appointment'));
        }
    }

    if (!declinedCoordinatorIds.isEmpty()) {
        List<Coordinator_workload__c> workloadsToUpdate = [SELECT Id, Name__c, Remaining_Capacity__c, Capacity__c
                                                           FROM Coordinator_Workload__c 
                                                           WHERE Name__c IN :declinedCoordinatorIds];
        System.debug('Workloads to update: ' + workloadsToUpdate);

        for (Coordinator_workload__c workload : workloadsToUpdate) {
            if (workload != null && workload.Remaining_Capacity__c != null && declinedCoordinatorIds.contains(workload.Name__c)) {
                workload.Capacity__c += 1;
                System.debug('Increasing capacity for workload ID: ' + workload.Id + ' New Remaining Capacity: ' + workload.Remaining_Capacity__c);
            } else {
                System.debug('Skipped workload update for workload: ' + (workload != null ? workload.Id : 'null workload'));
            }
        }

        if (!workloadsToUpdate.isEmpty()) {
            update workloadsToUpdate;
            System.debug('Updated workloads with increased capacities: ' + workloadsToUpdate);
        } else {
            System.debug('No workloads to update.');
        }
    } else {
        System.debug('No declined coordinators found to update workloads.');
    }

    // Remove assigned coordinator from declined appointments
    for (Appointment__c declinedAppointment : declinedAppointments) {
        if (declinedAppointment != null) {
            declinedAppointment.Assigned_Coordinator__c = null;
            System.debug('Removed assigned coordinator for declined appointment ID: ' + declinedAppointment.Id);
        } else {
            System.debug('Skipped null declined appointment.');
        }
    }

    System.debug('Exiting handleBeforeUpdate method');
}
    public static void handleRescheduledAppointments(List<Appointment__c> updatedAppointments, Map<Id, Appointment__c> oldMap) {
    System.debug('Entered handleRescheduledAppointments method');

    List<Appointment__c> rescheduledAppointments = new List<Appointment__c>();
    
    for (Appointment__c appointment : updatedAppointments) {
        if (appointment != null && appointment.Id != null && oldMap.containsKey(appointment.Id)) {
            Appointment__c oldAppointment = oldMap.get(appointment.Id);

            // Check if Scheduled_Date_Time__c has changed
            if (oldAppointment != null && appointment.Scheduled_Date_Time__c != oldAppointment.Scheduled_Date_Time__c) {
                appointment.Status__c = 'Rescheduled';
                System.debug('Scheduled date/time changed, status set to Rescheduled for ID: ' + appointment.Id);
                rescheduledAppointments.add(appointment);
            }
        } else {
            System.debug('Skipped appointment due to null ID or missing from oldMap: ' + (appointment != null ? appointment.Id : 'null appointment'));
        }
    }

    if (rescheduledAppointments.isEmpty()) {
        System.debug('No appointments have been rescheduled.');
        System.debug('Exiting handleRescheduledAppointments method');
        return;
    }

    Set<Date> rescheduledDatesSet = new Set<Date>();
    for (Appointment__c appointment : rescheduledAppointments) {
        if (!appointment.isHoliday__c) {
            rescheduledDatesSet.add(appointment.Scheduled_Date_Time__c.date());
        }
    }

    List<Coordinator_workload__c> availableWorkload = [SELECT Id, Name, Name__c, Date__c, Capacity__c 
                                                       FROM Coordinator_Workload__c 
                                                       WHERE Capacity__c > 0 
                                                       AND Date__c IN :rescheduledDatesSet];
    System.debug('Available Workloads: ' + availableWorkload);

    Map<Id, Coordinator_workload__c> workloadMap = new Map<Id, Coordinator_workload__c>();
    for (Coordinator_workload__c workload : availableWorkload) {
        if (workload.Name__c != null) {
            workloadMap.put(workload.Name__c, workload);
        }
    }

    List<User> internalUsers = [SELECT Id FROM User WHERE Id IN :workloadMap.keySet() AND Coordinator_Type__c = 'Internal'];
    List<User> externalUsers = [SELECT Id FROM User WHERE Id IN :workloadMap.keySet() AND Coordinator_Type__c = 'External'];
    List<User> managerUsers = [SELECT Id FROM User WHERE Id IN :workloadMap.keySet() AND Coordinator_Type__c = 'Coordinator Manager'];

    System.debug('Internal Users: ' + internalUsers);
    System.debug('External Users: ' + externalUsers);
    System.debug('Manager Users: ' + managerUsers);

    List<Appointment__c> oldRecords = [SELECT Round_Robin_Sequence__c 
                                       FROM Appointment__c 
                                       WHERE Round_Robin_Sequence__c != null 
                                       ORDER BY Round_Robin_Sequence__c DESC 
                                       LIMIT 1];

    Integer lastIndex = oldRecords.isEmpty() ? -1 : Integer.valueOf(oldRecords[0].Round_Robin_Sequence__c);

    List<Coordinator_workload__c> workloadsToUpdate = new List<Coordinator_workload__c>();

    for (Appointment__c appointment : rescheduledAppointments) {
        Boolean assigned = false;

        if (!internalUsers.isEmpty() && !assigned) {
            Integer index = Math.mod(lastIndex + 1, internalUsers.size());
            Id assignedUserId = internalUsers[index].Id;
            Coordinator_workload__c assignedWorkload = workloadMap.get(assignedUserId);

            if (assignedWorkload != null && assignedWorkload.Capacity__c > 0) {
                appointment.Assigned_Coordinator__c = assignedUserId;
                appointment.Round_Robin_Sequence__c = lastIndex + 1;
                assignedWorkload.Capacity__c = assignedWorkload.Capacity__c - 1;
                workloadsToUpdate.add(assignedWorkload);
                lastIndex = index;
                assigned = true;
            } else {
                internalUsers.remove(index); 
            }
        }

        if (!externalUsers.isEmpty() && !assigned) {
            Integer index = Math.mod(lastIndex + 1, externalUsers.size());
            Id assignedUserId = externalUsers[index].Id;
            Coordinator_workload__c assignedWorkload = workloadMap.get(assignedUserId);

            if (assignedWorkload != null && assignedWorkload.Capacity__c > 0) {
                appointment.Assigned_Coordinator__c = assignedUserId;
                appointment.Round_Robin_Sequence__c = lastIndex + 1;
                assignedWorkload.Capacity__c = assignedWorkload.Capacity__c - 1;
                workloadsToUpdate.add(assignedWorkload);
                lastIndex = index;
                assigned = true;
            } else {
                externalUsers.remove(index); 
            }
        }

        if (!managerUsers.isEmpty() && !assigned) {
            Integer index = Math.mod(lastIndex + 1, managerUsers.size());
            Id assignedUserId = managerUsers[index].Id;
            Coordinator_workload__c assignedWorkload = workloadMap.get(assignedUserId);

            if (assignedWorkload != null) {
                appointment.Assigned_Coordinator__c = assignedUserId;
                appointment.Round_Robin_Sequence__c = lastIndex + 1;
                workloadsToUpdate.add(assignedWorkload);
                lastIndex = index;
                assigned = true;
            } else {
                managerUsers.remove(index); 
            }
        }

        if (!assigned) {
            System.debug('No available users to assign to rescheduled Appointment ID: ' + appointment.Id);
        }
    }

    if (!workloadsToUpdate.isEmpty()) {
        update workloadsToUpdate;
    }

    System.debug('Exiting handleRescheduledAppointments method');
}

}