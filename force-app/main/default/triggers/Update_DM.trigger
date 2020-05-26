trigger Update_DM on Specification_Agreement__c (before update,before insert) {
    List<id> accid = new List<id>();
    List<Account> la = new List<Account>();
    Map<id,Specification_Agreement__c> smap = new  Map<id,Specification_Agreement__c>();
    For(Specification_Agreement__c sa : Trigger.new){     
        accid.add(sa.Ship_to_Account_Name__c);
        smap.put(sa.Ship_to_Account_Name__c,sa);
    }
    If(accid != null){
        la = [select owner.manager.email,owner.manager.id,AccountNumber,owner.email from account where id =: accid];        
    }
    For(Account sa : la){
        smap.get(sa.id).DM_Email__c= sa.owner.manager.email; 
        smap.get(sa.id).Account_number__c = sa.AccountNumber; 
        smap.get(sa.id).Account_owner_email__c = sa.owner.email; 
        smap.get(sa.id).Account_DM__c = sa.owner.manager.id; 
        smap.get(sa.id).Account_Seller__c = sa.owner.id;
    }
   
}