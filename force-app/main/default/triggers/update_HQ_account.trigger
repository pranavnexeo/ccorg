trigger update_HQ_account on Consumption__c (before insert) {
    list<account> la = new list<account>();
    list<id> aid = new list<id>();
    map<id,Account> amap = new map<id,Account>();
    for(Consumption__c con : trigger.new){
        If(con.Account_Name__c != null){
            aid.add(con.Account_Name__c);
        }
    }
    
    la = [select id,ownerid,SAP_Corporate_Account_Id__c from account where id =: aid];

    for(account a : la){
        amap.put(a.id,a);
    }
    for(Consumption__c con : trigger.new){
        If(amap.isEmpty() != true){
            If(amap.get(con.Account_Name__c).SAP_Corporate_Account_Id__c != ''){
                con.HQ_Account__c =  amap.get(con.Account_Name__c).SAP_Corporate_Account_Id__c;
            }
        }
    }
}