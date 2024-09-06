public class AppointmentHandler {

    public static void handleAfterInsert(List<Appointment__c> newAppointments) {
        sendAppointmentEmails(newAppointments);
    }

    private static void sendAppointmentEmails(List<Appointment__c> appointments) {
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

        // Query Lead names and emails
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        if (!leadIds.isEmpty()) {
            leadMap = new Map<Id, Lead>([
                SELECT Id, Name, Email 
                FROM Lead 
                WHERE Id IN :leadIds
            ]);
        }

        // Query Addresses
        Map<Id, Appointment__c> appointmentMap = new Map<Id, Appointment__c>([
            SELECT Id, Name, Installation_Type__c, Lead__c, Lead__r.Name, Installer_Team__c, Address__c, Scheduled_Date_Time__c 
            FROM Appointment__c 
            WHERE Id IN :appointments
        ]);

        // Create email messages
        for (Appointment__c appointment : appointments) {
            appointment = appointmentMap.get(appointment.Id); 
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

                // Adding lead email if available
                Lead lead = leadMap.get(appointment.Lead__c);
                String leadName = (lead != null) ? lead.Name : 'N/A';
                if (lead != null && lead.Email != null) {
                    //emailAddresses.add(lead.Email);
                }

                // Format address
                String formattedAddress = 'N/A';
                if (appointment.Address__c != null) {
                    System.Address address = appointment.Address__c;
                    formattedAddress = 
                        (address.street != null ? address.street + ', ' : '') +
                        (address.city != null ? address.city + ', ' : '') +
                        (address.state != null ? address.state + ', ' : '') +
                        (address.postalCode != null ? address.postalCode + ', ' : '') +
                        (address.country != null ? address.country : '');
                    formattedAddress = formattedAddress.trim();
                    if (formattedAddress.endsWith(',')) {
                        formattedAddress = formattedAddress.substring(0, formattedAddress.length() - 1);
                    }
                }

                if (!emailAddresses.isEmpty()) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(emailAddresses);
                    email.setSubject('New Appointment: ' + appointment.Name + ' | Installation Type: ' + appointment.Installation_Type__c);
                    email.setPlainTextBody('Dear '+ team.Name + ',\n\n' +
                        'We are pleased to inform you that a new appointment has been scheduled. Below are the details of the appointment:\n\n' +
                        'Appointment: ' + appointment.Name + '\n' +
                        'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                        'Lead: ' + leadName + '\n' +
                        'Team: ' + team.Name + '\n' +
                        'Address: ' + formattedAddress + '\n' +
                        'Scheduled Date and Time: ' + appointment.Scheduled_Date_Time__c + '\n\n' +
                        'Please ensure that you are prepared for the appointment at the specified date and time. If you have any questions or need further information, do not hesitate to contact us.\n\n' +
                        'Thank you for your attention and cooperation.\n\nBest regards,\nSCIS');

                    email.setSaveAsActivity(false);
                    emails.add(email);

                    System.debug('Email prepared for Team: ' + team.Name + ', Addresses: ' + emailAddresses);
                } else {
                    System.debug('No email addresses found for Team ID: ' + team.Id);
                }

                // Send email to lead as well
                if (lead != null && lead.Email != null) {
                    Messaging.SingleEmailMessage leadEmail = new Messaging.SingleEmailMessage();
                    leadEmail.setToAddresses(new List<String>{lead.Email});
                    leadEmail.setSubject('New Appointment: ' + appointment.Name + ' | Installation Type: ' + appointment.Installation_Type__c);
                    leadEmail.setPlainTextBody('Dear ' + lead.Name + ',\n\n' +
                        'We are pleased to inform you that a new appointment has been scheduled. Below are the details of the appointment:\n\n' +
                        'Appointment: ' + appointment.Name + '\n' +
                        'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                       // 'Lead: ' + leadName + '\n' +
                        'Team: ' + team.Name + '\n' +
                        'Address: ' + formattedAddress + '\n' +
                        'Scheduled Date and Time: ' + appointment.Scheduled_Date_Time__c + '\n\n' +
                        'Please ensure that you are prepared for the appointment at the specified date and time. If you have any questions or need further information, do not hesitate to contact us.\n\n' +
                        'Thank you for your attention and cooperation.\n\nBest regards,\nSCIS');

                    leadEmail.setSaveAsActivity(false);
                    emails.add(leadEmail);

                    System.debug('Email prepared for Lead: ' + lead.Name + ', Address: ' + lead.Email);
                } else {
                    System.debug('No email address found for Lead ID: ' + appointment.Lead__c);
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
}