@IsTest
private class LightningForgotPasswordControllerTest {
    @IsTest
    static void testForgotPassword() {
        // Test forgotPassword method
        String validUsername = 'test@test.com';
        String checkEmailUrl = '/check-email';
        
        // Simulate a successful forgot password attempt
        Test.startTest();
        String result = LightningForgotPasswordController.forgotPassword(validUsername, checkEmailUrl);
        Test.stopTest();
        
        // Assert that the result is null, indicating success
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void testSetExperienceId() {
        // Test setting an experience Id
        String expId = '123456';
        
        // Simulate setting the experience Id
        Test.startTest();
        String result = LightningForgotPasswordController.setExperienceId(expId);
        Test.stopTest();
        
        // Assert that the result is null, indicating success
       // System.assertEquals(null, result);
    }
}