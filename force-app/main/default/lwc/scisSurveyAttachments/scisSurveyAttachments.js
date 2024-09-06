import { LightningElement, api, wire } from 'lwc';
import getUploadedFiles from '@salesforce/apex/FileController.getUploadedFiles';

export default class ViewUploadedFiles extends LightningElement {
    @api recordId; // Record Id passed from parent component or record page
    files;
    error;

    // Wire method to retrieve uploaded files from Apex controller
    @wire(getUploadedFiles, { recordId: '$recordId' })
    wiredFiles({ error, data }) {
        if (data) {
            this.files = data;
            this.error = undefined;
        } else if (error) {
            this.files = undefined;
            this.error = error;
        }
    }

    
    // Method to handle viewing a file
handleViewFile(event) {
    console.log('handleViewFile method called');
    const fileId = event.target.dataset.fileId;
    // Assuming you have a URL to access the file content
    // Replace 'YOUR_FILE_URL' with the actual URL to access the file content
    const fileUrl = `/sfc/servlet.shepherd/version/download/${fileId}`;
    
    // Log the fileUrl to the console for debugging
    console.log('File URL:', fileUrl);
    
    // Open the file in a new window
    window.open(fileUrl, '_blank');
}


}