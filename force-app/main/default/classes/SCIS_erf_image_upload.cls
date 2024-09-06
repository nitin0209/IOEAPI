/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   23-03-2024
Trigger Name            :   SCIS_forms_image_upload
TestClass Name          :   SCIS_forms_image_uploadTest
Connected Class         :   
@Description            :   This class is used from app side to send EPR pdf into the salesforce. 
							This API is used to delete the old pdf and save new forms pdf into the saleforce.
                            @param EPRId The ID of the EPR record.
                            @param imageName The name of the image.
                            @param imageBase64 The base64-encoded image data.
                            @param isFirst Indicates whether it's the first image being uploaded.
                            @param fileType The type of the image file (e.g., 'jpg', 'pdf').
                            @return A map containing the status and message of the upload operation.
Last Modification Date  :   23-03-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							
************************************************************************************************************************************************** */

@RestResource(urlMapping='/uploaderfpdf/*')
global with sharing class SCIS_erf_image_upload {
    
}