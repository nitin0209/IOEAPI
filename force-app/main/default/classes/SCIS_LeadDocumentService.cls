/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	
Class Name 				: 	SCIS_LeadDocumentService
TestClass Name 			: 	SCIS_LeadDocumentServiceTest
@Description 			: 	RestResource class for adding documents to Lead records.
							Provides functionality to add documents as attachments to Lead records via REST API.
							* @param leadId The ID of the Lead record to which the document will be attached.
     						* @param documentName The name of the document.
     						* @param base64Data The base64 encoded data of the document.
     						* @return A message indicating the result of the operation.
Last Modification Date 	: 	
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */

/**
 * RestResource class for adding documents to Lead records.
 * Provides functionality to add documents as attachments to Lead records via REST API.
 */
@RestResource(urlMapping='/leadDocument/*')
global class SCIS_LeadDocumentService {
	/**
     * Adds a document as an attachment to the specified Lead record.
     * 
     * @param leadId The ID of the Lead record to which the document will be attached.
     * @param documentName The name of the document.
     * @param base64Data The base64 encoded data of the document.
     * @return A message indicating the result of the operation.
     */
    @HttpPost
    global static String addDocumentToLead(String leadId, String documentName, String base64Data) {
    //global static void addDocumentToLead(String leadId, String documentName, String base64Data) {
		
        // Get the Lead record
        Lead leadRecord = new Lead();
        if (Schema.sObjectType.Lead.isAccessible()) {
                leadRecord = [SELECT Id FROM Lead WHERE Id =: leadId LIMIT 1];
            }
        //Lead leadRecord = [SELECT Id FROM Lead WHERE Id =: leadId LIMIT 1];
		//system.debug(leadRecord);
		
		// Create Attachment
        Attachment attachment = new Attachment();
        attachment.Name = documentName;
        attachment.Body = EncodingUtil.base64Decode(base64Data);
        attachment.ParentId = leadRecord.id;

        try {
            // Insert the Attachment
            insert attachment;
           // system.debug('Attachment inserted');
           // Return success message
           return 'Document added successfully to Lead with ID: ' + leadId;
        } catch (Exception e) {
            // Handle exceptions and return error message
            return 'Error adding document to Lead: ' + e.getMessage();
        }
    }
}