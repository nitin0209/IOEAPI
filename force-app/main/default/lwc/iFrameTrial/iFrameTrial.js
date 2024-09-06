import { LightningElement, api, track } from 'lwc';
//import Heroku_Calendar_url from '@salesforce/label/Calendar_Heroku_URL';
import CalendarHerokuURL from '@salesforce/label/c.Heroku_Calendar_URL';
export default class IFrameTrial extends LightningElement {
    @api recordId; // This is the record Id of the record page where the component is placed
    @api selectedSurveyorId;
    @track url; // This will be tracked for reactivity in the template

    connectedCallback() {
        console.log("URL : " + CalendarHerokuURL);
        // Correctly assign the constructed URL to the tracked property 'url'
        //this.url = 'https://bundle-9ac85db01ae0.herokuapp.com/appointments/' + this.recordId + '/' + this.selectedSurveyorId;
        
       // this.url = Heroku_Calendar_url + this.recordId + '/' + this.selectedSurveyorId;
       this.url = CalendarHerokuURL +'appointments/'+ this.recordId + '/' + this.selectedSurveyorId;
       console.log("URL 2 : " + this.CalendarHerokuURL);
       console.log("URL 3 : " + this.url);
       console.log("Record ID : " + this.recordId);
        
        
        // For demonstration with hardcoded values, it would look like the following:
        // this.url = 'https://bundle-9ac85db01ae0.herokuapp.com/appointments/00QQz000006Ms1ZMAS/a0FQz000000o77xMAA';
        
        console.log(this.url); // Log the URL to the console correctly
    }
}