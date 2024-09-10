import { LightningElement, api, track } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISSurveyFileController.getRelatedFilesByRecordId';

export default class DocumentImageTabset extends LightningElement {
    @api recordId;
    @track imageFiles = [];
    @track documentFiles = [];
    noImageFiles = false;
    noDocumentFiles = false;
    activeTabValue = 'documents'; // Set default active tab to 'documents'

    connectedCallback() {
        // Fetch and display document files first
        this.fetchFiles(false);
        // Fetch and display image files afterward
        this.fetchFiles(true);
    }

    fetchFiles(isImage) {
        getRelatedFilesByRecordId({ parentRecordId: this.recordId, isImage })
            .then((result) => {
                const files = Object.keys(result).map((key) => ({
                    id: key,
                    title: result[key],
                    contentUrl: `/sfc/servlet.shepherd/version/download/${key}`, // Generates the URL to access the content
                }));
                if (isImage) {
                    this.imageFiles = files;
                    this.noImageFiles = files.length === 0;
                } else {
                    this.documentFiles = files;
                    this.noDocumentFiles = files.length === 0;
                }
            })
            .catch((error) => {
                console.error('Error fetching files:', error);
                if (isImage) {
                    this.noImageFiles = true;
                } else {
                    this.noDocumentFiles = true;
                }
            });
    }

    handleTabChange(event) {
        // Optional: handle actions when switching between tabs
        this.activeTabValue = event.target.value;
        console.log('Active Tab:', this.activeTabValue);
    }
}
