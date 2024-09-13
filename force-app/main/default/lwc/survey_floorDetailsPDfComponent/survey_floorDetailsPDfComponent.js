import { LightningElement, api, track } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/surveyPdfController.getRelatedFilesByRecordId';

export default class SurveyPdfViewerIframe extends LightningElement {
    @api recordId; // The recordId passed from the parent record (e.g., Survey__c)
    @track pdfUrl; // To store the PDF URL to show in iframe
    @track error; // To store errors if any
    @track loading = false; // Loading spinner control

    // Called automatically when the component loads
    connectedCallback() {
        this.fetchPDF();
    }

    // Fetch PDFs by calling Apex method and showing the first one in an iframe
    fetchPDF() {
        this.loading = true; // Start loading spinner
        this.error = undefined; // Clear previous errors
        this.pdfUrl = undefined; // Clear previous URL

        if (!this.recordId) {
            this.error = 'No Record ID provided.';
            this.loading = false;
            return;
        }

        getRelatedFilesByRecordId({ parentRecordId: this.recordId })
            .then(result => {
                const fileKeys = Object.keys(result);
                if (fileKeys.length > 0) {
                    // Set the URL for the first PDF
                    this.pdfUrl = `/sfc/servlet.shepherd/document/download/${fileKeys[0]}?operationContext=VIEW`;
                } else {
                    this.error = 'No Floor Plan Available here';
                }
                this.loading = false; // Stop loading spinner
            })
            .catch(error => {
                this.error = 'Error fetching PDF: ' + error.body.message;
                this.loading = false; // Stop loading spinner
            });
    }
}