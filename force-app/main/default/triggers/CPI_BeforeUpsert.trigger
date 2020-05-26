trigger CPI_BeforeUpsert on Customer_Product_Info__c (before update, before insert) {

  Set<String> matRecordKeys = new Set<String>();
  Set<String> accRecordKeys = new Set<String>();
  Map<string,id> matmap = new Map<String, id>();
  Map<string,string> chemmap = new Map<String, string>();
  Map<string,string> compmap = new Map<String, string>();
  Map<string,string> plasmap = new Map<String, string>();
  Map<string,string> esmap = new Map<String, string>();
  Map<string,string> copackmap = new Map<String, string>();
  Map<string, SAP_Plant__c> pmap = new map<String, SAP_Plant__c>();
  set<string> plants = new set<string>();
  Map<string, SAP_INCO_Term__c> incomap = new map<String, SAP_INCO_Term__c>();
  set<string> Inco = new set<string>();
  
 // Price_Request_Settings__c prs = Price_Request_Settings__c.getInstance(userinfo.getuserid());
  boolean useg2 = true;
  
  String G2 = '';
  if(useg2){ G2 = 'G2'; }
  
  for(Customer_Product_Info__c c:trigger.new)
  {
    if(c.Plant_Code__c != null)
      plants.add(c.Plant_Code__c);
      
    if(c.INCO_Terms1__c != null)
      Inco.add(c.INCO_Terms1__c);
      
    String rk1 = c.material_number__c + c.Sales_org_Code__c + c.distribution_channel_Code__c;
    matRecordKeys.add(rk1);
    String rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '31';// + G2;
    accRecordKeys.add(rk2);
    chemmap.put(rk2, '');
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '32';// + G2;
    accRecordKeys.add(rk2);
    plasmap.put(rk2, '');
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '33';// + G2;
    accRecordKeys.add(rk2);
    compmap.put(rk2, '');
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '34';// + G2;
    accRecordKeys.add(rk2);
    esmap.put(rk2, ''); 
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '36';// + G2;
    accRecordKeys.add(rk2);
    copackmap.put(rk2, '');
  }

  for(sap_plant__c p:[select id, Plant_code__c from SAP_Plant__c where Plant_Code__c IN :plants])
    pmap.put(p.Plant_code__c, p);
    
  for(SAP_INCO_Term__c t:[select id, INCO_Term_Code__c, INCO_Term_Name__c from SAP_INCO_Term__c where INCO_Term_Code__c IN :Inco])
    incomap.put(t.INCO_Term_Code__c, t);
  
  for(Material_Sales_data2__c m:[select id, record_key__c from Material_Sales_data2__c where record_key__c IN :matrecordkeys order by name ASC])
    matmap.put(m.record_key__c, m.id);
    
  for(Account a:[select id, Account_number__c from Account where Account_number__c IN :accRecordkeys])
  {
     if(chemmap.containskey(a.Account_number__c))
       chemmap.put(a.account_number__c, a.id);
     else if(compmap.containskey(a.Account_number__c))
       compmap.put(a.account_number__c, a.id); 
     else if(plasmap.containskey(a.Account_number__c))
       plasmap.put(a.account_number__c, a.id); 
     else if(esmap.containskey(a.Account_number__c))
       esmap.put(a.account_number__c, a.id);  
     else if(copackmap.containskey(a.Account_number__c))
       copackmap.put(a.account_number__c, a.id);  
  }
  
  for(Customer_Product_Info__c c:trigger.new){
    String rk1 = c.material_number__c + c.Sales_org_Code__c + c.distribution_channel_Code__c;
    if(matmap.containskey(rk1))
       c.SAP_Material__c = matmap.get(rk1);
       
    String rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '31';// + G2;
    if(chemmap.containskey(rk2) && chemmap.get(rk2)!= '')
       c.chem_account__c = chemmap.get(rk2);
       
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '32' ;//+ G2;
    if(plasmap.containskey(rk2) && plasmap.get(rk2)!= '')
       c.plastics_account__c = plasmap.get(rk2);
       
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '33' ;//+ G2;
    if(compmap.containskey(rk2) && compmap.get(rk2)!= '')
       c.comp_account__c = compmap.get(rk2);
    
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '34' ;//+ G2;
    if(esmap.containskey(rk2) && esmap.get(rk2)!= '')
       c.es_account__c = esmap.get(rk2);
       
    rk2 = c.ShipTo_Number__c + c.Sales_Org_Code__c + c.Distribution_Channel_Code__c + '36' ;//+ G2;
    if(copackmap.containskey(rk2) && copackmap.get(rk2)!= '')
       c.CoPackAccount__c = copackmap.get(rk2);
       
    //To update SAP Plant record Id on CPI
    if(pmap.containskey(c.plant_code__c))
      c.SAP_Plant__c = pmap.get(c.plant_code__c).Id;
    
    if(c.Plant_Code__c == null)
        c.SAP_Plant__c = null;
    
     //To update SAP Inco Terms record Id on CPI  
    if(incomap.containskey(c.INCO_Terms1__c))
      c.SAP_INCO_Term__c = incomap.get(c.INCO_Terms1__c).Id;
  }
    /****************
     * Added By- Veralogics(Pranav)
     * Date- 27/01/2020
     * **************/
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        String CPIcheck = 'true';
        if(CPIcheck.containsIgnoreCase(System.Label.CPITriggerControl)){
            CPI_TriggerHandler.updateCPIOwner(trigger.New);
        }
    } 
}