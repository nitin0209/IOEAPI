import { LightningElement, wire } from 'lwc';
import getCurrentUserCompanyName from '@salesforce/apex/NewUserController.getCurrentUserCompanyName';

export default class MyComponent extends LightningElement {
    companyName;
    //iframeSrc = 'https://bundleuat-d081fc5ba8b5.herokuapp.com/all-appointments';
     iframeSrc = 'https://bundledev-2a547a99bcdb.herokuapp.com/all-appointments';
   
    @wire(getCurrentUserCompanyName)
    wiredUserCompanyName({ error, data }) {
        if (data) {
            console.log('Received company name:', data);
            this.companyName = data;
            this.composeIframeSrc();
        } else if (error) {
            console.error('Error fetching current user company name:', error);
        }
    }

    composeIframeSrc() {
        if (this.companyName) {
            this.iframeSrc = `${this.iframeSrc}/${this.companyName}`;
        }
    }
}