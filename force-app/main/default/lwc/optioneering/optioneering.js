import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchLatestResponse from '@salesforce/apex/IOEResponseController.fetchLatestResponse';
import makeHttpPostRequest from '@salesforce/apex/scisIOEResponseHandler.makeHttpPostRequest';
import savePackageData from '@salesforce/apex/scisIOEResponseHandler.savePackageData';

export default class Optioneering extends LightningElement {
    @track responseBody;
    @track eiRating;
    @track totalDeliveredEnergy;
    @track totalFuelCosts;
    @track co2Emissions;
    @track spaceHeatingDemand;
    @track recommendations = [];
    @track surveyId;

    // Extract the surveyId from the current page reference
    @wire(CurrentPageReference)
    getPageRef(pageRef) {
        this.surveyId = pageRef?.attributes?.recordId; // Extract the recordId from attributes
        console.log('Current surveyId:', this.surveyId);
    }

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

                    // Extract recommendations directly
                    this.recommendations = responseJson.recommendations || [];

                    console.log('Recommendations:', this.recommendations);

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
                this.showToast('Error', 'An error occurred while fetching the response', 'error');
            });
    }

    // Make HTTP POST request to fetch the latest data from the external API
    handleMakeHttpPostRequest() {
        if (!this.surveyId) {
            console.error('Survey ID not found. Ensure the recordId is present in the URL.');
            this.showToast('Error', 'Survey ID not found', 'error');
            return;
        }

        makeHttpPostRequest({ surveyId: this.surveyId })
            .then(response => {
                if (response === 'Elmhurst XML Base64 file not found for this survey.') {
                    console.error('Elmhurst XML Base64 file not found.');
                    this.showToast('Error', response, 'error');
                } else {
                    console.log('HTTP POST request response:', response);
                    this.responseBody = response;

                    // Parse the JSON response
                    let responseJson = JSON.parse(response);
                    console.log('Parsed JSON from HTTP POST request:', responseJson);

                    // Extract recommendations directly
                    this.recommendations = responseJson.recommendations || [];

                    console.log('Recommendations:', this.recommendations);

                    // Show success toast
                    this.showToast('Success', 'HTTP POST request completed successfully', 'success');
                }
            })
            .catch(error => {
                console.error('Error making HTTP POST request:', error);
                this.showToast('Error', 'An error occurred while making the HTTP POST request', 'error');
            });
    }

    // Save the package data to Salesforce
    handleSavePackageData() {
        console.log('Package Data being saved:', this.recommendations);

        savePackageData({ recommendationData: this.recommendations })
            .then(result => {
                console.log('Package data saved successfully:', result);
                this.showToast('Success', 'Package data saved successfully', 'success');
            })
            .catch(error => {
                console.error('Error saving package data:', error);
                this.showToast('Error', 'Failed to save package data', 'error');
            });
    }

    // Handles click event for Improvement Options
    handleOptioneeringClick() {
        const showImprovementOptionsEvent = new CustomEvent('showimprovementoptions');
        this.dispatchEvent(showImprovementOptionsEvent);
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