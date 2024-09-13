import { LightningElement, track, api,wire } from 'lwc';
import getEmployeesForPrepWork from '@salesforce/apex/AppointmentController.getEmployeesForPrepWork';
import createAppointment from '@salesforce/apex/AppointmentController.createAppointment';
import getPicklistValues from '@salesforce/apex/AppointmentController.getPicklistValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // For toast notifications

import DOES_THIS_PROPERTY_REQUIRE_PREP_WORK_FIELD from '@salesforce/schema/Survey__c.Does_this_property_require_Prep_Work__c';
import { getRecord } from 'lightning/uiRecordApi';
//import getPrepWorkStatus from '@salesforce/apex/AppointmentController.getPrepWorkStatus';

export default class SurveyAppointmentForm extends LightningElement {
    @track ContractorTypes = ''; // The selected installation type
    @track scheduledStartDateTime = ''; // The selected start date and time
    @track scheduledEndDateTime = ''; // The selected end date and time
    @track employees = []; // List of employees fetched based on prep work
    @track selectedEmployeeId = ''; // The selected employee ID from the datatable
    @track prepWorkOptions = []; // Picklist options for installation type
    @api recordId; // Survey Record ID automatically passed from the page
    @track showDatatable = false;
    @track showMsgPrepWork = false;

    @track showAppointmentCreation = false;   // To control visibility of appointmentCreation
    @track prepWorkValue;
    //@track isLoading = false;

    // Fetch the value of Does_this_property_require_Prep_Work__c when the component is loaded
    @wire(getRecord, { recordId: '$recordId', fields: [DOES_THIS_PROPERTY_REQUIRE_PREP_WORK_FIELD] })
    wiredSurvey({ error, data }) {
        if (data) {
            this.prepWorkValue = data.fields.Does_this_property_require_Prep_Work__c.value;
            // Show or hide the appointmentCreation component based on the value
            this.showAppointmentCreation = this.prepWorkValue === 'Yes';
        } else if (error) {
            console.error('Error fetching Survey data: ', error);
        }
    }
    /*            OR
    @wire(getRecord, { recordId: '$recordId', fields: [DOES_THIS_PROPERTY_REQUIRE_PREP_WORK_FIELD] })
    wiredSurvey(result) {
        if (result.data) {
            this.prepWorkValue = result.data.fields.Does_this_property_require_Prep_Work__c.value;
            // Show or hide the appointmentCreation component based on the value
            this.showAppointmentCreation = this.prepWorkValue === 'Yes';
        } else if (result.error) {
            console.error('Error fetching Survey data: ', result.error);
        }
    }
    */
    // DataTable columns
    columns = [
        { label: 'Employee Name', fieldName: 'Name', type: 'text' },
        { label: 'Company Name', fieldName: 'Company_Name__c', type: 'text' }
    ];

    connectedCallback() {
        this.fetchPicklistValues();
        //this.fetchEmployees();
        //this.wiredPrepWork();
    }

    // Fetch picklist values for Installation_Type__c field
    fetchPicklistValues() {
        getPicklistValues({ objectName: 'Employee__c', fieldName: 'Contractor_type__c' })
            .then(result => {
                this.prepWorkOptions = result.map(value => ({ label: value, value: value }));
            })
            .catch(error => {
                this.handleError(error, 'Error fetching picklist values');
            });
    }

    // Fetch employees based on the selected installation type
    fetchEmployees() {
        getEmployeesForPrepWork({ ContractorType: this.ContractorTypes }) 
            .then(result => {
                if (result.length > 0) {
                    this.showDatatable = true; // Show the table if there are results
                    // Process result to include Company Name in a flat structure
                    this.employees = result.map(emp => {
                        return {
                            ...emp,
                            CompanyName: emp.Employee__r ? emp.Employee__r.Company_Name__c : 'N/A'
                        };
                    });
                } else {
                    this.showDatatable = false;
                    //this.showMsgPrepWork = true;
                    this.showToast('Info', 'Only Select "Asbestos" and "scaffolding" Prep Work Type.', 'info');
                }
            })
            .catch(error => {
                this.showDatatable = false; // Ensure table is hidden in case of an error
                this.showToast('Error', 'Error fetching employees', 'error');
            });
    }
    /*          OR
    fetchEmployees() {
        getEmployeesForPrepWork({ installationType: this.installationTypes })
            .then(result => {
                this.employees = result;
            })
            .catch(error => {
                this.handleError(error, 'Error fetching employees');
            });
    }
*/
    // Handle the change event for the installation type (picklist)
    handlePrepWorkChange(event) {
        this.ContractorTypes = event.detail.value;
        this.fetchEmployees(); // Fetch employees when installation type changes
        
    }

    // Handle the change event for the scheduled start date and time
    handleStartDateTimeChange(event) {
        this.scheduledStartDateTime = event.detail.value;
    }

    // Handle the change event for the scheduled end date and time
    handleEndDateTimeChange(event) {
        this.scheduledEndDateTime = event.detail.value;
    }

    // Handle the row selection from the employee datatable
    handleEmployeeSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            this.selectedEmployeeId = selectedRows[0].Id; // Store selected employee ID
        }
    }

    // Validate and create the appointment when the button is clicked
    createAppointment() {
        // Validate that all required fields are filled
        if (!this.ContractorTypes || !this.scheduledStartDateTime || !this.scheduledEndDateTime || !this.recordId || !this.selectedEmployeeId) {
            this.showToast('Error', 'Please fill all required fields.', 'error');
            return;
        }

        // Call Apex to create the appointment
        createAppointment({
            ContractorType: this.ContractorTypes,
            startDateTime: this.scheduledStartDateTime,
            endDateTime: this.scheduledEndDateTime,
            surveyUserId: this.recordId,           // Corrected to use recordId
            userDetailId: this.selectedEmployeeId
        })
        .then(result => {
            this.showToast('Success', result, 'success'); // Show success message
            this.resetForm(); // Reset the form after successful creation
        })
        .catch(error => {
            this.handleError(error, 'Already appointment is Created');
        });
    }

    
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    // Reset form fields after successful appointment creation
    resetForm() {
        this.ContractorTypes = '';
        this.scheduledStartDateTime = '';
        this.scheduledEndDateTime = '';
        this.selectedEmployeeId = '';
    }

    // Enhanced error handling function
    handleError(error, customMessage) {
        let errorMessage = customMessage; // Use custom message as fallback
        console.log(errorMessage);
        if (error && error.body && error.body.message) {
            // Error from Apex (server-side)
            errorMessage = error.body.message;
        } else if (error && error.message) {
            // Client-side JavaScript error
            errorMessage = error.message;
        }

        this.showToast('Error', errorMessage, 'error');
        console.error('Error:', errorMessage, error); // Log the full error for debugging
    }
}