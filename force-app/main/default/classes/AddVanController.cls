public class AddVanController {
    @AuraEnabled
    public static String saveVan(String vanName, String licensePlate, String status) {
        try {
            Van__c van = new Van__c();
            van.Name = vanName;
            van.License_Plate__c = licensePlate;
            van.Status__c = status;
            insert van;
            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error saving van: ' + e.getMessage());
        }
    }
}