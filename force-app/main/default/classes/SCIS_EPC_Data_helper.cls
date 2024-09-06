/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	04-12-2023
Class Name 				: 	SCIS_EPC_Data_helper
TestClass Name 			: 	SCIS_EPC_Data_helperTest
@Description 			: 	This class is used to convert the json response received from EPC website 
							into the HTML content to show on the lead form.
							* @param jsonString The JSON string containing data to be displayed in the table.
     						* @return String The HTML representation of the table.
Last Modification Date 	: 	04-12-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * Helper class for generating HTML table from JSON string.
 */
public class SCIS_EPC_Data_helper {
    /**
     * Generates an HTML table from a JSON string.
     * 
     * @param jsonString The JSON string containing data to be displayed in the table.
     * @return String The HTML representation of the table.
     */
	public static String generateHTMLTable(String jsonString) {
        // Initialize the HTML table structure
        String htmlTable = '<table border="1"><thead><tr><th>Key</th><th>Value</th></tr></thead><tbody>';
		// Deserialize the JSON string into a map
        Map<String, Object> jsonData = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
		// Retrieve the list of rows from the JSON data
        List<Object> rows = (List<Object>)jsonData.get('rows');
		// Iterate over each row
        for (Object row : rows) {
            Map<String, Object> rowData = (Map<String, Object>)row;
			// Iterate over each key-value pair in the row
            for (String key : rowData.keySet()) {
                Object value = rowData.get(key);
                // Escape HTML characters in key and value to prevent XSS attacks
                String escapedKey = key.escapeHtml4();
                String escapedValue = String.valueOf(value).escapeHtml4();
				// Append the key-value pair as a row in the HTML table
                htmlTable += '<tr><td>' + escapedKey + '</td><td>' + escapedValue + '</td></tr>';
            }
        }
		// Close the HTML table structure
        htmlTable += '</tbody></table>';
        return htmlTable;
    }
}