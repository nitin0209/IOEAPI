import { LightningElement, api, track } from 'lwc';
import generateAndAttachPDF from '@salesforce/apex/LeadPDFGeneratorV1.generateAndAttachPDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeadPdfButton extends LightningElement {
    @api recordId;
    @track showToast = false;
    @track toastMessage = '';
    @track toastTitle = '';
    @track toastVariant = '';

    handleGeneratePDF() {
        generateAndAttachPDF({ leadId: this.recordId })
            .then(result => {
                this.showToastMessage('Success', 'PDF attached successfully', 'success');
            })
            .catch(error => {
                this.showToastMessage('Error', 'Failed to attach PDF', 'error');
                console.error('Error:', error);
            });
    }

    showToastMessage(title, message, variant) {
        this.toastTitle = title;
        this.toastMessage = message;
        this.toastVariant = variant;
        this.showToast = true;
    }

    handleToastClose() {
        this.showToast = false;
    }
}