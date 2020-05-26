Global class cdfUpdateDefShipPlantBatch implements Database.Batchable<sObject>{
    Global String q;
    List<String> stat = new List<String>();
    //at.add('Expired');
    Set<String> pltcode = new Set<String>();
    Map<String,Id> plntMap = new Map<String,Id>();
    List<Contract> conList = New List<Contract>();
    global cdfUpdateDefShipPlantBatch(){
        stat.add('Expired');
        q= 'Select Id, Stocking_Warehouse__c from Contract where Status Not IN:stat and Stocking_Warehouse__c!= null and Default_Shipping_Plant__c = null';
    }
    
    Global Database.QueryLocator Start(Database.BatchableContext bcMain){
        return Database.getQueryLocator(q);
    }
    
    Global void Execute(Database.BatchableContext bcMain, List<Contract> cList){
        for (Contract c : cList){
            if(c.Stocking_Warehouse__c != null){
                pltcode.add(c.Stocking_Warehouse__c.substring(0, 4));
            }
        }
        
        for(SAP_Plant__c  sp : [select id, Plant_Code__c from SAP_Plant__c where Plant_Code__c IN :pltcode]){
            plntMap.put(sp.Plant_Code__c,sp.id);
        }
        
        for (Contract con: cList){
            if(plntMap.containskey(con.Stocking_Warehouse__c.substring(0, 4))&& plntMap.get(con.Stocking_Warehouse__c.substring(0, 4))!= null){
                con.Default_Shipping_Plant__c  = plntMap.get(con.Stocking_Warehouse__c.substring(0, 4));
                conList.add(con);
            }
        }
        
        update conlist;
       
    }
    Global void finish(Database.BatchableContext bcMain){
    }
    
}