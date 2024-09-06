public with sharing class ThirdPartyAPIHandler {
    @AuraEnabled(cacheable=true)
    public static ThirdPartyResponse getAPIResponse() {
        // Simulated API response
        String jsonResponse = '{ "CO2emissions": "1104.1353589857226"}';

        // Deserialize the response
        ThirdPartyResponse response = (ThirdPartyResponse) JSON.deserialize(jsonResponse, ThirdPartyResponse.class);

        // Return the response
        return response;
    }

    // Inner class to match the JSON structure
    public class ThirdPartyResponse {
        @AuraEnabled
        public Decimal CO2emissions;
        // Add other fields as per your API response
    }
}