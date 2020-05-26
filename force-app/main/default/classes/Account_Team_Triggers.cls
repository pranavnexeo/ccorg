public class Account_Team_Triggers{

@InvocableMethod
public static void AccountTeamMembersSyncFromFlow(List<Id> ids){
  set<Id> idset = new set<Id>();
  idset.addall(ids);
  AccountTeamMembersSync(idset, '');
}

@Future
public static void AccountTeamMembersSync(set<Id> ids, string sessionid){
  deleteAccountTeamMembers(ids);
  map<Id, Account> oldmap = new map<Id, Account>([select id, Team_Employee_Ids__c from Account where id IN :ids]);
  createAccountTeamMembers(oldmap.values(), oldmap);
  List<AccountTeamMember> team = [Select Id, AccountAccessLevel, AccountId, TeamMemberRole, UserId, IsDeleted from AccountTeamMember where AccountId in : Ids];
  Account_Team_Functions.createSharingRecordsBusinessContract(team,false);
  Account_Team_Functions.createSharingRecordsSampleAnalysisReq(team,false);
  Account_Team_Functions.createSharingRecordsRDRequest(team,false);
  Account_Team_Functions.createSharingRecordsSalesChurn(team,false);
  sharing_functions.share_with_Account_Team(ids);
  updateContactOwner(ids);
  Opportunity_Territory_Functions.assignOwner(ids);

}

public static void updateContactOwner(set<Id> ids){
   List<Contact> cons = [select id, 
                              account.SAP_Customer_Group_2__c, 
                              Account.YY_Partner__r.ZS_Partner__r.User__c,
                              account.YZ_Partner__r.ZS_Partner__r.User__c,
                              account.ZH_Partner__r.User__c,
                              account.YI_Partner__r.ZS_Partner__r.User__c,
                              account.ownerid from Contact where accountid IN :ids];
        for(Contact c:cons){      
          if(c.account.SAP_Customer_Group_2__c == 'COM' && c.account.YY_Partner__r.ZS_Partner__r.User__c != null){
            c.ownerid = c.account.YY_Partner__r.ZS_Partner__r.User__c;
          }
          
         else if(c.account.SAP_Customer_Group_2__c == 'SPC' && c.account.YZ_Partner__r.ZS_Partner__r.User__c != null){
          c.ownerid = c.account.YZ_Partner__r.ZS_Partner__r.User__c;
         }
         
          else if(c.account.SAP_Customer_Group_2__c == null && c.account.YY_Partner__r.ZS_Partner__r.User__c != null){
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

public static void createAccountTeamMembers(List<Account> alist, Map<Id, Account> oldmap){
  List<AccountTeamMember> toinsert = new List<AccountTeamMember>();
  Map<Id, List<string>> amap = new map<Id, List<String>>();
  
  
  for(Account a:alist){
    amap.put(a.id, new List<String>());
  }
  
  for(Account a:[select id,
                       YY_Partner__r.ZS_Partner__r.User__c,
                       YY_Partner__r.ZS_Partner__r.User__r.isActive,
                       YY_Partner__r.YS_Partner__r.User__c,
                       YY_Partner__r.YS_Partner__r.User__r.isActive,
                       YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,
                       YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__r.isActive,
                       YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,
                       YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__r.isActive,
                       YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,
                       YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__r.isActive,
                       YZ_Partner__r.ZS_Partner__r.User__c,
                       YZ_Partner__r.ZS_Partner__r.User__r.isActive,
                       YZ_Partner__r.YS_Partner__r.User__c,
                       YZ_Partner__r.YS_Partner__r.User__r.isActive,
                       YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,
                       YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__r.isActive,
                       YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c, 
                       YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__r.isActive,
                       YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c, 
                       YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__r.isActive,
                       ZH_Partner__r.User__c,
                       ZH_Partner__r.User__r.isActive,
                       ZC_Partner__r.User__c,
                       ZC_Partner__r.User__r.isActive,
                       ZU_Partner__r.User__c,
                       ZU_Partner__r.User__r.isActive,
                       YI_Partner__r.ZS_Partner__r.User__c,
                       YI_Partner__r.ZS_Partner__r.User__r.isActive
                          from Account where Id IN :amap.keyset()]){

      if(a.YY_Partner__r.ZS_Partner__r.User__c != null && a.YY_Partner__r.ZS_Partner__r.User__r.isActive == true) { toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YY_Partner__r.ZS_Partner__r.User__c, TeamMemberRole='Seller (Comm/Gen)'));} 
      if(a.YY_Partner__r.YS_Partner__r.User__c != null && a.YY_Partner__r.YS_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YY_Partner__r.YS_Partner__r.User__c, TeamMemberRole='Sales Support (Comm/Gen)'));}
      if(a.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null && a.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c, TeamMemberRole='DM (Comm/Gen)'));} 
      if(a.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null && a.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__r.isActive== true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c, TeamMemberRole='Sales Director (Comm/Gen)'));} 
      if(a.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != null && a.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__r.isActive== true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c, TeamMemberRole='VP of Sales (Comm/Gen)'));}
      if(a.YZ_Partner__r.ZS_Partner__r.User__c != null && a.YZ_Partner__r.ZS_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YZ_Partner__r.ZS_Partner__r.User__c, TeamMemberRole='Seller (Spec)'));}
      if(a.YZ_Partner__r.YS_Partner__r.User__c != null && a.YZ_Partner__r.YS_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YZ_Partner__r.YS_Partner__r.User__c, TeamMemberRole='Sales Support (Spec)'));}
      if(a.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null && a.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c, TeamMemberRole='DM (Spec)'));} 
      if(a.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null && a.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c, TeamMemberRole='Sales Director (Spec)'));} 
      if(a.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != null && a.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__r.isActive == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c, TeamMemberRole='VP of Sales (Spec)'));} 
      if(a.ZH_Partner__r.User__c != null && a.ZH_Partner__r.User__r.isActive  == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.ZH_Partner__r.User__c, TeamMemberRole='National Seller'));}
      if(a.ZC_Partner__r.User__c != null && a.ZC_Partner__r.User__r.isActive  == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.ZC_Partner__r.User__c, TeamMemberRole='Customer Service Rep'));}
      if(a.ZU_Partner__r.User__c != null && a.ZU_Partner__r.User__r.isActive  == true){ toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.ZU_Partner__r.User__c, TeamMemberRole='DZ Analyst'));}  
      if(a.YI_Partner__r.ZS_Partner__r.User__c != null && a.YI_Partner__r.ZS_Partner__r.User__r.isActive == true) { toinsert.add(new AccountTeamMember(AccountId=a.id, UserId=a.YI_Partner__r.ZS_Partner__r.User__c, TeamMemberRole='Informational Seller'));}                     
  }
  
  if(toinsert.size() > 0)
    insert toinsert;
    
  for(AccountTeamMember m:[select id, User.Ashland_Employee_Number__c, accountid from AccountTeamMember where AccountId IN :amap.keyset()]){
    amap.get(m.accountid).add( m.User.Ashland_Employee_Number__c);
  }
  
  List < AccountShare > shares = [select id from AccountShare where accountid IN :amap.keyset() and RowCause = 'Team' and (accountaccesslevel != 'Edit' or OpportunityAccessLevel != 'Edit')];

  for (AccountShare a: shares) {
            a.AccountAccessLevel = 'Edit';
            a.OpportunityAccessLevel = 'Edit';
  }

  if (shares.size() > 0)
     update shares;
  
    
  for(Account a:alist){
    if(oldmap.get(a.id).Team_Employee_Ids__c != String.join(amap.get(a.id), ',')){
      a.Team_Employee_Ids__c = String.join(amap.get(a.id), ',');
      a.Account_Team_Updated__c = false;
      a.Account_Team_Last_Synced__c = system.now();
    }
  }
  update alist;

  
}
public static void deleteAccountTeamMembers(set<Id> ids){
  List<AccountTeamMember> todelete = new List<AccountTeamMember>();
  List<AccountTeamMember> members = [select id,
                                     Account.YY_Partner__r.ZS_Partner__r.User__c,
                                     Account.YY_Partner__r.YS_Partner__r.User__c,
                                     Account.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c, 
                                     Account.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c, 
                                     Account.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,
                                     Account.YZ_Partner__r.ZS_Partner__r.User__c,
                                     Account.YZ_Partner__r.YS_Partner__r.User__c,
                                     Account.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c, 
                                     Account.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c, 
                                     Account.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c, 
                                     Account.ZH_Partner__r.User__c,
                                     Account.ZC_Partner__r.User__c,
                                     Account.ZU_Partner__r.User__c,
                                     Account.YI_Partner__r.ZS_Partner__r.User__c,
                                     UserId,
                                     TeamMemberRole
                                      from AccountTeamMember where AccountId IN :ids];
  
  for(AccountTeamMember m:members){
    if(
      (m.TeamMemberRole == 'Seller (Comm/Gen)' && m.Account.YY_Partner__r.ZS_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Sales Support (Comm/Gen)' && m.Account.YY_Partner__r.YS_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'DM (Comm/Gen)' && m.Account.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Sales Director (Comm/Gen)' && m.Account.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'VP of Sales (Comm/Gen)' && m.Account.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Seller (Spec)' && m.Account.YZ_Partner__r.ZS_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Sales Support (Spec)' && m.Account.YZ_Partner__r.YS_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'DM (Spec)' && m.Account.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Sales Director (Spec)' && m.Account.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'VP of Sales (Spec)' && m.Account.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'National Seller' && m.Account.ZH_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Customer Service Rep' && m.Account.ZC_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'Informational Seller' && m.Account.YI_Partner__r.ZS_Partner__r.User__c != m.userid) ||
      (m.TeamMemberRole == 'DZ Analyst' && m.Account.ZU_Partner__r.User__c != m.userid)
      ){
          todelete.add(new AccountTeamMember(id = m.id)); 
          system.debug('todelete'+m);
      }
  }
      
   if(todelete.size() > 0)
     delete todelete;
  
 
  
}

@Future
public static void Account(Set<Id> ids){
  
  Map<Id, Map<String, ObjectTerritory2Association>> ot2amap = new map<Id, Map<String, ObjectTerritory2Association>>();
  
  List<ObjectTerritory2Association> toinsert = new list<ObjectTerritory2Association>();
  List<ObjectTerritory2Association> todelete = new list<ObjectTerritory2Association>();
  
  for(ObjectTerritory2Association ot2a:[select id, territory2id, territory2.developername, objectid from ObjectTerritory2Association where objectid in :ids]){
    if(ot2amap.containskey(ot2a.objectid)){
      ot2amap.get(ot2a.objectid).put(ot2a.territory2.developername, ot2a);
    }else{
      ot2amap.put(ot2a.objectid, new Map<String, ObjectTerritory2Association>{ot2a.territory2.developername => ot2a});
    }
  }
  
  Map<string, id> tmap = new map<String, Id>();
  for(SAP_Territory__c t:[select id, record_key__c from SAP_Territory__c])
    tmap.put('T'+t.record_key__c, null);
    
  for(Territory2 t:[select id, developername from Territory2 where developername IN :tmap.keyset()])
    tmap.put(t.developername, t.id);
  
  List<Account> acclst = [select id, YY_Partner__r.record_key__c, YZ_Partner__r.Record_Key__c,YI_Partner__r.record_key__c, ccrz__UsedByCloudcraze__c,Type,SAP_Sales_Org__c,SAP_DistChannel__c,SAP_DivisionCode__c,Account_Number__c,ccrz__E_AccountGroup__c from Account where id IN :ids];
  
  for(Account a:acclst){
    
    map<String, ObjectTerritory2Association> omap = new map<String, ObjectTerritory2Association>();
    if(ot2amap.containskey(a.id))
      omap = ot2amap.get(a.id);
    
    if(a.YY_Partner__r.Record_Key__c != null){
       if(!omap.containskey('T' + a.YY_Partner__r.Record_Key__c))
         toinsert.add(new ObjectTerritory2Association(ObjectId = a.id, Territory2Id = tmap.get('T' + a.YY_Partner__r.Record_Key__c), AssociationCause='Territory2Manual'));
    }
    
    if(a.YI_Partner__r.Record_Key__c != null){
       if(!omap.containskey('T' + a.YI_Partner__r.Record_Key__c))
         toinsert.add(new ObjectTerritory2Association(ObjectId = a.id, Territory2Id = tmap.get('T' + a.YI_Partner__r.Record_Key__c), AssociationCause='Territory2Manual'));
    }
    
    if(a.YZ_Partner__r.Record_Key__c != null){
       if(!omap.containskey('T' + a.YZ_Partner__r.Record_Key__c))
         toinsert.add(new ObjectTerritory2Association(ObjectId = a.id, Territory2Id = tmap.get('T' + a.YZ_Partner__r.Record_Key__c), AssociationCause='Territory2Manual'));  
    }
    
    for(string s:omap.keyset()){
       if(s != 'T' + a.YY_Partner__r.Record_Key__c && s != 'T' + a.YZ_Partner__r.Record_Key__c && s != 'T' + a.YI_Partner__r.Record_Key__c){
         todelete.add(omap.get(s));  
       }
       
    }
  }
  
  if(todelete.size() > 0)
    delete todelete;
    
  if(toinsert.size() > 0)
    database.insert(toinsert, false);
    
   
}

@Future
public static void SAP_Sales_DOG(Set<Id> ids){
  Territory2Model m = [select id from Territory2Model where state = 'Active' limit 1];
  Territory2Type ZDOG = [select id from Territory2Type where MasterLabel = 'ZDOG' limit 1];
  Territory2Type ZTER = [select id from Territory2Type where MasterLabel = 'ZTER' limit 1];
  
  List<SAP_Sales_DOG__c> dogs = [select id, name, Record_Key__c, YV_Partner__r.User__c, YO_Partner__r.User__c, YD_Partner__r.User__c from SAP_Sales_DOG__c where id IN :ids];
  Map<String, SAP_Sales_DOG__c> dmap = new Map<String, SAP_Sales_DOG__c>();
  Map<String, Territory2> tmap = new Map<String, Territory2>();
  Map<Id, Map<String, UserTerritory2Association>> ut2amap = new map<Id, Map<String, UserTerritory2Association>>();
  
  for(SAP_Sales_DOG__c d:dogs){
    dmap.put('D' + d.Record_Key__c, d);
    tmap.put('D' + d.Record_Key__c, 
      new Territory2(
        developername = 'D' + d.Record_Key__c,
        description = d.name,
        name = d.name,
        territory2modelid = m.id,
        territory2typeid = zdog.id
      )
    );
  }
  
  Set<Id> tids = new set<Id>();
  
  for(Territory2 t:[select id, developername from Territory2 where developername IN :dmap.keyset()]){
    tmap.put(t.developername, t);
    tids.add(t.id);
    ut2amap.put(t.id, new Map<String, UserTerritory2Association>());
  }
  
  for(UserTerritory2Association ut2a:[select id, Territory2Id, UserId, RoleInTerritory2 from UserTerritory2Association where Territory2id IN :tids]){
     ut2amap.get(ut2a.Territory2id).put(ut2a.RoleInTerritory2, ut2a);
  }
 
  List<Territory2> t2insert = new List<Territory2>();
  for(Territory2 t:tmap.values()){
    if(t.id == null)
      t2insert.add(t);
  }
  
  if(t2insert.size() > 0){
    insert t2insert;
      for(Territory2 t:[select id, developername from Territory2 where developername IN :dmap.keyset()]){
        tmap.put(t.developername, t);
        tids.add(t.id);
        ut2amap.put(t.id, new Map<String, UserTerritory2Association>());
      }
      
      for(UserTerritory2Association ut2a:[select id, Territory2Id, UserId, RoleInTerritory2 from UserTerritory2Association where Territory2id IN :tids]){
         ut2amap.get(ut2a.Territory2id).put(ut2a.RoleInTerritory2, ut2a);
      }
  }
  
 List<UserTerritory2Association> todelete = new List<UserTerritory2Association>();
 List<UserTerritory2Association> toinsert = new List<UserTerritory2Association>();
 
 
 for(SAP_Sales_DOG__c d:dmap.values()){
   
   system.debug(d);
   Territory2 t = tmap.get('D' + d.Record_Key__c);
   system.debug(t);
   Map<String, UserTerritory2Association> umap = ut2amap.get(t.id);
   
   if(umap.containskey('Vice President')){
       if(umap.get('Vice President').UserId != d.YV_Partner__r.User__c){
         todelete.add(umap.get('Vice President'));
       }else if(d.yv_partner__r.user__c != null){
         toinsert.add(new UserTerritory2Association(territory2id = t.id, userid = d.YV_Partner__r.User__c, RoleInTerritory2 = 'Vice President'));   
       }
   }else{
       if(d.yv_partner__r.user__c != null)
       toinsert.add(new UserTerritory2Association(territory2id = t.id, userid = d.YV_Partner__r.User__c, RoleInTerritory2 = 'Vice President'));   
   }
   if(umap.containskey('Sales Director')){
       if(umap.get('Sales Director').UserId != d.YO_Partner__r.User__c){
         todelete.add(umap.get('Sales Director'));
       }else  if(d.yo_partner__r.user__c != null){
         toinsert.add(new UserTerritory2Association(territory2id = t.id, userid = d.YO_Partner__r.User__c, RoleInTerritory2 = 'Sales Director'));   
       }
   }else{
       if(d.yo_partner__r.user__c != null)
       toinsert.add(new UserTerritory2Association(territory2id = t.id, userid = d.YO_Partner__r.User__c, RoleInTerritory2 = 'Sales Director'));   
   }
   if(umap.containskey('District Manager')){
       if(umap.get('District Manager').UserId != d.YD_Partner__r.User__c){
         todelete.add(umap.get('District Manager'));
       }else     if(d.yd_partner__r.user__c != null){
         toinsert.add(new UserTerritory2Association(territory2id = t.id, userid = d.YD_Partner__r.User__c, RoleInTerritory2 = 'District Manager'));   
       }
   }else{
       if(d.yd_partner__r.user__c != null)
      toinsert.add(new UserTerritory2Association(territory2id = t.id, userid = d.YD_Partner__r.User__c, RoleInTerritory2 = 'District Manager'));   
   }
   
 }
 
 if(todelete.size() > 0)
   delete todelete;
 
 if(toinsert.size() > 0){
   List<Database.SaveResult> results = database.insert(toinsert, false);
   
   for(Database.saveresult r:results){
     if(!r.isSuccess()){ 
       system.debug('****ERROR***');
       system.debug(r.id);
       for(Database.Error e:r.geterrors()){
         system.debug('Error: ' + e.getmessage()); }
       }
   }
   
 }
 
}

@Future
public static void SAP_Territories(Set<Id> ids){
  Territory2Model m = [select id from Territory2Model where state = 'Active' limit 1];
  Territory2Type ZDOG = [select id from Territory2Type where MasterLabel = 'ZDOG' limit 1];
  Territory2Type ZTER = [select id from Territory2Type where MasterLabel = 'ZTER' limit 1];
  List<SAP_Territory__c> terrs = [select SAP_Sales_DOG__r.Record_Key__c, id, name, record_key__c, YS_Partner__r.User__c, ZS_Partner__r.User__c from SAP_Territory__c where id IN :ids];
  
  
  Map<String, SAP_Territory__c> dmap = new Map<String, SAP_Territory__c>();
  Map<String, Territory2> tmap = new Map<String, Territory2>();
  Set<String> dogids = new set<String>();
 
  Map<Id, Map<String, UserTerritory2Association>> ut2amap = new map<Id, Map<String, UserTerritory2Association>>();
  Map<String, Id> dogmap = new Map<String, Id>();
  
  for(SAP_Sales_DOG__c d:[select id, Record_Key__c from SAP_sales_DOG__c])
    dogids.add('D' + d.Record_Key__c);
    
  for(Territory2 t:[select id, developername from Territory2 where developername IN :dogids])
    dogmap.put(t.developername, t.id);
  
  for(SAP_Territory__c t:terrs){

    dmap.put('T' + T.Record_Key__c, t);
    id parentid = null;
    if(t.SAP_Sales_DOG__r.Record_Key__c != null){
      if(dogmap.containskey(t.SAP_Sales_DOG__r.Record_Key__c)){
        parentid = dogmap.get(t.SAP_Sales_DOG__r.Record_Key__c);
      }
    }
    
    tmap.put('T' + T.Record_Key__c, 
      new Territory2(
        developername = 'T' + T.Record_Key__c,
        description = T.name,
        name = T.name,
        ParentTerritory2id = parentid,
        territory2modelid = m.id,
        territory2typeid = zter.id
      )
    );
  }
  
  Set<Id> tids = new set<Id>();
  
   
  for(Territory2 t:[select id, developername from Territory2 where developername IN :dmap.keyset()]){
    tmap.put(t.developername, t);
    tids.add(t.id);
    ut2amap.put(t.id, new Map<String, UserTerritory2Association>());
  }
  
  for(UserTerritory2Association ut2a:[select id, Territory2Id, UserId, RoleInTerritory2 from UserTerritory2Association where Territory2id IN :tids]){
     ut2amap.get(ut2a.Territory2id).put(ut2a.RoleInTerritory2, ut2a);
  }
 
  List<Territory2> t2insert = new List<Territory2>();
  for(Territory2 t:tmap.values()){
    if(t.id == null)
      t2insert.add(t);
  }
  
  if(t2insert.size() > 0){
    insert t2insert;
      for(Territory2 t:[select id, developername from Territory2 where developername IN :dmap.keyset()]){
        tmap.put(t.developername, t);
        tids.add(t.id);
        ut2amap.put(t.id, new Map<String, UserTerritory2Association>());
      }
      
      for(UserTerritory2Association ut2a:[select id, Territory2Id, UserId, RoleInTerritory2 from UserTerritory2Association where Territory2id IN :tids]){
         ut2amap.get(ut2a.Territory2id).put(ut2a.RoleInTerritory2, ut2a);
      }
  }
  
  
  
 List<UserTerritory2Association> todelete = new List<UserTerritory2Association>();
 List<UserTerritory2Association> toinsert = new List<UserTerritory2Association>();
 
 
 for(SAP_Territory__c t:dmap.values()){
   
   system.debug(t);
   Territory2 t2 = tmap.get('T' + t.Record_Key__c);
   system.debug(t2);
   Map<String, UserTerritory2Association> umap = ut2amap.get(t2.id);
   
   if(umap.containskey('Seller')){
       if(umap.get('Seller').UserId != t.ZS_Partner__r.User__c){
         todelete.add(umap.get('Seller'));
       }
       else if(t.zs_partner__r.User__c != null){
         toinsert.add(new UserTerritory2Association(territory2id = t2.id, userid = t.ZS_Partner__r.User__c, RoleInTerritory2 = 'Seller'));
       }
   }else{
       if(t.zs_partner__r.User__c != null)
       toinsert.add(new UserTerritory2Association(territory2id = t2.id, userid = t.ZS_Partner__r.User__c, RoleInTerritory2 = 'Seller'));   
   }
   if(umap.containskey('Sales Support')){
       if(umap.get('Sales Support').UserId != t.YS_Partner__r.User__c){
         todelete.add(umap.get('Sales Support'));
       }
       else if(t.ys_partner__r.User__c != null){
         toinsert.add(new UserTerritory2Association(territory2id = t2.id, userid = t.YS_Partner__r.User__c, RoleInTerritory2 = 'Sales Support')); 
       }  
   }else{
       if(t.ys_partner__r.User__c != null)
       toinsert.add(new UserTerritory2Association(territory2id = t2.id, userid = t.YS_Partner__r.User__c, RoleInTerritory2 = 'Sales Support'));   
   }

   
 }
 
 if(todelete.size() > 0)
   delete todelete;
 
 if(toinsert.size() > 0){
  
   database.insert( toinsert, false);
   
 }
 
}

}