public class IOEResponseFields {
    
    
    
    public static void sanketnitinmethod (){
        
        
        List<IOE_Response__c> responses = [SELECT Name, eiRating__c FROM IOE_Response__c];
        Integer field1Count = 0;
        
        for (IOE_Response__c response : responses) {
            if (response.Name != null) {
                field1Count++;
            }
        }
        
        System.debug('Number of non-null Field1__c values: ' + field1Count);
        
        
    }
}