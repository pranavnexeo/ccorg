@RestResource(urlMapping='/updateAccountTeam/*')
global with sharing class AccountTeamUpdate{
    
    @HTTPPost
    global static void AccountTeamUpdate() {

        RestRequest req = RestContext.request;   
        Blob body = req.requestBody;
        String bodyString = body.toString();  
        Set<Id> Ids = (Set<Id>)JSON.deserialize(bodyString,Set<Id>.class);
        String sessionid = RestContext.request.params.get('sessionId');
        Account_Team_Triggers.AccountTeamMembersSync(ids, sessionid); 
        Account_Team_Triggers.Account(ids);

    }
    
    
}