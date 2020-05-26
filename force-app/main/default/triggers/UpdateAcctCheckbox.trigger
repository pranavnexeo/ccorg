/*****************************************************************************************
    Name    : updateacctcheckbox 
    Desc    : It is an before insert and after update trigger which will check the related account record type and if that is customer then check 
              the check box and if that is prospect then uncheck the customer account field            
                            
    Modification Log : 
---------------------------------------------------------------------------
 Developer        Date            Description
---------------------------------------------------------------------------
Sana Tarique     12/17/2013       Created
******************************************************************************************/
trigger UpdateAcctCheckbox on Account_Related_to_Campaign__c (before insert) {

        Set<Id> acctIdSet = new Set<Id>();
        
        for(Account_Related_to_Campaign__c relacct: Trigger.new){
            acctIdSet.add(relacct.Account__c);
        }
        
        Map<Id, Account> acctMap = new Map<Id, Account>([Select Id, Type from Account where Id IN: acctIdSet]);
        
        for(Account_Related_to_Campaign__c relacctnew: Trigger.new){
            if((acctMap.size() > 0) && ((acctMap.get(relacctnew.Account__c).Type=='Customer')||(acctMap.get(relacctnew.Account__c).Type=='Prospect'))){
                if(acctMap.get(relacctnew.Account__c).Type=='Customer'){
                  relacctnew.Customer_Account__c= True;
                }
                
              
           else{
                   relacctnew.Customer_Account__c= False;
                }           
            }
           
        }

}