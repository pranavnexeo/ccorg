trigger updateCSR on ES_Profile__c (before insert, before update) {
   
   Set<Id> OppIds = new Set<Id>();
   for(ES_Profile__c p:trigger.new){
      oppids.add(p.Opportunity__c);
   }
   
   Map<Id, Opportunity> omap = new map<Id, Opportunity>([select id, Account.ZC_Partner__r.User__c, Account.ZC_Partner__c from Opportunity where id In :oppids]);
   
   for(ES_Profile__c p:trigger.new){
      if(omap.containskey(p.Opportunity__c)){
        Opportunity opp = omap.get(p.Opportunity__c);
        if(opp.Account.ZC_Partner__c != null){
          p.Customer_Service_Rep__c = opp.Account.ZC_Partner__r.User__c; 
        }else{
          p.customer_service_Rep__c = null;
        }
      }
   }

}