//Author - Matt
global class AccountTeamBatch implements Database.Batchable < SObject > {
    global string q;
    global string callback;
    global Set<Id> SAP_Sellers = new Set<Id>();
    global Set<Id> SAP_Terr = new Set<Id>();
    global Set<Id> SAP_Sales_DOG = new Set<Id>();
    global Set<Id> AccountIds = new Set<Id>();
    
    global AccountTeamBatch(Date LastRun, String callback, boolean doprospect, boolean doall) {
        this.callback = callback;
        
        
        
        for(SAP_Seller__History h:[select id, parentid from SAP_Seller__History where createddate > :lastRun])
          SAP_Sellers.add(h.parentId);
          
        for(SAP_Territory__history h:[select id, parentid from SAP_Territory__history where createddate > :lastrun])
          SAP_Terr.add(h.parentid);
        
        for(SAP_Sales_DOG__history h:[select id, parentid from SAP_Sales_DOG__history where createddate > :lastrun])
          SAP_Sales_DOG.add(h.parentid);
        
        for(SAP_Territory__c t:[select id from SAP_Territory__c where SAP_Sales_DOG__c IN :SAP_Sales_DOG])
          SAP_Terr.add(t.id);
          
        for(AccountHistory h:[select id, accountid from AccountHistory where createddate > :lastrun and field IN ('YY_Partner__c', 'YI_Partner__c', 'YZ_Partner__c', 'ZH_Partner__c', 'ZU_Partner__c', 'ZC_Partner__c')])
          accountids.add(h.accountid);
        
        
        q = 'select id, ';
                    q += 'parentid,'; 
                    q += 'SAP_Corporate_Account_Id__c, ';
                    q += 'Team_Employee_Ids__c,'; 
                    q += 'parent.ZH_Partner__c,'; 
                    q += 'parent.ZH_Partner__r.User__c, ';
                    q += 'YI_Partner__r.ZS_Partner__r.User__c,'; 
                    q += 'YZ_Partner__r.ZS_Partner__r.User__c,'; 
                    q += 'YY_Partner__r.ZS_Partner__r.User__c,';
                    q += 'YI_Partner__r.YS_Partner__r.User__c,'; 
                    q += 'YZ_Partner__r.YS_Partner__r.User__c,'; 
                    q += 'YY_Partner__r.YS_Partner__r.User__c,';  
                    q += 'YI_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,'; 
                    q += 'YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,'; 
                    q += 'YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,'; 
                    q += 'YI_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,'; 
                    q += 'YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,'; 
                    q += 'YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,';   
                    q += 'YI_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,'; 
                    q += 'YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,'; 
                    q += 'YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,';
                    q += 'ZC_Partner__r.User__c, '; 
                    q += 'ZH_Partner__r.User__c,'; 
                    q += 'ZU_Partner__r.User__c, ';
                    q += 'Primary_Seller__c, ';
                    q += 'type ';
                    q += ' from Account where (type = \'Customer\'';
        
        if(doprospect)
          q += ' or type = \'Prospect\'';
        
        q += ')';
        
        if(doall){
          q += ' and (YI_Partner__c != null or YY_Partner__c != null or YZ_Partner__c != null or ZH_Partner__c != null or ZC_Partner__c != null or ZU_Partner__c != null)';
        }else{
          q += ' and (Id IN :AccountIds or YI_Partner__c IN :SAP_Terr or YY_Partner__c IN :SAP_Terr or YZ_Partner__c IN :SAP_Terr or ZH_Partner__c IN :SAP_Sellers or ZC_Partner__c IN :SAP_Sellers or ZU_Partner__c IN :SAP_Sellers)';
        }
        system.debug(q);
    }

    //Start method
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQueryLocator(q);
    }

    //Execute Method
    global void execute(Database.BatchableContext bcMain, List < Account > alist) {

        //Map of Team Member Roles
        
        List<AccountTeamMember> atms = new List<AccountTeamMember>();
        List<Account> AccountsToUpdate = new List<Account>();
        
        Map<Id, User> umap = new map<id, User>([select id, isactive, Ashland_Employee_Number__c from user where isactive = true]);
        Map<Id, Map<Id, AccountTeamMember>> atmmap = new Map<Id, Map<Id, AccountTeamMember>>();
        
        for(Account a:alist){
          atmmap.put(a.id, new Map<Id, AccountTeamMember>());
        }
        
        for(AccountTeamMember m:[select id, User.Ashland_Employee_Number__c, AccountId, UserId from AccountTeamMember where AccountId IN :alist ]){
          atmmap.get(m.AccountId).put(m.UserId, m);
        }
        
        Set<Id> AccountIds = new Set<Id>();
        
        for(Account a:alist){
          
          map<Id, AccountTeamMember> amap = atmmap.get(a.id);
          AccountIds.add(a.id);

          if(a.type == 'Prospect'){
          addRole(umap, amap, 'Seller (Comm/Gen)', a.Id, a.primary_Seller__c);   
          }
          else if(a.type == 'Customer'){
          //Add National Seller
          
          addRole(umap, amap, 'Vice President', a.Id, a.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c);
          addRole(umap, amap, 'SD (Spec)', a.Id, a.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c);
          addRole(umap, amap, 'DM (Spec)', a.Id, a.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c);
          addRole(umap, amap, 'Vice President', a.Id, a.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c);
          addRole(umap, amap, 'SD (Comm/Gen)', a.Id, a.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c);
          addRole(umap, amap, 'DM (Comm/Gen)', a.Id, a.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c);
          addRole(umap, amap, 'Vice President', a.Id, a.YI_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c);
          addRole(umap, amap, 'SD (Info)', a.Id, a.YI_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c);
          addRole(umap, amap, 'DM (Info)', a.Id, a.YI_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c);
          addRole(umap, amap, 'National Seller', a.Id, a.parent.ZH_Partner__r.User__c);
          addRole(umap, amap, 'National Seller', a.Id, a.ZH_Partner__r.User__c);
          addRole(umap, amap, 'Seller (Spec)', a.Id, a.YZ_Partner__r.ZS_Partner__r.User__c);
          addRole(umap, amap, 'Seller (Comm/Gen)', a.Id, a.YY_Partner__r.ZS_Partner__r.User__c);
          addRole(umap, amap, 'Seller (Info)', a.Id, a.YI_Partner__r.ZS_Partner__r.User__c);
          addRole(umap, amap, 'Sales Support(Spec)', a.Id, a.YZ_Partner__r.YS_Partner__r.User__c);
          addRole(umap, amap, 'Sales Support (Comm/Gen)', a.Id, a.YY_Partner__r.YS_Partner__r.User__c);
          addRole(umap, amap, 'Sales Support (Info)', a.Id, a.YI_Partner__r.YS_Partner__r.User__c);
          addRole(umap, amap, 'Customer Service Rep', a.Id, a.ZC_Partner__r.User__c);
          addRole(umap, amap, 'Customer Service Rep', a.Id, a.ZU_Partner__r.User__c);
         }
         
         List<String> EmployeeIds = new List<String>();
         for(Id id:amap.keyset()){
           EmployeeIds.add(umap.get(id).Ashland_Employee_Number__c);
         }

         if(a.Team_Employee_Ids__c != String.join(EmployeeIds, ',') || (a.SAP_Corporate_Account_Id__c != '' && a.parentid == null)){
           
           if(a.Team_Employee_Ids__c != String.join(EmployeeIds, ',')){
             a.Team_Employee_Ids__c = String.join(EmployeeIds, ',');
             if(a.Team_Employee_Ids__c.length() > 250){ a.team_Employee_ids__c = a.Team_Employee_Ids__c.abbreviate(250); }
             a.Account_Team_Updated__c = true;
           }
           if(a.SAP_Corporate_Account_Id__c != '' && a.parentid == null){
             a.parentid = a.SAP_Corporate_Account_Id__c;
           }
           AccountsToUpdate.add(a);
         }
         
         if(amap.values().size() > 0){ atms.addall(amap.values()); }
       }//End For Loop
       
       if(AccountsToUpdate.size() > 0)
         update AccountsToUpdate;
   
       if(atms.size() > 0)
         upsert atms; 
         
         List < AccountShare > shares = [select id from AccountShare where accountid IN: accountids and RowCause = 'Team' and (accountaccesslevel != 'Edit' or OpportunityAccessLevel != 'Edit')];

        for (AccountShare a: shares) {
            a.AccountAccessLevel = 'Edit';
            a.OpportunityAccessLevel = 'Edit';
        }

        if (shares.size() > 0)
            update shares;
    } 
    
    
    private static void addRole(Map<Id, User> umap, Map<Id, AccountTeamMember> amap, string role, Id AccountId, Id UserId){
     if(UserId != null){
      if(umap.containskey(UserId)){
         if(amap.containskey(UserId)){
             amap.get(UserId).TeamMemberRole=role;
         }
         else{
             amap.put(UserId,
               new AccountTeamMember(
                  AccountId=AccountId,
                  UserId=UserId,
                  TeamMemberRole=role
               )
            );
         }
           
     }
    }
   }

    
        //Finish Method
    global void finish(Database.BatchableContext bcMain) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = : bcMain.getJobId()];
        String str = callback;
        str += 'AccountTeamBatch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.';
        database.executebatch(new AccountTeamShareBusinessContract(str));
    }
}