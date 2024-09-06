import { LightningElement, track } from 'lwc';
import getResponseCode from '@salesforce/apex/ResponseCodeService.getResponseCode';

export default class ResponseCodeComponent extends LightningElement {
    @track responseCode;

    connectedCallback() {
        this.fetchResponseCode();
    }

    fetchResponseCode() {
        getResponseCode()
            .then(result => {
                this.responseCode = result;
            })
            .catch(error => {
                console.error('Error fetching response code:', error);
            });
    }
}