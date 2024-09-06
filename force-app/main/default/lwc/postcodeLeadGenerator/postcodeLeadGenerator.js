import { LightningElement, track,api } from 'lwc';
    import { ShowToastEvent } from 'lightning/platformShowToastEvent';
    import getUserLogInDetails from '@salesforce/apex/userlogindetailscontroller.getUserLogInDetails';
    import updatePostcodeAssignment from '@salesforce/apex/userlogindetailscontroller.updatePostcodeAssignment';
    import createPostcodeAssignment from '@salesforce/apex/userlogindetailscontroller.createPostcodeAssignment';


    export default class PostcodeLeadGenerator extends LightningElement {
        @track selectedDate;
        @track assignedLeadGenerators = [];
        @track notAssignedLeadGenerators = [];
        @track selectedLeadGeneratorForReassign;
        @track test;
        @track selectedLeadGeneratorForAssign;
        @track error;
        @track loading = false;
        @track showReAssignmentpopUp = false;
        @track showAssignmentpopUp = false;
        @track startTime = '';
        @track endTime = '';
        @track leadGeneratorName= '';
        @api postcode;
        @track pincode='';

        //to track pincode
        handlePincode(event){
            this.pincode=event.target.value;
        }


        // Handle Date Change
        handleDateChange(event) {
    const selectedDate = event.target.value;
    const currentDate = new Date().toISOString().split('T')[0]; 

    if (selectedDate >= currentDate) {
        this.selectedDate = selectedDate;
        this.fetchLeadGenerators();
        this.error = ''; // Clear any previous error message
    } else {
        // Display an error message
        this.error = 'Please select a date equal to or after today.';
        //  clearing the selected date
         this.selectedDate = null;
    }
}

        // Fetch Lead Generators
        // fetchLeadGenerators() {
        //     this.loading = true;
        //     getUserLogInDetails({ selectedDate: this.selectedDate })
        //         .then(result => {
        //             if (result && result.length > 0) {
        //                 let assignedLeadGenerators = [];
        //                 let notAssignedLeadGenerators = [];
        //                 result.forEach(detail => {
        //                     let leadGeneratorLabel = detail.Name;
        //                     if (detail.Postcode_Assignments__r && detail.Postcode_Assignments__r.length > 0) {
        //                         let assignedPostcode = detail.Postcode_Assignments__r[0].Assigned_Postcode__c;
        //                         leadGeneratorLabel = `${detail.Name}${assignedPostcode ? '-' + assignedPostcode : ''}`;
        //                         this.leadGeneratorName=`${detail.Name}`;
        //                         assignedLeadGenerators.push({ label: leadGeneratorLabel, value: detail.Id });
        //                     } else {
        //                         notAssignedLeadGenerators.push({ label: leadGeneratorLabel, value: detail.Id });
        //                     }
        //                 });
        //                 this.assignedLeadGenerators = assignedLeadGenerators;
        //                 this.notAssignedLeadGenerators = notAssignedLeadGenerators;
        //                 this.error = undefined;
        //             } else {
        //                 this.error = 'No lead generators found.';
        //                 this.assignedLeadGenerators = [];
        //                 this.notAssignedLeadGenerators = [];
        //             }
        //             this.loading = false;
        //         })
        //         .catch(error => {
        //             this.error = error.body.message || 'An error occurred while fetching lead generators.';
        //             this.assignedLeadGenerators = [];
        //             this.notAssignedLeadGenerators = [];
        //             this.loading = false;
        //         });
        // }

        //added time
        // Fetch Lead Generators
fetchLeadGenerators() {
    this.loading = true;
    getUserLogInDetails({ selectedDate: this.selectedDate })
        .then(result => {
            if (result && result.length > 0) {
                let assignedLeadGenerators = [];
                let notAssignedLeadGenerators = [];
                result.forEach(detail => {
                    let leadGeneratorLabel = detail.Name;
                    if (detail.Postcode_Assignments__r && detail.Postcode_Assignments__r.length > 0) {
                        let assignedPostcode = detail.Postcode_Assignments__r[0].Assigned_Postcode__c;
                        let startTime = detail.Postcode_Assignments__r[0].Postcode_Assignment_Start_Time__c;
                        leadGeneratorLabel = `${detail.Name} - ${assignedPostcode ? assignedPostcode : 'No postcode assigned'} (Start Time: ${startTime ? startTime : 'Not available'})`;
                        assignedLeadGenerators.push({ label: leadGeneratorLabel, value: detail.Id });
                    } else {
                        notAssignedLeadGenerators.push({ label: leadGeneratorLabel, value: detail.Id });
                    }
                });
                this.assignedLeadGenerators = assignedLeadGenerators;
                this.notAssignedLeadGenerators = notAssignedLeadGenerators;
                this.error = undefined;
            } else {
                this.error = 'No lead generators found.';
                this.assignedLeadGenerators = [];
                this.notAssignedLeadGenerators = [];
            }
            this.loading = false;
        })
        .catch(error => {
            this.error = error.body.message || 'An error occurred while fetching lead generators.';
            this.assignedLeadGenerators = [];
            this.notAssignedLeadGenerators = [];
            this.loading = false;
        });
}


        // Handle Lead Generator Change for Reassign
        handleLeadGeneratorChangeForReassign(event) {
            this.selectedLeadGeneratorForReassign = event.detail.value;
        }

        handleAssignYes(event) {

            this.test = event.detail.value;
            console.log('ssssssss'+this.selectedLeadGeneratorForReassign)
        }

        // Handle Lead Generator Change for Assign
        handleLeadGeneratorChangeForAssign(event) {
            this.selectedLeadGeneratorForAssign = event.detail.value;
        }

        // Handle Reassign Button Click
        handleReassign() {
    if (!this.pincode) {
        this.error = 'Please enter a pincode to reassign.';
    } else {
        this.error = ''; // Clear any previous error message
        this.showReAssignmentpopUp = true;
    }
}

        // Handle Assign Button Click
        handleAssign() {
            this.showAssignmentpopUp = true;
        }

        // Handle Yes in Reassignment Popup
        handleReassignYes() {
            this.showReAssignmentpopUp = false;

            updatePostcodeAssignment({ 
                leadGeneratorId: this.selectedLeadGeneratorForReassign,
                newPostcode: this.pincode // Replace with the actual new postcode
            })
            .then(result => {
        console.log('Postcode Assignment updated successfully.');
        // Refresh the data after updating the assignment
        this.fetchLeadGenerators();

        // Show a success toast message
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Postcode reassigned to lead generator successfully.',
            variant: 'success',
        });
        this.dispatchEvent(event);
    })
            .catch(error => {
                console.error('Error updating Postcode Assignment:', error);
            });
        }

        // Handle No in Reassignment Popup
        handleReassignNo() {
            this.showReAssignmentpopUp = false;
        }
    //code not in use 
        // Handle Yes in Assignment Popup
        handleAssignYes() {
    this.showAssignmentpopUp = false;

    // Format start time and end time as "HH:mm:ss"
    const formattedStartTime = this.formatTime(this.startTime);
    const formattedEndTime = this.formatTime(this.endTime);

    createPostcodeAssignment({ 
        leadGeneratorId: this.selectedLeadGeneratorForAssign,
        newPostcode: this.newPostcode,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        leadGeneratorName: this.leadGeneratorName,
        selectedDate: this.selectedDate
    })
    .then(result => {
        console.log('Postcode Assignment created successfully.');
        // Refresh the data after creating the assignment
        this.fetchLeadGenerators();

        // Show a success toast message
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Postcode assigned to lead generator successfully.',
            variant: 'success',
        });
        this.dispatchEvent(event);
    })
    .catch(error => {
        console.error('Error creating Postcode Assignment:', error);

        // Show an error toast message
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Failed to assign postcode to lead generator. Please try again.',
            variant: 'error',
        });
        this.dispatchEvent(event);
    });
}


        // Handle No in Assignment Popup
        handleAssignNo() {
            this.showAssignmentpopUp = false;
        }

        // Function to close popups
        closePopup() {
            this.showReAssignmentpopUp = false;
            this.showAssignmentpopUp = false;
        }

        // handle assignment logic
        // Handle Start Time Change
        handleStartTimeChange(event) {
            this.startTime = event.target.value;
        }

        // Handle End Time Change
        handleEndTimeChange(event) {
            this.endTime = event.target.value;
        }
        // end here
        //v2 to update time 
        // Handle Yes in Assignment Popup
    handleAssignYes() {
    this.showAssignmentpopUp = false;

    // Format start time and end time as "HH:mm:ss"
    const formattedStartTime = this.formatTime(this.startTime);
    const formattedEndTime = this.formatTime(this.endTime);

    createPostcodeAssignment({ 
        leadGeneratorId: this.selectedLeadGeneratorForAssign,
        newPostcode: this.newPostcode,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        leadGeneratorName: this.leadGeneratorName,
        selectedDate: this.selectedDate
    })
    .then(result => {
        console.log('Postcode Assignment created successfully.');
        // Refresh the data after creating the assignment
        this.fetchLeadGenerators();

        // Clear input fields
        this.startTime = '';
        this.endTime = '';
        this.newPostcode = '';

        // Show a success toast message
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Postcode assigned to lead generator successfully.',
            variant: 'success',
        });
        this.dispatchEvent(event);
    })
    .catch(error => {
        console.error('Error creating Postcode Assignment:', error);

        // Show an error toast message
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Failed to assign postcode to lead generator. Please try again.',
            variant: 'error',
        });
        this.dispatchEvent(event);
    });
}


    // Function to format time as "HH:mm:ss"
    formatTime(time) {
        const date = new Date();
        const [hours, minutes] = time.split(':');
        date.setHours(hours);
        date.setMinutes(minutes);
        date.setSeconds(0); // Ensure seconds are set to 0
        return date.toISOString().split('T')[1].substring(0, 8); // Format as "HH:mm:ss"
    }

    }