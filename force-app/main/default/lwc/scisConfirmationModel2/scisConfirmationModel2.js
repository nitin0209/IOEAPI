import { LightningElement, track } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class SCISConfirmationButton extends LightningElement {
     @track isModalOpen = false;

    handleOpenModal() {
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleProceed() {
        this.isModalOpen = false;
        // Dispatch the FlowNavigationNextEvent to navigate to the next screen in the flow
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
}