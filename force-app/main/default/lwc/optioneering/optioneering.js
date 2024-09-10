import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchLatestResponse from '@salesforce/apex/IOEResponseController.fetchLatestResponse';
import makeHttpPostRequest from '@salesforce/apex/scisIOEResponseHandler.makeHttpPostRequest';
import savePackageData from '@salesforce/apex/scisIOEResponseHandler.savePackageData'; // Import the save method

export default class Optioneering extends LightningElement {
    @track responseBody;
    @track eiRating;
    @track totalDeliveredEnergy;
    @track totalFuelCosts;
    @track co2Emissions;
    @track spaceHeatingDemand;
    @track recommendations = []; // Track recommendations
    @track recommendationData = []; // Track extracted recommendation data (name, text, result)

    // Fetches the latest response from Salesforce and parses it
    handleFetch() {
        fetchLatestResponse()
            .then(result => {
                if (result) {
                    console.log('Fetched response from Salesforce:', result);

                    this.responseBody = result.Response_Body__c;

                    // Parse the JSON response from the fetched result
                    let responseJson = JSON.parse(result.Response_Body__c);

                    console.log('Parsed JSON response:', responseJson);

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

                    // Prepare recommendation data for saving
                    this.recommendationData = responseJson.recommendations.map(recommendation => {
                        return {
                            name: recommendation.name || '',
                            text: recommendation.text || '',
                            result: recommendation.result || 0
                        };
                    });

                    console.log('Extracted recommendation data:', this.recommendationData);

                    // Show success toast
                    this.showToast('Success', 'Latest response fetched successfully', 'success');
                } else {
                    this.responseBody = 'No response found.';
                    console.log('No response found.');
                    this.showToast('Info', 'No response found', 'info');
                }
            })
            .catch(error => {
                console.error('Error fetching response:', error);
                this.responseBody = 'An error occurred while fetching the response.';
                this.showToast('Error', 'An error occurred while fetching the response', 'error');
            });
    }

    // Method to call the Apex makeHttpPostRequest method with toast messages
    handleMakeHttpPostRequest() {
        makeHttpPostRequest()
            .then(response => {
                if (response) {
                    console.log('HTTP POST request response:', response);

                    this.responseBody = response;

                    // Parse the JSON response
                    let responseJson = JSON.parse(response);

                    console.log('Parsed JSON from HTTP POST request:', responseJson);

                    // Extract data for recommendations
                    this.recommendationData = responseJson.recommendations.map(recommendation => {
                        return {
                            name: recommendation.name || '',
                            text: recommendation.text || '',
                            result: recommendation.result || 0
                        };
                    });

                    console.log('Extracted recommendation data:', this.recommendationData);

                    // Show success toast
                    this.showToast('Success', 'HTTP POST request completed successfully', 'success');
                }
            })
            .catch(error => {
                console.error('Error making HTTP POST request:', error);
                this.showToast('Error', 'An error occurred while making the HTTP POST request', 'error');
            });
    }

    // Method to save the recommendations data to Salesforce
    handleSavePackageData() {
        // Debugging to check if values are passed correctly
        console.log('Package Data being saved:', this.recommendationData);

        // Pass the extracted recommendation data to Apex
        savePackageData({ recommendationData: this.recommendationData })
            .then(result => {
                console.log('Package data saved successfully:', result);
                this.showToast('Success', 'Package data saved successfully', 'success');
            })
            .catch(error => {
                console.error('Error saving package data:', error);
                this.showToast('Error', 'Failed to save package data', 'error');
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