trigger PropertyTrigger on Property__c (after insert, after update) {
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate) ){
        List<string> uprnList = new list<string>();
        List<lead> leadsToUpdate = new List<lead>();
        //system.debug('Entered into Trigger Property');
        
        for(Property__c prop : trigger.new){
            
                uprnList.add(prop.UPRN__c);
                //system.debug('This is list of UPRN');
            
            
        }
        //system.debug('Executed getDtata'+uprnList );
        List<lead> leadList = new List<lead>();
        leadList = [select id,name,uprn__c,EPC_Data__c,is_EPC_Available__c
                    from lead
                    where uprn__c IN: uprnList ];
        //system.debug('Fetched LeadsList : '+leadList);
        
            for(property__C prop : trigger.new){
                for(lead ld : leadList){
                system.debug('This is EPC Data = '+ prop.EPC_Data__c);
                if(! ld.is_EPC_Available__c){
                    system.debug('Property EPC = ' +prop.EPC_Data__c );
                    ld.EPC_Data__c = prop.EPC_Data__c;
                    ld.is_EPC_Available__c = true;
                    leadsToUpdate.add(ld);
                }
            }
            }
        
        
        
        if(! leadsToUpdate.isEmpty()){
            update leadsToUpdate;
        }else{
            system.debug('leadsToUpdate List is Empty !!!');
        }
    }
}