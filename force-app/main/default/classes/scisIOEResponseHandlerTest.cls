@isTest
public class scisIOEResponseHandlerTest {

    // Mock class for the HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"eiRating": 83, "spaceHeatingCost": 100, "primaryEnergy": 150, "totalCost": 200, "Result": 95}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testMakeHttpPostRequest() {
        // Create test survey record
        Survey__c testSurvey = new Survey__c(Name = 'Test Survey');
        insert testSurvey;

        // Create a ContentVersion linked to the survey
        ContentVersion version = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Data'),  // Simulate file data
            PathOnClient = 'TestDocument.txt',
            FirstPublishLocationId = testSurvey.Id,  // Link to the Survey record
            IsMajorVersion = true
        );
        insert version;

        // Fetch ContentDocumentId (Salesforce automatically creates ContentDocument when inserting ContentVersion)
        ContentVersion insertedVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :version.Id LIMIT 1];

        // Check if ContentDocumentLink already exists to avoid duplicates
        List<ContentDocumentLink> existingLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :testSurvey.Id AND ContentDocumentId = :insertedVersion.ContentDocumentId LIMIT 1];
        if (existingLinks.isEmpty()) {
            // Create a ContentDocumentLink if it doesn't exist
            ContentDocumentLink docLink = new ContentDocumentLink(
                LinkedEntityId = testSurvey.Id,
                ContentDocumentId = insertedVersion.ContentDocumentId,
                ShareType = 'V'
            );
            insert docLink;
        }

        // Mock HTTP Callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        String response = scisIOEResponseHandler.makeHttpPostRequest(testSurvey.Id);
        Test.stopTest();

        // Assertions
        /*System.assertNotEquals(null, response, 'Response should not be null');
        IOE_Response__c responseRecord = [SELECT Id, Survey__c, eiRating__c, Space_Heating_Demand__c, Total_Delivered_Energy__c, Total_Fuel_Costs__c, Result__C FROM IOE_Response__c WHERE Survey__c = :testSurvey.Id LIMIT 1];
        System.assertNotEquals(null, responseRecord, 'IOE_Response__c record should be created');
        System.assertEquals(83, responseRecord.eiRating__c, 'eiRating should be 83');
        System.assertEquals(100, responseRecord.Space_Heating_Demand__c, 'Space Heating Demand should be 100');
        System.assertEquals(150, responseRecord.Total_Delivered_Energy__c, 'Primary Energy should be 150');
        System.assertEquals(200, responseRecord.Total_Fuel_Costs__c, 'Total Fuel Costs should be 200');
        System.assertEquals(95, responseRecord.Result__C, 'Result should be 95');
*/
    }

    @isTest
    static void testSavePackageData() {
        // Prepare test data
        List<Map<String, Object>> recommendationData = new List<Map<String, Object>>();
        Map<String, Object> recommendation1 = new Map<String, Object>{
            'name' => 'Package1', 
            'text' => 'Test Text 1',
            'result' => 100,
            'isEnabled' => true,
            'isVisible' => true,
            'isChecked' => true,
            'shortText' => 'Short Text 1',
            'savingCost' => 50,
            'saPband' => 'A',
            'saPrating' => 85,
            'cO2emissionsChange' => 20,
            'eIrating' => 83
        };
        recommendationData.add(recommendation1);

        Test.startTest();
        scisIOEResponseHandler.savePackageData(recommendationData);
        Test.stopTest();

        // Verify that the package data was inserted
        List<Package__c> insertedPackages = [SELECT Name, Text__c, Result__c, isEnabled__c, isVisible__c, isChecked__c, shortText__c, savingCost__c, SAP_Band__c, SAP_Rating__c, cO2_Emissions_Change__c, EI_Rating__c FROM Package__c WHERE Name = 'Package1'];
        System.assertEquals(1, insertedPackages.size(), 'One package should be inserted');
        System.assertEquals('Package1', insertedPackages[0].Name, 'Package name should be "Package1"');
        System.assertEquals('Test Text 1', insertedPackages[0].Text__c, 'Package text should match');
        System.assertEquals(100, insertedPackages[0].Result__c, 'Result should be 100');
        System.assertEquals(true, insertedPackages[0].isEnabled__c, 'isEnabled should be true');
        System.assertEquals(true, insertedPackages[0].isVisible__c, 'isVisible should be true');
        System.assertEquals(true, insertedPackages[0].isChecked__c, 'isChecked should be true');
        System.assertEquals('Short Text 1', insertedPackages[0].shortText__c, 'shortText should match');
        System.assertEquals(50, insertedPackages[0].savingCost__c, 'Saving cost should be 50');
        System.assertEquals('A', insertedPackages[0].SAP_Band__c, 'SAP Band should be A');
        System.assertEquals(85, insertedPackages[0].SAP_Rating__c, 'SAP Rating should be 85');
        System.assertEquals(20, insertedPackages[0].cO2_Emissions_Change__c, 'CO2 Emissions Change should be 20');
        System.assertEquals(83, insertedPackages[0].EI_Rating__c, 'EI Rating should be 83');
    }

    @isTest
    static void testFetchLatestResponse() {
        // Create a mock IOE_Response__c record
        IOE_Response__c mockResponse = new IOE_Response__c(
            Survey__c = 'a2HUE0000004s532AA',
            Response_Body__c = 'Test Response Body',
            eiRating__c = 80,
            Space_Heating_Demand__c = 120,
            Total_Delivered_Energy__c = 200,
            Total_Fuel_Costs__c = 150,
            Result__C = 95
        );
        insert mockResponse;

        Test.startTest();
        IOE_Response__c latestResponse = scisIOEResponseHandler.fetchLatestResponse();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, latestResponse, 'Latest response should not be null');
       // System.assertEquals('Test Response Body', latestResponse.Response_Body__c, 'Response Body should match');
       // System.assertEquals(80, latestResponse.eiRating__c, 'EI Rating should be 80');
       // System.assertEquals(120, latestResponse.Space_Heating_Demand__c, 'Space Heating Demand should be 120');
       // System.assertEquals(200, latestResponse.Total_Delivered_Energy__c, 'Total Delivered Energy should be 200');
       // System.assertEquals(150, latestResponse.Total_Fuel_Costs__c, 'Total Fuel Costs should be 150');
       // System.assertEquals(95, latestResponse.Result__C, 'Result should be 95');
    }
}