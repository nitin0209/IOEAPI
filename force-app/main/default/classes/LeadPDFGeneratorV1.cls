public class LeadPDFGeneratorV1 {
 @AuraEnabled
    public static String generateAndAttachPDF(Id leadId) {
        Lead lead = [SELECT Id, FirstName, LastName, Company FROM Lead WHERE Id = :leadId LIMIT 1];
        
        // Generate PDF content
        /*
        String pdfContent = '<html><head><style>body { font-family: Arial, sans-serif; } table { width: 100%; border-collapse: collapse; } th, td { border: 1px solid #ddd; padding: 8px; } th { background-color: #f2f2f2; }</style></head><body>';
        pdfContent += '<h2>Lead Details</h2>';
        pdfContent += '<table><tr><th>Field</th><th>Value</th></tr>';
        pdfContent += '<tr><td>Lead ID</td><td>' + lead.Id + '</td></tr>';
        pdfContent += '<tr><td>First Name</td><td>' + lead.FirstName + '</td></tr>';
        pdfContent += '<tr><td>Last Name</td><td>' + lead.LastName + '</td></tr>';
        pdfContent += '<tr><td>Company</td><td>' + lead.Company + '</td></tr>';
        pdfContent += '</table></body></html>';
*/
        String pdfContent = 'Hello';
        Blob pdfBlob;
        try {
            pdfBlob = Blob.valueOf(pdfContent);
        } catch (Exception e) {
            throw new AuraHandledException('Error generating PDF content.');
        }
        
        // Store the PDF in Salesforce as ContentDocument
        ContentVersion cv = new ContentVersion();
        try {
        cv.Title = 'abc' + '.pdf';
        cv.PathOnClient = 'abc' + '.pdf';
        cv.VersionData = pdfBlob;
        cv.FirstPublishLocationId = lead.Id;
        cv.Origin = 'H';
        //cv.FileExtension ='.pdf';
        //cv.MimeType = 'application/pdf'; // Ensure the MIME type is set correctly
        //cv.FileExtension = '.pdf'; // Ensure the file extension is set correctly
        //cv.FileType = '.pdf';
        cv.IsMajorVersion = true;
        
        insert cv;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        return 'PDF Generated successfully1';
        // Create an attachment
       /*
        Attachment pdfAttachment = new Attachment();
        pdfAttachment.Name = 'Lead_Details_' + leadId + '.pdf';
        pdfAttachment.Body = pdfBlob;
        pdfAttachment.ParentId = leadId;
        pdfAttachment.ContentType = 'application/pdf';
        
        insert pdfAttachment;
        
        return 'PDF attached successfully1';
*/
    }

}