public class ReparentFilesToSurveyHandler {
    public static void reparentFiles(List<ERF__c> erfList) {
        List<ContentVersion> newVersions = new List<ContentVersion>();
        List<ContentDocumentLink> newLinks = new List<ContentDocumentLink>();
        Set<Id> existingLinks = new Set<Id>();

        for (ERF__c erf : erfList) {
            if (erf.Survey__c != null) {  // Assuming there is a lookup to Survey__c on ERF__c
                // Fetch all ContentDocumentLinks associated with the Survey to avoid duplicates
                List<ContentDocumentLink> existingContentLinks = [SELECT ContentDocumentId 
                                                                  FROM ContentDocumentLink 
                                                                  WHERE LinkedEntityId = :erf.Survey__c];

                for (ContentDocumentLink link : existingContentLinks) {
                    existingLinks.add(link.ContentDocumentId);
                }

                // Fetch all ContentVersions associated with the ERF record
                List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId, Title, VersionData, 
                                                        PathOnClient, IsMajorVersion 
                                                        FROM ContentVersion 
                                                        WHERE FirstPublishLocationId = :erf.Id];

                // Clone each ContentVersion without setting FirstPublishLocationId
                for (ContentVersion version : contentVersions) {
                    if (!existingLinks.contains(version.ContentDocumentId)) {
                        ContentVersion newVersion = new ContentVersion(
                            ContentDocumentId = version.ContentDocumentId,
                            Title = version.Title,
                            VersionData = version.VersionData,
                            PathOnClient = version.PathOnClient,
                            IsMajorVersion = version.IsMajorVersion
                        );
                        newVersions.add(newVersion);
                    }
                }

                // Insert new versions and create links to Survey
                if (!newVersions.isEmpty()) {
                    insert newVersions;
                    for (ContentVersion version : newVersions) {
                        ContentDocumentLink newLink = new ContentDocumentLink(
                            ContentDocumentId = version.ContentDocumentId,
                            LinkedEntityId = erf.Survey__c,
                            ShareType = 'I' // 'I' for Inferred permission, 'V' for Viewer, 'C' for Collaborator
                        );
                        newLinks.add(newLink);
                    }
                }
            }
        }

        if (!newLinks.isEmpty()) {
            insert newLinks;
        }
    }
}