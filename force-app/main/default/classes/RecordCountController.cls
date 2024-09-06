public class RecordCountController {
  public Integer getRecordCount() {
    // Query to count the number of Survey__c records based on the given conditions
    return [SELECT COUNT() 
            FROM Survey__c  
            WHERE Status__c = 'Approved by Coordinator'];
}

}