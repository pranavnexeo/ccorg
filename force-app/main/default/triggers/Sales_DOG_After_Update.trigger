trigger Sales_DOG_After_Update on SAP_Sales_DOG__c (after insert, after update) {
  Set<Id> ids = new set<Id>();
  for(SAP_Sales_DOG__c d:trigger.new){
    ids.add(d.id);
  }
  
  if( test.isrunningtest() == false)
  Account_Team_Triggers.SAP_Sales_DOG(ids);
  
  List<SAP_Territory__c> terrs = [select id from SAP_Territory__c where SAP_Sales_DOG__c IN :ids];
  if(terrs.size() > 0)
    update terrs;
}