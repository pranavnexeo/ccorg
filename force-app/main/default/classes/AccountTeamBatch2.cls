global class AccountTeamBatch2 implements Database.Batchable < SObject >,  Database.AllowsCallouts{
    global string q;
    global string callback;
    global Set<Id> SAP_Sellers = new Set<Id>();
    global Set<Id> SAP_Terr = new Set<Id>();
    global Set<Id> SAP_Sales_DOG = new Set<Id>();
    global Set<Id> AccountIds = new Set<Id>();
    global string sessionid;
    global boolean getterrs;
    
    global AccountTeamBatch2(string sessionid){
      this.getterrs = true;
      this.callback = '';
      this.sessionid = sessionid;
       q = 'select id from Account where (type = \'Customer\' and (YI_Partner__c IN :SAP_Terr or YY_Partner__c IN :SAP_Terr or YZ_Partner__c IN :SAP_Terr))';     
    }
    
    global AccountTeamBatch2(String Sessionid, Date LastRun, String callback, boolean doprospect, boolean doall) {
        this.getterrs = false;
        this.callback = callback;
        this.sessionid = sessionid;
        
        
        for(SAP_Seller__History h:[select id, parentid from SAP_Seller__History where createddate > :lastRun])
          SAP_Sellers.add(h.parentId);
          system.debug('SAP_Sellers....'+ SAP_Sellers );
          
        for(SAP_Territory__history h:[select id, parentid from SAP_Territory__history where createddate > :lastrun])
          SAP_Terr.add(h.parentid);
        
        for(SAP_Sales_DOG__history h:[select id, parentid from SAP_Sales_DOG__history where createddate > :lastrun])
          SAP_Sales_DOG.add(h.parentid);
        
        for(SAP_Territory__c t:[select id from SAP_Territory__c where SAP_Sales_DOG__c IN :SAP_Sales_DOG])
          SAP_Terr.add(t.id);
          
        for(AccountHistory h:[select id, accountid from AccountHistory where createddate > :lastrun and field IN ('YY_Partner__c', 'YI_Partner__c', 'YZ_Partner__c', 'ZH_Partner__c', 'ZU_Partner__c', 'ZC_Partner__c')])
          accountids.add(h.accountid);
        
        
        q = 'select id from Account where (type = \'Customer\'';
        
        if(doprospect)
          q += ' or type = \'Prospect\'';
        
        q += ')';
        
        if(doall){
          q += ' and (YI_Partner__c != null or YY_Partner__c != null or YZ_Partner__c != null or ZH_Partner__c != null or ZC_Partner__c != null or ZU_Partner__c != null)';
        }else{
          q += ' and (Id IN :AccountIds or YI_Partner__c IN :SAP_Terr or YY_Partner__c IN :SAP_Terr or YZ_Partner__c IN :SAP_Terr or ZH_Partner__c IN :SAP_Sellers or ZC_Partner__c IN :SAP_Sellers or ZU_Partner__c IN :SAP_Sellers)';
        }
        system.debug('aaaaaaaaaaaa'+q);
    }

    //Start method
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        if(getterrs == true){
           List<SAP_territory__c> terrs = [select id from SAP_Territory__c where Update_Accounts__c = true];
           for(SAP_Territory__c t:terrs){
              t.update_Accounts__c = false;
              t.batch_updated__c = true;
              SAP_Terr.add(t.id);
           }
           if(terrs.size() > 0)
             database.update(terrs, false);
        }
           return Database.getQueryLocator(q);
    }

    //Execute Method
    global void execute(Database.BatchableContext bcMain, List < Account > alist) {
        Set<Id> ids = new Set<Id>();
        for(Account a:alist){
          ids.add(a.id);
        }
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        http h1 = new http();
        httprequest req1 = new httprequest();       
        req1.setHeader('Content-Type', 'application/json'); 
        req1.setHeader('Authorization', 'OAuth ' + sessionid);  
        req1.settimeout(60000); 
        req1.setMethod('POST');
        req1.setBody(JSON.Serialize(ids));    
        req1.setEndpoint(settings.Base_URL__c + '/services/apexrest/updateAccountTeam');
        String s1 = '';
        if(Test.isRunningTest() == false){
          httpresponse res1 = h1.send(req1);
          s1 = res1.getbody();
        }

    }

        //Finish Method
    global void finish(Database.BatchableContext bcMain) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = : bcMain.getJobId()];
        String str = callback;
        str += 'AccountTeamBatch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.';
        //database.executebatch(new AccountTeamShareBusinessContract(str));
        //database.executebatch(new AccountTeamUpdatedClear());
    }
}