import { LightningElement, track } from 'lwc';
import fetchLatestResponse from '@salesforce/apex/scisIOEResponseHandler.fetchLatestResponse'; // Import the Apex method

export default class ImprovementOptions extends LightningElement {
    @track improvementOptions = []; // Track the improvement options for dynamic rendering
    @track selectedPackageName = null; // To store the selected package name for dynamic rendering

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

                    // Ensure all "Mark for installation" checkboxes are checked by default
                    this.improvementOptions = this.improvementOptions.map(option => {
                        return { ...option, isMarkForInstallationChecked: true };
                    });

                    console.log('Improvement Options:', this.improvementOptions);
                } else {
                    console.error('No recommendations found in response');
                }
            })
            .catch(error => {
                console.error('Error fetching improvement options:', error);
            });
    }

    // Handle when "Add to package" checkbox is clicked
    handleAddToPackage(event) {
        const selectedOptionName = event.target.value; // Get the name from the checkbox value
        if (event.target.checked) {
            // If "Add to package" is checked, store the selected package name
            this.selectedPackageName = selectedOptionName;
        } else {
            // If unchecked, remove the selected package
            this.selectedPackageName = null;
        }
    }

    // Handle the right arrow icon click
    handleRightArrowClick(event) {
        const selectedOptionName = event.currentTarget.dataset.optionName; // Get option name from dataset
        this.selectedPackageName = selectedOptionName;
    }

    // Event to hide improvement options
    handleBackClick() {
        const hideImprovementOptionsEvent = new CustomEvent('hideimprovementoptions');
        this.dispatchEvent(hideImprovementOptionsEvent);
    }
}