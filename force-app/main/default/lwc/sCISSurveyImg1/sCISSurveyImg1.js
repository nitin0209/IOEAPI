import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISSurveyImgController.getRelatedFilesByRecordId';

export default class SCISSurveyImg1 extends LightningElement {
    @api recordId; // This should be automatically set when the LWC is on a record page
    @api heightInRem;
    @track error;
    @track fileID;
    @track imageFiles = []; // Renamed to reflect images, not PDFs
    @track activeTabId = '';
    @track fileUrl = '';

    @wire(getRelatedFilesByRecordId, { parentRecordId: '$recordId' })
    wiredFieldValue({ error, data }) {
        console.log('Record ID passed to Apex:', this.recordId); // Debugging line to check recordId
        if (data) {
            this.imageFiles = data;
            this.error = undefined;
            const fileIDs = Object.keys(data);
            this.fileID = fileIDs.length ? fileIDs[0] : undefined;
            this.activeTabId = this.fileID;
            this.fileUrl = this.getImageUrl(this.fileID); // Generate initial image URL
        } else if (error) {
            console.error('Error retrieving data from Apex:', error);
            this.error = error;
            this.imageFiles = [];
            this.fileID = undefined;
        }
    }

    get tabs() {
        if (!this.imageFiles || Object.keys(this.imageFiles).length === 0) {
            return [];
        }

        return Object.entries(this.imageFiles).map(([ID, title]) => ({
            value: ID,
            label: title,
            isActive: this.activeTabId === ID
        }));
    }

    setFileID(e) {
        this.activeTabId = e.target.value;
        this.fileID = this.activeTabId;
        this.fileUrl = this.getImageUrl(this.fileID); // Update image URL when tab changes
    }

    getImageUrl(fileID) {
        // Use the correct URL to render images directly using ContentVersion ID
        return `/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${fileID}`;
    }

    renderedCallback() {
        this.adjustTabStyles();
    }

    adjustTabStyles() {
        const tabs = this.template.querySelectorAll('.slds-tabs_default__item');
        tabs.forEach(tab => {
            tab.style.minWidth = '150px'; // Adjust width as needed
            tab.style.height = '50px'; // Adjust height as needed
        });
    }
}