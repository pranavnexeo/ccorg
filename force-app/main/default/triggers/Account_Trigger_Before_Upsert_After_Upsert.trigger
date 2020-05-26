trigger Account_Trigger_Before_Upsert_After_Upsert on Account (before insert, before update, after insert, after update) {
    
    set<id> accid = new set<id>(); 
    set<id> acid = new set<id>(); 
    List<String> acCIS = new List<String>();    
    map<id,account> accMap = new map<id,account>();
    map<id,account> oldAccMap = new map<id,account>();
    List<Id> toProcess = new List<Id>();
    
    if(trigger.isbefore){
    if(checkRecursive.runAccountOnce2()){
    system.debug(':::1');
    Account_Trigger_Functions.processBeforeUpsert(Trigger.new, trigger.isupdate, trigger.oldmap);
      if(trigger.isUpdate){system.debug(':::2');
         Account_Trigger_Functions.processBeforeUpdate(trigger.new, trigger.oldmap);        
         
      }
     }
    }
    
    if(trigger.isAfter){
                     
             if(trigger.isinsert){system.debug(':::3');
                 Account_Trigger_Functions.processAfterInsert(trigger.new);
                 
                 for(integer i=0;i<trigger.new.size(); i++)
                     if(trigger.new[i].Type == 'Customer' && trigger.new[i].ccrz__UsedByCloudcraze__c == true)
                         toProcess.add(trigger.new[i].id);
                         
               }
        
        
          
             if(trigger.isUpdate){system.debug(':::4');
             system.debug('updation.isfutureupdate$$$:'+updation.isfutureupdate);
             
                //This function if called to create Account Group record for the Account if it is enabled for Customer portal 
                     if(checkRecursive.runAccountOnce1()){ //  if(!updation.isfutureupdate)
                         system.debug(':::5');
                             //Cloudcraze_Product_Function.add_AccountGroupCreation(trigger.new);  
                             if(!system.isfuture() && !test.isrunningtest() && (userinfo.getusername().contains('nexeo_integration') || userinfo.getprofileid().startswith('00eE0000000XXcd')) ){
                                 system.debug(':::7');
                                 Account_Team_Triggers.Account(trigger.newmap.keyset());
                                 system.debug(':::8');
                                 Account_Team_Triggers.AccountTeamMembersSync(trigger.newmap.keyset(), userinfo.getsessionid());
                               //  Cloudcraze_Product_Function.add_AccountGroupCreation(trigger.newmap.keyset()); 
                              
                             }   
                             
                             for(integer i=0;i<trigger.new.size(); i++)
                                 if(trigger.new[i].Type == 'Customer' && trigger.old[i].ccrz__UsedByCloudcraze__c == false && trigger.new[i].ccrz__UsedByCloudcraze__c == true)
                                     toProcess.add(trigger.new[i].id);
                             
                                                  
                       }
                      
                         
                 }
         
        /*  else{system.debug(':::6');
           if(!system.isfuture() && !test.isrunningtest() && (userinfo.getusername().contains('nexeo_integration') || userinfo.getprofileid().startswith('00eE0000000XXcd')) ){
             system.debug(':::7');
            Account_Team_Triggers.Account(trigger.newmap.keyset());
             system.debug(':::8');
           Account_Team_Triggers.AccountTeamMembersSync(trigger.newmap.keyset(), userinfo.getsessionid()); 
          
         }
        }*/    
        
   } 
   
  if(toProcess.size()>0){ system.debug('toProcess size is ***'+ toProcess.size());
   
      CloudcrazePriceListCreation cp = new CloudcrazePriceListCreation(toProcess);
      Database.executeBatch(cp,1);} 
  
  
  if(trigger.isAfter && trigger.isUpdate){
        
        for(account a: Trigger.New){
            if(a.Type == 'Customer' && a.ccrz__UsedByCloudcraze__c == true && trigger.oldmap.get(a.id).ccrz__UsedByCloudcraze__c == False){
                accId.add(a.id);
            }
            else if(a.Type == 'Customer' && (trigger.oldmap.get(a.id).Mapquest_Address__c != a.Mapquest_Address__c || trigger.oldmap.get(a.id).Billing_Address_for_Business_Contract__c != a.Billing_Address_for_Business_Contract__c)){
                accId.add(a.id);
            }                          
        }   
        if(accId.size()>0){    
           AccountTriggerHelper.ContactAddressInsert(accId);
        }
        
            
       
      for(account a: Trigger.New){
          if(a.Type == 'Customer' && a.ccrz__UsedByCloudcraze__c == false && trigger.oldmap.get(a.id).ccrz__UsedByCloudcraze__c == True){
              acId.add(a.id);
              acCIS.add(a.Account_Number__c);
          }        
      } 
      
      if(acId.size()>0 && acCIS.size()>0)
      {
          AccountTriggerHelper.ToDeleteRelatedAccountGrp(acId, acCIS);   
      }
     
  }
}