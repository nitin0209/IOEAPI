import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISInstallationPDfController.getRelatedFilesByRecordId';
export default class sCISInstallationPdf extends LightningElement {
    

    @api recordId; // This should be automatically set when the LWC is on a record page
    @api heightInRem;
    @track error;
    @track fileID;
    @track pdfFiles = [];
    @track activeTabId = '';
    @track fileUrl = '';


    @wire(getRelatedFilesByRecordId, { parentRecordId: '$recordId' })
    wiredFieldValue({ error, data }) {
        console.log('Record ID passed to Apex:', this.recordId); // Debugging line to check recordId
        if (data) {
            this.pdfFiles = data;
            this.error = undefined;
            const fileIDs = Object.keys(data);
            this.fileID = fileIDs.length ? fileIDs[0] : undefined;
            this.activeTabId = this.fileID;
            this.fileUrl = this.getFileUrl(this.fileID); // Generate initial file URL
        } else if (error) {
            console.error('Error retrieving data from Apex:', error);
            this.error = error;
            this.pdfFiles = [];
            this.fileID = undefined;
        }
    }

    get tabs() {
        if (!this.pdfFiles || Object.keys(this.pdfFiles).length === 0) {
            return [];
        }

        return Object.entries(this.pdfFiles).map(([ID, title]) => ({
            value: ID,
            label: title,
            isActive: this.activeTabId === ID
        }));
    }

    setFileID(e) {
        this.activeTabId = e.target.value;
        this.fileID = this.activeTabId;
        this.fileUrl = this.getFileUrl(this.fileID); // Update file URL when tab changes
    }

    getFileUrl(fileID) {
        return `/sfc/servlet.shepherd/document/download/${fileID}?operationContext=S1`;
    }

    disablePDFControls(event) {
        // Your existing disable PDF controls logic
    }

    renderedCallback() {
        this.adjustTabStyles();
        this.applyPdfViewerHandlers(); // Reapply handlers after each render
    }

    adjustTabStyles() {
        const tabs = this.template.querySelectorAll('.slds-tabs_default__item');
        tabs.forEach(tab => {
            tab.style.minWidth = '150px'; // Adjust width as needed
            tab.style.height = '50px'; // Adjust height as needed
        });
    }

    applyPdfViewerHandlers() {
        const iframe = this.template.querySelector('iframe');
        if (iframe) {
            iframe.onload = this.disablePDFControls.bind(this);
        }
    }
}