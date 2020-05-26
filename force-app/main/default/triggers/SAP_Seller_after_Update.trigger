Trigger SAP_Seller_after_Update on SAP_Seller__c (after Update){
    List <Account> alist = new List <Account>();
    set<Id> ids = new set<Id>();
    for(SAP_Seller__c s:trigger.new){
      ids.add(s.id);
    }
    Set<Id> dogids = new set<Id>();
    List<SAP_Sales_DOG__c> dogs = [select id from SAP_Sales_DOG__c where 
         YD_Partner__c IN :ids or 
         YO_Partner__c IN :ids or
         YV_Partner__c IN :ids];
         
    for(SAP_Sales_DOG__c d: dogs ){
           dogids.add(d.id);
         }
     
   set<Id> terrids = new set<Id>();
   List<SAP_Territory__c> terrs = [select id from SAP_Territory__c where 
       (ZS_Partner__c IN :ids or
       YS_Partner__c IN :ids) and
       (NOT SAP_Sales_DOG__C IN :dogids)];
    
     
   if(dogs.size() > 0)
     update dogs;
     
   if(terrs.size() > 0)
     update terrs;

}