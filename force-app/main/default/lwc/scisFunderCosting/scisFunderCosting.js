import { LightningElement, track, wire } from 'lwc';
import getCostingDetails from '@salesforce/apex/FunderCostingController.getCostingDetails';

export default class FundCostingDetails extends LightningElement {
    @track costingDetails;
    @track fieldVisibility = {}; // Object to track visibility of each field
    
    // Fetch costing details from the server
    @wire(getCostingDetails)
    wiredCostingDetails({ error, data }) {
        if (data) {
            this.costingDetails = data;
        } else if (error) {
            console.error('Error fetching costing details:', error);
        }
    }

    // Handle checkbox change
    handleCheckboxChange(event) {
        const fieldName = event.target.dataset.field; // Get field from data-field attribute
        this.fieldVisibility[fieldName] = event.target.checked; // Toggle visibility
    }

    // Check if a field's value should be visible
    isFieldVisible(field) {
        return this.fieldVisibility[field];
    }
}