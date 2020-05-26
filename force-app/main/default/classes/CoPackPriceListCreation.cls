public with sharing class CoPackPriceListCreation {
    
    public static void coPackPriceListSetup(Set<id> accGroupSet){
        List<ccrz__E_AccountGroup__c> accGroupList = new List<ccrz__E_AccountGroup__c>();
        Map<String, Set<ccrz__E_AccountGroupPriceList__c>> accGroupPLMap = new Map<String, Set<ccrz__E_AccountGroupPriceList__c>>();
        List<String> acclist = new List<String>();

        accGroupList = [select id, name, ccrz__AccountGroupID__c, Account__c, Account__r.CurrencyIsoCode, SalesArea__c, ccrz__Desc__c, ccrz__PriceListSelectionMethod__c 
                        from ccrz__E_AccountGroup__c where id in :accGroupSet];

        if(accGroupList.size()>0){
            for(ccrz__E_AccountGroup__c a :accGroupList){
                 acclist.add(a.ccrz__AccountGroupID__c);
            }
        }
        
        List<Customer_Product_Info__c>accCPIList = new List<Customer_Product_Info__c>();
        accCPIList = [Select id, Customer_Number__c, ShipTo_Number__c, Sales_Org_Code__c, CPI_Account__c, Chem_Account__c, Distribution_Channel_Code__c, Deletion_Indicator__c, 
                        SAP_Material__r.Division_Code__c, SAP_Material__r.Record_Key__c, CPI_Account__r.CurrencyIsoCode, CoPackAccount__c, CoPackAccount__r.CurrencyIsoCode, CoPackAccount__r.SAP_DivisionCode__c  
                        from Customer_Product_Info__c 
                        where CoPackAccount__c IN : acclist and CPI_Record_Type__c = '1' and Deletion_Indicator__c != 'X'];
        Map<String, List<Customer_Product_Info__c>> accCPIMap = new Map<String, List<Customer_Product_Info__c>>();
        
        for(Customer_Product_Info__c cpi :accCPIList)
        {
             if(accCPIMap.containsKey(cpi.CoPackAccount__c)) 
                accCPIMap.get(cpi.CoPackAccount__c).add(cpi);
            else 
                accCPIMap.put(cpi.CoPackAccount__c, new List<Customer_Product_Info__c>{cpi});

        }
        
        List<ccrz__E_AccountGroupPriceList__c> accGrpPriceList = new List<ccrz__E_AccountGroupPriceList__c>();
        accGrpPriceList = [Select Id, Type__c, ccrz__AccountGroup__c, ccrz__AccountGroupPriceListID__c, ccrz__Pricelist__c, ccrz__Sequence__c 
                            from ccrz__E_AccountGroupPriceList__c where ccrz__AccountGroup__c IN :accGroupSet];

        List<ccrz__E_AccountGroupPriceList__c> accGrpPLtoInsert = new List<ccrz__E_AccountGroupPriceList__c>();

        //Map<String, String> mapPL = getCPIPriceListMap();
        Map<String, Set<String>> plType = new Map<String, Set<String>>();

        //Create a Map of Account Group and Set of Account Group Price List if Account Group already has some Account Group Price List records associated
        if(accGrpPriceList.size()>0){
            for(ccrz__E_AccountGroupPriceList__c p : accGrpPriceList){
                if(accGroupPLMap.containsKey(p.ccrz__AccountGroup__c))    
                    accGroupPLMap.get(p.ccrz__AccountGroup__c).add(p);
                else
                    accGroupPLMap.put(p.ccrz__AccountGroup__c, new Set<ccrz__E_AccountGroupPriceList__c>{p});   
            }
        }
        for(ccrz__E_AccountGroup__c ag :accGroupList)
        {
            if(accGroupPLMap.get(ag.id) == null)
                accGroupPLMap.put(ag.id, new Set<ccrz__E_AccountGroupPriceList__c>{});

        }

        //If no Account Group Price Lists are associated to Account Group, create AGPL records
        //This is for associating 'SalesArea - All Products' Price List 
        for(ccrz__E_AccountGroup__c ag :accGroupList){
            if(accGroupPLMap.get(ag.id).size() > 0){
                for(ccrz__E_AccountGroupPriceList__c p :accGroupPLMap.get(ag.id)){
                    if(p.Type__c == 'CPIPriceList'){ //Check if CPIPriceList is added in the Account Group
                        if(plType.containsKey(ag.id) && !plType.get(ag.id).contains('CPIPriceList')) {
                        plType.put(ag.id, new Set<String>{'CPIPriceList'});}
                     }
                }//end of for p
            } //end of accGroupPLMap.get(ag.id).size() check
             else if(accGroupPLMap.get(ag.id).size() == 0){
                plType.put(ag.id, new Set<String>{});
            }
                
        }

    
        List<ccrz__E_PriceList__c> lstCPIPList = new List<ccrz__E_PriceList__c>();
        List<ccrz__E_PriceList__c> lstPListnew = new List<ccrz__E_PriceList__c>();
        for(ccrz__E_AccountGroup__c ag :accGroupList){
            if((plType.isEmpty()) || (!plType.get(ag.id).contains('CPIPriceList'))){
                //Call the function to create CPI Price List for account
                //and create Account Group Price List for CPI Price List
                if(!accCPIMap.isEmpty() && accCPIMap.get(ag.ccrz__AccountGroupID__c) != null){
                    system.debug('@@ ag.ccrz__AccountGroupID__c is :' +ag.ccrz__AccountGroupID__c);
                    if(accCPIMap.get(ag.ccrz__AccountGroupID__c).size()>0){
                        List<Customer_Product_info__c> temp = accCPIMap.get(ag.ccrz__AccountGroupID__c);
                        system.debug('@@ temp.size() is :' +temp.size());
                        if(temp.size()>0){
                            lstCPIPList = create_coPack_PriceList(accCPIMap.get(ag.ccrz__AccountGroupID__c));
                        }
                    }
                }
                else{
                    if(ag.name!=''){

                        ccrz__E_PriceList__c  recPL = new ccrz__E_PriceList__c();
                        recPL.ccrz__PricelistId__c = ag.name;
                        recPL.SalesArea__c = ag.name;
                        recPL.Name = ag.name;
                        recPL.ccrz__CurrencyISOCode__c = ag.Account__r.CurrencyIsoCode;
                        recPL.ccrz__Storefront__c = 'mynexeo';
                        recPL.PriceListType__c = 'CPIPriceList';
                        lstPListnew.add(recPL);         
    
                    }
                 }
            }
        }
        System.debug('lstPListnew.size is : '+lstPListnew.size());
        List<Database.Upsertresult> upsertPList =  new List<Database.Upsertresult>();
        upsertPList = Database.upsert(lstPListnew, ccrz__E_PriceList__c.ccrz__PricelistId__c, false);

        //Error handling - Store the errors in case of failure
        if(upsertPList.size()>0){
            for(integer i=0; i<upsertPList.size();i++){
                if (upsertPList.get(i).isSuccess()){
                    upsertPList.get(i).getId();
                }
                else if (!upsertPList.get(i).isSuccess()){
                    // Upsert DML operation failed
                    Database.Error error = upsertPList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    lstPListnew.get(i);//failed record from the list
                    system.debug('Failed Material Record Key : '+lstPListnew.get(i).ccrz__PricelistId__c+': '+failedDML);
    
                }
             }
        }
        system.debug('lstCPIPList.size():'+lstCPIPList.size());
        Map<String, String> mapPL = new Map<String,String>();
        //mapPL = getCPIPriceListMap();
        //Scenario: For New Users registering on website for new SAP Customer
        //Create a CPI Account Group Price List even if there is no CPI associated to the Account 
        //if(lstCPIPList.size() > 0){system.debug('inside size : 1');

        for(ccrz__E_PriceList__c p: lstCPIPList){
            if(!mapPL.containsKey(p.SalesArea__c)){system.debug('inside size 2:');
                mapPL.put(p.SalesArea__c, p.id);}
        }
    
        for(ccrz__E_AccountGroup__c ag :accGroupList){

            if((plType.isEmpty()) || (!plType.get(ag.id).contains('CPIPriceList'))){
                ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c();
                agpl.ccrz__AccountGroup__c = ag.id;
                agpl.ccrz__Pricelist__c =  mapPL.get(ag.Name);      
                agpl.Type__c = 'CPIPriceList';
                agpl.ccrz__Sequence__c = 500;
                agpl.ccrz__AccountGroupPriceListID__c = ag.id+'-'+agpl.Type__c; 
                accGrpPLtoInsert.add(agpl);  
            }      
        }    

        if(accGrpPLtoInsert.size()>0){
            List<Database.upsertResult> insertResult =  new List<Database.upsertResult>();
            insertResult = Database.upsert(accGrpPLtoInsert, ccrz__E_AccountGroupPriceList__c.ccrz__AccountGroupPriceListID__c, false);

            //Error handling - Store the errors in case of failure
            if(insertResult.size()>0){
                for(integer i=0; i<insertResult.size();i++){
                    if (insertResult.get(i).isSuccess()){
                        insertResult.get(i).getId();
                    }
                    else if (!insertResult.get(i).isSuccess()){
                        // Upsert DML operation failed
                        Database.Error error = insertResult.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        accGrpPLtoInsert.get(i);//failed record from the list
                        system.debug('Failed Material Record Key : '+accGrpPLtoInsert.get(i).ccrz__AccountGroupPriceListID__c +': '+failedDML);
                     }
                }
            }
         }
        
    }
    
    public static List<ccrz__E_PriceList__c> create_coPack_PriceList(List<Customer_Product_Info__c> cpiList){
    
        Map<String, String> mapCPIPriceList = new Map<String, String>();
        Set<String> plid = new Set<String>();
        for(Customer_Product_Info__c cpi : cpiList)
        {     
            String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CoPackAccount__r.SAP_DivisionCode__c;
            plid.add(sRecKey);
        }
        mapCPIPriceList = getCPIPriceListMap(plid);
        List<ccrz__E_PriceList__c> lstCPIPList = new List<ccrz__E_PriceList__c>();
        List<ccrz__E_PriceListItem__c> lstPLI = new List<ccrz__E_PriceListItem__c>();

        Map<String, String> mapMatToProd = new Map<String, String>();
        List<String> prodMatId = new List<String>();
        Set<String> recKeyPLlst = new Set<String>();

        for(Customer_Product_Info__c cpi : cpiList)
        {    //Need to confirm the record key for this!!!
            //String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.SAP_Material__r.Division_Code__c;  
            String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CoPackAccount__r.SAP_DivisionCode__c;
            system.debug('sRecKey :'+sRecKey);
            if(mapCPIPriceList.isEmpty() || !mapCPIPriceList.containsKey(sRecKey))
            {
                if(!recKeyPLlst.contains(sRecKey)){
                    ccrz__E_PriceList__c  recPL = new ccrz__E_PriceList__c();
                    recPL.ccrz__PricelistId__c = sRecKey;
                    recPL.SalesArea__c = sRecKey;
                    recPL.Name = sRecKey;
                    recPL.ccrz__CurrencyISOCode__c = cpi.CoPackAccount__r.CurrencyIsoCode;
                    recPL.ccrz__Storefront__c = 'mynexeo';
                    recPL.PriceListType__c = 'CPIPriceList';
                    lstCPIPList.add(recPL);
                    recKeyPLlst.add(sRecKey);}
             }
            prodMatId.add(cpi.SAP_Material__r.Record_Key__c);
        }

        mapMatToProd = Cloudcraze_Product_Function.getMatToProdMap(prodMatId);


        System.debug('lstCPIPList.size is : '+lstCPIPList.size());
        List<Database.Upsertresult> upsertPList =  new List<Database.Upsertresult>();
        upsertPList = Database.upsert(lstCPIPList, ccrz__E_PriceList__c.ccrz__PricelistId__c, false);

        //Error handling - Store the errors in case of failure
        if(upsertPList.size()>0){
             for(integer i=0; i<upsertPList.size();i++){
                if (upsertPList.get(i).isSuccess()){
                    upsertPList.get(i).getId();
                }
                else if (!upsertPList.get(i).isSuccess()){
                    // Upsert DML operation failed
                    Database.Error error = upsertPList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    lstCPIPList.get(i);//failed record from the list
                    system.debug('Failed Material Record Key : '+lstCPIPList.get(i).ccrz__PricelistId__c+': '+failedDML);
    
                }
            }
        }

        if(lstCPIPList.size()>0){
            mapCPIPriceList = getCPIPriceListMap(plid);
        }

        Set<String> recKeyPLIlst = new Set<String>();

        for(Customer_Product_Info__c cpi : cpiList)
        {
            //Need to decide on this key 
            //String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.SAP_Material__r.Division_Code__c;
            String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CoPackAccount__r.SAP_DivisionCode__c;
            system.debug('sRecKey:'+sRecKey);
   
            if(!recKeyPLIlst.contains(sRecKey)){         
                ccrz__E_PriceListItem__c PLI = new ccrz__E_PriceListItem__c();
       
                if(mapCPIPriceList.containsKey(sRecKey))
                    PLI.ccrz__Pricelist__c = mapCPIPriceList.get(sRecKey);
                //get the product record for corresponding SAP Material record
                if(mapMatToProd.containsKey(cpi.SAP_Material__r.Record_Key__c))
                    PLI.ccrz__Product__c = mapMatToProd.get(cpi.SAP_Material__r.Record_Key__c);
                PLI.ccrz__Price__c = 0;
                PLI.ccrz__PricelistItemId__c = PLI.ccrz__Pricelist__c+'-'+PLI.ccrz__Product__c+'-'+cpi.id;
                //PLI.CPI_Deletion_Indicator__c = cpi.Deletion_Indicator__c;
                PLI.CPI__c = cpi.id;
                system.debug('PLI.ccrz__PricelistItemId__c:'+PLI.ccrz__PricelistItemId__c);
                lstPLI.add(PLI);
                recKeyPLIlst.add(PLI.ccrz__PricelistItemId__c);
            }

        }

        //upsert the CPI related Price List Item in CPI Price List
        List<Database.Upsertresult> upsertPLI =  new List<Database.Upsertresult>();
        upsertPLI = Database.upsert(lstPLI, ccrz__E_PriceListItem__c.ccrz__PricelistItemId__c, false);

        //Error handling - Store the errors in case of failure
        if(upsertPLI.size()>0){
            for(integer i=0; i<upsertPLI.size();i++){
                if (upsertPLI.get(i).isSuccess()){
                    upsertPLI.get(i).getId();
                }
                else if (!upsertPLI.get(i).isSuccess()){
                    // Upsert DML operation failed
                    Database.Error error = upsertPLI.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    lstPLI.get(i);//failed record from the list
                    system.debug('Failed Material Record Key : '+lstPLI.get(i).ccrz__PricelistItemId__c+': '+failedDML);
    
                }
            }
        }

        return lstCPIPList;
        
    }
    
    public static Map<String, String> getCPIPriceListMap(Set<String> Pkey) {
        Map<String, String> mapPlist = new Map<String, String>();
        List<ccrz__E_PriceList__c> lstPlist = [Select id, ccrz__PricelistId__c, PriceListType__c from ccrz__E_PriceList__c where ccrz__PricelistId__c IN: Pkey];
        for(ccrz__E_PriceList__c p: lstPlist)
        {
            String sCPI = p.ccrz__PricelistId__c;
          
            if(sCPI != null && sCPI.trim().length()>0)
                mapPlist.put(sCPI,p.id);   
        }
     
        return mapPlist;     
    }
    
    public static void update_CoPack_PriceList(List<Customer_Product_Info__c> cpiList){
        
        Map<String, String> mapPL = new Map<String, String>();
        Map<String, String> mapCpiMaterial = new Map<String, String>();
        Map<String, String> mapPLItem = new Map<String, String>();
        List<ccrz__E_PriceListItem__c> plItemList = new List<ccrz__E_PriceListItem__c>(); 
        List<ccrz__E_PriceList__c> plst = new List<ccrz__E_PriceList__c>();
        List<ccrz__E_PriceListItem__c> lstPLI = new List<ccrz__E_PriceListItem__c>();
        List<String> keyList = new List<String>();
        List<id> matId = new List<id>();
        List<Material_Sales_Data2__c> lstMaterialsToUpdate = new List<Material_Sales_Data2__c>();
        List<Id> lstMaterialIds = new List<Id>();
    
        for(Customer_Product_Info__c cpi :cpiList){
            if(cpi.SAP_Material__r.Create_CC_Product__c == false){
                lstMaterialIds.add(cpi.SAP_Material__r.id);
            }
        }
        
        lstMaterialsToUpdate = [Select Id, Create_CC_Product__c from Material_Sales_Data2__c where Id IN : lstMaterialIds];
    
        for(Material_Sales_Data2__c msd : lstMaterialsToUpdate){
            msd.Create_CC_Product__c = true;
        }
       
        if(lstMaterialsToUpdate.size()>0) {
            update lstMaterialsToUpdate;}
    
        for(Customer_Product_Info__c cpi: cpiList)
        {              
            matId.add(cpi.SAP_Material__c);
            //Need to decide on this key
            //String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.SAP_Material__r.Division_Code__c;
            String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CoPackAccount__r.SAP_DivisionCode__c;
            keyList.add(sRecKey);
            system.debug('sRecKey:'+sRecKey);
            //String CPIrecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.SAP_Material__r.Division_Code__c+'-'+cpi.SAP_Material__c; 
            String CPIrecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CoPackAccount__r.SAP_DivisionCode__c+'-'+cpi.SAP_Material__c;
   
            if(mapPL.isEmpty() || !mapPL.containsKey(sRecKey))
                mapPL.put(sRecKey, cpi.id);
        
            if(mapCpiMaterial.isEmpty() || !mapCpiMaterial.containsKey(CPIrecKey))
                mapCpiMaterial.put(CPIrecKey, cpi.Id);
    
            system.debug('Initial mapCpiMaterial.size: '+mapCpiMaterial.size());

        }
        system.debug('matId:'+matId);
        List<ccrz__E_Product__c> prodList = [select id, name, SAP_Material__c from ccrz__E_Product__c where SAP_Material__c in : matId ];
        system.debug('prodList.size is :'+prodList.size());
    
        if(keyList.size()>0)
        {
            plItemList = [select id, ccrz__Pricelist__r.Id,ccrz__Pricelist__r.Name, ccrz__Pricelist__c, ccrz__Product__c,ccrz__Product__r.SAP_Material__c from ccrz__E_PriceListItem__c where ccrz__Pricelist__r.Name in:keyList];
        }
        
        system.debug('plItemList.size is :'+plItemList.size());
        if(plItemList.size()>0)
    
        {
            For(ccrz__E_PriceListItem__c plilist: plItemList)
            {
                String plItemKey = plilist.ccrz__Pricelist__r.Name+'-'+plilist.ccrz__Product__r.SAP_Material__c;
                if(mapPLItem.isEmpty() || !mapPLItem.containsKey(plItemKey))
                    mapPLItem.put(plItemKey, plilist.ccrz__Product__c);
            }       
            system.debug('mapPLItem: '+mapPLItem.Keyset());
    
        }
        List<ccrz__E_PriceList__c> listPriceList = [select Id,Name from ccrz__E_PriceList__c where Name in:keyList];
    
    
        system.debug('mapCpiMaterial.Keyset() : '+mapCpiMaterial.Keyset());
        for(String keyId: mapCpiMaterial.Keyset()){
           if(mapPLItem.keyset().contains(keyId)){
               system.debug('Entered if : ');
               mapCpiMaterial.remove(keyId);
           }
        }
        system.debug('mapCpiMaterial.size() is '+mapCpiMaterial.size());       
   
        for(String keyId:mapCpiMaterial.Keyset()){
            if(listPriceList.size()>0){
                for(ccrz__E_PriceList__c c: listPriceList){
                    if(c.Name!= ''  && c.name == keyId.split('-')[0]){
                        if(prodList.size()>0){
                            system.debug('Entered Second for');
                            for(ccrz__E_Product__c p: prodList){
                                if(p.Sap_Material__c != null && p.Sap_Material__c == keyId.split('-')[1]){
                                    system.debug('Entered Third for');
                                    ccrz__E_PriceListItem__c PLI = new ccrz__E_PriceListItem__c();      
                                    PLI.ccrz__Pricelist__c = c.id;            
                                    PLI.ccrz__Product__c = p.id;
                                    PLI.ccrz__Price__c = 0;
                                    PLI.CPI__c = mapCpiMaterial.get(keyId);
                                    PLI.ccrz__PricelistItemId__c = PLI.ccrz__Pricelist__c+'-'+PLI.ccrz__Product__c+'-'+PLI.CPI__c;
                                    system.debug('PLI.ccrz__PricelistItemId__c:'+PLI.ccrz__PricelistItemId__c);
                                    lstPLI.add(PLI);                                                                              
                                 
                                 }
                              }
                          }    
                      }
                  }
               }                
           }
        

         
   
        system.debug('lstPLIsize:'+lstPLI.size()); 
        system.debug('lstPLIsize:'+lstPLI);

        if(lstPLI.size()>0){
        //upsert the CPI related Price List Item in CPI Price List
            List<Database.Upsertresult> upsertPLI =  new List<Database.Upsertresult>();
            upsertPLI = Database.upsert(lstPLI, ccrz__E_PriceListItem__c.ccrz__PricelistItemId__c, false);
        
        //Error handling - Store the errors in case of failure
            if(upsertPLI.size()>0){
                for(integer i=0; i<upsertPLI.size();i++){
                    if (upsertPLI.get(i).isSuccess()){
                            upsertPLI.get(i).getId();
                    }
                    else if (!upsertPLI.get(i).isSuccess()){
                        // Upsert DML operation failed
                         Database.Error error = upsertPLI.get(i).getErrors().get(0);
                         String failedDML = error.getMessage();
                         lstPLI.get(i);//failed record from the list
                         system.debug('Failed Material Record Key : '+lstPLI.get(i).ccrz__PricelistItemId__c+': '+failedDML);
            
                    }
                 }
             }
         } 
    }
}