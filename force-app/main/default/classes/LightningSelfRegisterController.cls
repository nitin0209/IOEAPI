/* 
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	10-11-2023
Class Name 				: 	LightningSelfRegisterController
TestClass Name 			: 	LightningSelfRegisterControllerTest
@Description 			: 	'Apex class to handle self-registration functionality for users, including password validation and user creation.
							Provides methods for self-registration, password validation, retrieval of extra fields, and setting experience ID.
							* @param password The password entered by the user.
     						* @param confirmPassword The confirmed password entered by the user.
     						* @return Boolean indicating whether the passwords match.
							* @param communityUrl The URL of the community.
							* @return Boolean indicating whether the site is used as a container for the community.
							* @param u The User object.
     						* @param password The password entered by the user.
     						* @param confirmPassword The confirmed password entered by the user.
 							* @param firstname The user's first name.
     						* @param lastname The user's last name.
     						* @param email The user's email address.
     						* @param password The user's chosen password.
    					 	* @param confirmPassword The confirmed password.
     						* @param accountId The ID of the associated account.
     						* @param regConfirmUrl The URL for registration confirmation.
     						* @param extraFields JSON string representing additional fields to be populated.
     						* @param startUrl The URL to redirect the user to after registration.
     						* @param includePassword Boolean indicating whether to include the password in the registration process.
     						* @return If successful, returns null; otherwise, returns an error message.
							* @param extraFieldsFieldSet The name of the field set containing extra fields.
     						* @return A list of maps containing details of the extra fields.
							* @param expId The experience ID to be set.
     						* @return If successful, returns null; otherwise, returns an error message.
Last Modification Date 	: 	10-11-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							29-03-2024 Added comments and params for all declared variables.
************************************************************************************************************************************************** */

global class LightningSelfRegisterController {

    public LightningSelfRegisterController() {

    }
	// Validates whether the password matches the confirmed password.
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    // Checks if the community is using the site as a container.
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    // Validates the user's password.
    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
        Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }
    // Initiates the self-registration process for a user.
    @AuraEnabled
    public static String selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword) {
        Savepoint sp = null;
        try {
            sp = Database.setSavepoint();
            // Validating input parameters
            if (lastname == null || String.isEmpty(lastname)) {
                return Label.Site.lastname_is_required;
            }
            
            if (email == null || String.isEmpty(email)) {
                return Label.Site.email_is_required;
            }
            // Creating a new User object
            User u = new User();
            u.Username = email;
            u.put('Email',email);
            
            u.FirstName = firstname;
            u.LastName = lastname;
            // Checking if the community uses the site as a container
            String networkId = Network.getNetworkId();

            // If using site to host the community the user should not hit s1 after logging in from mobile.
            if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                u.put('UserPreferencesHideS1BrowserUI',true);
            }
            // Generating CommunityNickname based on first name, last name, and random numbers
            String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            u.put('CommunityNickname', nickname);
            
            // Populating additional fields if provided
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    u.put(sof, thisField.get('value'));
                }
            }
            // Validating and setting the password if required        
            if (includePassword) {    
                if (!isValidPassword(password, confirmPassword)) {
                    return Label.site.passwords_dont_match;
                }
             validatePassword(u, password, confirmPassword);
            }
            else {
                password = null;
            }
            
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            String userId = Site.createPortalUser(u, accountId, password);
            // create a fake userId for test.
            if (Test.isRunningTest()) {
                userId = 'fakeUserId';           
            }
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                    if(!Test.isRunningTest()) {
                     aura.redirect(lgn);
                    }
                }
                else {
                    ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                    if(!Test.isRunningTest()) {
                    aura.redirect(confirmRef);
                   }

                }
            }
            return null;
        }
        catch (Exception ex) {
            // Rollback transaction and return error message
            Database.rollback(sp);
            return ex.getMessage();            
        }
    }
    
    // Retrieves extra fields based on a field set.
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if(!Test.isRunningTest()) {
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
            }}}
        return extraFields;
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