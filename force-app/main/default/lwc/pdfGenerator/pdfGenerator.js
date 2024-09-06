import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import savePDF from '@salesforce/apex/SCIS_LeadPDFController.savePDF';
import jsPDF from '@salesforce/resourceUrl/jsPDFLibrary';

export default class LeadPDFGenerator extends LightningElement {
    @api recordId;

    handleButtonClick(event) {
        // Create a new jsPDF instance
        const doc = new jsPDF();
        console.log('this.recordID = ' + this.recordId);
        console.log('recordID = ' + recordId);
        // Generate PDF content
        const content = `
            Lead Details\n\n
            Name: ${recordId}\n
            Company: Sample Company\n
            Email: sample@example.com\n
            Phone: 123-456-7890\n
            Status: New\n
            Website: www.example.com\n
        `;

        doc.text(content, 10, 10);

        // Convert PDF to Base64 string
        const base64Data = doc.output('datauristring').split(',')[1];

        // Call Apex method to save the PDF
        savePDF({ base64Data: base64Data, leadId: this.recordId })
            .then(url => {
                this.showToast('Success', 'PDF generated and stored successfully.', 'success');
                
                // Create an invisible anchor element and trigger the download
                const link = document.createElement('a');
                link.href = url;
                link.download = `Lead_${this.recordId}.pdf`;
                link.click();
            })
            .catch(error => {
                this.showToast('Error', 'Error generating or saving PDF: ' + error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}