import { LightningElement, api, wire } from 'lwc';
import getWavFileUrl from '@salesforce/apex/WavFileController.getWavFileUrl';

export default class WavPlayer extends LightningElement {
    @api recordId;
    wavFileUrl;
    error;

    @wire(getWavFileUrl, { recordId: '$recordId' })
    wiredWavFile({ error, data }) {
        if (data) {
            this.wavFileUrl = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.wavFileUrl = undefined;
        }
    }
}