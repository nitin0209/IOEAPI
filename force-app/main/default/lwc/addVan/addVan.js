import { LightningElement, track } from 'lwc';
import saveVan from '@salesforce/apex/AddVanController.saveVan';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddVan extends LightningElement {
    @track vanName = '';
    @track licensePlate = '';
    @track status = 'Available';

    // Define the options for the status dropdown
    get statusOptions() {
        return [
            { label: 'Available', value: 'Available' }
            // { label: 'Assigned', value: 'Assigned' }
        ];
    }

    handleVanNameChange(event) {
        this.vanName = event.target.value;
    }

    handleLicensePlateChange(event) {
        this.licensePlate = event.target.value;
    }

    handleStatusChange(event) {
        this.status = event.detail.value;
    }

    handleSaveVan() {
        if (!this.vanName || !this.licensePlate || !this.status) {
            this.showToast('Error', 'Please fill in all fields.', 'error');
            return;
        }

        saveVan({ vanName: this.vanName, licensePlate: this.licensePlate, status: this.status })
            .then(result => {
                if (result === 'success') {
                    this.showToast('Success', 'Van added successfully!', 'success');
                    this.vanName = '';
                    this.licensePlate = '';
                    this.status = 'Available';
                }
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}