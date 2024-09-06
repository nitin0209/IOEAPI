import { LightningElement, api, wire, track } from 'lwc';
import getLeadRecord from '@salesforce/apex/SCIS_lead_on_map_helper.getLeadRecord';

export default class FetchLeadComponent extends LightningElement {
    @api recordId;
    leadData;
    error;
    @track latitude1;
    @track longitude1;
    @track leadFullName1;
    @track locationObject;
    
    //dynamicImageUrl="https://maps.google.com/maps?width=100%25&amp;height=600&amp;hl=en&amp;q=57.1014740000,-2.2428510000+(LeadNamedddd)&amp;t=&amp;z=14&amp;ie=UTF8&amp;iwloc=B&amp;output=embed";
    @wire(getLeadRecord, { leadId: '$recordId' })
    wiredLead({ error, data }) {
        if (data) {
            this.leadData = data;
            this.error = undefined;
            //this.locationObject = this.leadData.Location__c;
            this.latitude1 = this.leadData.Location__c.latitude;
            this.longitude1 = this.leadData.Location__c.longitude;
            this.leadFullName = this.leadData.Name;
            // Extract latitude and longitude from compound field Location__c
            if (this.leadData && this.leadData.Location__latitude__s && this.leadData.Location__longitude__s) {
                this.latitude1 = this.leadData.Location__latitude__s;
                this.longitude1 = this.leadData.Location__longitude__s;
                
            }
        } else if (error) {
            this.error = error;
            this.leadData = undefined;
        }
    }

    get leadName() {
        return this.leadData ? this.leadData.Name : '';
    }

    get leadEmail() {
        return this.leadData ? this.leadData.Email : '';
    }

    get location() {
        return this.leadData ? this.leadData.Location__c : '';
    }

    // get dynamicMapUrl() {
    //     return "https://maps.google.com/maps?width=100%25&amp;height=600&amp;hl=en&amp;q=57.1014740000,-2.2428510000+(My%20Business%20Name)&amp;t=&amp;z=16&amp;ie=UTF8&amp;iwloc=B&amp;output=embed";
    //    // return `https://maps.google.com/maps?width=100%25&amp;height=600&amp;hl=en&amp;q=${this.latitude1},${this.longitude1}+(LeadNamedddd)&amp;t=&amp;z=14&amp;ie=UTF8&amp;iwloc=B&amp;output=embed`;
    // }


    get dynamicMapUrl() {
        if (this.latitude1 && this.longitude1) {
            return "https://maps.google.com/maps?width=100%25&amp;height=600&amp;hl=en&amp;q=57.1014740000,-2.2428510000+(My%20Business%20Name)&amp;t=&amp;z=16&amp;ie=UTF8&amp;iwloc=B&amp;output=embed";

            //return `https://maps.google.com/maps?width=100%25&amp;height=600&amp;hl=en&amp;q=${this.latitude1},${this.longitude1}+(LeadNamedddd)&amp;t=&amp;z=14&amp;ie=UTF8&amp;iwloc=B&amp;output=embed`;
        }
        return ''; // Return an empty string if latitude and longitude are not available yet
    }
    
    
}