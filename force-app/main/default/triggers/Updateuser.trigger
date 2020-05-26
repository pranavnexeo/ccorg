trigger Updateuser on Price_Request_Transaction__c (before update,before insert) {
    set<Id> prupdate = new set<Id>();
    map<string,Account> accountIdWFUsermap = new map<string,Account>();
    map<string,Material_Sales_Data2__c> sapmatmap = new map<string,Material_Sales_Data2__c>();
    list<account> accountList = New List<account>();
    
    for(Price_Request_Transaction__c pr : trigger.new){
        //If(bc.id != null){
            prupdate.add(pr.id);
            If(pr.Ship_To__c != null){
                accountIdWFUsermap.put(pr.Ship_To__c,pr.Ship_To__r);
            }
            If(pr.SAP_Material__c != null){
                sapmatmap.put(pr.SAP_Material__c,pr.SAP_Material__r);
            }
        //}
    }
    //accountList  = [SELECT ID,YY_Partner__r.YS_Partner__r.User__c from account where Id =: accountIdWFUsermap.keyset()];

    for(account objAcc : [SELECT ID,YY_Partner__r.YS_Partner__r.User__c,YZ_Partner__r.ZS_Partner__r.User__c,SAP_Customer_Group_2_Desc__c,YY_Partner__r.ZS_Partner__r.User__c,YZ_Partner__r.Ys_Partner__r.User__c from account where Id IN :accountIdWFUsermap.keyset()]){
        accountIdWFUsermap.put(objAcc.id,objAcc);
    
    }
    
    for(Material_Sales_Data2__c objMat : [SELECT ID,Material_Group3_Desc__c from Material_Sales_Data2__c where Id IN :sapmatmap.keyset()]){
        sapmatmap.put(objMat.id,objMat);
    }
    for(Price_Request_Transaction__c prt: trigger.new){
        if(prt.SAP_Material__c != null){
            if(sapmatmap.get(prt.SAP_Material__c).Material_Group3_Desc__c == 'SPECIALTY' && prt.Ship_To__c != null){
            
                if(accountIdWFUsermap.get(prt.Ship_To__c).YZ_Partner__r.ZS_Partner__r.User__c != null){
                    prt.Seller__c= accountIdWFUsermap.get(prt.Ship_To__c).YZ_Partner__r.ZS_Partner__r.User__c;
                }
                if(accountIdWFUsermap.get(prt.Ship_To__c).YZ_Partner__r.YS_Partner__r.User__c != null){
                    prt.Sales_Support__c= accountIdWFUsermap.get(prt.Ship_To__c).YZ_Partner__r.YS_Partner__r.User__c;
                }
        
            }
            if(sapmatmap.get(prt.SAP_Material__c).Material_Group3_Desc__c == 'COMMODITY' && prt.Ship_To__c != null){
                if(accountIdWFUsermap.get(prt.Ship_To__c).YY_Partner__r.ZS_Partner__r.User__c != null){
                    prt.Seller__c= accountIdWFUsermap.get(prt.Ship_To__c).YY_Partner__r.ZS_Partner__r.User__c;
                }
                if(accountIdWFUsermap.get(prt.Ship_To__c).YY_Partner__r.YS_Partner__r.User__c != null){
                    prt.Sales_Support__c= accountIdWFUsermap.get(prt.Ship_To__c).YY_Partner__r.YS_Partner__r.User__c;
                }
        
            }
        }
    }
}