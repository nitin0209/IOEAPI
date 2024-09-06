import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchLatestResponse from '@salesforce/apex/IOEResponseController.fetchLatestResponse';
import makeHttpPostRequest from '@salesforce/apex/scisIOEResponseHandler.makeHttpPostRequest';

export default class Optioneering extends LightningElement {
    @track responseBody;
    @track eiRating;
    @track totalDeliveredEnergy;
    @track totalFuelCosts;
    @track co2Emissions;
    @track spaceHeatingDemand;
    @track recommendations = []; // Track recommendations

    // Fetches the latest response from Salesforce and parses it
    handleFetch() {
        fetchLatestResponse()
            .then(result => {
                if (result) {
                    this.responseBody = result.Response_Body__c;

                    // Parse the JSON response from the fetched result
                    let responseJson = JSON.parse(result.Response_Body__c);

                    // Extract values from JSON response using safe access
                    this.eiRating = responseJson.eiRating || null;
                    this.totalDeliveredEnergy = responseJson.primaryEnergy || null;
                    this.totalFuelCosts = responseJson.totalCost || null;
                    this.co2Emissions = responseJson.cO2Emissions || null;
                    this.spaceHeatingDemand = responseJson.spaceHeatingCost || null;

                    // Extract recommendations if present
                    this.recommendations = responseJson.recommendations.map(recommendation => {
                        return {
                            ...recommendation,
                            isCheckedLabel: recommendation.isChecked ? 'Yes' : 'No' // Add a new field for 'Yes' or 'No'
                        };
                    });

                    // Show success toast
                    this.showToast('Success', 'Latest response fetched successfully', 'success');
                } else {
                    this.responseBody = 'No response found.';
                    this.showToast('Info', 'No response found', 'info');
                }
            })
            .catch(error => {
                console.error('Error fetching response', error);
                this.responseBody = 'An error occurred while fetching the response.';
                this.showToast('Error', 'An error occurred while fetching the response', 'error');
            });
    }

    // Method to call the Apex makeHttpPostRequest method with toast messages
    handleMakeHttpPostRequest() {
        makeHttpPostRequest()
            .then(response => {
                if (response) {
                    this.responseBody = response;

                    // Parse the JSON response
                    let responseJson = JSON.parse(response);

                    // Update component state with parsed data
                    this.eiRating = responseJson.eiRating || null;
                    this.totalDeliveredEnergy = responseJson.primaryEnergy || null;
                    this.totalFuelCosts = responseJson.totalCost || null;
                    this.co2Emissions = responseJson.cO2Emissions || null;
                    this.spaceHeatingDemand = responseJson.spaceHeatingCost || null;

                    // Extract recommendations if present
                    this.recommendations = responseJson.recommendations.map(recommendation => {
                        return {
                            ...recommendation,
                            isCheckedLabel: recommendation.isChecked ? 'Yes' : 'No' // Add a new field for 'Yes' or 'No'
                        };
                    });

                    // Show success toast
                    this.showToast('Success', 'HTTP POST request completed successfully', 'success');
                }
            })
            .catch(error => {
                console.error('Error making HTTP POST request', error);
                this.showToast('Error', 'An error occurred while making the HTTP POST request', 'error');
            });
    }

    // Utility method to show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}