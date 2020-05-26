public with sharing class cc_mn_ctrl_MyOrderBIE {
public Boolean isES {get; private set;}
  public cc_mn_ctrl_MyOrderBIE() {
        Account a = new Account();
        if(!test.isrunningTest())
            a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.effAccountId); 
        else
           a =   [select id,SAP_DivisionCode__c from Account limit 1];    
           
        isES = False;
        if(a.SAP_DivisionCode__c!=null){
            if(a.SAP_DivisionCode__c=='34')
            {
              isES=True;  
            }
        }
     }
   }