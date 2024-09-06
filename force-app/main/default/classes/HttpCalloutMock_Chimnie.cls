/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   15-03-2024
Trigger Name            :   FileUploadToSurveyRest
TestClass Name          :   
Connected Class         :   
@Description            :   This class is used for mock HTTP response for a successful callout.
                            @param HTTPRequest req of response.
                            @return a response.
Last Modification Date  :   15-03-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1Change : 14 March 2024 : Updated code to delete the associated images with survey
************************************************************************************************************************************************** */

@isTest
global class HttpCalloutMock_Chimnie implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a mock HTTP response for a successful callout
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
       // res.setBody('{"key": "value"}'); // Replace with your desired JSON response
        return res;
    }
}