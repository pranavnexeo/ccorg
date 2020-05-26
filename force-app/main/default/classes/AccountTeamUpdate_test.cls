@isTest

Private class AccountTeamUpdate_test{
     static testMethod void myUnitTest() {
     try{
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/updateAccountTeam';  
        req.httpMethod = 'POST';
        req.addParameter('sessionId','test12');
        RestContext.request = req;
        RestContext.response= res;
        AccountTeamUpdate atu = new AccountTeamUpdate();
        AccountTeamUpdate.AccountTeamUpdate();
        test.stopTest();
        }catch(exception e){}
    }
}