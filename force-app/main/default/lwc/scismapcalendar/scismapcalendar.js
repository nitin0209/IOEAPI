import { LightningElement, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getUserLogInDetails from '@salesforce/apex/UserController.getUserLogInDetails';
import reassignLeadGenerator from '@salesforce/apex/UserController.reassignLeadGenerator';

export default class Scismapcalendar extends LightningElement {
    @track selectedDate;
    @track leadGeneratorsAssigned = [];
    @track leadGeneratorsNotAssigned = [];
    @track selectedLeadGenerator;
    @track error;
    @track loading = false;
    @track showReAssignmentpopUp = false;
    @track selectedValue;

    handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.fetchLeadGenerators(this.selectedDate);
    }

    fetchLeadGenerators(selectedDate) {
        this.loading = true;
        getUserLogInDetails({ selectedDate: selectedDate })
            .then(result => {
                if (result && result.length > 0) {
                    let assignedGenerators = [];
                    let notAssignedGenerators = [];
                    result.forEach(detail => {
                        if (detail.Area_Assignments__r && detail.Area_Assignments__r.length > 0) {
                            detail.Area_Assignments__r.forEach(assignment => {
                                assignedGenerators.push({ label: `${detail.Name} - ${assignment.Assigned_Area__c}`, value: detail.Id });
                            });
                        } else {
                            notAssignedGenerators.push({ label: detail.Name, value: detail.Id });
                        }
                    });
                    this.leadGeneratorsAssigned = assignedGenerators;
                    this.leadGeneratorsNotAssigned = notAssignedGenerators;
                    this.error = undefined;
                } else {
                    this.error = 'No lead generators found.';
                    this.leadGeneratorsAssigned = [];
                    this.leadGeneratorsNotAssigned = [];
                }
                this.loading = false;
            })
            .catch(error => {
                this.error = error.body.message || 'An error occurred while fetching lead generators.';
                this.leadGeneratorsAssigned = [];
                this.leadGeneratorsNotAssigned = [];
                this.loading = false;
            });
    }

    get leadGeneratorOptions() {
        return [
            ...this.leadGeneratorsAssigned.map(generator => ({ ...generator, group: 'Assigned' })),
            ...this.leadGeneratorsNotAssigned.map(generator => ({ ...generator, group: 'Not Assigned' }))
        ];
    }

    handleLeadGeneratorChange(event) {
        this.selectedLeadGenerator = event.detail.value;
    }

    handleReassign(event) {
        const selectedLeadGeneratorId = this.selectedLeadGenerator;
        const isAssignedToLeads = this.leadGeneratorsAssigned.some(generator => generator.value === selectedLeadGeneratorId);

        if (isAssignedToLeads) {
            this.showReAssignmentpopUp = true;
            this.selectedValue = selectedLeadGeneratorId;
        } else {
            console.log("Lead Generator not assigned to leads");
        }
    }

    closePopup() {
        this.showReAssignmentpopUp = false;
    }

    handleYes() {
        // Reassign lead generator to a new area and cancel the previous assignment
        const newPostcode = '100100'; // Replace 'YOUR_NEW_POSTCODE' with the actual new postcode
        reassignLeadGenerator({ leadGeneratorId: this.selectedValue, newPostcode: newPostcode })
            .then(result => {
                // Handle success
                console.log('Lead generator reassigned successfully.');
            })
            .catch(error => {
                // Handle error
                console.error('Error reassigning lead generator:', error);
            })
            .finally(() => {
                // Close the popup regardless of success or failure
                this.showReAssignmentpopUp = false;
            });
    }

    handleNo() {
        // Close the popup without taking any action
        this.showReAssignmentpopUp = false;
    }
}