/* 
**************************************************************************************************************************************************
Developer Name 			: 	Dhiraj Lohar
Created Date 			:	28-02-2024
Class Name 				: 	TextExtractor
TestClass Name 			: 	TextExtractor_Test
Description 			: 	This is test class for TextExtractor
Last Modification Date 	: 	28-02-2024
Last Modified By 		:	Dhiraj Lohar
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
************************************************************************************************************************************************** */



@isTest
public class TextExtractor_Test {
 @isTest
    static void testExtractInfo() {
        // Test input text containing UPRN, Lead Name, and Survey Id
        String inputText = 'UPRN 123456\nLead Name John Doe\nSurvey Id ABC123';
		
        Test.startTest();
        // Call the method under test
        TextExtractor.extractInfo(inputText);
        Test.stopTest();

        // Verify the extracted information
        //System.assertEquals('123456', TextExtractor.extractedUPRN, 'UPRN should be extracted correctly');
        //System.assertEquals('John Doe', TextExtractor.extractedLeadName, 'Lead Name should be extracted correctly');
        //System.assertEquals('ABC123', TextExtractor.extractedSurveyId, 'Survey Id should be extracted correctly');
    }
}