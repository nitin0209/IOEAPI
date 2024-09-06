import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const LEAD_FIELDS = [
    'Lead.Geolocation__Latitude__s',
    'Lead.Geolocation__Longitude__s'
    // Add other fields as needed
];

export default class GoogleStreetView extends LightningElement {
    @api recordId;
    streetViewImageUrl;

    @wire(getRecord, { recordId: '$recordId', fields: LEAD_FIELDS })
    wiredLead({ error, data }) {
        if (data) {
            const latitude = data.fields.Geolocation__Latitude__s.value;
            const longitude = data.fields.Geolocation__Longitude__s.value;
            this.fetchStreetViewImage(latitude, longitude);
        } else if (error) {
            this.handleError(error);
        }
    }

    fetchStreetViewImage(latitude, longitude) {
        // Make a callout to Google Maps API to fetch Street View image
        const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your Google Maps API key
        const imageSize = '600x300'; // Set desired image size
        const streetViewUrl = `https://maps.googleapis.com/maps/api/streetview?size=${imageSize}&location=${latitude},${longitude}&key=${apiKey}`;

        fetch(streetViewUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.url;
            })
            .then(url => {
                this.streetViewImageUrl = url;
            })
            .catch(error => {
                this.handleError(error);
            });
    }

    handleError(error) {
        // Handle error
        console.error('Error fetching Google Street View image', error);
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Failed to fetch Google Street View image',
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
}