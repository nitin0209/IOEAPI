@isTest
public class RichTextPDFControllerTest {

    @isTest
    static void testRichTextPDFController() {
        // Step 1: Simulate the current Visualforce page and set the 'content' parameter
        Test.setCurrentPage(Page.RichTextToPDF);  // Simulate a page (replace with an actual page name)
        ApexPages.currentPage().getParameters().put('content', 'Test rich text content');

        // Step 2: Instantiate the RichTextPDFController
        RichTextPDFController controller = new RichTextPDFController();

        // Step 3: Assert that the 'content' field is populated with the correct parameter
        System.assertEquals('Test rich text content', controller.content, 'The content field should be populated with the URL parameter value');
    }
}