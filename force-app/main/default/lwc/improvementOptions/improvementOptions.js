import { LightningElement, track, wire } from 'lwc';
import fetchLatestResponse from '@salesforce/apex/scisIOEResponseHandler.fetchLatestResponse'; // Import the Apex method

export default class ImprovementOptions extends LightningElement {
    @track improvementOptions = []; // Track the improvement options for dynamic rendering

    // Call Apex method to fetch the improvement options on component initialization
    connectedCallback() {
        this.fetchImprovementOptions();
    }

    // Fetch improvement options from the server
    fetchImprovementOptions() {
        fetchLatestResponse()
            .then(result => {
                // Parse the response and assign it to the improvementOptions array
                if (result) {
                    let responseJson = JSON.parse(result.Response_Body__c);
                    this.improvementOptions = responseJson.recommendations || [];
                    console.log('Improvement Options:', this.improvementOptions);
                } else {
                    console.error('No recommendations found in response');
                }
            })
            .catch(error => {
                console.error('Error fetching improvement options:', error);
            });
    }
    handleBackClick() {
        const hideImprovementOptionsEvent = new CustomEvent('hideimprovementoptions');
        this.dispatchEvent(hideImprovementOptionsEvent);
    }
}