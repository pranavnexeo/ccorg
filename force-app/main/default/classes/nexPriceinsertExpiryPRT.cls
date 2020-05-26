@RestResource(urlMapping='/insertExpiryPRT/*')
global with sharing class nexPriceinsertExpiryPRT {
    
    @HTTPPost
    global static  List<Id> insertExpiryPRT() {
        List<Id> prtids = new List<Id>();
        RestRequest req = RestContext.request;
        system.debug('req:'+req);
        Blob body = req.requestBody;
        String bodyString = body.toString();
        system.debug('bodyString:'+bodyString);
        List<Price_Request_Transaction__c> transactions= (List<Price_Request_Transaction__c>)JSON.deserialize(bodyString,List<Price_Request_Transaction__c>.class);
        system.debug('transactions:'+transactions);
        Database.SaveResult[] PRTSaveResult = Database.Insert(transactions, false);
        system.debug('PRTSaveResult:'+PRTSaveResult);
        system.debug('PRTSaveResult.size():'+PRTSaveResult.size());
        for (Integer i = 0; i < PRTSaveResult.size(); i++) {
            if (PRTSaveResult[i].isSuccess()) {
            
                  prtids.add(PRTSaveResult[i].getId());
            }
         }
         if(prtids.size()>0){
             system.debug('prtids.size():'+prtids.size());
             system.debug('prtids:'+prtids);}
        return prtids;
        
    }
    
    
}