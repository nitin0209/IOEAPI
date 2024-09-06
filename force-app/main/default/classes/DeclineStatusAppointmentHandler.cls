public class DeclineStatusAppointmentHandler {

    public static void handleAfterUpdate(List<Appointment__c> updatedAppointments, Map<Id, Appointment__c> oldAppointmentMap) {
        List<Appointment__c> declinedAppointments = new List<Appointment__c>();

        for (Appointment__c appointment : updatedAppointments) {
            Appointment__c oldAppointment = oldAppointmentMap.get(appointment.Id);
            if (appointment.Status__c == 'Declined' && oldAppointment.Status__c != 'Declined') {
                declinedAppointments.add(appointment);
            }
        }

        if (!declinedAppointments.isEmpty()) {
            sendDeclinedAppointmentEmails(declinedAppointments);
        }
    }

    public static void sendDeclinedAppointmentEmails(List<Appointment__c> appointments) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        // Collect Team IDs for declined appointments
        Set<Id> teamIds = new Set<Id>();
        for (Appointment__c appointment : appointments) {
            if (appointment.Installer_Team__c != null) {
                teamIds.add(appointment.Installer_Team__c);
            }
        }

        // Query teams and their installers
        Map<Id, Teams__c> teamMap = new Map<Id, Teams__c>();
        if (!teamIds.isEmpty()) {
            teamMap = new Map<Id, Teams__c>([
                SELECT Id, Name, Lead_Installer__c, Assistant_Installer__c
                FROM Teams__c 
                WHERE Id IN :teamIds
            ]);
        }

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

        Map<Id, Installer__c> installerEmailsMap = new Map<Id, Installer__c>();
        if (!installerIds.isEmpty()) {
            installerEmailsMap = new Map<Id, Installer__c>([
                SELECT Id, Email__c 
                FROM Installer__c 
                WHERE Id IN :installerIds
            ]);
        }

        // Create email messages for declined appointments
        for (Appointment__c appointment : appointments) {
            Teams__c team = teamMap.get(appointment.Installer_Team__c);

            if (team != null) {
                List<String> emailAddresses = new List<String>();

                // Adding installer emails
                Installer__c leadInstaller = installerEmailsMap.get(team.Lead_Installer__c);
                if (leadInstaller != null && leadInstaller.Email__c != null) {
                    emailAddresses.add(leadInstaller.Email__c);
                }

                Installer__c assistantInstaller = installerEmailsMap.get(team.Assistant_Installer__c);
                if (assistantInstaller != null && assistantInstaller.Email__c != null) {
                    emailAddresses.add(assistantInstaller.Email__c);
                }

                if (!emailAddresses.isEmpty() && appointment.Lead__c != null) {
                    
                    // Email to installers with template SCIS_Installer_Decline_Team - By using template 
                   /* Messaging.SingleEmailMessage emailToInstallers = new Messaging.SingleEmailMessage();
                    emailToInstallers.setToAddresses(emailAddresses);
                    emailToInstallers.setTemplateId(getEmailTemplateId('SCIS_Installer_Decline_Team')); // Use provided template name
                   emailToInstallers.setTargetObjectId(appointment.Lead__c); // Set Lead Id as targetObjectId
                    emailToInstallers.setWhatId(appointment.Id); // Set WhatId to the Appointment Id
                    emailToInstallers.setSaveAsActivity(false);
                    emails.add(emailToInstallers);*/
                    
                    if (!emailAddresses.isEmpty()) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(emailAddresses);
                    email.setSubject('Decline Appointment: ' + appointment.Name + ' | Installation Type: ' + appointment.Installation_Type__c);
                    email.setPlainTextBody('Dear '+ team.Name + ',\n\n' +
                        'We are pleased to inform you that a new appointment has been Declined. Below are the details of the appointment:\n\n' +
                        'Appointment: ' + appointment.Name + '\n' +
                        'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                        //'Lead: ' + leadName + '\n' +
                        'Team: ' + team.Name + '\n' +
                        'Address: ' + appointment.Email_Template_Address__c + '\n' +
                        'Scheduled Date and Time: ' + appointment.Scheduled_Date_Time__c + '\n\n' +
                        'Please ensure that you are prepared for the appointment at the specified date and time. If you have any questions or need further information, do not hesitate to contact us.\n\n' +
                        'Thank you for your attention and cooperation.\n\nBest regards,\nSCIS');

                    email.setSaveAsActivity(false);
                    emails.add(email);

                    System.debug('Email prepared for Team: ' + team.Name + ', Addresses: ' + emailAddresses);
                } else {
                    System.debug('No email addresses found for Team ID: ' + team.Id);
                }

                    // Email to lead with template SCIS_Installer_Decline_Customer
                    Messaging.SingleEmailMessage emailToLead = new Messaging.SingleEmailMessage();
                    emailToLead.setTargetObjectId(appointment.Lead__c); // Set Lead Id as targetObjectId
                    emailToLead.setTemplateId(getEmailTemplateId('SCIS_Installer_Decline_Customer')); // Use template for lead
                    emailToLead.setWhatId(appointment.Id); // Set WhatId to the Appointment Id
                    emailToLead.setSaveAsActivity(false);
                    emails.add(emailToLead);

                    System.debug('Email prepared for Team: ' + team.Name + ', Addresses: ' + emailAddresses);
                } else {
                    System.debug('No valid email addresses found or Lead__c is null for Appointment ID: ' + appointment.Id);
                }
            } else {
                System.debug('No team found for Appointment ID: ' + appointment.Id);
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
    
    // Helper method to get Email Template Id by DeveloperName
    private static Id getEmailTemplateId(String templateDeveloperName) {
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :templateDeveloperName LIMIT 1];
        return template.Id;
    }
}