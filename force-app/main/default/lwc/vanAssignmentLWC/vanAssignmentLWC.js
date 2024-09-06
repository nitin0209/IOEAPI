import { LightningElement, wire, track } from 'lwc';
import getAvailableVans from '@salesforce/apex/VanAssignmentControllerNew.getAvailableVans';
import getInstallers from '@salesforce/apex/VanAssignmentControllerNew.getInstallers';
import assignVan from '@salesforce/apex/VanAssignmentControllerNew.assignVan';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class VanAssignment extends LightningElement {
    @track availableVans = [];
    @track availableInstallers = [];
    @track selectedVanId;
    @track selectedInstallerId;

    @wire(getAvailableVans)
    wiredVans({ error, data }) {
        if (data) {
            this.availableVans = data.map(van => {
                return { label: van.Name, value: van.Id };
            });
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    @wire(getInstallers)
    wiredInstallers({ error, data }) {
        if (data) {
            this.availableInstallers = data.map(installer => {
                return { label: installer.Name, value: installer.Id };
            });
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleVanChange(event) {
        this.selectedVanId = event.detail.value;
    }

    handleInstallerChange(event) {
        this.selectedInstallerId = event.detail.value;
    }

    handleAssignVan() {
        if (!this.selectedVanId || !this.selectedInstallerId) {
            this.showToast('Error', 'Please select both a van and an installer.', 'error');
            return;
        }

        assignVan({ vanId: this.selectedVanId, installerId: this.selectedInstallerId })
            .then(result => {
                if (result === 'success') {
                    this.showToast('Success', 'Van assigned successfully!', 'success');
                    this.template.querySelector('lightning-combobox[data-id="van"]').value = null;
                    this.template.querySelector('lightning-combobox[data-id="installer"]').value = null;
                    this.selectedVanId = null;
                    this.selectedInstallerId = null;
                    return refreshApex(this.wiredVans);
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