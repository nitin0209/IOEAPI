import { LightningElement, track } from 'lwc';

export default class OptioneeringParent extends LightningElement {
    @track showOptioneering = true;
    @track showImprovementOptions = false;

    handleShowImprovementOptions() {
        this.showOptioneering = false;
        this.showImprovementOptions = true;
    }

    handleHideImprovementOptions() {
        this.showOptioneering = true;
        this.showImprovementOptions = false;
    }
}