import { LightningElement, track, wire } from 'lwc';
import fetchLatestResponse from '@salesforce/apex/scisIOEResponseHandler.fetchLatestResponse';

export default class ScisPackageDetails extends LightningElement {
    @track sapRating;  // To store the SAP rating value
    @track lifetime;   // You can track other fields similarly
    @track spaceHeatingDemand;
    
    connectedCallback() {
        this.fetchLatestResponse();
    }

    // Fetch the latest response from the server
    fetchLatestResponse() {
        fetchLatestResponse()
            .then(response => {
                if (response && response.Response_Body__c) {
                    let responseBody = JSON.parse(response.Response_Body__c); // Parse the JSON response
                    this.sapRating = responseBody.sapRating || 'N/A';  // Store sapRating in tracked variable
                    this.lifetime = responseBody.lifetime || 'N/A';  // Store lifetime if available
                    this.spaceHeatingDemand = responseBody.spaceHeatingCost || 'N/A';  // Store spaceHeatingCost if available
                } else {
                    console.error('No response found.');
                }
            })
            .catch(error => {
                console.error('Error fetching response:', error);
            });
    }
}