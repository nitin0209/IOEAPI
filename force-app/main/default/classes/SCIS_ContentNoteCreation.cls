public class SCIS_ContentNoteCreation {

// Define the input parameter for the Flow
    public class InputParameters {
        @InvocableVariable(label='Note Title' required=true)
        public String noteTitle;
        
        @InvocableVariable(label='Note Content' required=true)
        public String noteContent;
        
        @InvocableVariable(label='Note OwnerId' required=false)
        public String noteOwnerId;
        
        @InvocableVariable(label='Note ParentId' required=false)
        public String noteParentId;
        
    }
    
    // Define the method as invocable
    @InvocableMethod(label='Create Content Note')
    public static void createContentNote(List<InputParameters> input) {
        // Get the input parameters from the Flow
        String title = input[0].noteTitle;
        String content = input[0].noteContent;
        String parentId = input[0].noteParentId;
        // Create a new ContentNote record
        ContentNote note = new ContentNote();
        Blob noteContentBlob = Blob.valueOf(content);
        // Set values for required fields
        note.Title = title;
        note.Content = noteContentBlob;
        note.OwnerId = userinfo.getUserId();
        // Insert the ContentNote record
        insert note;
        
        ContentDocumentLink link = new ContentDocumentLink();
			link.ContentDocumentId   = note.id;
			link.LinkedEntityId      = parentId;
			link.ShareType           = 'V';
			link.Visibility          = 'AllUsers';
			insert link;
        
        System.debug('ContentNote created with Id: ' + note.Id);
    }
}