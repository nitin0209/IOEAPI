import { LightningElement } from 'lwc';
import jsPDF from '@salesforce/resourceUrl/jsPDFLibrary';
import { loadScript } from 'lightning/platformResourceLoader';
import savePdf from '@salesforce/apex/PdfController.savePdf';

export default class PdfGenerator extends LightningElement {
    jsPdfLib;
    jsPdfInitialized = false;

    renderedCallback() {
        if (this.jsPdfInitialized) {
            return;
        }
        this.jsPdfInitialized = true;

        // Load jsPDF library
        loadScript(this, jsPDF)
            .then(() => {
                this.jsPdfLib = window.jspdf;
            })
            .catch(error => {
                console.error('Error loading jsPDF library:', error);
            });
    }

    generatePdf() {
        if (!this.jsPdfLib) {
            console.error('jsPDF library is not loaded.');
            return;
        }

        const doc = new this.jsPdfLib.jsPDF();
        const content = this.template.querySelector('#contentToConvert').innerHTML;

        // Using doc.html to handle HTML content
        doc.html(content, {
            callback: (doc) => {
                const pdfOutput = doc.output('blob');
                this.uploadPdf(pdfOutput);
            },
            x: 10,
            y: 10
        });
    }

    uploadPdf(pdfBlob) {
        const reader = new FileReader();
        reader.onloadend = () => {
            const base64data = reader.result.split(',')[1];

            savePdf({ base64Data: base64data, fileName: 'generated.pdf' })
                .then(() => {
                    console.log('PDF saved successfully');
                })
                .catch(error => {
                    console.error('Error saving PDF', error);
                });
        };
        reader.readAsDataURL(pdfBlob);
    }
}