import { LightningElement, wire, track } from 'lwc';
import getAssignedVans from '@salesforce/apex/VanManagementControllerSCIS.getAssignedVans';
import getUnassignedVans from '@salesforce/apex/VanManagementControllerSCIS.getUnassignedVans';
import removeAssignment from '@salesforce/apex/VanManagementControllerSCIS.removeAssignment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class vanManagementSCIS extends LightningElement {
    @track assignedVans = [];
    @track unassignedVans = [];
    @track wiredAssignedVans;
    @track wiredUnassignedVans;
 
    @wire(getAssignedVans)
    wiredAssignedVansMethod(value) {
        this.wiredAssignedVans = value;
        const { data, error } = value;
        if (data) {
            this.assignedVans = data.map(van => ({
                ...van,
                vehicleName: van.Vehicle_Details__r ? van.Vehicle_Details__r.Name : 'N/A',
                vehicleRegistration: van.Vehicle_Details__r ? van.Vehicle_Details__r.Vehicle_Registration__c : 'N/A',
                assignedInstaller: van.User_Log_In_Details__r ? van.User_Log_In_Details__r.Name : 'N/A'
            }));
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    @wire(getUnassignedVans)
    wiredUnassignedVansMethod(value) {
        this.wiredUnassignedVans = value;
        const { data, error } = value;
        if (data) {
            this.unassignedVans = data;
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleRemoveAssignment(event) {
        const assignmentId = event.target.dataset.id;
        removeAssignment({ assignmentId })
            .then(result => {
                if (result === 'success') {
                    this.showToast('Success', 'Assignment removed successfully!', 'success');
                    return Promise.all([
                        refreshApex(this.wiredAssignedVans),
                        refreshApex(this.wiredUnassignedVans)
                    ]);
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