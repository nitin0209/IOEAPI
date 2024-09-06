import { LightningElement, wire } from 'lwc';
import getUsers from '@salesforce/apex/SCIS_CoordinatorController.getUsers';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Company Name', fieldName: 'Company_Name__c' },
    { label: 'Coordinator Type', fieldName: 'Coordinator_Type__c' }
];

export default class ScisCoordinatorData extends LightningElement {
    columns = columns;
    coordinators;

    @wire(getUsers)
    wiredUsers({ error, data }) {
        if (data) {
            this.coordinators = data;
        } else if (error) {
            this.error = error;
        }
    }
}