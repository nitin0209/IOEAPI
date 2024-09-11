public with sharing class RecommendationController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecommendations() {
      
        // Mocked data for example purposes
        List<Map<String, Object>> recommendations = new List<Map<String, Object>>();

        // Adding some example data
        Map<String, Object> recommendation1 = new Map<String, Object>{
            'name' => 'A',
            'shortText' => 'Cavity wall insulation',
            'isChecked' => true,
            'result' => 5
        };
        recommendations.add(recommendation1);

        Map<String, Object> recommendation2 = new Map<String, Object>{
            'name' => 'B',
            'shortText' => 'Centralized mechanical extract ventilation',
            'isChecked' => false,
            'result' => 3
        };
        recommendations.add(recommendation2);

        // Return the list of recommendations
        return recommendations;
    }
}