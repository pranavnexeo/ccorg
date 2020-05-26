public class CdfTriggerHandler {
    
    public static boolean firstRun = true;
    public static void Updatesellerandsales(List<Contract> cdflist){
        set<Id> prupdate = new set<Id>();
        map<string,Account> accountIdWFUsermap = new map<string,Account>();
        map<string,Material_Sales_Data2__c> sapmatmap = new map<string,Material_Sales_Data2__c>();
        list<account> accountList = New List<account>();
    
        for(Contract pr : cdflist){
        //If(bc.id != null){
            prupdate.add(pr.id);
            accountIdWFUsermap.put(pr.Accountid,pr.Account);
            sapmatmap.put(pr.SAP_Material__c,pr.SAP_Material__r);
            
        //}
        }
        //accountList  = [SELECT ID,YY_Partner__r.YS_Partner__r.User__c from account where Id =: accountIdWFUsermap.keyset()];

        for(account objAcc : [SELECT Primary_Seller__c, Primary_Sales_Support__c, ID,YY_Partner__c,YY_Partner__r.YS_Partner__r.User__c,YZ_Partner__c,YZ_Partner__r.ZS_Partner__r.User__c,SAP_Customer_Group_2_Desc__c,
                                YY_Partner__r.ZS_Partner__r.User__c,YZ_Partner__r.Ys_Partner__r.User__c 
                                from account 
                                where Id =: accountIdWFUsermap.keyset()]){
            accountIdWFUsermap.put(objAcc.id,objAcc);
    
        }
    
        for(Material_Sales_Data2__c objMat : [SELECT ID,Material_Group3_Desc__c from Material_Sales_Data2__c where Id =: sapmatmap.keyset()]){
            sapmatmap.put(objMat.id,objMat);
        }
        for(Contract prt: cdflist){
            if(PRT.SAP_Material__c != null && SAPmatmap.containskey(prt.SAP_Material__c)){
                if(sapmatmap.get(prt.SAP_Material__c).Material_Group3_Desc__c == 'SPECIALTY'){
                    if((accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.ZS_Partner__r.User__c != null) && accountIdWFUsermap.containskey(prt.Accountid)){
                        prt.Seller__c= accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.ZS_Partner__r.User__c;
                    }
                    else if(accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.ZS_Partner__r.User__c == null){
                        prt.Seller__c = null;
                    }    
                    if((accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.YS_Partner__r.User__c != null) && accountIdWFUsermap.containskey(prt.Accountid)){
                        prt.Sales_Support__c= accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.YS_Partner__r.User__c;
                    }
                    else if(accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.YS_Partner__r.User__c == null){
                        prt.Sales_Support__c = null;
                    }
                    //Added by Spuran to populate Non Primary seller
                    if(accountIdWFUsermap.containskey(prt.Accountid) && accountIdWFUsermap.get(prt.Accountid).YY_Partner__c != null &&accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.ZS_Partner__r.User__c != null){
                        prt.Non_Primary_Seller__c = accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.ZS_Partner__r.User__c;
                    }
                    else if(accountIdWFUsermap.get(prt.Accountid).YY_Partner__c == null || accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.ZS_Partner__r.User__c == null){
                        prt.Non_Primary_Seller__c = null;
                    }
                }
        
                else if(sapmatmap.get(prt.SAP_Material__c).Material_Group3_Desc__c == 'COMMODITY'){
                    if((accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.ZS_Partner__r.User__c != null) && accountIdWFUsermap.containskey(prt.Accountid)){
                        prt.Seller__c= accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.ZS_Partner__r.User__c;
                    }
                    else if(accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.ZS_Partner__r.User__c == null){
                        prt.Seller__c = null;
                    } 
                    if((accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.YS_Partner__r.User__c != null) && accountIdWFUsermap.containskey(prt.Accountid)){
                        prt.Sales_Support__c= accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.YS_Partner__r.User__c;
                    }
                    else if(accountIdWFUsermap.get(prt.Accountid).YY_Partner__r.YS_Partner__r.User__c == null){
                        prt.Sales_Support__c = null;
                    }
                    //Added by Spuran to populate Non Primary seller
                    if(accountIdWFUsermap.containskey(prt.Accountid) && accountIdWFUsermap.get(prt.Accountid).YZ_Partner__c != null &&accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.ZS_Partner__r.User__c != null){
                        prt.Non_Primary_Seller__c = accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.ZS_Partner__r.User__c;
                    }
                    else if(accountIdWFUsermap.get(prt.Accountid).YZ_Partner__c == null || accountIdWFUsermap.get(prt.Accountid).YZ_Partner__r.ZS_Partner__r.User__c == null){
                        prt.Non_Primary_Seller__c = null;
                    }
        
                }
            else{
                prt.Seller__c = accountIdWFUsermap.get(prt.AccountId).Primary_Seller__c;
                prt.Sales_Support__c = accountIdWFUsermap.get(prt.AccountId).Primary_Sales_Support__c;
            }
        }
      }
    }
    
    
    public static void updateApproverandComments(List<Contract> cdflist, map<id, Contract> oldcdf){
        Set<Id> ids = new set<Id>();
        Set<Id> matids = new set<Id>(); //Material Sales Data2 Ids
        Set<String> MaterialNumbers = new set<String>(); //Material Numbers
        Set<Id> plntids = new set<Id>();//SAP Plant Id's
  
        for(contract c: cdflist){
            //Add Material Sales Data2 Ids to a Set
            if(c.SAP_Material__C != null){
                matids.add(c.SAP_Material__c);
            }
            //Add CDF Ids to a set if record has just been approved or rejected
            if(oldcdf.get(c.id).status != c.status && (c.status == 'Activated' || c.status == 'Rejected - Never Activated')){
                ids.add(c.id);
            }
            if(c.Default_Shipping_Plant__c != null){
                plntids.add(c.Default_Shipping_Plant__c);
            }
        }
  
        //Material Sales Data2 Map
        Map<Id,Material_Sales_Data2__c> mmap = new Map<Id, Material_Sales_Data2__c>([select id, Material_Number__c from Material_Sales_Data2__c where id IN :matids]);
  
        //Add Material Numbers to a Set
        for(Material_Sales_Data2__c msd2:mmap.values()){
            materialnumbers.add(msd2.Material_Number__c);
        }
  
        //Map of Material Number + Plant Number to User Id 
        Map<String, Id> mp2map = new map<String, Id>();
        
        //Map of PlantId to Plant Code
        Map<Id,String> plt2Codemap = new map<Id,String>();
  
        //Query Material Plant 2 for material numbers above. Put the SAP Purchasing Analyst User Id in the Map
        for(Material_Plant2__c mp2:[select id, Record_Key__c, SAP_Purchasing_Analyst__r.User__c, Plant_Code__c, Material_Number__c from Material_Plant2__c where Material_Number__c IN :materialnumbers]){
            system.debug('mp2: ' + mp2);
            mp2map.put(mp2.Material_Number__c + mp2.plant_Code__c, mp2.SAP_Purchasing_Analyst__r.User__c);
        }
        
        for(SAP_Plant__c sp2:[select id, Plant_Code__c from SAP_Plant__c where ID IN :plntids]){
            system.debug('sp2: ' + sp2);
            plt2Codemap.put(sp2.Id, sp2.Plant_Code__c );
        }
  
        system.debug(mp2map);
        //Get the Last Approvers Comments
        Map<id, string> commentmap = Approval_Functions.getLastApproversComments(ids);
  
        for(contract c : cdflist){
     
            //Set the Approver
            /*if(mmap.containskey(c.SAP_Material__c)){
                if(c.Stocking_Warehouse__c != null){
                    system.debug('key: ' + (mmap.get(c.SAP_Material__c).material_number__c + c.Stocking_Warehouse__c.substring(0, 4)));
                    if(mp2map.containskey(mmap.get(c.SAP_Material__c).material_number__c + c.Stocking_Warehouse__c.substring(0, 4))){
                        if(mp2map.get(mmap.get(c.SAP_Material__c).material_number__c + c.Stocking_Warehouse__c.substring(0, 4)) != null){
                            c.Approver__c = mp2map.get(mmap.get(c.SAP_Material__c).material_number__c + c.Stocking_Warehouse__c.substring(0, 4));
                        }
                    }
                }
            }*/  
            
            if(mmap.containskey(c.SAP_Material__c)){
                if(c.Default_Shipping_Plant__c != null && plt2Codemap.containskey(c.Default_Shipping_Plant__c)){
                    //system.debug('key: ' + (mmap.get(c.SAP_Material__c).material_number__c + c.Stocking_Warehouse__c.substring(0, 4)));
                    if(mp2map.containskey(mmap.get(c.SAP_Material__c).material_number__c + plt2Codemap.get(c.Default_Shipping_Plant__c))){
                        if(mp2map.get(mmap.get(c.SAP_Material__c).material_number__c + plt2Codemap.get(c.Default_Shipping_Plant__c)) != null){
                            c.Approver__c = mp2map.get(mmap.get(c.SAP_Material__c).material_number__c + plt2Codemap.get(c.Default_Shipping_Plant__c));
                        }
                    }
                }
            }
       
            //Move the last comments over.
            if(ids.contains(c.id) && commentmap.containskey(c.id)){
                if(c.buyer_comments__c != '' && c.buyer_comments__c != null){
                    if(commentmap.get(c.id) != 'No Comments' && !c.buyer_comments__c.contains(commentmap.get(c.id)))
                        { string comment= (c.buyer_comments__c +'\n' + commentmap.get(c.id));
                        system.debug('++'+comment);
                            if(comment.length() > 250){ c.addError('Comments must be lower than 250 characters. Current Character Count: ' + comment.length()); }
                            else{ c.buyer_comments__c = comment; }
                        //c.buyer_comments__c = comment.abbreviate(250); 
                    }
                }
                else if(commentmap.get(c.id) != 'No Comments'){
                    string comment = commentmap.get(c.id);
                    if(comment.length() > 250){ c.addError('Comments must be lower than 250 characters. Current Character Count: ' + comment.length()); }
                    else{ c.buyer_comments__c = comment; }
                    //c.buyer_comments__c = comment.abbreviate(250); 
                }
            }
        }  
    }
    public static void submitClonedCdf(List<Contract> cdflist){
        for(Contract c : cdflist){
            if(!Approval.isLocked(c.Id) && c.Status == 'Draft' && c.Cloned_From__c != null && (!c.Business_Contract_Required__c || (c.Business_Contract_Required__c && c.Business_Contract__c != null && c.Business_Contract_Status__c == 'Activated'))){
                // create new approval request 
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(c.id);
                // submit the approval request
                Approval.ProcessResult result = Approval.process(req);
            }
        }
    }
    public static void UpdateCdfFields(List<Contract> cdflist, map<id, Contract> oldcdf){
        UpdatePlmField(cdflist, oldcdf);
        Set<Id> accIds = new Set<Id>();
        Set<Id> matIds = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        Map<Id,Customer_Product_Info__c> CPIPlant = new Map<Id,Customer_Product_Info__c>();
        Set<String> accNums = new Set<String>();
        List<Customer_Product_Info__c> cpiList = new List<Customer_Product_Info__c>();
        for(Contract con : cdflist){
            if(con.AccountId != null)
                accIds.add(con.AccountId);
            if(con.SAP_Material__c != null)
                matIds.add(con.SAP_Material__c);
        }
        
        
        for(account objAcc : [SELECT Id, AccountNumber,SAP_Plant__c
                                    from account 
                                    where Id =: accIds]){
            accMap.put(objAcc.id,objAcc);
            accNums.add(objAcc.AccountNumber);
        }
        
        cpilist = [Select ID,SAP_Plant__c,ShipTo_Number__c,SAP_Material__c 
                    from Customer_Product_Info__c 
                    where ShipTo_Number__c IN: accNums AND SAP_Material__c IN: matIds and CPI_Record_Type__c='1' and Deletion_Indicator__c != 'X'];
        
        if(!cpiList.isEmpty()){
            for(Customer_Product_Info__c cpi : cpiList){
                CPIPlant.put(cpi.SAP_Material__c,cpi);
            }
        }
        
        for(Contract c : cdflist){
            if(CPIPlant.containskey(c.SAP_Material__c) && CPIPlant.get(c.SAP_Material__c).SAP_Plant__c != null){
                c.Default_Shipping_Plant__c = CPIPlant.get(c.SAP_Material__c).SAP_Plant__c;
            }
            else{
                if(accMap.containskey(c.AccountId) && accMap.get(c.AccountId).SAP_Plant__c != null ){
                    c.Default_Shipping_Plant__c = accMap.get(c.AccountId).SAP_Plant__c;
                }
            }
            /*if(c.ContractTerm == null){
                c.ContractTerm = 4;
            }*/
            
        }
        
    }
    
    public static boolean isFirstRun(){
        if(firstRun){
            firstRun = false;
            return true;
         }else{
            return firstRun;
        }
    }
    
    public static void UpdatePlmField(List<Contract> ConList, map<id, Contract> oldMap){
        Set<Id> matIds = new Set<Id>();
        Map<Id,String> plmMap = new Map<Id, String>();
        Map<String,Id> userMap = new Map<String,Id>();
        for(Contract b : ConList){
            if(b.SAP_Material__c != null && (oldMap == null || (oldMap != null && b.SAP_Material__c != oldMap.get(b.Id).SAP_Material__c)))
              matIds.add(b.SAP_Material__c);  
        }
        if(!matIds.isEmpty()){
            for(Material_Sales_Data2__c mat : [Select Id, Material_Group2_Code__c from Material_Sales_Data2__c where Id IN: matIds]){
                if(mat.Material_Group2_Code__c != null)
                    plmMap.put(mat.Id,mat.Material_Group2_Code__c);
            }
            
            for(User u : [Select Id, PLM_Number__c from User where PLM_Number__c != null]){
                List<String> plmNums = u.PLM_Number__c.split(',');
                for(String s : plmNums){
                    userMap.put(s.trim(),u.Id);
                }
            }
            
            for(Contract c : ConList){
                if(c.SAP_Material__c != null){
                    String mtcode = plmMap.containskey(c.SAP_Material__c)?plmMap.get(c.SAP_Material__c):null;
                    if(mtcode != null){
                       c.PLM__c =  userMap.containskey(mtcode)?userMap.get(mtcode):null;
                    }
                }
                
            }
        }
    }
    public static void UpdateQuantities(List<Contract> ConList){
        for(Contract c : ConList){
            if(c.Order_Frequency__c == 'Every Other Month – Ongoing'){
                c.Quantity_2__c = null;
                c.Quantity_4__c = null;
            
            }
            if(c.Order_Frequency__c == 'Once Per Quarter – Ongoing'){
                c.Quantity_2__c = null;
                c.Quantity_3__c = null;
                c.Quantity_4__c = null;
            }
        }
    }
}