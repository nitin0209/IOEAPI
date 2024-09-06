import { LightningElement, api, track } from 'lwc';

export default class ScisDesignFlow extends LightningElement {
    @api recordId;
    @track isDesignFlowVisible = false; // Track the visibility state of the Flow
    @track isProjectConstraintVisible=false;
    @track showStartDesignWorkButton= true;
    @track showProjectConstraintButton=true;
    DesignflowApiName = 'SCIS_Design_Flow'; // Replace with the correct Flow API Name
    projectConstraintFlowApiName='SCIS_design_project_constraint';
    get designFlowInputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            }
        ];
    }

    handleShowDesignFlowClick() {
        this.isDesignFlowVisible = true; // Show the Flow when the button is clicked
        this.showStartDesignWorkButton=false;
    }

    handleShowProjectConstraintButtonClick() {
        this.isProjectConstraintVisible = true; // Show the Flow when the button is clicked
        this.showProjectConstraintButton=false;
    }

    handleStatusChange(event) {
        console.log('Flow status changed: ', event.detail.status);
    }
}