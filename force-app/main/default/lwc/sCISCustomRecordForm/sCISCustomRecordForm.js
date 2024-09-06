// customRecordForm.js
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SCISCustomRecordForm extends LightningElement {
    @api recordId;
    @api objectApiName;

    handleSuccess() {
        // Show confirmation dialog before saving
        if (confirm('Do you want to save this survey?')) {
            this.template.querySelector('lightning-record-form').submit();
        } else {
            // Optionally handle cancel action
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Action canceled',
                    message: 'Survey was not saved',
                    variant: 'warning'
                })
            );
        }
    }
}