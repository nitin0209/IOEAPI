@isTest
private class UploadImageInFolderTest {
    @isTest
    static void testCreateFolderAndAddImages() {
        // Create test data
        String folderName = 'TestFolder';
        Map<String, String> imageMap = new Map<String, String>{
            'Image1.jpg' => 'Base64EncodedImageString1',
            'Image2.jpg' => 'Base64EncodedImageString2'
        };

        Test.startTest();
        // Call the method under test
        UploadImageInFolder.createFolderAndAddImages(folderName, imageMap);
        Test.stopTest();

        // Query the created ContentWorkspace
        ContentWorkspace contentWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name = :folderName LIMIT 1];
        System.assertNotEquals(null, contentWorkspace, 'ContentWorkspace should be created');

        // Query the ContentWorkspaceDoc records
        List<ContentWorkspaceDoc> contentWorkspaceDocs = [SELECT Id, ContentDocumentId, ContentWorkspaceId FROM ContentWorkspaceDoc WHERE ContentWorkspaceId = :contentWorkspace.Id];
        //System.assertEquals(2, contentWorkspaceDocs.size(), 'ContentWorkspaceDoc records should be created for each image');

        // Query the ContentVersion records
        List<ContentVersion> contentVersions = [SELECT Id, Title, VersionData, PathOnClient FROM ContentVersion WHERE ContentDocumentId IN (SELECT ContentDocumentId FROM ContentWorkspaceDoc WHERE ContentWorkspaceId = :contentWorkspace.Id)];
        //System.assertEquals(2, contentVersions.size(), 'ContentVersion records should be created for each image');
        for (ContentVersion cv : contentVersions) {
            System.assertEquals(true, imageMap.containsKey(cv.Title), 'ContentVersion title should be in the image map');
            System.assertEquals(imageMap.get(cv.Title), EncodingUtil.base64Encode(cv.VersionData), 'ContentVersion data should match the image map');
            System.assertEquals(cv.Title, cv.PathOnClient, 'ContentVersion PathOnClient should match the title');
        }
    }
}