Global class ElmhurstRdsapLodgeController {
	global String responseData { get; set; }
    global String res { get; set; }
    //global String jsonResponse { get; set; }
global void submitSurveyRdsapLodge() {
    
    // Prepare the endpoint URL
    HttpRequest req = new HttpRequest();
            Http http = new Http();

            // Set the request method and endpoint
            req.setMethod('POST');
            req.setEndpoint('https://elmhurst-api-staging.elmhurstenergy.net/api/Rdsap/Lodge?api-version=2.0');

            // Set the username and password for basic authentication
            String username = '311245362999';
            String password = '5bfac846aa90466bf65d93bb35473f19';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);

            // Set additional headers
            req.setHeader('Surveyor-Code', 'I061-0001');
    		req.setHeader('Password', '5bfac846aa90466bf65d93bb35473f19');
            req.setHeader('Content-Type', 'application/xml');
        
        // Set the body (your XML data)
        String requestBody = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<SurveyRec xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SurveyorIdCode>I061-0001</SurveyorIdCode>' +
            '<RefNumber>000003</RefNumber>' +
  '<Guid>867AD43F-8C3A-49D7-B9DB-789B8286DDD4</Guid>' + 
  '<Billing>' + 
    '<BillingSubject>Surveyor</BillingSubject>' + 
    '<OperationsDepartmentID xsi:nil="true" />' + 
  '</Billing>' + 
  '<Status>Submitted</Status>' + 
  '<TrainingType>None</TrainingType>' + 
  '<BuildingParts>' + 
    '<BuildingPartRec>' + 
      '<DateBuilt>I</DateBuilt>' + 
      '<RoomInRoofDateBuilt xsi:nil="true" />' + 
      '<FloorArea>' + 
        '<double>36</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
      '</FloorArea>' + 
      '<RoomHeight>' + 
        '<double>2.5</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
      '</RoomHeight>' + 
      '<Perimeter>' + 
        '<double>14</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
      '</Perimeter>' + 
      '<PartyWallLength>' + 
        '<double>10</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
        '<double>0</double>' + 
      '</PartyWallLength>' + 
      '<RoomInRoofArea>0</RoomInRoofArea>' + 
      '<ExternalWallAsMainExternalWall>false</ExternalWallAsMainExternalWall>' + 
      '<ExternalWallType>Cavity</ExternalWallType>' + 
      '<ExternalWallInsulation>FilledCavityExternal</ExternalWallInsulation>' + 
      '<ExternalWallInsulationThickness>_200mm</ExternalWallInsulationThickness>' + 
      '<ExternalWallUvalue>0</ExternalWallUvalue>' + 
      '<ExternalWallUValueKnown>false</ExternalWallUValueKnown>' + 
      '<ExternalWallThicknessUnknown>false</ExternalWallThicknessUnknown>' + 
      '<ExternalWallThickness>350</ExternalWallThickness>' + 
      '<ExternalWallDryLining xsi:nil="true" />' + 
      '<ExternalAlternativeWallArea>0</ExternalAlternativeWallArea>' + 
      '<ExternalAlternativeWallAsMainExternalAlternativeWall>false</ExternalAlternativeWallAsMainExternalAlternativeWall>' + 
      '<ExternalAlternativeWallType xsi:nil="true" />' + 
      '<ExternalAlternativeWallInsulation xsi:nil="true" />' + 
      '<ExternalAlternativeWallInsulationThickness xsi:nil="true" />' + 
      '<ExternalAlternativeWallUvalue>0</ExternalAlternativeWallUvalue>' + 
      '<ExternalAlternativeWallUvalueKnown>false</ExternalAlternativeWallUvalueKnown>' + 
      '<ExternalAlternativeWallThicknessUnknown>false</ExternalAlternativeWallThicknessUnknown>' + 
      '<ExternalAlternativeWallThickness>0</ExternalAlternativeWallThickness>' + 
      '<ExternalAlternativeWallDryLining xsi:nil="true" />' + 
      '<ExternalAlternativeWallSheltered>false</ExternalAlternativeWallSheltered>' + 
      '<PartyWallType>CavityMasonryUnfilled</PartyWallType>' + 
      '<RoofConstruction>AnotherDwellingAbove</RoofConstruction>' + 
      '<RoofInsulation xsi:nil="true" />' + 
      '<RoofThickness xsi:nil="true" />' + 
      '<RoofAsMain>false</RoofAsMain>' + 
      '<FlatRoofInsulation xsi:nil="true" />' + 
      '<RoomInRoofInsulation xsi:nil="true" />' + 
      '<RoomInRoofOtherInsulation xsi:nil="true" />' + 
      '<RoomInRoofThickness xsi:nil="true" />' + 
      '<RoofUvalueKnown>false</RoofUvalueKnown>' + 
      '<RoofUvalue>0</RoofUvalue>' + 
      '<RoomInRoofEdit>false</RoomInRoofEdit>' + 
      '<RoomInRoofAttached>false</RoomInRoofAttached>' + 
      '<RoomInRoof>' + 
        '<RoomInRoofRec>' + 
          '<Element>FlatCeiling1</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>FlatCeiling2</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>GableWall1</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>GableWall2</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>Slope1</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>Slope2</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>StudWall1</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
        '<RoomInRoofRec>' + 
          '<Element>StudWall2</Element>' + 
          '<Area>0</Area>' + 
          '<Uvalue>0</Uvalue>' + 
        '</RoomInRoofRec>' + 
      '</RoomInRoof>' + 
      '<FloorLocation>AnotherDwellingBelow</FloorLocation>' + 
      '<FloorConstruction xsi:nil="true" />' + 
      '<FloorInsulation xsi:nil="true" />' + 
      '<FloorAsMain>false</FloorAsMain>' + 
      '<FloorInsulationThickness xsi:nil="true" />' + 
      '<FloorUvalueKnown>false</FloorUvalueKnown>' + 
      '<FloorUvalue>0</FloorUvalue>' + 
    '</BuildingPartRec>' + 
        '<BuildingPartRec>' +
  '<DateBuilt xsi:nil="true" />' +
  '<RoomInRoofDateBuilt xsi:nil="true" />' +
  '<FloorArea>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</FloorArea>' +
  '<RoomHeight>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</RoomHeight>' +
  '<Perimeter>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</Perimeter>' +
  '<PartyWallLength>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</PartyWallLength>' +
  '<RoomInRoofArea>0</RoomInRoofArea>' +
  '<ExternalWallAsMainExternalWall>false</ExternalWallAsMainExternalWall>' +
  '<ExternalWallType xsi:nil="true" />' +
  '<ExternalWallInsulation xsi:nil="true" />' +
  '<ExternalWallInsulationThickness xsi:nil="true" />' +
  '<ExternalWallUvalue>0</ExternalWallUvalue>' +
  '<ExternalWallUValueKnown>false</ExternalWallUValueKnown>' +
  '<ExternalWallThicknessUnknown>false</ExternalWallThicknessUnknown>' +
  '<ExternalWallThickness>0</ExternalWallThickness>' +
  '<ExternalWallDryLining xsi:nil="true" />' +
  '<ExternalAlternativeWallArea>0</ExternalAlternativeWallArea>' +
  '<ExternalAlternativeWallAsMainExternalAlternativeWall>false</ExternalAlternativeWallAsMainExternalAlternativeWall>' +
  '<ExternalAlternativeWallType xsi:nil="true" />' +
  '<ExternalAlternativeWallInsulation xsi:nil="true" />' +
  '<ExternalAlternativeWallInsulationThickness xsi:nil="true" />' +
  '<ExternalAlternativeWallUvalue>0</ExternalAlternativeWallUvalue>' +
  '<ExternalAlternativeWallUvalueKnown>false</ExternalAlternativeWallUvalueKnown>' +
  '<ExternalAlternativeWallThicknessUnknown>false</ExternalAlternativeWallThicknessUnknown>' +
  '<ExternalAlternativeWallThickness>0</ExternalAlternativeWallThickness>' +
  '<ExternalAlternativeWallDryLining xsi:nil="true" />' +
  '<ExternalAlternativeWallSheltered>false</ExternalAlternativeWallSheltered>' +
  '<PartyWallType xsi:nil="true" />' +
  '<RoofConstruction xsi:nil="true" />' +
  '<RoofInsulation xsi:nil="true" />' +
  '<RoofThickness xsi:nil="true" />' +
  '<RoofAsMain>false</RoofAsMain>' +
  '<FlatRoofInsulation xsi:nil="true" />' +
  '<RoomInRoofInsulation xsi:nil="true" />' +
  '<RoomInRoofOtherInsulation xsi:nil="true" />' +
  '<RoomInRoofThickness xsi:nil="true" />' +
  '<RoofUvalueKnown>false</RoofUvalueKnown>' +
  '<RoofUvalue>0</RoofUvalue>' +
  '<RoomInRoofEdit>false</RoomInRoofEdit>' +
  '<RoomInRoofAttached>false</RoomInRoofAttached>' +
  '<RoomInRoof>' +
    '<RoomInRoofRec>' +
      '<Element>FlatCeiling1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>FlatCeiling2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>GableWall1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>GableWall2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>Slope1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>Slope2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>StudWall1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>StudWall2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
  '</RoomInRoof>' +
  '<FloorLocation xsi:nil="true" />' +
  '<FloorConstruction xsi:nil="true" />' +
  '<FloorInsulation xsi:nil="true" />' +
  '<FloorAsMain>false</FloorAsMain>' +
  '<FloorInsulationThickness xsi:nil="true" />' +
  '<FloorUvalueKnown>false</FloorUvalueKnown>' +
  '<FloorUvalue>0</FloorUvalue>' +
'</BuildingPartRec>'+
        '<BuildingPartRec>' +
    '<DateBuilt xsi:nil="true" />' +
    '<RoomInRoofDateBuilt xsi:nil="true" />' +
    '<FloorArea>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
    '</FloorArea>' +
    '<RoomHeight>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
    '</RoomHeight>' +
    '<Perimeter>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
    '</Perimeter>' +
    '<PartyWallLength>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
        '<double>0</double>' +
    '</PartyWallLength>' +
    '<RoomInRoofArea>0</RoomInRoofArea>' +
    '<ExternalWallAsMainExternalWall>false</ExternalWallAsMainExternalWall>' +
    '<ExternalWallType xsi:nil="true" />' +
    '<ExternalWallInsulation xsi:nil="true" />' +
    '<ExternalWallInsulationThickness xsi:nil="true" />' +
    '<ExternalWallUvalue>0</ExternalWallUvalue>' +
    '<ExternalWallUValueKnown>false</ExternalWallUValueKnown>' +
    '<ExternalWallThicknessUnknown>false</ExternalWallThicknessUnknown>' +
    '<ExternalWallThickness>0</ExternalWallThickness>' +
    '<ExternalWallDryLining xsi:nil="true" />' +
    '<ExternalAlternativeWallArea>0</ExternalAlternativeWallArea>' +
    '<ExternalAlternativeWallAsMainExternalAlternativeWall>false</ExternalAlternativeWallAsMainExternalAlternativeWall>' +
    '<ExternalAlternativeWallType xsi:nil="true" />' +
    '<ExternalAlternativeWallInsulation xsi:nil="true" />' +
    '<ExternalAlternativeWallInsulationThickness xsi:nil="true" />' +
    '<ExternalAlternativeWallUvalue>0</ExternalAlternativeWallUvalue>' +
    '<ExternalAlternativeWallUvalueKnown>false</ExternalAlternativeWallUvalueKnown>' +
    '<ExternalAlternativeWallThicknessUnknown>false</ExternalAlternativeWallThicknessUnknown>' +
    '<ExternalAlternativeWallThickness>0</ExternalAlternativeWallThickness>' +
    '<ExternalAlternativeWallDryLining xsi:nil="true" />' +
    '<ExternalAlternativeWallSheltered>false</ExternalAlternativeWallSheltered>' +
    '<PartyWallType xsi:nil="true" />' +
    '<RoofConstruction xsi:nil="true" />' +
    '<RoofInsulation xsi:nil="true" />' +
    '<RoofThickness xsi:nil="true" />' +
    '<RoofAsMain>false</RoofAsMain>' +
    '<FlatRoofInsulation xsi:nil="true" />' +
    '<RoomInRoofInsulation xsi:nil="true" />' +
    '<RoomInRoofOtherInsulation xsi:nil="true" />' +
    '<RoomInRoofThickness xsi:nil="true" />' +
    '<RoofUvalueKnown>false</RoofUvalueKnown>' +
    '<RoofUvalue>0</RoofUvalue>' +
    '<RoomInRoofEdit>false</RoomInRoofEdit>' +
    '<RoomInRoofAttached>false</RoomInRoofAttached>' +
    '<RoomInRoof>' +
        '<RoomInRoofRec>' +
            '<Element>FlatCeiling1</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>FlatCeiling2</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>GableWall1</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>GableWall2</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>Slope1</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>Slope2</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>StudWall1</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
        '<RoomInRoofRec>' +
            '<Element>StudWall2</Element>' +
            '<Area>0</Area>' +
            '<Uvalue>0</Uvalue>' +
        '</RoomInRoofRec>' +
    '</RoomInRoof>' +
    '<FloorLocation xsi:nil="true" />' +
    '<FloorConstruction xsi:nil="true" />' +
    '<FloorInsulation xsi:nil="true" />' +
    '<FloorAsMain>false</FloorAsMain>' +
    '<FloorInsulationThickness xsi:nil="true" />' +
    '<FloorUvalueKnown>false</FloorUvalueKnown>' +
    '<FloorUvalue>0</FloorUvalue>' +
'</BuildingPartRec>'+
        '<BuildingPartRec>' +
  '<DateBuilt xsi:nil="true" />' +
  '<RoomInRoofDateBuilt xsi:nil="true" />' +
  '<FloorArea>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</FloorArea>' +
  '<RoomHeight>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</RoomHeight>' +
  '<Perimeter>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</Perimeter>' +
  '<PartyWallLength>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</PartyWallLength>' +
  '<RoomInRoofArea>0</RoomInRoofArea>' +
  '<ExternalWallAsMainExternalWall>false</ExternalWallAsMainExternalWall>' +
  '<ExternalWallType xsi:nil="true" />' +
  '<ExternalWallInsulation xsi:nil="true" />' +
  '<ExternalWallInsulationThickness xsi:nil="true" />' +
  '<ExternalWallUvalue>0</ExternalWallUvalue>' +
  '<ExternalWallUValueKnown>false</ExternalWallUValueKnown>' +
  '<ExternalWallThicknessUnknown>false</ExternalWallThicknessUnknown>' +
  '<ExternalWallThickness>0</ExternalWallThickness>' +
  '<ExternalWallDryLining xsi:nil="true" />' +
  '<ExternalAlternativeWallArea>0</ExternalAlternativeWallArea>' +
  '<ExternalAlternativeWallAsMainExternalAlternativeWall>false</ExternalAlternativeWallAsMainExternalAlternativeWall>' +
  '<ExternalAlternativeWallType xsi:nil="true" />' +
  '<ExternalAlternativeWallInsulation xsi:nil="true" />' +
  '<ExternalAlternativeWallInsulationThickness xsi:nil="true" />' +
  '<ExternalAlternativeWallUvalue>0</ExternalAlternativeWallUvalue>' +
  '<ExternalAlternativeWallUvalueKnown>false</ExternalAlternativeWallUvalueKnown>' +
  '<ExternalAlternativeWallThicknessUnknown>false</ExternalAlternativeWallThicknessUnknown>' +
  '<ExternalAlternativeWallThickness>0</ExternalAlternativeWallThickness>' +
  '<ExternalAlternativeWallDryLining xsi:nil="true" />' +
  '<ExternalAlternativeWallSheltered>false</ExternalAlternativeWallSheltered>' +
  '<PartyWallType xsi:nil="true" />' +
  '<RoofConstruction xsi:nil="true" />' +
  '<RoofInsulation xsi:nil="true" />' +
  '<RoofThickness xsi:nil="true" />' +
  '<RoofAsMain>false</RoofAsMain>' +
  '<FlatRoofInsulation xsi:nil="true" />' +
  '<RoomInRoofInsulation xsi:nil="true" />' +
  '<RoomInRoofOtherInsulation xsi:nil="true" />' +
  '<RoomInRoofThickness xsi:nil="true" />' +
  '<RoofUvalueKnown>false</RoofUvalueKnown>' +
  '<RoofUvalue>0</RoofUvalue>' +
  '<RoomInRoofEdit>false</RoomInRoofEdit>' +
  '<RoomInRoofAttached>false</RoomInRoofAttached>' +
  '<RoomInRoof>' +
    '<RoomInRoofRec>' +
      '<Element>FlatCeiling1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>FlatCeiling2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>GableWall1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>GableWall2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>Slope1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>Slope2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>StudWall1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>StudWall2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
  '</RoomInRoof>' +
  '<FloorLocation xsi:nil="true" />' +
  '<FloorConstruction xsi:nil="true" />' +
  '<FloorInsulation xsi:nil="true" />' +
  '<FloorAsMain>false</FloorAsMain>' +
  '<FloorInsulationThickness xsi:nil="true" />' +
  '<FloorUvalueKnown>false</FloorUvalueKnown>' +
  '<FloorUvalue>0</FloorUvalue>' +
'</BuildingPartRec>'+
        '<BuildingPartRec>' +
  '<DateBuilt xsi:nil="true" />' +
  '<RoomInRoofDateBuilt xsi:nil="true" />' +
  '<FloorArea>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</FloorArea>' +
  '<RoomHeight>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</RoomHeight>' +
  '<Perimeter>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</Perimeter>' +
  '<PartyWallLength>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
    '<double>0</double>' +
  '</PartyWallLength>' +
  '<RoomInRoofArea>0</RoomInRoofArea>' +
  '<ExternalWallAsMainExternalWall>false</ExternalWallAsMainExternalWall>' +
  '<ExternalWallType xsi:nil="true" />' +
  '<ExternalWallInsulation xsi:nil="true" />' +
  '<ExternalWallInsulationThickness xsi:nil="true" />' +
  '<ExternalWallUvalue>0</ExternalWallUvalue>' +
  '<ExternalWallUValueKnown>false</ExternalWallUValueKnown>' +
  '<ExternalWallThicknessUnknown>false</ExternalWallThicknessUnknown>' +
  '<ExternalWallThickness>0</ExternalWallThickness>' +
  '<ExternalWallDryLining xsi:nil="true" />' +
  '<ExternalAlternativeWallArea>0</ExternalAlternativeWallArea>' +
  '<ExternalAlternativeWallAsMainExternalAlternativeWall>false</ExternalAlternativeWallAsMainExternalAlternativeWall>' +
  '<ExternalAlternativeWallType xsi:nil="true" />' +
  '<ExternalAlternativeWallInsulation xsi:nil="true" />' +
  '<ExternalAlternativeWallInsulationThickness xsi:nil="true" />' +
  '<ExternalAlternativeWallUvalue>0</ExternalAlternativeWallUvalue>' +
  '<ExternalAlternativeWallUvalueKnown>false</ExternalAlternativeWallUvalueKnown>' +
  '<ExternalAlternativeWallThicknessUnknown>false</ExternalAlternativeWallThicknessUnknown>' +
  '<ExternalAlternativeWallThickness>0</ExternalAlternativeWallThickness>' +
  '<ExternalAlternativeWallDryLining xsi:nil="true" />' +
  '<ExternalAlternativeWallSheltered>false</ExternalAlternativeWallSheltered>' +
  '<PartyWallType xsi:nil="true" />' +
  '<RoofConstruction xsi:nil="true" />' +
  '<RoofInsulation xsi:nil="true" />' +
  '<RoofThickness xsi:nil="true" />' +
  '<RoofAsMain>false</RoofAsMain>' +
  '<FlatRoofInsulation xsi:nil="true" />' +
  '<RoomInRoofInsulation xsi:nil="true" />' +
  '<RoomInRoofOtherInsulation xsi:nil="true" />' +
  '<RoomInRoofThickness xsi:nil="true" />' +
  '<RoofUvalueKnown>false</RoofUvalueKnown>' +
  '<RoofUvalue>0</RoofUvalue>' +
  '<RoomInRoofEdit>false</RoomInRoofEdit>' +
  '<RoomInRoofAttached>false</RoomInRoofAttached>' +
  '<RoomInRoof>' +
    '<RoomInRoofRec>' +
      '<Element>FlatCeiling1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>FlatCeiling2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>GableWall1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>GableWall2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>Slope1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>Slope2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>StudWall1</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
    '<RoomInRoofRec>' +
      '<Element>StudWall2</Element>' +
      '<Area>0</Area>' +
      '<Uvalue>0</Uvalue>' +
    '</RoomInRoofRec>' +
  '</RoomInRoof>' +
  '<FloorLocation xsi:nil="true" />' +
  '<FloorConstruction xsi:nil="true" />' +
  '<FloorInsulation xsi:nil="true" />' +
  '<FloorAsMain>false</FloorAsMain>' +
  '<FloorInsulationThickness xsi:nil="true" />' +
  '<FloorUvalueKnown>false</FloorUvalueKnown>' +
  '<FloorUvalue>0</FloorUvalue>' +
'</BuildingPartRec>'+
  '</BuildingParts>'+
        '<UPRN />' + 
'<HouseName />' + 
'<HouseNumber>16</HouseNumber>' + 
'<Street>St. Johns Business Park</Street>' + 
'<Locality />' + 
'<Town>LUTTERWORTH</Town>' + 
'<County />' + 
'<AddressLine1>16</AddressLine1>' + 
'<AddressLine2>St. Johns Business Park</AddressLine2>' + 
'<AddressLine3 />' + 
'<AddressLine4 />' + 
'<AccredSchemeType>' + 
'<AccredSchemeTypeID>23</AccredSchemeTypeID>' + 
'<AccredSchemeTypeName>[FAKE E]</AccredSchemeTypeName>' + 
'</AccredSchemeType>' + 
'<RegsRegion>England</RegsRegion>' + 
'<PostCode>LE17 4HB</PostCode>' + 
'<Region>Midlands</Region>' + 
'<TransactionTypeStruct>' + 
'<Code>1</Code>' + 
'<Text>Marketed Sale</Text>' + 
'</TransactionTypeStruct>' + 
'<Tenure>' + 
'<Code>1</Code>' + 
'<Text>Owner-occupied</Text>' + 
'</Tenure>' + 
'<ProcessDate>2024-08-22T12:57:00</ProcessDate>' + 
'<InspectionDate>2024-07-16T23:00:00</InspectionDate>' + 
'<LockDate>2024-08-22T12:57:24.343</LockDate>' + 
'<EpcLanguage>English</EpcLanguage>' + 
'<PropertyType1>Flat</PropertyType1>' + 
'<PropertyType2>MidTerrace</PropertyType2>' + 
'<Storeys>1</Storeys>' + 
'<Rooms>3</Rooms>' + 
'<RoomsHeated>3</RoomsHeated>' + 
'<ConservatoryPresent>false</ConservatoryPresent>' + 
'<ConservatorySeparated>false</ConservatorySeparated>' + 
'<ConservatoryFixedHeaters>false</ConservatoryFixedHeaters>' + 
'<ConservatoryFloorArea>0</ConservatoryFloorArea>' + 
'<ConservatoryDoubleGlazed>false</ConservatoryDoubleGlazed>' + 
'<ConservatoryGlazedPerimeter>0</ConservatoryGlazedPerimeter>' + 
'<HeatedConservatoryHeight>_1_Storey</HeatedConservatoryHeight>' + 
'<DimensionType>Internal</DimensionType>' + 
'<FlatCoridor>None</FlatCoridor>' + 
'<FlatShelteredWallLength>0</FlatShelteredWallLength>' + 
'<FlatWhichFloor>2</FlatWhichFloor>' + 
'<FlatPosition>MidFloor</FlatPosition>' + 
'<Doors>1</Doors>' + 
'<DoorsInsulated>0</DoorsInsulated>' + 
'<DoorUvalue>0</DoorUvalue>' + 
'<ExtendedWindowsData />' + 
'<OpeningsTotalArea>Typical</OpeningsTotalArea>' + 
'<DoubleGlazedProportion>100</DoubleGlazedProportion>' + 
'<GlazingType>DoublePre2002</GlazingType>' + 
'<WindowUvalue>0</WindowUvalue>' + 
'<WindowGvalue>0</WindowGvalue>' + 
'<GlazingDatasource xsi:nil="true" />' + 
'<OpeningsFrameType>PvcFrame</OpeningsFrameType>' + 
'<OpeningsGlazingGap>_6</OpeningsGlazingGap>' + 
'<DraughtProofing>100</DraughtProofing>' + 
'<OpenFireplaces>0</OpenFireplaces>' + 
'<LightsTotal>20</LightsTotal>' + 
'<LelLightsTotal>10</LelLightsTotal>' + 
'<MechanicalVentilation>false</MechanicalVentilation>' + 
'<MechVentSuplyExtractSystem>false</MechVentSuplyExtractSystem>' + 
'<FixedSpaceCooling>false</FixedSpaceCooling>' + 
'<MainHeating>' + 
'<MainHeatingRec>' + 
'<MHS>BGW</MHS>' + 
'<HeatEmitterType>Radiators</HeatEmitterType>' + 
'<MHSCtrl>CBE</MHSCtrl>' + 
'<PCDFBoilerReference>16850</PCDFBoilerReference>' + 
'<FuelType>MainsGas</FuelType>' + 
'<PercentageOfHeat>100</PercentageOfHeat>' + 
'<FanAssistedFlue>Yes</FanAssistedFlue>' + 
'<FlueType>Balanced</FlueType>' + 
'<HeatingPumpAge>Unknown</HeatingPumpAge>' + 
'<FlowTemperature>Unknown</FlowTemperature>' + 
'<McsCertificate>No</McsCertificate>' + 
'<StorageHeaters />' + 
'<PcdfHeatingControls>0</PcdfHeatingControls>' + 
'<PCDFCompensator>0</PCDFCompensator>' + 
'</MainHeatingRec>' + 
        '<MainHeatingRec>' + 
      '<MHS />' + 
      '<HeatEmitterType xsi:nil="true" />' + 
      '<MHSCtrl />' + 
      '<PCDFBoilerReference>0</PCDFBoilerReference>' + 
      '<FuelType xsi:nil="true" />' + 
      '<PercentageOfHeat>0</PercentageOfHeat>' + 
      '<FanAssistedFlue xsi:nil="true" />' + 
      '<FlueType xsi:nil="true" />' + 
      '<HeatingPumpAge>Unknown</HeatingPumpAge>' + 
      '<FlowTemperature>Unknown</FlowTemperature>' + 
      '<McsCertificate>No</McsCertificate>' + 
      '<StorageHeaters />' + 
      '<PcdfHeatingControls>0</PcdfHeatingControls>' + 
      '<PCDFCompensator>0</PCDFCompensator>' + 
    '</MainHeatingRec>' +
'</MainHeating>' +
        '  <CommunityHeatNetwork>0</CommunityHeatNetwork>' + 
'  <CommunityHeatSourceType>Boilers</CommunityHeatSourceType>' + 
'  <CommunityFuelType xsi:nil="true" />' + 
'  <CommunityWaterHeatSourceType>None</CommunityWaterHeatSourceType>' + 
'  <CommunityWaterFuelType xsi:nil="true" />' + 
'  <SHS />' + 
'  <WHS>HWP</WHS>' + 
'  <ImmersionType>Single</ImmersionType>' + 
'  <HotWaterCylinder>false</HotWaterCylinder>' + 
'  <CylinderSize xsi:nil="true" />' + 
'  <CylinderInsulation xsi:nil="true" />' + 
'  <CylinderInsulationThickness xsi:nil="true" />' + 
'  <CylinderStat>false</CylinderStat>' + 
'  <SolarWaterHeating>false</SolarWaterHeating>' + 
'  <SolarDetailsKnown>false</SolarDetailsKnown>' + 
'  <SolarPanelType xsi:nil="true" />' + 
'  <SolarPanelElevation xsi:nil="true" />' + 
'  <SolarPanelOrientation xsi:nil="true" />' + 
'  <SolarPanelOvershading xsi:nil="true" />' + 
'  <SolarPanelArea>0</SolarPanelArea>' + 
'  <SolarPanelEfficiency>0</SolarPanelEfficiency>' + 
'  <SolarPanelCollectorCoefficientA1>0</SolarPanelCollectorCoefficientA1>' + 
'  <SolarPanelCollectorCoefficientA2>0</SolarPanelCollectorCoefficientA2>' + 
'  <SolarStoreCombined>false</SolarStoreCombined>' + 
'  <SolarStoreVolume>0</SolarStoreVolume>' + 
'  <SolarStoreDetailsKnown>false</SolarStoreDetailsKnown>' + 
'  <TotalHotWaterStoreVolume>0</TotalHotWaterStoreVolume>' + 
'  <SolarPump xsi:nil="true" />' + 
'  <SolarShowersInProperty xsi:nil="true" />' + 
'  <SolarCollectorDetailsKnown>false</SolarCollectorDetailsKnown>' + 
'  <WWHRSPresent>NoUnknown</WWHRSPresent>' + 
'  <WWHRSRoomsWithBath>1</WWHRSRoomsWithBath>' + 
'  <WWHRSRoomsWithMixShowerAndNoBath>1</WWHRSRoomsWithMixShowerAndNoBath>' + 
'  <WWHRSRoomsWithMixShowerAndBath>0</WWHRSRoomsWithMixShowerAndBath>' + 
'  <WWHRSInstantaneous1>' + 
'    <PCDFIndex xsi:nil="true" />' + 
'    <Rooms1 xsi:nil="true" />' + 
'    <Rooms2 xsi:nil="true" />' + 
'  </WWHRSInstantaneous1>' + 
'  <WWHRSInstantaneous2>' + 
'    <PCDFIndex xsi:nil="true" />' + 
'    <Rooms1 xsi:nil="true" />' + 
'    <Rooms2 xsi:nil="true" />' + 
'  </WWHRSInstantaneous2>' + 
'  <WWHRSStorage>' + 
'    <PCDFIndex xsi:nil="true" />' + 
'    <Rooms1 xsi:nil="true" />' + 
'    <Rooms2 xsi:nil="true" />' + 
'  </WWHRSStorage>' + 
'  <FGHRSMhs1present>false</FGHRSMhs1present>' + 
'  <FGHRSMhs2present>false</FGHRSMhs2present>' + 
'  <FGHRSMhs1>' + 
'    <FGHRSIndexNumber>0</FGHRSIndexNumber>' + 
'    <FGHRS_PVEnergy>0</FGHRS_PVEnergy>' + 
'    <FGHRS_PVElevation xsi:nil="true" />' + 
'    <FGHRS_PVOrientation xsi:nil="true" />' + 
'    <FGHRS_PVOvershading xsi:nil="true" />' + 
'  </FGHRSMhs1>' + 
'  <FGHRSMhs2>' + 
'    <FGHRSIndexNumber>0</FGHRSIndexNumber>' + 
'    <FGHRS_PVEnergy>0</FGHRS_PVEnergy>' + 
'    <FGHRS_PVElevation xsi:nil="true" />' + 
'    <FGHRS_PVOrientation xsi:nil="true" />' + 
'    <FGHRS_PVOvershading xsi:nil="true" />' + 
'  </FGHRSMhs2>' + 
'  <PvPanelData>None</PvPanelData>' + 
'  <PvRoofAreaProportion>0</PvRoofAreaProportion>' + 
'  <PhotovoltaicUnitData />' + 
'  <SpecialFeatures />' + 
'  <PvConnectedToDwelling>false</PvConnectedToDwelling>' + 
'  <WTDetailsKnown>false</WTDetailsKnown>' + 
'  <WTNumberOfTurbines>1</WTNumberOfTurbines>' + 
'  <WTRotorDiameter>2</WTRotorDiameter>' + 
'  <WTHubHeight>2</WTHubHeight>' + 
'  <ElectricityMeterType>Single</ElectricityMeterType>' + 
'  <MainsGasAvailable>true</MainsGasAvailable>' + 
'  <WindTurbinePresent>false</WindTurbinePresent>' + 
'  <TerrainType>Suburban</TerrainType>' + 
'  <Recommendation>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
'    <boolean>true</boolean>' + 
            '    <boolean>true</boolean>' +
            '    <boolean>true</boolean>' +
            '    <boolean>true</boolean>' +
            '    <boolean>true</boolean>' +
'  </Recommendation>' + 
'  <Addenda />' + 
'  <AddendumNarrowCavities>false</AddendumNarrowCavities>' + 
'  <AddendumAccessIssues>false</AddendumAccessIssues>' + 
'  <AddendumHighExposure>false</AddendumHighExposure>' + 
'  <OriginalSapVersion>994</OriginalSapVersion>' + 
'  <SapVersion>994</SapVersion>' + 
'  <LodgementRequired xsi:nil="true" />' + 
'  <RdSapGo xsi:nil="true" />' + 
'  <PrintEnergyChartScotland>false</PrintEnergyChartScotland>' + 
'  <PrintEnergyReportScotland>false</PrintEnergyReportScotland>' + 
'  <MandatoryEvidence>false</MandatoryEvidence>' + 
'  <SectionCompletedVisible>false</SectionCompletedVisible>' + 
'  <PlanupCreated>false</PlanupCreated>' + 
'  <PRRN>7517097</PRRN>' + 
'  <EPCExistenceChecked>false</EPCExistenceChecked>' + 
'  <EPCExists xsi:nil="true" />' + 
'  <AddressHasEPC xsi:nil="true" />' + 
'</SurveyRec>';
    
    req.setBody(requestBody);
    
    // Send the HTTP request
    HttpResponse response = http.send(req);
    
    // Process the response
    if (response.getStatusCode() == 200) {
        responseData = response.getBody();
        String res = JSON.serializePretty(responseData);
        //jsonResponse = convertXmlToJson(responseData);
    } else {
        responseData = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
    }
}
}