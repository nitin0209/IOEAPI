/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   04-12-2023
Trigger Name            :   SCIS_LeadTrigger
TestClass Name          :   SCIS_LeadTriggerTest
Connected Class         :   SCIS_ChimnieIntegration
Description             :   This trigger is used to check if lead is coming from App or not. If lead is coming from applicatioin 
                            then it should fire trigger otherwise it should not fire trigger because triggering will consume credits
                            for fetching property details which are limited.
Last Modification Date  :   05-01-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
                            #1 05-01-2024 : To avoid deletion of Lead Record.
************************************************************************************************************************************************** */

trigger SCIS_LeadTrigger on Lead (after insert,before insert, before update,before delete) {
    
    if(trigger.isAfter && Trigger.isInsert  ){
        system.debug('After Inserted Executed');
        
                List<Lead> leadsToUpdate2 = new List<Lead>();
                for (Lead newLead : Trigger.new) {
                // Collect only the leads that were inserted in this trigger
                if (newLead.Id != null && newLead.IsConverted == false) {
                    // Create a Lead object to leverage Database.DMLOptions
                    Lead leadWithDmlOptions = new Lead(Id = newLead.Id);
                    
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule = true; // Use default Lead Assignment Rules
        
                    // Set the DMLOptions for the lead
                    leadWithDmlOptions.setOptions(dmo);
                    leadsToUpdate2.add(leadWithDmlOptions);
                }
            }
                // Update leads with assignment rules applied
                if (!leadsToUpdate2.isEmpty()) {
                    update leadsToUpdate2;
                }

    
        
        try{
            string apiKey=system.label.chimnie_Api_Key;
            string address;
            string fields;
            string leadId;
            set<id> idSet = new set<id>();
            
            for(lead ld : trigger.new){
                if(ld.id != null){
                    
                    // This if block is for checking if the lead is creatd from the application.
                    // If lead is generated from Application then only API call should be executed because it consumes credits.
                    
                    idSet.add(ld.Id);
                        system.debug('THis is IDSET '+idSet);

                }
                
            
        }
            list<lead> leadsToUpdate = new list<lead>();
            lead ld = new lead();
            ld = [select id, Name, Website, Street, City, Postalcode,lead_receive_from_app__c  from lead WHERE id IN: idSet limit 1];
            system.debug(ld);
            
            
                
                    address = ld.street + ', '+ld.City +', '+ ld.PostalCode;
                    system.debug(address);
                    fields = 'premium,plus,property';
                    system.debug(fields);
                    leadId = ld.Id;
                    system.debug(leadId);
                    system.debug('Entered into Before Execute Class');
                    
            
                    
                String encodedAddress = address.replaceAll(' ', '%20');
            system.debug('this is encodeAddress value : '+ encodedAddress);
                
            
            //update leadsToUpdate;
            if(ld.lead_receive_from_app__c){
                SCIS_ChimnieIntegration.getResidentialAddressDetails(address, fields, leadId);
                //SCIS_EPC_Data.getEpcData(encodedAddress,leadId);
                SCIS_StreetViewImage.showStreetViewImage(trigger.new);
                
            }else{
                system.debug('Not generated from APp');
                SCIS_ChimnieIntegration.getResidentialAddressDetails(address, fields, leadId);
                //SCIS_EPC_Data.getEpcData(encodedAddress,leadId);
                SCIS_StreetViewImage.showStreetViewImage(trigger.new);
                System.debug('SCIS_StreetViewImage.showStreetViewImage class executed');
            }
          
            
        }catch (Exception e) {
            // Catch block to handle the exception
            System.debug('An exception occurred in Trigger : SCIS_LeadTrigger ' + e.getMessage());
            // Handle the exception gracefully, log it, or perform necessary actions
        }
        
        
        
                
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        system.debug('Before Insert Trigger Executed');
        SCIS_StreetViewImage.showStreetViewImageBeforeUpdate(trigger.new);
    }
    
// #1 05-01-2024 : START
    
    if(trigger.IsBefore && trigger.isDelete){
        
        id ProfileId = userInfo.getProfileId();
        profile userProfile = [select id,name from profile where name = 'System Administrator' limit 1];
        if(ProfileId == userProfile.Id ){
            if( system.label.SCIS_Allow_Lead_Delete != 'YES' ||
                system.label.SCIS_Allow_Lead_Delete != 'yes' || 
                system.label.SCIS_Allow_Lead_Delete != 'Yes'){
                
                
                for(lead ld : trigger.old){
                    ld.addError('YOU CANNOT DELETE LEAD. TO DELETE LEAD, FIRST ALLOW DELETE FROM SETTING  !!');
                }
  
            }
        }else{
            for(lead ld : trigger.old){
                ld.addError('ONLY ADMIN CAN DELETE LEAD ! YOU ARE NOT ADMIN !');
            }
        }
        
        
        
    }
    
// #1 05-01-2024 : END 

    
}