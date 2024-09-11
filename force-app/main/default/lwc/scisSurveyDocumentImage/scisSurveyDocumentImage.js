import { LightningElement, api, track } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISSurveyFileController.getRelatedFilesByRecordId';

export default class DocumentImageTabset extends LightningElement {
    @api recordId;
    @track imageFiles = [];
    @track documentFiles = [];
    noImageFiles = false;
    noDocumentFiles = false;

    connectedCallback() {
        // Fetch and display image files
        this.fetchFiles(true);
        // Fetch and display document files
        this.fetchFiles(false);
    }

    fetchFiles(isImage) {
        getRelatedFilesByRecordId({ parentRecordId: this.recordId, isImage })
            .then((result) => {
                const files = Object.keys(result).map((key) => ({
                    id: key,
                    title: result[key],
                    contentUrl: `/sfc/servlet.shepherd/version/download/${key}` // Generates the URL to access the content
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
        const activeTab = event.target.value;
        console.log('Active Tab:', activeTab);
    }
}