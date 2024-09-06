public class SelectOptionWrapper {
    @AuraEnabled
    public String label { get; set; }
    
    @AuraEnabled
    public String value { get; set; }

    public SelectOptionWrapper(String label, String value) {
        this.label = label;
        this.value = value;
    }
}