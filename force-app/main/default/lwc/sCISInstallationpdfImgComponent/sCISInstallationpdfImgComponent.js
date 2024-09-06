import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISInstallationImgPdfController.getRelatedFilesByRecordId';

export default class SCISInstallationPdfImgComponent extends LightningElement {
    @api recordId;
    @track error;
    @track fileID;
    @track pdfFiles = {};
    @track imageFiles = {};
    @track activeTabId = '';
    @track fileUrl = '';
    @track activeContentType = '';

    @wire(getRelatedFilesByRecordId, { parentRecordId: '$recordId' })
    wiredFieldValue({ error, data }) {
        if (data) {
            this.pdfFiles = data.pdfs || {};
            this.imageFiles = data.images || {};
            this.error = undefined;

            const fileIDs = Object.keys(this.pdfFiles).concat(Object.keys(this.imageFiles));
            if (fileIDs.length > 0) {
                this.fileID = fileIDs[0];
                this.activeTabId = this.fileID;
                this.fileUrl = this.getFileUrl(this.fileID);
                this.activeContentType = this.pdfFiles[this.fileID] ? 'pdf' : 'image';
            }
        } else if (error) {
            this.error = error;
            this.pdfFiles = {};
            this.imageFiles = {};
            this.fileID = undefined;
        }
    }

    get documentTabs() {
        return this.generateTabs(this.pdfFiles);
    }

    get imageTabs() {
        return this.generateTabs(this.imageFiles);
    }

    generateTabs(files) {
        if (!files || Object.keys(files).length === 0) {
            return [];
        }
        return Object.entries(files).map(([ID, title]) => ({
            value: ID,
            label: title,
            isActive: this.activeTabId === ID,
        }));
    }

    setFileID(event) {
        this.activeTabId = event.target.value;
        this.fileID = this.activeTabId;
        this.fileUrl = this.getFileUrl(this.fileID);
        this.activeContentType = this.pdfFiles[this.fileID] ? 'pdf' : 'image';

        this.reloadContent();
    }

    getFileUrl(fileID) {
        if (!fileID) return '';
        return `/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${fileID}`;
    }

    reloadContent() {
        // Force the iframe or img to reload
        if (this.activeContentType === 'pdf') {
            this.resetIframe();
        } else if (this.activeContentType === 'image') {
            this.resetImage();
        }
    }

    resetIframe() {
        // Reset and reload the iframe for PDFs
        const iframe = this.template.querySelector('iframe');
        if (iframe) {
            iframe.src = ''; // Reset the iframe src to force reload
            setTimeout(() => {
                iframe.src = this.fileUrl;
            }, 50); // Delay to ensure proper reload
        }
    }

    resetImage() {
        // Reset and reload the img for images
        const img = this.template.querySelector('img');
        if (img) {
            img.src = ''; // Reset the img src to force reload
            setTimeout(() => {
                img.src = this.fileUrl;
            }, 50); // Delay to ensure proper reload
        }
    }

    handleMainTabChange(event) {
        const selectedTabLabel = event.target.label;

        if (selectedTabLabel === 'Documents' && this.documentTabs.length > 0) {
            this.activeTabId = this.documentTabs[0].value;
            this.fileID = this.activeTabId;
            this.fileUrl = this.getFileUrl(this.fileID);
            this.activeContentType = 'pdf';
        } else if (selectedTabLabel === 'Images' && this.imageTabs.length > 0) {
            this.activeTabId = this.imageTabs[0].value;
            this.fileID = this.activeTabId;
            this.fileUrl = this.getFileUrl(this.fileID);
            this.activeContentType = 'image';
        }

        this.reloadContent();
    }

    get noDocumentsAvailable() {
        return !this.documentTabs || this.documentTabs.length === 0;
    }

    get noImagesAvailable() {
        return !this.imageTabs || this.imageTabs.length === 0;
    }
}