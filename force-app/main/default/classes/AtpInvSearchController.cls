global class AtpInvSearchController {

    
    Public Account_Material__c amId {get; set;}
    public string response {get; set;}
    public string matNum {get; set;}
    public string source;
    public AtpInvSearchController(apexpages.standardcontroller sc) {
        amId = (Account_Material__c)sc.getRecord();
        source = ApexPages.currentPage().getParameters().get('source');
        
    }

    public pagereference checkInv(){
        //Date convDate = date.valueOf(shipToDate);
        Map<String,String> respMap = new Map<String,String>();
        if(amId.Ship_Date__c < system.today()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a future date'));
        }
        else{
            Account_material__c accMat = [Select Id, Account__c,Account__r.SAP_Sales_Org__c,Account__r.SAP_DistChannel__c,Account__r.SAP_DivisionCode__c,Account__r.Sold_To_Customer_Number__c,Account__r.SAP_Sold_To_Account_Number__c,Account__r.AccountNumber,SAP_Material__r.Material_Number__c,SAP_Plant_Code__c,Ship_Date__c,Quantity__c,ATP_UOM__c from Account_Material__c where Id =: amId.Id];
            Account acc = accMat.Account__r;
            List<Account_Material__c> accMats = new List<Account_Material__c>();
            accMats.add(amId);
            matNum = accMat.SAP_Material__r.Material_Number__c;
            //matNum = [select id, SAP_Material__r.Material_Number__c from Account_Material__c where id =: amId.Id].SAP_Material__r.Material_Number__c;
            //response = atpInventoryCallOut.doPost(accMat,acc,amId.Ship_Date__c,amId.Quantity__c,amId.ATP_UOM__c)+' '+amID.Ship_Date__c+' '+amId.Quantity__c+' '+amId.ATP_UOM__c;
            
            respMap = atpInventoryCallOut.doPost(accMats,acc,source);
            system.debug('check this out'+matNum);
            if(respMap.ContainsKey(matNum)){
                response = respMap.get(matNum);
                system.debug('I am inside if '+response);
            }
            else{
                response = 'Material may be available. Please contact Customer Solutions to determine availability.';
            }
            system.debug(amId.Quantity__c);
            //response = atpInventoryCallOut.doPost(accMat,acc)+' '+amID.Ship_Date__c+' '+amId.Quantity__c+' '+amId.ATP_UOM__c;
        }
       return null;
    }
    
    public List<SelectOption> getStockingUnitCodes(){
     List<SelectOption> options = new List<SelectOption>();
     //options.add(new SelectOption('--None--', '--None--'));
     Id msd = [Select Id,SAP_Material__c from Account_Material__c where Id =: amId.Id].SAP_Material__c;
     if(msd != null){
      for(Material_UOM2__c mUOM : Material_Sales_Data_Functions.getAltUOMs(msd)){
       options.add(new SelectOption(mUOM.Alternative_UOM__c, mUOM.Alternative_UOM__c));
      }
     }
     return options;
    }
}