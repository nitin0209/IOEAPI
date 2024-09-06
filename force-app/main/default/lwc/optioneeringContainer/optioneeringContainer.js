import { LightningElement, track } from 'lwc';

export default class OptioneeringContainer extends LightningElement {
    @track showOptioneering = true;
    @track showImprovementOptionSelection = false;

    handleShowImprovementOptions() {
        this.showOptioneering = false;
        this.showImprovementOptionSelection = true;
    }
}