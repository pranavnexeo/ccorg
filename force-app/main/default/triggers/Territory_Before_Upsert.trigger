trigger Territory_Before_Upsert on SAP_Territory__c (before insert, before update) {
  Set<Id> sellerids = new set<Id>();
  Set<Id> dogids = new set<Id>();
  for(SAP_Territory__c t:trigger.new){
    if(t.YS_Partner__c != null)
      sellerids.add(t.YS_Partner__c);
    if(t.ZS_Partner__c != null)
      sellerids.add(t.ZS_Partner__c);
    if(t.SAP_Sales_Dog__c != null)
      dogids.add(t.SAP_Sales_DOG__c);
  }
  
  Map<Id, SAP_Seller__c> smap = new Map<Id, SAP_Seller__c>([select id, User__r.Ashland_Employee_Number__c from SAP_Seller__C where id IN :sellerids]);
  Map<Id, SAP_Sales_DOG__c> dmap = new map<Id, SAP_Sales_DOG__c>([select id,
                                                                    SAP_Sales_District_Desc__c,
                                                                    SAP_Sales_Office_Desc__c,
                                                                    SAP_Sales_Group_Desc__c, 
                                                                    YD_Partner__r.User__r.Ashland_Employee_Number__c,
                                                                    YO_Partner__r.User__r.Ashland_Employee_Number__c,
                                                                    YV_Partner__r.User__r.Ashland_Employee_Number__c
                                                                    from SAP_Sales_DOG__c where id IN :dogids]);
  
  boolean launchbatch = false;
  for(SAP_Territory__c t:trigger.new){
    
    if(t.batch_updated__c == true){
      t.batch_updated__c = false;
      t.Update_Accounts__c = false;
    }else{
      t.update_accounts__c = true;
      launchbatch = true;
    }
    
    List<String> ids = new List<String>();
    if(t.YS_Partner__c != null && smap.containskey(t.YS_Partner__c)){
      ids.add(smap.get(t.YS_Partner__c).User__r.Ashland_Employee_Number__c);
    }
    if(t.ZS_Partner__c != null && smap.containskey(t.ZS_Partner__c)){
      ids.add(smap.get(t.ZS_Partner__c).User__r.Ashland_Employee_Number__c);
    }
    if(t.SAP_Sales_DOG__c != null && dmap.containskey(t.SAP_Sales_DOG__c)){
      
      t.SAP_Sales_District_Desc__c = dmap.get(t.SAP_Sales_DOG__c).SAP_Sales_District_Desc__c;
      t.SAP_Sales_Office_Desc__c = dmap.get(t.SAP_Sales_DOG__c).SAP_Sales_Office_Desc__c;
      t.SAP_Sales_Group_Desc__c = dmap.get(t.SAP_Sales_DOG__c).SAP_Sales_Group_Desc__c;
      
      if(dmap.get(t.SAP_Sales_DOG__C).YD_Partner__r.User__r.Ashland_Employee_Number__c != null){
        ids.add(dmap.get(t.SAP_Sales_DOG__c).YD_Partner__r.User__r.Ashland_Employee_Number__c);
      }
      if(dmap.get(t.SAP_Sales_DOG__C).YO_Partner__r.User__r.Ashland_Employee_Number__c != null){
        ids.add(dmap.get(t.SAP_Sales_DOG__c).YO_Partner__r.User__r.Ashland_Employee_Number__c);
      }
      if(dmap.get(t.SAP_Sales_DOG__C).YV_Partner__r.User__r.Ashland_Employee_Number__c != null){
        ids.add(dmap.get(t.SAP_Sales_DOG__c).YV_Partner__r.User__r.Ashland_Employee_Number__c);
      }
    }else{
      t.SAP_Sales_District_Desc__C = '';
      t.SAP_Sales_Office_Desc__C = '';
      t.SAP_Sales_Group_Desc__C = '';
    }
    
    t.Employee_Ids__c = String.join(ids, ',');
  }
     
    if(trigger.isupdate && launchbatch && ([SELECT count() FROM CronTrigger where cronjobdetail.name = 'syncaccounts' limit 1] == 0)){
       system.schedulebatch(new AccountTeamBatch2(userinfo.getsessionid()), 'syncaccounts', 1, 5);
    }                                                           
}