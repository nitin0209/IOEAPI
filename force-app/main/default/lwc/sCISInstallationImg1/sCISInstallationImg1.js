import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISSurveyImgController.getRelatedFilesByRecordId';

export default class SCISInstallationImg1 extends LightningElement {
    @api recordId; 
    @api heightInRem;
    @track error;
    @track fileID;
    @track imageFiles = {}; // Use an object to handle multiple images
    @track activeTabId = '';
    @track fileUrl = '';
  
    

    @wire(getRelatedFilesByRecordId, { parentRecordId: '$recordId' })
    wiredFieldValue({ error, data }) {

        
        console.log('Record ID passed to Apex:', this.recordId);
        if (data) {
            console.log('Data received from Apex:', JSON.stringify(data));
            this.imageFiles = data || {};
            this.error = undefined;

            const fileIDs = Object.keys(this.imageFiles);
            if (fileIDs.length > 0) {
                this.fileID = fileIDs[0];
                this.activeTabId = this.fileID;
                this.fileUrl = this.getImageUrl(this.fileID);
            }

            console.log('Initial file URL:', this.fileUrl);
        } else if (error) {
            console.error('Error retrieving data from Apex:', error);
            this.error = error;
            this.imageFiles = {};
            this.fileID = undefined;
        }
    }

    get tabs() {
        // Generate tab objects for all images
        if (!this.imageFiles || Object.keys(this.imageFiles).length === 0) {
            console.log('No images found in data.');
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
        this.fileUrl = this.getImageUrl(this.fileID);

        console.log('Updated active tab ID:', this.activeTabId);
        console.log('Updated image URL:', this.fileUrl);
    }

    getImageUrl(fileID) {
        if (!fileID) {
            console.warn('Missing fileID for URL generation');
            return '';
        }

        const url = `/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${fileID}`;
        console.log('Generated Image URL:', url);
        return url;
    }

    renderedCallback() {
        this.adjustTabStyles();
    }

    adjustTabStyles() {
        const tabs = this.template.querySelectorAll('.slds-tabs_default__item');
        tabs.forEach(tab => {
            tab.style.minWidth = '150px';
            tab.style.height = '50px';
        });
    }

    get noImagesAvailable() {
        return !this.tabs || this.tabs.length === 0;
    }
}