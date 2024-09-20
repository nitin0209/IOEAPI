global class ElmhurstSurveyController {
    global String responseData { get; set; }
    global String resp { get; set; }

    global void submitSurvey() {
        // Fetch the .txt file from ContentDocumentLink
        List<ContentDocumentLink> attachments = [
            SELECT ContentDocumentId, ContentDocument.Title 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = 'a2HUE00000051mf2AA'  // Replace with correct Parent ID
            AND ContentDocument.Title LIKE '%.txt%'       // Fetching .txt file
        ];

        if (attachments.size() > 0) {
            // Get the ContentDocumentId
            String contentDocId = attachments[0].ContentDocumentId;
            
            // Fetch the file body from ContentVersion
            List<ContentVersion> contentVersions = [
                SELECT Id, VersionData, Title 
                FROM ContentVersion 
                WHERE ContentDocumentId = :contentDocId 
                LIMIT 1
            ];

            if (contentVersions.size() > 0) {
                ContentVersion txtFile = contentVersions[0];
                Blob fileBody = txtFile.VersionData; // This is the file content in Blob format
                String requestBody = fileBody.toString();  // Convert the file content to a string
                
                // Log the request body for debugging
                System.debug('Request Body: ' + requestBody);

                // Prepare the HTTP request
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://elmhurst-api-staging.elmhurstenergy.net/api/Rdsap/Results/Survey?api-version=2.0');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/xml');

                // Set Basic Authentication headers
                String username = '311245362999';
                String password = '5bfac846aa90466bf65d93bb35473f19'; 
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                request.setHeader('Authorization', authorizationHeader);

                // Use the file content as the request body
                request.setBody(requestBody);

                // Send the HTTP request
                HttpResponse response = http.send(request);

                // Process the response
                if (response.getStatusCode() == 200) {
                    responseData = response.getBody();
                    resp = JSON.serializePretty(responseData);
                    responseData = 'Success: ' + resp;
                } else {
                    responseData = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus() + ' - ' + response.getBody();
                    System.debug('Error Body: ' + response.getBody());
                }
            } else {
                responseData = 'No ContentVersion found for the .txt file.';
            }
        } else {
            responseData = 'No .txt file found in Notes and Attachments.';
        }
    }
}