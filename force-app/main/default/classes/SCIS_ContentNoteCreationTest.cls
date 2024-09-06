@isTest
private class SCIS_ContentNoteCreationTest {
    
    @isTest
    static void testCreateContentNote() {
        // Create a test Account record to serve as the parent record
        Account testAccount = new Account(Name = 'Test Account', Type = 'Funder');
        insert testAccount;

        // Verify the account was created successfully
        System.assertNotEquals(null, testAccount.Id, 'Test Account should have been created');
        
        // Create test data
        String noteTitle = 'Test Note';
        String noteContent = 'This is a test note content.';
        Id parentId = testAccount.Id; // Use the Id of the created Account record
        
        // Set up input parameters
        SCIS_ContentNoteCreation.InputParameters inputParams = new SCIS_ContentNoteCreation.InputParameters();
        inputParams.noteTitle = noteTitle;
        inputParams.noteContent = noteContent;
        inputParams.noteParentId = parentId;
        
        List<SCIS_ContentNoteCreation.InputParameters> inputList = new List<SCIS_ContentNoteCreation.InputParameters>{inputParams};
        
        // Call the method
        Test.startTest();
        SCIS_ContentNoteCreation.createContentNote(inputList);
        Test.stopTest();
        
        // Verify the content note creation
        ContentNote[] createdNotes = [SELECT Id, Title, TextPreview, OwnerId FROM ContentNote];
        System.assertEquals(1, createdNotes.size(), 'One ContentNote should have been created');
        
        ContentNote createdNote = createdNotes[0];
        System.assertEquals(noteTitle, createdNote.Title, 'Title should match');
        System.assertEquals(noteContent, createdNote.TextPreview, 'Content should match');
        System.assertEquals(UserInfo.getUserId(), createdNote.OwnerId, 'Owner should be the current user');
        
        // Verify the content document link creation
        ContentDocumentLink[] createdLinks = [SELECT Id, ContentDocumentId, LinkedEntityId, ShareType, Visibility 
                                              FROM ContentDocumentLink 
                                              WHERE LinkedEntityId = :parentId];
        System.assertEquals(1, createdLinks.size(), 'One ContentDocumentLink should have been created');
        
        ContentDocumentLink createdLink = createdLinks[0];
        System.assertEquals(createdNote.Id, createdLink.ContentDocumentId, 'ContentDocumentId should match');
        System.assertEquals(parentId, createdLink.LinkedEntityId, 'LinkedEntityId should match');
        System.assertEquals('V', createdLink.ShareType, 'ShareType should be "V"');
        System.assertEquals('AllUsers', createdLink.Visibility, 'Visibility should be "AllUsers"');
    }
}