public class PdfController {
    @AuraEnabled
    public static void savePdf(String base64Data, String fileName, Id parentId) {
        // Decode the base64 string
        Blob pdfBlob = EncodingUtil.base64Decode(base64Data);

        // Create the ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.VersionData = pdfBlob;
        cv.Title = fileName;
        cv.PathOnClient = '/' + fileName;
        insert cv;

        // Link the ContentVersion to the parent record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
}