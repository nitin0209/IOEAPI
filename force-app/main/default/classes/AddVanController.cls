public class AddVanController {
    @AuraEnabled
    public static String saveVan(String vanName, String licensePlate, String status) {
        try {
            /*
            Van__c van = new Van__c();
            van.Name = vanName;
            van.License_Plate__c = licensePlate;
            van.Status__c = status;
            insert van;
            */
            
            Vehicle_Details__c vehicle = new Vehicle_Details__c();
            vehicle.Name = vanName;
            vehicle.Vehicle_Registration__c = licensePlate;
            vehicle.Status__c = status;
            insert vehicle;
            
            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException('Error saving van: ' + e.getMessage());
        }
    }
}


/*
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


*/