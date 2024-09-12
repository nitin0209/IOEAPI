@isTest
public class SelectOptionWrapperTest {

    @isTest
    static void testSelectOptionWrapper() {
        // Create a new instance of SelectOptionWrapper
        String testLabel = 'Test Label';
        String testValue = 'Test Value';
        
        SelectOptionWrapper option = new SelectOptionWrapper(testLabel, testValue);

        // Assert that the label and value are correctly set
        System.assertEquals(testLabel, option.label, 'The label should be set to "Test Label".');
        System.assertEquals(testValue, option.value, 'The value should be set to "Test Value".');
    }
}