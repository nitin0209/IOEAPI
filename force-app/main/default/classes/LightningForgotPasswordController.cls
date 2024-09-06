/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	10-11-2023
Class Name 				: 	LightningForgotPasswordController
TestClass Name 			: 	LightningForgotPasswordControllerTest
@Description 			: 	'Invoked by Lightning components to initiate the forgotten password process.
							 @param username The username for which the password is to be reset.
     						 @param checkEmailUrl The URL to redirect the user to after initiating the process.
     						 @return If successful, returns null; otherwise, returns an error message.
							 @param expId Sets the experience ID for the user session.'
Last Modification Date 	: 	10-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */

//Apex class to handle forgotten password functionality and experience ID management for Lightning components.
global class LightningForgotPasswordController {

   /* public LightningForgotPasswordController() {

    } */
	// Invoked by Lightning components to initiate the forgotten password process.
    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {
        try {
            // Initiating forgotten password process
            Site.forgotPassword(username);
            
            // Redirecting to the specified check email URL
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            if(!Site.isValidUsername(username)) {
                // Returning an error message if the username is invalid
                return Label.Site.invalid_email;
            }
            aura.redirect(checkEmailRef);
            return null;
        }
        catch (Exception ex) {
            // Returning any caught exceptions as error messages
            return ex.getMessage();
        }
    }
	
    // Sets the experience ID for the user session.
    @AuraEnabled
    global static String setExperienceId(String expId) {    
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);               
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    } 
}