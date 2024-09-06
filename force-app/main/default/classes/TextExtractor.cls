/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   
Trigger Name            :   TextExtractor
TestClass Name          :   
Connected Class         :   
@Description            :   The TextExtractor class provides methods to extract information such as UPRN, Lead Name, and Survey Id from input text.
							* @param inputText The text from which information needs to be extracted.
Last Modification Date  :   
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */

/**
 * The TextExtractor class provides methods to extract information such as UPRN, Lead Name, and Survey Id from input text.
 */
public class TextExtractor {
    /**
     * Method to extract information from the input text.
     * @param inputText The text from which information needs to be extracted.
     */
    public static void extractInfo(String inputText) {
        // Regular expressions to find UPRN, Lead Name, and Survey Id
        Pattern uprnPattern = Pattern.compile('UPRN\\s+([a-zA-Z0-9]+)');
        Pattern leadNamePattern = Pattern.compile('Lead Name\\s+([^\\r\\n]+)');
        Pattern surveyIdPattern = Pattern.compile('Survey Id\\s+([^\\r\\n]+)');

        Matcher uprnMatcher = uprnPattern.matcher(inputText);
        Matcher leadNameMatcher = leadNamePattern.matcher(inputText);
        Matcher surveyIdMatcher = surveyIdPattern.matcher(inputText);

        // Extracting UPRN
        if (uprnMatcher.find()) {
            String uprn = uprnMatcher.group(1);
            System.debug('UPRN: ' + uprn);
        }

        // Extracting Lead Name
        if (leadNameMatcher.find()) {
            String leadName = leadNameMatcher.group(1);
            System.debug('Lead Name: ' + leadName);
        }

        // Extracting Survey Id
        if (surveyIdMatcher.find()) {
            String surveyId = surveyIdMatcher.group(1);
            System.debug('Survey Id: ' + surveyId);
        }
    }
}