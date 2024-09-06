public class ImprovementEvaluatorController {
    // Variable to store the response data from API
    public String responseBody { get; set; }

    // Constructor to initialize and call the API
    public ImprovementEvaluatorController() {
        responseBody = ImprovementElmhurstAPI.calculateAssessment();
    }

    // Getter method for response data
    public String getFormattedResponseBody() {
        if (responseBody != null) {
            // Optional: Format JSON data for display purposes (e.g., pretty print)
            return JSON.serializePretty(JSON.deserializeUntyped(responseBody));
        } else {
            return 'No data received or an error occurred.';
        }
    }
}