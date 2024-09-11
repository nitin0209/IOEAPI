@isTest
public class RecommendationControllerTest {

    @isTest
    static void testGetRecommendations() {
        // Step 1: Start the test
        Test.startTest();

        // Step 2: Call the getRecommendations method
        List<Map<String, Object>> recommendations = RecommendationController.getRecommendations();

        // Step 3: Stop the test
        Test.stopTest();

        // Step 4: Assert that the list is not null and contains expected data
        System.assertNotEquals(null, recommendations, 'The recommendations list should not be null');
        System.assertEquals(2, recommendations.size(), 'The recommendations list should contain 2 items');

        // Step 5: Validate the first recommendation
        Map<String, Object> recommendation1 = recommendations[0];
        System.assertEquals('A', recommendation1.get('name'), 'First recommendation name should be "A"');
        System.assertEquals('Cavity wall insulation', recommendation1.get('shortText'), 'First recommendation shortText should be "Cavity wall insulation"');
        System.assertEquals(true, recommendation1.get('isChecked'), 'First recommendation isChecked should be true');
        System.assertEquals(5, recommendation1.get('result'), 'First recommendation result should be 5');

        // Step 6: Validate the second recommendation
        Map<String, Object> recommendation2 = recommendations[1];
        System.assertEquals('B', recommendation2.get('name'), 'Second recommendation name should be "B"');
        System.assertEquals('Centralized mechanical extract ventilation', recommendation2.get('shortText'), 'Second recommendation shortText should be "Centralized mechanical extract ventilation"');
        System.assertEquals(false, recommendation2.get('isChecked'), 'Second recommendation isChecked should be false');
        System.assertEquals(3, recommendation2.get('result'), 'Second recommendation result should be 3');
    }
}