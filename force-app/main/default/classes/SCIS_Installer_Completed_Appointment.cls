/**************************************************************************************************************************************************
Developer Name          :   Dhiraj Lohar
Created Date            :   12-06-2024
Trigger Name            :   SCIS_Installer_Completed_Appointment
TestClass Name          :   SCIS_Installer_Completed_AppointmentTest
Connected Class         :   
@Description            :   
Last Modification Date  :   12-06-2024
Last Modified By        :   Dhiraj Lohar
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

public class SCIS_Installer_Completed_Appointment {
    
    public static void handleAfterUpdate(List<Appointment__c> updatedAppointments, Map<Id, Appointment__c> oldAppointmentMap) {
        List<Appointment__c> insCompletedAppointments = new List<Appointment__c>();

        // Check for appointments that have been Installation Completed
        for (Appointment__c appointment : updatedAppointments) {
            Appointment__c oldAppointment = oldAppointmentMap.get(appointment.Id);
            if (appointment.Status__c == 'Installation Completed' && oldAppointment.Status__c != 'Installation Completed' && appointment.Appointment_Type__c == 'Install') {
                insCompletedAppointments.add(appointment);
            }
        }

        // If there are any Installation Completed appointments, send emails
        if (!insCompletedAppointments.isEmpty()) {
            instCompletedAppointmentEmails(insCompletedAppointments);
        }
    }

    private static void instCompletedAppointmentEmails(List<Appointment__c> appointments) {
        List<Messaging.SingleEmailMessage> installerEmails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> customerEmails = new List<Messaging.SingleEmailMessage>();
        Set<Id> teamIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();

        // Collect Team IDs and Lead IDs from Installation Completed appointments
        for (Appointment__c appointment : appointments) {
            if (appointment.Installer_Team__c != null) {
                teamIds.add(appointment.Installer_Team__c);
            }
            if (appointment.Lead__c != null) {
                leadIds.add(appointment.Lead__c);
            }
        }

        // Query Teams and their Installers
        Map<Id, Teams__c> teamMap = new Map<Id, Teams__c>();
        if (!teamIds.isEmpty()) {
            teamMap = new Map<Id, Teams__c>([
                SELECT Id, Name, Lead_Installer__c, Assistant_Installer__c
                FROM Teams__c 
                WHERE Id IN :teamIds
            ]);
        }

        // Collect Installer IDs
        Set<Id> installerIds = new Set<Id>();
        for (Teams__c team : teamMap.values()) {
            if (team.Lead_Installer__c != null) {
                installerIds.add(team.Lead_Installer__c);
            }
            if (team.Assistant_Installer__c != null) {
                installerIds.add(team.Assistant_Installer__c);
            }
        }

        // Query Installer emails
        Map<Id, Installer__c> installerEmailsMap = new Map<Id, Installer__c>();
        if (!installerIds.isEmpty()) {
            installerEmailsMap = new Map<Id, Installer__c>([
                SELECT Id, Email__c 
                FROM Installer__c 
                WHERE Id IN :installerIds
            ]);
        }

        // Query Lead emails
        Map<Id, Lead> leadEmailsMap = new Map<Id, Lead>();
        if (!leadIds.isEmpty()) {
            leadEmailsMap = new Map<Id, Lead>([
                SELECT Id, Email, Name 
                FROM Lead 
                WHERE Id IN :leadIds
            ]);
        }

        // Create email messages for each Installation Completed appointment
        for (Appointment__c appointment : appointments) {
            Teams__c team = teamMap.get(appointment.Installer_Team__c);

            if (team != null) {
                List<String> installerEmailAddresses = new List<String>();

                // Add Lead Installer email
                Installer__c leadInstaller = installerEmailsMap.get(team.Lead_Installer__c);
                if (leadInstaller != null && leadInstaller.Email__c != null) {
                    installerEmailAddresses.add(leadInstaller.Email__c);
                }

                // Add Assistant Installer email
                Installer__c assistantInstaller = installerEmailsMap.get(team.Assistant_Installer__c);
                if (assistantInstaller != null && assistantInstaller.Email__c != null) {
                    installerEmailAddresses.add(assistantInstaller.Email__c);
                }

                
                // Format the Scheduled Date and Time
                String formattedDate = '';
                if (appointment.Scheduled_Date_Time__c != null) {
                    DateTime dt = appointment.Scheduled_Date_Time__c;
                    formattedDate = dt.format('dd/MM/yyyy HH:mm');
                }
                
                // Create and add email to the list for installers
                if (!installerEmailAddresses.isEmpty()) {
                    Messaging.SingleEmailMessage installerEmail = new Messaging.SingleEmailMessage();
                    installerEmail.setToAddresses(installerEmailAddresses);
                    installerEmail.setSubject('Installation Completed: ' + appointment.Name + ' | Team: ' + team.Name + ' | Installation Type: ' + appointment.Installation_Type__c);
                    installerEmail.setPlainTextBody('Dear Installer ' + team.Name + ',\n\n' +
                        'We are pleased to confirm that the following appointment has been Installation Completed. Please review the details below and ensure that you are prepared for the scheduled installation:\n\n' +
                        'Appointment: ' + appointment.Name + '\n' +
                        'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                        //'Lead: ' + (lead != null ? lead.Name : 'N/A') + '\n' +
                        'Team: ' + team.Name + '\n' +
                        'Address: ' + appointment.Address__Street__s +', '+ appointment.Address__City__s +', '+ appointment.Post_Code__c + '\n' +
                        'Scheduled Date and Time: ' + formattedDate + '\n\n' +
                        'If you have any questions or require further information, please do not hesitate to contact us.\n\n' +
                        'Thank you for your attention and cooperation.\n\n' +
                        'Best regards,\n' +
                        'SCIS');

                    installerEmail.setSaveAsActivity(false);
                    installerEmails.add(installerEmail);

                    System.debug('Email prepared for Team: ' + team.Name + ', Addresses: ' + installerEmailAddresses);
                } else {
                    System.debug('No email addresses found for Team ID: ' + team.Id);
                }
            } else {
                System.debug('No team found for Appointment ID: ' + appointment.Id);
            }

            // Add Customer email
            Lead lead = leadEmailsMap.get(appointment.Lead__c);
            if (lead != null && lead.Email != null) {
                
                // Format the Scheduled Date and Time
                String formattedDate = '';
                if (appointment.Scheduled_Date_Time__c != null) {
                    DateTime dt = appointment.Scheduled_Date_Time__c;
                    formattedDate = dt.format('dd/MM/yyyy HH:mm');
                }
                
                Messaging.SingleEmailMessage customerEmail = new Messaging.SingleEmailMessage();
                customerEmail.setToAddresses(new List<String> { lead.Email });
                customerEmail.setSubject('Your Installation Appointment is Complete');
                customerEmail.setPlainTextBody('Dear ' + lead.Name + ',\n\n' +
                    'We are pleased to inform you that your installation appointment has been successfully completed. Please find the details below:\n\n' +
                    'Appointment: ' + appointment.Name + '\n' +
                    'Installation Type: ' + appointment.Installation_Type__c + '\n' +
                    'Address: ' + appointment.Address__Street__s +', '+ appointment.Address__City__s +', '+ appointment.Post_Code__c + '\n' +
                    'Scheduled Date and Time: ' + formattedDate + '\n\n' +
                    'If you have any questions or need further assistance, please do not hesitate to contact us.\n\n' +
                    'Thank you for choosing our services.\n\n' +
                    'Best regards,\n' +
                    'SCIS');

                customerEmail.setSaveAsActivity(false);
                customerEmails.add(customerEmail);

                System.debug('Customer email prepared for Lead: ' + lead.Name + ', Address: ' + lead.Email);
            } else {
                System.debug('No email address found for Lead ID: ' + appointment.Lead__c);
            }
        }

        // Send the emails to installers
        if (!installerEmails.isEmpty()) {
            try {
                Messaging.sendEmail(installerEmails);
                System.debug('Installer emails sent: ' + installerEmails);
            } catch (Exception e) {
                System.debug('Exception while sending installer emails: ' + e.getMessage());
            }
        } else {
            System.debug('No installer emails to send.');
        }

        // Send the emails to customers
        if (!customerEmails.isEmpty()) {
            try {
                Messaging.sendEmail(customerEmails);
                System.debug('Customer emails sent: ' + customerEmails);
            } catch (Exception e) {
                System.debug('Exception while sending customer emails: ' + e.getMessage());
            }
        } else {
            System.debug('No customer emails to send.');
        }
    }
}