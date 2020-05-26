trigger updateSellerandSalesOnSamples on Sample_Request__c (before insert,before Update) {
    map<string,Account> accountIdWFUsermap = new map<string,Account>();
   
    for(Sample_Request__c sr : trigger.new){
        If(sr.Account__c != null){
            accountIdWFUsermap.put(sr.Account__c,sr.Account__r);   
        }         
    }
    for(account objAcc : [SELECT Primary_Seller__c, Primary_Sales_Support__c, ID,YY_Partner__r.YS_Partner__r.User__c,YZ_Partner__r.ZS_Partner__r.User__c,SAP_Customer_Group_2_Desc__c,YY_Partner__r.ZS_Partner__r.User__c,YZ_Partner__r.Ys_Partner__r.User__c from account where Id =: accountIdWFUsermap.keyset()]){
        accountIdWFUsermap.put(objAcc.id,objAcc);
    }
    for(Sample_Request__c sr : trigger.new){
        if(sr.Account__c != null && accountIdWFUsermap.containskey(sr.Account__c)){
            If(accountIdWFUsermap.get(sr.Account__c).YZ_Partner__r.ZS_Partner__r.User__c != null){
                sr.Speciality_Seller__c= accountIdWFUsermap.get(sr.Account__c).YZ_Partner__r.ZS_Partner__r.User__c; 
            }
            else{
                sr.Speciality_Seller__c = null;
            }       
            If(accountIdWFUsermap.get(sr.Account__c).YZ_Partner__r.YS_Partner__r.User__c != null){        
                sr.Speciality_Sales_Support__c= accountIdWFUsermap.get(sr.Account__c).YZ_Partner__r.YS_Partner__r.User__c;
            } 
            else{
                sr.Speciality_Sales_Support__c = null;
            }     
            If(accountIdWFUsermap.get(sr.Account__c).YY_Partner__r.ZS_Partner__r.User__c != null){
                sr.Commodity_Seller__c= accountIdWFUsermap.get(sr.Account__c).YY_Partner__r.ZS_Partner__r.User__c;
            }   
            else{
                sr.Commodity_Seller__c = null;
            } 
            If(accountIdWFUsermap.get(sr.Account__c).YY_Partner__r.YS_Partner__r.User__c != null){
                //system.debug('&&'+accountIdWFUsermap.get(sr.Account__c).YY_Partner__r.YS_Partner__r.User__c);
                sr.Commodity_Sales_Support__c= accountIdWFUsermap.get(sr.Account__c).YY_Partner__r.YS_Partner__r.User__c;
            }
            else{
                sr.Commodity_Sales_Support__c = null;
            }     
        }
    }
}