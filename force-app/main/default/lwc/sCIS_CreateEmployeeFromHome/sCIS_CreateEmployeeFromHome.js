import { LightningElement } from 'lwc';

export default class SCIS_CreateEmployeeFromHome extends LightningElement {
    handleSuccess(event) {
        // Show success message or navigate to a different page
        console.log('Employee created successfully:', event.detail.id);
    }
}