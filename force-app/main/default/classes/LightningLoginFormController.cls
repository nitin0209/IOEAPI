/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	10-11-2023
Class Name 				: 	LightningLoginFormController
TestClass Name 			: 	LightningLoginFormControllerTest
@Description 			: 	'The LightningLoginFormController class is a Salesforce Apex class designed to handle various 
							authentication-related functionalities within a Lightning component or application. 
							It provides methods for user authentication, retrieving authentication configuration settings, 
							and setting the experience ID for the user session.
							@param username The username of the user for authenticate the user.
							@param password The password of the user for authenticate the user.
							@param startUrl startUrl parameter to redirect the user to a specific location after successful authentication.
							@param return a map containing the message of the login operation.'
Last Modification Date 	: 	10-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */

global class LightningLoginFormController {

    public LightningLoginFormController() {
        
    }
	// It calls Site.login to authenticate the user. 
    @AuraEnabled
    public static String login(String username, String password, String startUrl) {
        try{
            ApexPages.PageReference lgn = Site.login(username, password, startUrl);
            aura.redirect(lgn);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();            
        }
    }
    
    // This method retrieves whether username-password authentication is enabled.
    @AuraEnabled
    public static Boolean getIsUsernamePasswordEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getUsernamePasswordEnabled();
    }
	
    // Similar to the previous method, it retrieves whether self-registration is enabled.
    @AuraEnabled
    public static Boolean getIsSelfRegistrationEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getSelfRegistrationEnabled();
    }
 
    // Returns the URL for self-registration if enabled.
    @AuraEnabled
    public static String getSelfRegistrationUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        if (authConfig.getSelfRegistrationEnabled()) {
            return authConfig.getSelfRegistrationUrl();
        }
        return null;
    }

    // Retrieves the URL for password recovery.
    @AuraEnabled
    public static String getForgotPasswordUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getForgotPasswordUrl();
    }
    
    // A utility method to get the authentication configuration.
    @TestVisible
    private static Auth.AuthConfiguration getAuthConfig(){
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig;
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