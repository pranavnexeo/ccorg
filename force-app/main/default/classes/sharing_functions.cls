public class sharing_functions{

  
  public static void share_with_Account_Team(Account a){
    Map<Id, Set<Id>> TeamMembers = getTeamMembers(new Set<Id>{a.id});
    createAccountMaterialShares([select id, Account__c from Account_Material__c where account__c = :a.id], TeamMembers);
  }
  
  public static void share_with_Account_Team(Set<Id> accountids){
    Map<Id, Set<Id>> TeamMembers = getTeamMembers(accountids);
    createAccountMaterialShares([select id, Account__c from Account_Material__c where account__c IN :accountids], TeamMembers);
  }
  
  public static void share_with_Account_Team(List<Account_Material__c> ams){
  
    set<Id> accountids = new set<Id>();
    for(Account_Material__c m:ams){
      accountids.add(m.account__c);
    }
    Map<Id, Set<Id>> TeamMembers = getTeamMembers(accountids);
    createAccountMaterialShares(ams, TeamMembers);
  }
  
  private static List<Account> getAccounts(Set<Id> accountids){
     return  [select id, 
                        YZ_Partner__r.ZS_Partner__r.User__c,
                        YZ_Partner__r.YS_Partner__r.User__c,
                        YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,
                        YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,
                        YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,
                        
                        YY_Partner__r.ZS_Partner__r.User__c, 
                        YY_Partner__r.YS_Partner__r.User__c,
                        YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,
                        YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,
                        YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,
                        
                        YI_Partner__r.ZS_Partner__r.User__c,
                        YI_Partner__r.YS_Partner__r.User__c,
                        YI_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,
                        YI_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,
                        YI_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c,
                        
                        ZC_Partner__r.User__c,
                        ZU_Partner__r.User__c,
                        ZH_partner__r.User__c,
                        Parent.ZH_Partner__r.User__c
                        
                        from Account where Id IN :accountids];
  }
  private static Map<Id, set<Id>> getTeamMembers(Set<Id> accountids){
    
    List<Account> accts = getAccounts(accountids);
                     
    Map<Id, Set<Id>> returnmap = new Map<Id, Set<ID>>();
    Map<Id, User> umap = new Map<Id, User>([select id from user where isactive = true]);
    
    for(Account a:accts){
                         
    Set<Id> toreturn = new set<Id>();
    if(a.YZ_Partner__r.ZS_Partner__r.User__c != null){ toreturn.add(a.YZ_Partner__r.ZS_Partner__r.User__c); } 
    if(a.YZ_Partner__r.YS_Partner__r.User__c != null){ toreturn.add(a.YZ_Partner__r.YS_Partner__r.User__c);}
    if(a.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null){ toreturn.add(a.YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c); }
    if(a.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null){ toreturn.add(a.YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c); }
    if(a.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != null){ toreturn.add(a.YZ_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c); }
                        
    if(a.YY_Partner__r.ZS_Partner__r.User__c != null){ toreturn.add(a.YY_Partner__r.ZS_Partner__r.User__c); } 
    if(a.YY_Partner__r.YS_Partner__r.User__c != null){ toreturn.add(a.YY_Partner__r.YS_Partner__r.User__c); }
    if(a.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null){ toreturn.add(a.YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c); }
    if(a.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null){ toreturn.add(a.YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c); }
    if(a.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != null){ toreturn.add(a.YY_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c); }
    
    if(a.YI_Partner__r.ZS_Partner__r.User__c != null){ toreturn.add(a.YI_Partner__r.ZS_Partner__r.User__c); } 
    if(a.YI_Partner__r.YS_Partner__r.User__c != null){ toreturn.add(a.YI_Partner__r.YS_Partner__r.User__c); }
    if(a.YI_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null){ toreturn.add(a.YI_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c); }
    if(a.YI_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null){ toreturn.add(a.YI_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c); }
    if(a.YI_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c != null){ toreturn.add(a.YI_Partner__r.SAP_Sales_DOG__r.YV_Partner__r.User__c); }
                        
    if(a.ZC_Partner__r.User__c != null){ toreturn.add(a.ZC_Partner__r.User__c);}
    if(a.ZU_Partner__r.User__c != null){ toreturn.add(a.ZU_Partner__r.User__c);}
    if(a.ZH_partner__r.User__c != null){ toreturn.add(a.ZH_Partner__r.User__c);}
    if(a.Parent.ZH_Partner__r.User__c != null){ toreturn.add(a.Parent.ZH_Partner__r.User__c);}
    
    Set<Id> activeusers = new Set<Id>();
    List<Id> team = new List<Id>();
    team.addall(toreturn);
    
    for(Id Id:team){ 
      if(activeusers.contains(id)){
       toreturn.add(id);
      }
    }
    returnmap.put(a.id, toreturn);
    }
    return returnmap;

  }

  private static void createAccountMaterialShares(List<Account_Material__c> ams, Map<Id, set<Id>> teammembers){
    
    List<Account_Material__share> newshares = new List<Account_material__share>(); 

    for(Account_Material__c am:ams){
      if(teammembers.containskey(am.account__c)){
      for(Id userid:teammembers.get(am.account__c)){
      newshares.add(new Account_material__share(
        parentid=am.id,
        RowCause=Account_material__share.RowCause.Nexprice_Team_Member__c,
        AccessLevel = 'Edit',
        UserOrGroupId=userid
      ));
     }
     }
    }
    
    if(newshares.size() > 0)
      Database.SaveResult[] srList = Database.insert(newshares, false);
  }
    
}