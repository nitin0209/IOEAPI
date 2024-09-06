public class ds_LeadPDFGenerator {
    
    // Method to generate PDF and attach it to the Lead record
    public static void generateAndAttachPDF(Id leadId) {
        // Query the Lead record
        Lead lead = [SELECT Id, EPC_Data__c FROM Lead WHERE Id = :leadId LIMIT 1];
        
        if (lead == null || lead.EPC_Data__c == null) {
            throw new CustomException('Lead record or Rich Text Field is null.');
        }
        
        // Generate the PDF
        Blob pdfBlob = generatePDF(lead.EPC_Data__c);
        
        // Create an attachment
        Attachment attachment = new Attachment();
        attachment.ParentId = leadId;
        attachment.Name = 'LeadRichText.pdf';
        attachment.ContentType = 'application/pdf';
        attachment.Body = pdfBlob;
        
        // Insert the attachment
        insert attachment;
    }

    // Method to generate PDF from rich text
    private static Blob generatePDF(String richTextContent) {
        // Use Visualforce page to create the PDF
        PageReference pdfPage = Page.RichTextToPDF; // Visualforce page name
        pdfPage.getParameters().put('content', EncodingUtil.urlEncode(richTextContent, 'UTF-8'));
        
        Blob pdfBlob;
        try {
            pdfBlob = pdfPage.getContent();
        } catch (Exception e) {
            throw new CustomException('Error generating PDF: ' + e.getMessage());
        }
        
        return pdfBlob;
    }
    
    // Custom exception class
    public class CustomException extends Exception {}
}