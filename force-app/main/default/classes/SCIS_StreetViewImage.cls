/*
**************************************************************************************************************************************************
Developer Name 			: 	DINESH SURYAVANSHI
Created Date 			:	07-12-2023
Class Name 				: 	SCIS_StreetViewImage
TestClass Name 			: 	SCIS_StreetViewImageTest
@Description 			: 	This class is used to fetch Property Images from Google Street View Images from Google API.
							And show this images on the lead form.
							* @param leadList The list of Lead records for which Street View and Aerial View images need to be displayed.
Last Modification Date 	: 	26-12-2023
Last Modified By 		:	DINESH SURYAVANSHI
Modification Description:	NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							#1 26-12-2023 : 
								Added method "showStreetViewImageBeforeUpdate" for changing the images as soon as the property
								address changes or updated. This will update the Google Street View Image and Google Aerial View Image.
************************************************************************************************************************************************** */

/**
 * SCIS_StreetViewImage class provides methods to display Google Street View and Aerial View images 
 * on Lead records.
 */

public class SCIS_StreetViewImage {

    @InvocableMethod(label='GoogleImageOnLead' description='This class displays google image in lead form')
    public static void showStreetViewImage(List<Lead> leadList) {
        System.debug('Received List= ' + leadList);
        Set<Id> idSet = new Set<Id>();
        List<Lead> leadQuery = new List<Lead>();
        String streetViewURL = System.label.SCIS_StreetViewURL;
        String aerialViewURL = System.label.SCIS_GoogleMap_Aerial_View_URL;
        String apiKey = System.label.SCIS_StreetView_API_Key;
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead ld : leadList) {
            idSet.add(ld.Id);
        }

        if (Schema.sObjectType.Lead.isAccessible()) {
            leadQuery = [SELECT ID, Street, City, Country, PostalCode, Street_ViewI_mage__c, Location__Latitude__s, Location__Longitude__s, Aerial_View_Image__c
                         FROM Lead 
                         WHERE Id IN :idSet];
        }

        System.debug('This is query List of Leads = ' + leadQuery);

        for (Lead ld1 : leadQuery) {
            String address = ld1.Street + ',' + ld1.City + ',' + ld1.PostalCode + ',' + ld1.Country;
            String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');

            String finalURL = '<img src="' + streetViewURL 
                + encodedAddress 
                + '&key=' + apiKey 
                + '&maptype=satellite&markers=color:blue%7clabel:S%7c' 
                + encodedAddress 
                + '" alt="Street View Image">';

            String finalAerialViewURL = '<img src="' + aerialViewURL 
                + encodedAddress
                + '&zoom=' + System.label.SCIS_AerialViewMap_ZoomLevel
                + '&maptype=satellite&size=600x300' 
                + '&markers=color:red%7clabel:s%7c' 
                + encodedAddress 
                + '&key=' + apiKey 
                + '" alt="Aerial View Image">';

            ld1.Street_ViewI_mage__c = finalURL;
            ld1.Aerial_View_Image__c = finalAerialViewURL;
            leadsToUpdate.add(ld1);

            System.debug(finalURL);
            System.debug(finalAerialViewURL);
        }

        update leadsToUpdate;
    }

    public static void showStreetViewImageBeforeUpdate(List<Lead> leadList) {
        String streetViewURL = System.label.SCIS_StreetViewURL;
        String aerialViewURL = System.label.SCIS_GoogleMap_Aerial_View_URL;
        String apiKey = System.label.SCIS_StreetView_API_Key;

        for (Lead ld1 : leadList) {
            String address = ld1.Street + ',' + ld1.City + ',' + ld1.Country;
            String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');

            String finalURL = '<img src="' + streetViewURL 
                + encodedAddress 
                + '&key=' + apiKey 
                + '&maptype=satellite&markers=color:blue%7clabel:S%7c' 
                + encodedAddress 
                + '" alt="Street View Image">';

            String finalAerialViewURL = '<img src="' + aerialViewURL 
                + encodedAddress
                + '&zoom=' + System.label.SCIS_AerialViewMap_ZoomLevel
                + '&maptype=satellite&size=600x300' 
                + '&markers=color:red%7clabel:s%7c' 
                + encodedAddress 
                + '&key=' + apiKey 
                + '" alt="Aerial View Image">';

            ld1.Street_ViewI_mage__c = finalURL;
            ld1.Aerial_View_Image__c = finalAerialViewURL;

            System.debug(finalURL);
            System.debug(finalAerialViewURL);
        }
    }
}