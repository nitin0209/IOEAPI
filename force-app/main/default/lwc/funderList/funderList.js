import { LightningElement, track } from 'lwc';

export default class FunderList extends LightningElement {
    @track funders = [
        { id: '1', funderName: 'Scottish Power', type: 'Individual' },
        { id: '2', funderName: 'EON', type: 'Company' },
        { id: '3', funderName: 'ADP', type: 'Company' }
    ];

    @track selectedFunder = null; // Holds the selected funder's ID

    get totalFunders() {
        return this.funders.length;
    }

    // This getter computes how many items are selected
    get selectionStatus() {
        return this.selectedFunder ? '1 item selected' : '0 items selected';
    }

    handleRadioChange(event) {
        this.selectedFunder = event.target.value;
    }
}