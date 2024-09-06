public class AppointmentStatusHandler {

    public static void handleAfterUpdate(List<Appointment__c> updatedAppointments, Map<Id, Appointment__c> oldAppointmentMap) {
        List<Appointment__c> acceptedAppointments = new List<Appointment__c>();

        for (Appointment__c appointment : updatedAppointments) {
            Appointment__c oldAppointment = oldAppointmentMap.get(appointment.Id);
            if (appointment.Status__c == 'Accepted' && oldAppointment.Status__c != 'Accepted') {
                acceptedAppointments.add(appointment);
            }
        }

        if (!acceptedAppointments.isEmpty()) {
            sendAcceptedAppointmentEmails(acceptedAppointments);
        }
    }

    public static void sendAcceptedAppointmentEmails(List<Appointment__c> appointments) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Set<Id> teamIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();

        // Collect Team IDs and Lead IDs
        for (Appointment__c appointment : appointments) {
            if (appointment.Installer_Team__c != null) {
                teamIds.add(appointment.Installer_Team__c);
            }
            if (appointment.Lead__c != null) {
                leadIds.add(appointment.Lead__c);
            }
        }

        System.debug('Collected Team IDs: ' + teamIds);
        System.debug('Collected Lead IDs: ' + leadIds);

        // Query teams and their installers
        Map<Id, Teams__c> teamMap = new Map<Id, Teams__c>();
        if (!teamIds.isEmpty()) {
            teamMap = new Map<Id, Teams__c>([
                SELECT Id, Name, Lead_Installer__c, Assistant_Installer__c
                FROM Teams__c 
                WHERE Id IN :teamIds
            ]);
        }

        System.debug('Queried Teams: ' + teamMap);

        // Query installer emails from Installer__c
        Set<Id> installerIds = new Set<Id>();
        for (Teams__c team : teamMap.values()) {
            if (team.Lead_Installer__c != null) {
                installerIds.add(team.Lead_Installer__c);
            }
            if (team.Assistant_Installer__c != null) {
                installerIds.add(team.Assistant_Installer__c);
            }
        }

        System.debug('Collected Installer IDs: ' + installerIds);

        Map<Id, Installer__c> installerEmailsMap = new Map<Id, Installer__c>();
        if (!installerIds.isEmpty()) {
            installerEmailsMap = new Map<Id, Installer__c>([
                SELECT Id, Email__c 
                FROM Installer__c 
                WHERE Id IN :installerIds
            ]);
        }

        System.debug('Queried Installers: ' + installerEmailsMap);

        // Query Lead names and emails
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        if (!leadIds.isEmpty()) {
            leadMap = new Map<Id, Lead>([
                SELECT Id, Name, Email
                FROM Lead
                WHERE Id IN :leadIds
            ]);
        }

        System.debug('Queried Leads: ' + leadMap);

        // Create email messages for Teams
        for (Appointment__c appointment : appointments) {
            System.debug('Processing appointment: ' + appointment);

            Teams__c team = teamMap.get(appointment.Installer_Team__c);
            if (team != null) {
                List<String> teamEmailAddresses = new List<String>();

                // Adding installer emails
                Installer__c leadInstaller = installerEmailsMap.get(team.Lead_Installer__c);
                if (leadInstaller != null && leadInstaller.Email__c != null && String.isNotBlank(leadInstaller.Email__c)) {
                    teamEmailAddresses.add(leadInstaller.Email__c);
                } else {
                    System.debug('Lead Installer email is blank or null for Team: ' + team.Name);
                }

                Installer__c assistantInstaller = installerEmailsMap.get(team.Assistant_Installer__c);
                if (assistantInstaller != null && assistantInstaller.Email__c != null && String.isNotBlank(assistantInstaller.Email__c)) {
                    teamEmailAddresses.add(assistantInstaller.Email__c);
                } else {
                    System.debug('Assistant Installer email is blank or null for Team: ' + team.Name);
                }

                if (!teamEmailAddresses.isEmpty()) {
                    Messaging.SingleEmailMessage teamEmail = new Messaging.SingleEmailMessage();
                    teamEmail.setToAddresses(teamEmailAddresses);

                    // Set the email subject and body manually
                    teamEmail.setSubject('Appointment Accepted: ' + appointment.Name + ' | Installation Type: ' + appointment.Installation_Type__c);
                    teamEmail.setPlainTextBody('Dear '+ team.Name + ',\n\n' +
                        'We are pleased to inform you that a new appointment has been Accepted. Below are the details of the appointment:\n\n' +
                        'Appointment: ' + appointment.Name + '\n' +
                        'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                        'Team: ' + team.Name + '\n' +
                        'Address: ' + appointment.Email_Template_Address__c + '\n'+                        
                        'Scheduled Date and Time: ' + appointment.Scheduled_Date_Time__c + '\n\n' +
                        'Please ensure that you are prepared for the appointment at the specified date and time. If you have any questions or need further information, do not hesitate to contact us.\n\n' +
                        'Thank you for your attention and cooperation.\n\nBest regards,\nSCIS');

                    teamEmail.setSaveAsActivity(false);
                    emails.add(teamEmail);

                    System.debug('Email prepared for Team: ' + team.Name + ', Addresses: ' + teamEmailAddresses);
                } else {
                    System.debug('No email addresses found for Team ID: ' + team.Id);
                }
            } else {
                System.debug('No team found for Appointment ID: ' + appointment.Id);
            }
        }

        // Create email messages for Leads
        for (Appointment__c appointment : appointments) {
            if (appointment.Lead__c != null) {
                Lead lead = leadMap.get(appointment.Lead__c);
                if (lead != null && lead.Email != null && String.isNotBlank(lead.Email)) {
                    Messaging.SingleEmailMessage leadEmail = new Messaging.SingleEmailMessage();
                    leadEmail.setToAddresses(new List<String>{lead.Email});

                    // Set the email subject and body manually
                    leadEmail.setSubject('Appointment Accepted: ' + appointment.Name + ' | Installation Type: ' + appointment.Installation_Type__c);
                    leadEmail.setPlainTextBody('Dear ' + lead.Name + ',\n\n' +
                        'We are pleased to inform you that a new appointment has been Accepted. Below are the details of the appointment:\n\n' +
                        'Appointment: ' + appointment.Name + '\n' +
                        'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                        'Address: ' + appointment.Email_Template_Address__c + '\n'+                        
                        'Scheduled Date and Time: ' + appointment.Scheduled_Date_Time__c + '\n\n' +
                        'Please ensure that you are prepared for the appointment at the specified date and time. If you have any questions or need further information, do not hesitate to contact us.\n\n' +
                        'Thank you for your attention and cooperation.\n\nBest regards,\nSCIS');

                    leadEmail.setTargetObjectId(lead.Id);
                    leadEmail.setWhatId(appointment.Id);

                    leadEmail.setSaveAsActivity(false);
                    emails.add(leadEmail);

                    System.debug('Email prepared for Lead: ' + lead.Name + ', Address: ' + lead.Email);
                } else {
                    System.debug('Lead email is blank or null for Appointment ID: ' + appointment.Id);
                }
            }
        }

        // Send emails
        if (!emails.isEmpty()) {
            try {
                Messaging.sendEmail(emails);
                System.debug('Emails sent: ' + emails);
            } catch (Exception e) {
                System.debug('Exception while sending emails: ' + e.getMessage());
            }
        } else {
            System.debug('No emails to send.');
        }
    }
}