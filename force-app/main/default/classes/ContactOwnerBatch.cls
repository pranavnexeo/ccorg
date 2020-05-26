global class ContactOwnerBatch implements Database.Batchable<SObject> {

    global string callback{get; set;}
    global ContactOwnerBatch(string callback){
      this.callback = callback;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
             return Database.getQueryLocator('Select id, OwnerId, AccountId, Account.OwnerId, Account.ZH_Partner__r.User__c, Account.ZH_Partner__c, Account.Owner_name__c, Account.SAP_Customer_Group_2_Desc__c, Account.YY_Partner__r.ZS_Partner__r.User__c, Account.YZ_Partner__r.ZS_Partner__r.User__c from Contact where contact_update__c = true');                  
    }
    
    global void execute(Database.BatchableContext bcMain, List<Contact> Cons) {
        for(Contact c:cons){      
          if(c.account.SAP_Customer_Group_2_Desc__c == 'Primary Commodity' && c.account.YY_Partner__r.ZS_Partner__r.User__c != null){
            c.ownerid = c.account.YY_Partner__r.ZS_Partner__r.User__c;
          }
          
         else if(c.account.SAP_Customer_Group_2_Desc__c == 'Primary Specialty' && c.account.YZ_Partner__r.ZS_Partner__r.User__c != null){
          c.ownerid = c.account.YZ_Partner__r.ZS_Partner__r.User__c;
         }
         
          else if(c.account.SAP_Customer_Group_2_Desc__c == null && c.account.YY_Partner__r.ZS_Partner__r.User__c != null){
            c.ownerid = c.account.YY_Partner__r.ZS_Partner__r.User__c;
          }
          
          else{
            if(c.account.ZH_Partner__r.User__c != null){ c.ownerid = c.account.ZH_Partner__r.User__c; }
            else{ c.ownerid = c.account.OwnerId; }
          }
         
       }
       
       for(Database.saveresult sr : Database.Update(cons, false)){
        if(!sr.isSuccess()){
          for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Fields that affected this error: ' + err.getFields());
         }
        }
       } 
     }

    
    global void finish(Database.BatchableContext bcMain) {
    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
    string str = '';
    if(callback != '')
      str += '\n' + callback;
     
    OpportunityOwnerBatch o = new OpportunityOwnerBatch(str);
    database.executebatch(o);
      
    
    }
}