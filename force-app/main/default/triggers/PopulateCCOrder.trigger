/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/13/2016
*    Author:             Sneha Likhar
*   Last Modified:       Naren Karthik
*   Last Modified By:    03/30/2017
*
*   Short Description:  Update Transaction Payment to populate Order lookup field.
*                       Updated Transaction Payment to send out new order email to CSR.
*   **********************************************************************************************************************/

trigger PopulateCCOrder on ccrz__E_TransactionPayment__c (before insert, before update, after insert) {
    
    if(trigger.isBefore)
    {
        List<ccrz__E_Order__c> Orders = New List<ccrz__E_Order__c>();
        List<String> TransIds = New List<String>();
            
        id id1 = userinfo.getProfileId();
        String profileName = [Select Name from Profile where Id =: id1].name;
        
        For(ccrz__E_TransactionPayment__c trans : Trigger.New){
            TransIds.add(trans.ccrz__TransactionPaymentId__c);
        }
        if(TransIds.size()>0 && profileName!= '' && (profileName == 'Integration User'  || profileName == 'System Administrator')){
            Orders = [select id, name, ccrz__OrderId__c from ccrz__E_Order__c where ccrz__OrderId__c in : TransIds];
            if(Orders.size()>0){
                For(ccrz__E_TransactionPayment__c trans : Trigger.New){
                    for(ccrz__E_Order__c ordr: Orders){
                        if(trans.ccrz__TransactionPaymentId__c == ordr.ccrz__OrderId__c ){
                            trans.ccrz__CCOrder__c = ordr.id;
                            System.debug('Inside profile condition with profile name' + profileName);
                          
                        }
                    }
                }
            } 
         }
     }
     if(trigger.isAfter)
     {
        if(trigger.isInsert)
        {            
            Set<String> mynexeo_transpayids = new Set<String>();
            
            for(ccrz__E_TransactionPayment__c trans : Trigger.New)
            {    
                if(trans.ccrz__storefront__c == 'mynexeo')
                {
                    mynexeo_transpayids.add(String.Valueof(trans.Id));
                }             
            }
            
            if(mynexeo_transpayids.size() > 0)
            {
                cc_nex_order_email.emailtocsr(mynexeo_transpayids);
            }
        }    
     }
 }