trigger Updateworkflowuser on Business_Contract__c (before update,before insert) {
    //set<Id> bcupdate = new set<Id>();
    map<string,Account> accountIdWFUsermap = new map<string,Account>();
    list<account> accountList = New List<account>();
    
    for(Business_Contract__c bc : trigger.new){
        //If(bc.id != null){
            //bcupdate.add(bc.id);
            accountIdWFUsermap.put(bc.Customer_Name__c,bc.Customer_Name__r);
        //}
    }
    //accountList  = [SELECT ID,YY_Partner__r.YS_Partner__r.User__c from account where Id =: accountIdWFUsermap.keyset()];

    for(account objAcc : [SELECT ID,YZ_Partner__c,YY_Partner__c,YY_Partner__r.YS_Partner__r.User__c,YZ_Partner__r.ZS_Partner__r.User__c,SAP_Customer_Group_2_Desc__c,SAP_Customer_Group_2__c,YY_Partner__r.ZS_Partner__r.User__c,YZ_Partner__r.Ys_Partner__r.User__c, 
                                    YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c,
                                    YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c,YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c
                                    from account 
                                    where Id =: accountIdWFUsermap.keyset()]){
        accountIdWFUsermap.put(objAcc.id,objAcc);
    
    }

    for(Business_Contract__c businessContrct: trigger.new){
       /* if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2_Desc__c == 'Primary Specialty' && accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.YS_Partner__r.User__c != null){
            if(accountIdWFUsermap.containskey(businessContrct.Customer_Name__c)){
                businessContrct.Workflow_User__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.YS_Partner__r.User__c;
            }
        }
        if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2_Desc__c == 'Primary Specialty' && accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.ZS_Partner__r.User__c != null && accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.YS_Partner__r.User__c == null){
            if(accountIdWFUsermap.containskey(businessContrct.Customer_Name__c)){
                businessContrct.Workflow_User__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.ZS_Partner__r.User__c;
            }
        }
        if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2_Desc__c == 'Primary Commodity' && accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.YS_Partner__r.User__c != null){
            if(accountIdWFUsermap.containskey(businessContrct.Customer_Name__c)){
                businessContrct.Workflow_User__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.YS_Partner__r.User__c;
            }
        }
        if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2_Desc__c == 'Primary Commodity' && accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.ZS_Partner__r.User__c != null && accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.YS_Partner__r.User__c == null){
            if(accountIdWFUsermap.containskey(businessContrct.Customer_Name__c)){
                businessContrct.Workflow_User__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.ZS_Partner__r.User__c;
            }
        }*/
        
        if(accountIdWFUsermap.containskey(businessContrct.Customer_Name__c)){
            if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2__c == 'SPC'){
                if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__c != null){
                    if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null){
                        businessContrct.DM__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c;
                    }
                    if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null){
                        businessContrct.Sales_Director__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c;
                    }
                    if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.ZS_Partner__r.User__c != null){
                        businessContrct.Workflow_User__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YZ_Partner__r.ZS_Partner__r.User__c;
                    }
                }
            }
            else if((accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2__c == 'COM') || 
                    (accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2__c != 'SPC' && accountIdWFUsermap.get(businessContrct.Customer_Name__c).SAP_Customer_Group_2__c != 'COM')){
                if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__c != null){
                    if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c != null){
                        businessContrct.DM__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.SAP_Sales_DOG__r.YD_Partner__r.User__c;
                    }
                    if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c != null){
                        businessContrct.Sales_Director__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.SAP_Sales_DOG__r.YO_Partner__r.User__c;
                    }
                    if(accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.ZS_Partner__r.User__c != null){
                        businessContrct.Workflow_User__c = accountIdWFUsermap.get(businessContrct.Customer_Name__c).YY_Partner__r.ZS_Partner__r.User__c;
                    }
                }
            }
        }
        
    }
}