public with sharing class LeadWithInstallationController {
    @AuraEnabled(cacheable=true)
    public static List<LeadWrapper> getLeadsWithInstallationStatus() {
        List<LeadWrapper> leadWrapperList = new List<LeadWrapper>();

        // Query Lead records with related Installation status
        List<Lead> leads = [
            SELECT Id, Name, Status,
                   (SELECT Id, Status__c FROM Installations__r) // Assuming 'Installations__r' is the child relationship name
            FROM Lead
            WHERE Status != NULL limit 10
        ];

        for (Lead lead : leads) {
            LeadWrapper lw = new LeadWrapper();
            lw.leadId = lead.Id;
            lw.leadName = lead.Name;
            lw.leadStatus = lead.Status;

            if (!lead.Installations__r.isEmpty()) {
                lw.installationStatus = lead.Installations__r[0].Status__c; // Assuming one installation per lead
            } else {
                lw.installationStatus = 'No Installation';
            }

            leadWrapperList.add(lw);
        }

        return leadWrapperList;
    }

    // Wrapper class to hold Lead and Installation data
    public class LeadWrapper {
        @AuraEnabled
        public Id leadId;
        @AuraEnabled
        public String leadName;
        @AuraEnabled
        public String leadStatus;
        @AuraEnabled
        public String installationStatus;
    }
}