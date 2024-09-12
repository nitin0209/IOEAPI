import { LightningElement, wire } from 'lwc';
import getLeadsWithInstallationStatus from '@salesforce/apex/LeadWithInstallationController.getLeadsWithInstallationStatus';

export default class LeadInstallationStatus extends LightningElement {
    leads;
    error;

    columns = [
        { label: 'Lead Name', fieldName: 'leadName', type: 'text' },
        { label: 'Lead Status', fieldName: 'leadStatus', type: 'text' },
        { label: 'Installation Status', fieldName: 'installationStatus', type: 'text' }
    ];

    @wire(getLeadsWithInstallationStatus)
    wiredLeads({ error, data }) {
        if (data) {
            this.leads = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.leads = undefined;
        }
    }
}