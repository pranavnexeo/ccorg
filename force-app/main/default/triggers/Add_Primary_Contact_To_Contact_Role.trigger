trigger Add_Primary_Contact_To_Contact_Role on Opportunity (after Insert,after Update ) {

List<OpportunityContactRole> OppRoles = new List<OpportunityContactRole >();
if(Trigger.isInsert){
        for (Integer i = 0; i<Trigger.New.size(); i++){
             if(Trigger.new[i].contact__c != null)
             {
             OpportunityContactRole sr = new OpportunityContactRole();
             sr.ContactId =trigger.new[i].Contact__c;
             sr.IsPrimary =true;
             sr.OpportunityId= trigger.new[i].id;
             sr.Role='Business User';   
             OppRoles.add(sr);
             }
        }
}
else if(Trigger.isUpdate){
     Set<Id> OppIds = new Set<Id>();
     
     for(Opportunity oppt:trigger.new){
       OppIds.add(oppt.id);
     }
     
     List<OpportunityContactRole> OCRs = [select id, opportunityid, Contactid from OpportunityContactRole where OpportunityId IN :OppIds];
     Set<Id> OCRChanged = new Set<Id>();
     
     for (Integer i = 0; i < Trigger.new.size(); i++) {
     if (Trigger.old[i].Contact__c!=Trigger.new[i].Contact__c ){
        OCRChanged.add(Trigger.new[i].id);
  
     if(trigger.new[i].Contact__c != null){
     OpportunityContactRole sr = new OpportunityContactRole();
             sr.ContactId =trigger.new[i].Contact__c;
             sr.IsPrimary =true;
             sr.OpportunityId= trigger.new[i].id;
             sr.Role='Business User';              
             OppRoles.add(sr);
      }
     }  
    }
    
    List<OpportunityContactRole> ToDelete = new List<OpportunityContactRole>();
    for(OpportunityContactRole OCR:OCRs){
      if(OCRChanged.contains(OCR.OpportunityId))
        ToDelete.add(OCR);
    }
    if(ToDelete.size() > 0)
      Delete toDelete;
}
if(OppRoles.size() > 0)
  upsert OppRoles;
}