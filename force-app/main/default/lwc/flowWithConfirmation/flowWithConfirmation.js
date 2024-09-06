import { LightningElement, api, track } from 'lwc';

export default class FlowWithConfirmation extends LightningElement {
    @api flowName;
    @track isModalOpen = false;
    @track flowInstance;

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            // Handle flow finish event if needed
        }
    }

    handleBeforeNext(event) {
        event.preventDefault(); // Prevent the default navigation
        this.flowInstance = event.detail.flowInstance; // Save the flow instance for later use
        this.isModalOpen = true; // Open the confirmation modal
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleProceed() {
        this.isModalOpen = false;
        // Resume the flow navigation
        this.flowInstance.next();
    }
}