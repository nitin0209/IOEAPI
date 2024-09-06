/**************************************************************************************************************************************************
Developer Name          :   DINESH SURYAVANSHI
Created Date            :   07-08-2024
Trigger Name            :   SCIS_Survey_trigger
TestClass Name          :   
Connected Class         :   SCIS_survey_trigger_handler
@Description            :   This class contains 
							- changeOwnerToCoordinator = which is used to change the Owner of the survey record id. 
Last Modification Date  :   07-08-2024
Last Modified By        :   DINESH SURYAVANSHI
Modification Description:   NO MODIFICATION YET. (PLEASE WRITE MODIFICATION IN BULLETS WITH MODIFICATION DATE)
							@param listOfUsername = used to store the list of username of coordinator
							@param userNameAndIdMap = used to store userName and id of coordinator
							@param userList = used to store usernames fetched from the query
************************************************************************************************************************************************** */

public without sharing class SCIS_survey_trigger_handler {
    public static void changeOwnerToCoordinator(List<survey__c> surveyList) {
        System.debug('surveyList = ' + surveyList);
        
        try {
            List<String> listOfUsername = new List<String>(); // Used to store the list of usernames of coordinators
            Map<String, Id> userNameAndIdMap = new Map<String, Id>(); // Used to store usernames and IDs of coordinators
            
            for (survey__c survey : surveyList) {
                if (survey.Assigned_Coordinator__c != null) {
                    listOfUsername.add(survey.Assigned_Coordinator__c);
                } else {
                    // Default to current user if Assigned Coordinator is null
                    survey.OwnerId = UserInfo.getUserId();
                    System.debug('OwnerId = ' + survey.OwnerId);
                }
            }
            
            System.debug('listOfUsername = ' + listOfUsername);
            List<User> userList = new List<User>(); // Used to store usernames fetched from the query
            
            if (!listOfUsername.isEmpty()) {
                userList = [SELECT Id, Username FROM User WHERE Username IN :listOfUsername];
                System.debug('userList = ' + userList);
            }
            
            if (!userList.isEmpty()) {
                System.debug('UserList = ' + userList);
                for (User usr : userList) {
                    userNameAndIdMap.put(usr.Username, usr.Id);
                }
            }
       
            for (survey__c survey : surveyList) {
                Id ownerId = userNameAndIdMap.get(survey.Assigned_Coordinator__c);
                System.debug('owner id = ' + ownerId);
                if (ownerId != null) {
                    survey.OwnerId = ownerId;
                }             
            }
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        } 
        
        
        
    }
}






/*
public without sharing class SCIS_survey_trigger_handler {
    public static void changeOwnerToCoordinator(list<survey__C> surveyList){
        system.debug('surveyList = ' + surveyList);
        
        
        try{
            
            list<string> listOfUsername = new list<string>(); // used to store the list of username of coordinator
        map<string,id> userNameAndIdMap = new map<string,id>(); // used to store userName and id of coordinator
        id ownerId='';
        for(survey__c survey : surveyList){
            
            if(survey.Assigned_Coordinator__c != Null ){
                listOfUsername.add(survey.Assigned_Coordinator__c );
            }else{
            OwnerId = userInfo.getUserId();
                system.debug('OwnerId = '+ OwnerId);
        }
    
        }
            system.debug('listOfUsername = '+listOfUsername);
        list<user> userList = new List<user>(); //used to store usernames fetched from the query
        
        if(! listOfUsername.isEmpty() ){
            userList = [select id,username from user where userName IN: listOfUsername];
        	system.debug('userList = ' + userList);
        }
        
        if(! userList.isEmpty()  ){
            system.debug('UserList = ' + userList);
            for(user usr : userList){
            userNameAndIdMap.put(usr.Username , usr.Id);
            }
        }
       
        for(survey__c survey : surveyList){
            ownerId = userNameAndIdMap.get(survey.Assigned_Coordinator__c);
            system.debug('owner id = ' + ownerId);
            if(String.isEmpty(ownerId) || ownerId == null){
                survey.OwnerId = ownerId;
            }             
        }
            
            
            
        }catch(exception e){
            system.debug('DINESH = ' + e.getMessage());
        }
        
        
        
        
        
        
        
        
        
        
    }
}

*/