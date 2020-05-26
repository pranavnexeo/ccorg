/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        11/20/2012
*    Author:             Matthew Rumschlag
*   Last Modified:       Sneha Likhar
*   Last Modified By:    10/13/2016
*
*   Short Description:  Update CPI Account Lookup fields.
*   **********************************************************************************************************************/

trigger CPI_AfterUpsert on Customer_Product_Info__c (After update, After insert) {
    
Set<Id> CPIIds = new Set<Id>();
Set<String> AccountIds = new Set<String>();
List<Customer_Product_Info__c> CPIS= new List<Customer_Product_Info__c>(); 
Set<String> MaterialIds = new Set<String>();
Map<Id,Id> AccIdAcctOwnerIdMap = new map<Id,Id>();
Map<Id,Id> CPIAndAccount = new map<Id,Id>();    
Set<String> AccountMaterialIds = new set<String>();
Map<Id, List<String>> IdMap = new Map<Id, List<String>>();
    //*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++       
    Map<Id, List<String>> IdClauseValuesMap = new Map<Id, List<String>>();
    List<String> AllclauseValues = new list<String>();
    Map<Id,String> ConcatenatedClauses = new Map<Id,String>();
    //Set<String> MaterialIds = new Set<String>();
    //*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  for(Customer_Product_Info__c c:trigger.new)
  {
    CPIIds.add(c.id);
    set<String> values= new set<String>();   
    List<String> ids = new list<String>();
    List<String> clauseValues = new list<String>();
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     if(c.ShipTo_Number__c != null && c.Sales_Org_Code__c != null && c.Distribution_Channel_Code__c!=null && c.SAP_Material__c!=null)//Checking not nulls
        {
            // if(c.Customer_Number__c != '' && c.Sales_Org_Code__c != '' && c.Distribution_Channel_Code__c!='' && c.SAP_Material__c!='')//Checking not Empty
            //  {
                    clauseValues.add(c.ShipTo_Number__c);
                    clauseValues.add(c.Sales_Org_Code__c);
                    clauseValues.add(c.Distribution_Channel_Code__c);
                    clauseValues.add(c.SAP_Material__c);    
                    ConcatenatedClauses.put(c.Id,c.ShipTo_Number__c+c.Sales_Org_Code__c+c.Distribution_Channel_Code__c);
                    IdClauseValuesMap.put(c.Id,clauseValues);
                    System.debug('FGG'+clauseValues[3]);
                    AllclauseValues.add(c.ShipTo_Number__c);
                    AllclauseValues.add(c.Sales_Org_Code__c);
                    AllclauseValues.add(c.Distribution_Channel_Code__c);
                    CPIS.add(c);
                    
              //  }
        }
  
    
      
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                  
      
      
    if(c.Chem_Account__c != null)
    {  ids.add(c.Chem_Account__c);
       
     //  if(c.SAP_Material__c != null)
      //   AccountMaterialIds.add(''+c.Chem_Account__c + c.SAP_Material__c);
    }
    
    if(c.Plastics_Account__c != null)
    {
      ids.add(c.Plastics_Account__c);
      
  //    if(c.SAP_Material__c != null)
  //       AccountMaterialIds.add(''+c.Plastics_Account__c + c.SAP_Material__c);
    }
    if(c.Comp_Account__c != null)
    {
      ids.add(c.Comp_Account__c);
      
   //   if(c.SAP_Material__c != null)
   //      AccountMaterialIds.add(''+c.Comp_Account__c + c.SAP_Material__c);
    }
    if(c.Es_Account__c != null)
    {
      ids.add(c.ES_Account__c);
      
   //   if(c.SAP_Material__c != null)
    //     AccountMaterialIds.add(''+c.ES_Account__c + c.SAP_Material__c);
    }
    //Adding this If condition For Div 36 to create Account material
    if(c.CoPackAccount__c != null)
    {
      ids.add(c.CoPackAccount__c);
      
    }
    idMap.put(c.id, ids);
    AccountIds.addall(ids);
    AccountMaterialIds.addall(clauseValues);
    MaterialIds.add(c.SAP_Material__c);
  }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    List<Account> Accounts=new List<Account>();
    Map<Id,string> MaterialsIdandDivision= new Map<Id,string>();
    Map<String,Map<id,List<String>>> divisions = new Map<String,Map<id,List<String>>>();
    for(material_sales_data2__c materials: [select id,Division_Code__c from material_sales_data2__c where id in : MaterialIds]){
                System.debug('FGG:'+materials.Division_Code__c); 
                MaterialsIdandDivision.put(materials.id, materials.Division_Code__c);
                AllclauseValues.add(materials.Division_Code__c);
    }
      Set<String> setClauses = new Set<String>(AllclauseValues);
    /*for(Account acct : [select id,Account_Number__c from Account where Account_Number__c like :ConcatenatedClauses.keyset()]){
        Accounts.add(acct);  
        System.debug('FGG Account Name:'+acct.Account_Number__c);
    } */
     System.debug('FGG Size Accounts'+Accounts.size());
    set<string> concatenatedValues= new set<string>();
    for (Id key : IdClauseValuesMap.keySet()) {

        List<String> Clauses = IdClauseValuesMap.get(key);
        System.debug('FGG DivisionCode'+MaterialsIdandDivision.get(Clauses[3]));
        Clauses.add(MaterialsIdandDivision.get(Clauses[3]));
        Clauses.add(Clauses[0]+Clauses[1]+Clauses[2]+Clauses[4]);        
        concatenatedValues.add(Clauses[0]+Clauses[1]+Clauses[2]+Clauses[4]);
        System.debug('Concatenated Values:'+concatenatedValues);
        IdClauseValuesMap.put(key,Clauses);
        System.debug('FGG Clauses[0]'+Clauses[0]);
        System.debug('FGG Clauses[1]'+Clauses[1]);
        System.debug('FGG Clauses[2]'+Clauses[2]);
        System.debug('FGG Clauses[3]'+Clauses[3]);
        System.debug('FGG Clauses[4]'+Clauses[4]);
    }    
    
      /*for(Account acct : [select id,Account_Number__c from Account where Account_Number__c in :concatenatedValues]){
        Accounts.add(acct);  
        System.debug('FGG Account Name:'+acct.Account_Number__c);
       }
       
    for (Id key : IdClauseValuesMap.keySet()) {
            system.debug('FGG ACCOUNTS2'+IdClauseValuesMap.get(key));        
        for(Account act : Accounts){
            system.debug('FGG ACCOUNTS2');
            List<String> Clauses = IdClauseValuesMap.get(key);
            if(act.Account_Number__c==Clauses[5])
            {
                for(Customer_Product_Info__c cpi: CPIS){
                    if(cpi.Id==key){
                        CPIAndAccount.put(key, act.id);
                    }
                }   
            }
            
        }
    }*/
    
    
   
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    
for(Account acct : [Select Id,OwnerId from Account where id in : AccountIds]){
    AccIdAcctOwnerIdMap.put(acct.id,acct.ownerId);  
}

List<Account_Material__c> ToUpsert = [select id, Account__c, Created_From_CPI__c, SAP_Material__c, Account_Material_Id__c from Account_Material__c where (Created_From_CPI__c IN :CPIIds) OR (Account__c IN :AccountIds and SAP_Material__c IN :MaterialIds) order by createddate desc];
Map<String, Account_Material__c> amMap = new Map<String, Account_Material__c>();
List<Account_Material__c> toDelete = new List<Account_Material__c>();

if(ToUpsert.size() == 0)
  ToUpsert = new List<Account_Material__c>();

for(Account_Material__c am:ToUpsert){
    if(am.created_from_cpi__c == null)
      amMap.put(''+am.account__c + am.SAP_Material__c, am);
    else if ((!(amMap.containskey(''+am.account__c + am.SAP_Material__c)))&&(!(amMap.containskey(''+am.created_from_cpi__c + am.account__c + am.SAP_Material__c))))
      amMap.put(''+am.created_from_cpi__c + am.account__c + am.SAP_Material__c, am);
    else
      toDelete.add(am);
    
}
ToUpsert.clear();

for(Customer_Product_Info__c c:trigger.new) 
{
  system.debug(idmap.get(c.id));
  for(string s:idmap.get(c.id))
  {
  Account_material__c a;
  if(amMap.containskey(''+c.id + s + c.SAP_Material__c))
     a = amMap.get(c.id + s + c.SAP_Material__c);
  else if(amMap.containskey(s + c.SAP_Material__c))
     a = amMap.get(s + c.SAP_Material__c);
  else
     a = new Account_Material__c();    
  
  a.Account__c = s;
  a.SAP_Material__c = c.SAP_Material__c;
  a.created_from_cpi__c = c.id;
  if(AccIdAcctOwnerIdMap.get(s)!= null)
    a.ownerid = AccIdAcctOwnerIdMap.get(s);
  if(a.account__c != null && a.sap_material__c != null)
    toupsert.add(a);
  system.debug('string: ' + s);
  }
} 
  if(ToUpsert.size() > 0)
    upsert ToUpsert;
  
  Delete_CSP.updatePriceLetterItems(ammap,toDelete);
  Delete_CSP.updatePRTs(ammap,toDelete);
  delete toDelete;
  


    /*if(RecursiveHandler.isFirstTime){
        RecursiveHandler.isFirstTime = false;
        UpdateCPIAccount updateCPI=new UpdateCPIAccount();
        updateCPI.updateCPI(CPIAndAccount); 
        
    }*/
    
 /*List<Customer_Product_Info__c> triggerCPI = new List<Customer_Product_Info__c>();        
 List<Customer_Product_Info__c> toPriceList = new List<Customer_Product_Info__c>();
 Set<id> accids = new Set<id>();
 List<Account> webAccount = new List<Account>();
 Set<id> webaccids = new Set<id>();
 
  //to create Cloudcraze Price List for a CPI record
  for(Customer_Product_Info__c c:trigger.new){  
      if(c.CPI_Account__c !=null){
      accids.add(c.CPI_Account__c);
      }
  }
  System.debug('@@@accids.size is :' + accids.size());
  
  webAccount = [Select id, ccrz__UsedByCloudcraze__c from Account where id IN :accids];
  
  System.debug('@@@webAccount.size is :' + webAccount.size());
 
  for(Account a: webAccount){
  if(a.ccrz__UsedByCloudcraze__c == true){
      webaccids.add(a.id);}
  }
  System.debug('@@@webaccids.size is :' + webaccids.size());
  
  if(webaccids.size()>0)
      toPriceList= [select id , CPI_Account__c, CPI_Account__r.ccrz__E_AccountGroup__r.Name, ShipTo_Number__c,  Deletion_Indicator__c, CPI_Record_Type__c, Customer_Number__c, Sales_Org_Code__c, Distribution_Channel_Code__c, SAP_Material__r.Division_Code__c, SAP_Material__c, SAP_Material__r.Create_CC_Product__c, CPI_Account__r.ccrz__UsedByCloudcraze__c, CPI_Account__r.Type from Customer_Product_Info__c where CPI_Account__c in:webaccids and cpi_account__r.ccrz__UsedByCloudcraze__c = true and cpi_account__r.Type = 'Customer' and CPI_Record_Type__c = '1' and Deletion_Indicator__c != 'X'];
      system.debug('toPriceList.size is :'+toPriceList.size());
      
 if(toPriceList.size()>0)
      Cloudcraze_Product_Function.update_CPI_PriceList(toPriceList);
      
      /**********************************************************************************************************/
       /* List<Customer_Product_Info__c> coPackPriceList = new List<Customer_Product_Info__c>();
        Set<id> copackaccids = new Set<id>();
        List<Account> webAccCopack = new List<Account>();
        Set<id> webaccidscopk = new Set<id>();
 
        //to create Cloudcraze Price List for a CPI record
        for(Customer_Product_Info__c c:trigger.new){  
            if(c.CoPackAccount__c !=null){
                copackaccids.add(c.CoPackAccount__c);
            }
        }
        System.debug('@@@accids.size is :' + accids.size());
  
        webAccCopack = [Select id, ccrz__UsedByCloudcraze__c from Account where id IN :copackaccids];
  
        System.debug('@@@webAccount.size is :' + webAccCopack.size());
 
        for(Account acc: webAccCopack){
            if(acc.ccrz__UsedByCloudcraze__c == true){
                 webaccidscopk.add(acc.id);
            }
        }
        System.debug('@@@webaccidscopk.size is :' + webaccidscopk.size());
  
        if(webaccidscopk.size()>0)
            coPackPriceList= [select id , CPI_Account__c, CPI_Account__r.ccrz__E_AccountGroup__r.Name, ShipTo_Number__c,  Deletion_Indicator__c, 
                                CPI_Record_Type__c, Customer_Number__c, Sales_Org_Code__c, Distribution_Channel_Code__c, SAP_Material__r.Division_Code__c, 
                                SAP_Material__c, SAP_Material__r.Create_CC_Product__c, CPI_Account__r.ccrz__UsedByCloudcraze__c, CPI_Account__r.Type,CoPackAccount__r.Type,
                                CoPackAccount__r.ccrz__UsedByCloudcraze__c,CoPackAccount__r.ccrz__E_AccountGroup__r.Name, CoPackAccount__r.SAP_DivisionCode__c  
                                from Customer_Product_Info__c 
                                where CoPackAccount__c in:webaccids and CoPackAccount__r.ccrz__UsedByCloudcraze__c = true 
                                and CoPackAccount__r.Type = 'Customer' and CPI_Record_Type__c = '1' and Deletion_Indicator__c != 'X'];
            system.debug('toPriceList.size is :'+toPriceList.size());
      
        if(coPackPriceList.size()>0)
            CoPackPriceListCreation.update_CoPack_PriceList(coPackPriceList);*/
       /**********************************************************************************************************/
      
    

//this is to delete PriceListItem when CPI deletion indicator = X.
     List<id> CPIdelId = new List<id>();
     List<ccrz__E_PriceListItem__c> lstPLI = new List<ccrz__E_PriceListItem__c>(); 
if(trigger.isAfter && trigger.isUpdate){
    
    for(Customer_Product_Info__c c:trigger.new){
        if(c.Deletion_Indicator__c == 'X')
        {
            CPIdelId.add(c.id);
        }
      }
        System.debug('@@@CPIdelId.size is :' + CPIdelId.size());
      if(CPIdelId.size()>0)
      {
        lstPLI = [select id, CPI__c from ccrz__E_PriceListItem__c where CPI__c in : CPIdelId];  
      } 
      System.debug('@@@lstPLI.size is :' + lstPLI.size());
      if(lstPLI.size()>0)
      {
          delete lstPLI;
      }
    
    }
}