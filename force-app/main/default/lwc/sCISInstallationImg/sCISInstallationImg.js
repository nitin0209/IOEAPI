import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/SCISInstallationImgController.getRelatedFilesByRecordId';

export default class ScisInstallationImg extends LightningElement {
    @api recordId; // This should be automatically set when the LWC is on a record page
    @api heightInRem; // Height for the display elements, defined in rem
    @track error; // Holds any error returned from the Apex controller
    @track imageFiles = []; // List of images
    @track activeImageId = ''; // Active Image ID for display
    @track imageUrl = ''; // URL to display the active image

    @wire(getRelatedFilesByRecordId, { parentRecordId: '$recordId' })
    wiredFieldValue({ error, data }) {
        console.log('Record ID passed to Apex:', this.recordId); // Debugging line to check recordId
        if (data) {
            this.imageFiles = data || {}; // Initialize imageFiles with the returned data or an empty object
            this.error = undefined; // Clear previous errors if the call was successful

            const imageIDs = Object.keys(this.imageFiles); // Extract IDs of images

            this.activeImageId = imageIDs.length ? imageIDs[0] : undefined; // Set the active Image ID to the first in the list, if any

            // Generate URL for the first image (if available)
            this.imageUrl = this.getImageUrl(this.activeImageId);
        } else if (error) {
            console.error('Error retrieving data from Apex:', error);
            this.error = error;
            this.imageFiles = [];
            this.activeImageId = undefined;
        }
    }

    get imageTabs() {
        // Generate tab objects for images if available
        if (!this.imageFiles || Object.keys(this.imageFiles).length === 0) {
            return [];
        }

        return Object.entries(this.imageFiles).map(([ID, title]) => ({
            value: ID,
            label: title,
            isActive: this.activeImageId === ID // Determine if this tab is active
        }));
    }

    setImageId(e) {
        this.activeImageId = e.target.value; // Update the active Image ID based on the user's selection
        this.imageUrl = this.getImageUrl(this.activeImageId); // Update the URL to display the selected image
    }

    getImageUrl(fileID) {
        // Generate the correct URL to display the image
        return `/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${fileID}`;
    }
}