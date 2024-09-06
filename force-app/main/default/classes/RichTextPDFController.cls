public class RichTextPDFController {
    public String content { get; set; }
    
    public RichTextPDFController() {
        // Retrieve content parameter from URL
        content = ApexPages.currentPage().getParameters().get('content');
    }
}