//***Author -- Sneha Likhar
public with sharing class Opportunity_Territory_Functions {
  
    public static void assignOwner(Set<Id> AccountIds){
    
       assignowner([select id from Opportunity where accountid IN :accountids]);
    }
    
    //This method reassigns the owner to the territory seller
    public static void assignOwner(List<Opportunity> opportunities){
      Set<Id> oppids = new set<id>();
      for(Opportunity o:opportunities){
        oppids.add(o.id);
      }
      
      List<Opportunity> opps = [select id, Account.YY_Partner__c, 
                                           Account.YZ_Partner__c, 
                                           Account.YY_Partner__r.ZS_Partner__r.User__c,
                                           Account.YZ_Partner__r.ZS_Partner__r.User__c,
                                           Account.ZH_Partner__r.User__c,
                                           Account.ZH_Partner__c,
                                           OwnerId, 
                                           Account.OwnerId,
                                           SAP_Territory__r.ZS_Partner__c, 
                                           SAP_Territory__r.ZS_Partner__r.User__c from Opportunity where id IN :oppids]; 
      
      for(Opportunity o:opps){
      
        if(o.Account.YZ_Partner__c != null){
          if(o.Account.YZ_Partner__r.ZS_Partner__r.User__c != null){
            o.ownerid = o.Account.YZ_Partner__r.ZS_Partner__r.User__c;
          }
          o.SAP_territory__c = o.Account.YZ_Partner__c;
        }
        else if(o.Account.YY_Partner__c != null){
          if(o.Account.YY_Partner__r.ZS_Partner__r.User__c != null){
            o.ownerid = o.Account.YY_Partner__r.ZS_Partner__r.User__c;
          }
          o.SAP_Territory__c = o.Account.YY_Partner__c;
        }
        else if(o.Account.ZH_Partner__c != null){
          if(o.Account.ZH_Partner__r.User__c != null){
            o.ownerid = o.Account.ZH_Partner__r.User__c;
          }
          o.SAP_Territory__C = null;
        }
        else{
          o.ownerid = o.account.ownerid;
          o.SAP_Territory__C = null;
        }
      }
      
       for(Database.saveresult sr : Database.Update(opps, false)){
        if(!sr.isSuccess()){
          for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Fields that affected this error: ' + err.getFields());
         }
        }
      } 
    }
    
        
    //This method is called from trigger - reassignSellers_SAP_Territory only on an insert event.
    public static void reAssign_Sellers(List<Opportunity> opportunities){
    
       }
}