trigger Update_Opportunity_Owner on Opportunity (before update, after insert){
    Opportunity_Territory_Functions.assignOwner(trigger.new);
    /*
    set<Id> acupdate = new set<Id>();
    map<string,Account> accountIdWFUsermap = new map<string,Account>();
    list<account> accountList = New List<account>();
    system.debug('(('+trigger.new);
    for(Opportunity op : trigger.new){
        If(op.Accountid != null){
            acupdate.add(op.accountid);
        }
    }
    for(account objAcc : [SELECT ID,YY_Partner__r.YS_Partner__r.User__c,YZ_Partner__r.ZS_Partner__r.User__c,SAP_Customer_Group_2_Desc__c,YY_Partner__r.ZS_Partner__r.User__c,YZ_Partner__r.Ys_Partner__r.User__c from account where Id IN :acupdate]){
        accountIdWFUsermap.put(objAcc.id,objAcc);
    }
    for(Opportunity op : trigger.new){
        if(accountIdWFUserMap.containskey(op.accountid)){
          if(accountIdWFUserMap.get(op.accountid).YZ_Partner__c != null){
            If(accountIdWFUsermap.get(op.accountid).YZ_Partner__r.ZS_Partner__r.User__c != null){
                if(accountIdWFUsermap.containskey(op.accountid)){                
                  op.Ownerid = accountIdWFUsermap.get(op.Accountid).YZ_Partner__r.ZS_Partner__r.User__c;            
                }
            } 
          }
          else if(accountIdWFUserMap.get(op.accountid).YY_Partner__c != null){               
            If(accountIdWFUsermap.get(op.accountid).YY_Partner__r.ZS_Partner__r.User__c != null){    
              if(accountIdWFUsermap.containskey(op.accountid)){                
                op.Ownerid = accountIdWFUsermap.get(op.Accountid).YY_Partner__r.ZS_Partner__r.User__c;            
              }
            }        
          }
        }
    }
    */
}