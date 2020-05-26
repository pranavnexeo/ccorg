// Purpose: This Triggers fires when SAP Order Number is populated on 
// CC Order, it fetches all the child records (Order Line Items) and update the 
// the key field with the combination of SAP order number and SAP item number
// 
// Created Date: 10/13/2016
// Author: Parvez Bandeali
// 
// Last Modified Date: 3/30/2017
// Last Modified by: Naren Karthik
////////////////////////////////////////////////////////////////////////////////////////////////////////////
trigger recordKeyGenerator_OrderItem on ccrz__E_Order__c (After Insert,After update) 
{
    if(trigger.isAfter)
    {                                       
        if(trigger.isInsert)
        {            
            Set<String> nexeo3d_orderids = new Set<String>();
            
            for(ccrz__E_Order__c order : Trigger.New)
            {    
                if(order.ccrz__storefront__c == 'nexeo3d')
                {
                    nexeo3d_orderids.add(String.Valueof(order.Id));
                }             
            }
            
            if(nexeo3d_orderids.size() > 0)
            {
                cc_nex_order_email.emailtonexeo3demail(nexeo3d_orderids);
            }
        }
        
        if(trigger.isUpdate)
        {
            map<id,ccrz__E_Order__c> ordmap = new map<id,ccrz__E_Order__c>();
            
            for(ccrz__E_Order__c  ordhed : Trigger.new)
            {
                if(ordhed.ccrz__OrderId__c != Trigger.oldMap.get(ordhed.Id).ccrz__OrderId__c)                                                                       
                {
                    ordmap.put(ordhed.id,ordhed);
                }
            }
                       
            list<ccrz__E_OrderItem__c> listtoupd = new list<ccrz__E_OrderItem__c>();
            List<ccrz__E_TransactionPayment__c> lstTransaction = new List<ccrz__E_TransactionPayment__c>();
            
            if(!ordmap.isEmpty())
            {
                map<id, ccrz__E_OrderItem__c> orditmmap= new map<id, ccrz__E_OrderItem__c>([select id,cc_imp_Sequence__c,ccrz__Order__c from ccrz__E_OrderItem__c where ccrz__Order__c IN :ordmap.keyset()]);    
                
                map<id, ccrz__E_TransactionPayment__c> transactionmap = new map<id, ccrz__E_TransactionPayment__c>([select id, ccrz__AccountType__c, ccrz__CCOrder__c, ccrz__TransactionPaymentId__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN :ordmap.keyset()]);    
                           
                for(ccrz__E_OrderItem__c orditm : orditmmap.values())
                    {
                        if(ordmap.get(orditm.ccrz__Order__c).ccrz__OrderId__c != null && orditm.cc_imp_Sequence__c != null ){
                        orditm.Record_Key__c =  ordmap.get(orditm.ccrz__Order__c).ccrz__OrderId__c + orditm.cc_imp_Sequence__c ;
                        }
                        else{
                        orditm.Record_Key__c ='';  
                        }
                        listtoupd.add(orditm);
                    }
                
                update listtoupd;  
                
                for(ccrz__E_TransactionPayment__c trans : transactionmap.values())
                {
                    system.debug('$$$'+ordmap.get(trans.ccrz__CCOrder__c).ccrz__OrderId__c);
                    system.debug('$$$Tran'+trans.ccrz__TransactionPaymentId__c);
                    
                    if(trans.ccrz__TransactionPaymentId__c == null)
                            trans.ccrz__TransactionPaymentId__c = ordmap.get(trans.ccrz__CCOrder__c).ccrz__OrderId__c;
            
                    if(ordmap.get(trans.ccrz__CCOrder__c).ccrz__Storefront__c == 'mynexeo')
                        trans.ccrz__AccountType__c = 'po';
                        
                    lstTransaction.add(trans);
                }
                
                if(lstTransaction.size()>0)
                    update lstTransaction;
                
            }
        }
    }
}