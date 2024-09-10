import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISInstallationImgPdfController.getRelatedFilesByRecordId';

export default class SCISInstallationpdfImgComponent extends LightningElement {
    @api recordId;
    @api heightInRem;
    @track error;
    @track fileID;
    @track pdfFiles = {}; // Map to store PDFs
    @track imageFiles = {}; // Map to store images
    @track activeTabId = '';
    @track fileUrl = '';
    @track activeContentType = ''; // Track the type of active content (pdf or image)

    MAX_VISIBLE_TABS = 3; // Number of tabs before "More" option appears
    @track visibleDocumentTabs = [];
    @track moreDocumentTabs = [];
    @track visibleImageTabs = [];
    @track moreImageTabs = [];
    @track showMoreDocuments = false;
    @track showMoreImages = false;
    @track isFirstRender = true; // Track first render to manage initial loading

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

            // Adjust tabs after data is fetched
            this.adjustTabs();
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
            isActive: this.activeTabId === ID
        }));
    }

    setFileID(event) {
        this.activeTabId = event.target.value;
        this.fileID = this.activeTabId;

        // Update file URL
        this.fileUrl = this.getFileUrl(this.fileID);

        // Determine content type for reloading
        this.activeContentType = this.pdfFiles[this.fileID] ? 'pdf' : 'image';

        // Reload the relevant content only
        this.reloadContent();
    }

    // for connectedCallBack start here
    // connectedCallback() {
        
    //     this.initializeActiveTab();
    // }
    
    // initializeActiveTab() {
        
    //     const tabs = this.generateTabs(this.files);
        
        
    //     if (tabs.length > 0) {
    //         this.activeTabId = tabs[0].value;
    //         this.setFileID({ target: { value: this.activeTabId } });
    //     }
    // }

    // connectCallBack ends here

    getFileUrl(fileID) {
        if (!fileID) return '';
        return `/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${fileID}`;
    }

    reloadContent() {
        if (this.activeContentType === 'pdf') {
            const iframe = this.template.querySelector('iframe');
            if (iframe) {
                iframe.src = this.fileUrl;
            }
        } else if (this.activeContentType === 'image') {
            const img = this.template.querySelector('img');
            if (img) {
                img.src = this.fileUrl;
            }
        }
    }

    handleTabChange(event) {
        // This method is triggered when the main tab (Documents or Images) changes
        if (event.target.label === 'Documents' && this.documentTabs.length > 0) {
            this.activeTabId = this.documentTabs[0].value;
            this.fileUrl = this.getFileUrl(this.activeTabId);
            this.activeContentType = 'pdf';
        } else if (event.target.label === 'Images' && this.imageTabs.length > 0) {
            this.activeTabId = this.imageTabs[0].value;
            this.fileUrl = this.getFileUrl(this.activeTabId);
            this.activeContentType = 'image';
        }

        this.reloadContent();
    }

    adjustTabs() {
        const docTabs = this.documentTabs;
        const imgTabs = this.imageTabs;

        this.visibleDocumentTabs = docTabs.slice(0, this.MAX_VISIBLE_TABS);
        this.moreDocumentTabs = docTabs.slice(this.MAX_VISIBLE_TABS);

        this.visibleImageTabs = imgTabs.slice(0, this.MAX_VISIBLE_TABS);
        this.moreImageTabs = imgTabs.slice(this.MAX_VISIBLE_TABS);

        this.showMoreDocuments = this.moreDocumentTabs.length > 0;
        this.showMoreImages = this.moreImageTabs.length > 0;
    }

    renderedCallback() {
        if (this.isFirstRender) {
            this.adjustTabStyles();
            this.reloadContent();
            this.isFirstRender = false;
        }
    }

    adjustTabStyles() {
        const tabs = this.template.querySelectorAll('.slds-tabs_default__item');
        tabs.forEach(tab => {
            tab.style.minWidth = '150px';
            tab.style.height = '50px';
        });
    }

    get noDocumentsAvailable() {
        return !this.documentTabs || this.documentTabs.length === 0;
    }

    get noImagesAvailable() {
        return !this.imageTabs || this.imageTabs.length === 0;
    }
}