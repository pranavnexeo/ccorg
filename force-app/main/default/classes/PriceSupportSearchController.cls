/**  
* @Name PriceSupportSearchController
* @Purpose This is a controller class used for quick search page.
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class PriceSupportSearchController {
  
  public String agreementId{get;set;}
  public String divisionName{get;set;}
  public String status{get;set;}
  public String sapTransfer{get;set;}
  public String salesOrg{get;set;}
  public String supportType{get;set;}
  public String nexeoGroupName{get;set;}
  public String supplierGroupName{get;set;}
  public String customerName{get;set;}
  public String customerNumber{get;set;}
  public String region{get;set;}
  public String seller{get;set;}
  public String supplierName{get;set;}
  public String supplierNumber{get;set;}
  public String materialName{get;set;}
  public String materialCode{get;set;}
  public Date expDate{get;set;}
  public String nexeoMainApprover{get;set;}
  public String mg2{get;set;}
  public String mg4{get;set;}
  public String newChanged{get;set;}
  public String materialNameBuy{get;set;}
  public String created{get;set;}
  private Date todaysDate = System.today();
  private List<SelectOption> supplierDmContactNameList = new List<SelectOption>();
  private List<String> supplierDmContactNumberList = new List<String>();
  public String newNexeoGroup{get;set;}
  public String newDebitMemo{get;set;}
  Integer i;
  public ApexPages.StandardSetController setCon{get;set;}
  public integer noOfRecords{get;set;}
  Public Integer size{get;set;} 
  
  Date expDt = null;
  
  public Date getExpDt(){
    return expDt;
  }
    
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of price supports to display
  public List<Price_Support__c> priceSupports ;//{get;set;}
  
  public List<Price_Support__c> getPriceSupports(){
        return (List<Price_Support__c>)setCon.getRecords();
  }
  
  public String limitVal {get  { if (limitVal == null) {limitVal = '50'; } return limitVal;  }
    set;
  }
  
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'LastModifiedDate'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit '+limitVal; }
    set;
  }
 
  // init the controller and display some sample data when the page loads
  public PriceSupportSearchController() {
    
    soql = 'Select Id,Region_Code__c,LastModifiedDate,LastModifiedBy.name,name,Upfront_Cost__c,Agreement_Number__c,Status__c,SAP_Transfer__c,Support_Type__c,Customer_Name__c,Material_Description_Selling__c,Material_Description_Buying__c,New_or_Changed__c,Supplier_Name__c,Supplier_Supported_Price__c,Units__c,Currency__c,Dis1_Sell__c,Dis2_Sell__c,Purchase_Cost__c,Dis1_Buy__c,Dis2_Buy__c,Requested_Rebate_Amount__c,Effective_Date__c,Expiration_Date__c from Price_Support__c where Archieved__c=false';
    runQuery();
  }
    /**  
    * @Name toggleSort
    * @Purpose This method is used to toggle the sort.
    * @param 
    * @return 
    * @Author  Deepak
    */
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    System.debug('-----------Inside toggleSort------------');
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
  
    /**  
    * @Name runQuery
    * @Purpose This method is used to run the query.
    * @param 
    * @return 
    * @Author  Deepak
    */
  // runs the actual query
  public void runQuery() {
 
    try {
        System.debug('----------Sort Field------------'+sortField);
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' limit '+limitVal));
        size = 200;
        setCon.setPageSize(size); 
        noOfRecords = setCon.getResultSize();
      //priceSupports = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit '+limitVal);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    }
 
  }
    /**  
    * @Name runSearch
    * @Purpose This method is used to set the dynamic query
    * @param 
    * @return 
    * @Author  Deepak
    */
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String agreementId = Apexpages.currentPage().getParameters().get('agreementId');
    String divisionName = Apexpages.currentPage().getParameters().get('divisionName');
    String status = Apexpages.currentPage().getParameters().get('status');
    String sapTransfer = Apexpages.currentPage().getParameters().get('sapTransfer');
    String salesOrg = Apexpages.currentPage().getParameters().get('salesOrg');
    String supportType = Apexpages.currentPage().getParameters().get('supportType');
    String nexeoGroupName = Apexpages.currentPage().getParameters().get('nexeoGroupName');
    //String supplierGroupName = Apexpages.currentPage().getParameters().get('supplierGroupName');
    String customerName = Apexpages.currentPage().getParameters().get('customerName');
    String customerNumber = Apexpages.currentPage().getParameters().get('customerNumber');
    String region = Apexpages.currentPage().getParameters().get('region');
    String sellerName = Apexpages.currentPage().getParameters().get('seller');
    String supplierName = Apexpages.currentPage().getParameters().get('supplierName');
    String supplierNumber = Apexpages.currentPage().getParameters().get('supplierNumber');
    String materialName = Apexpages.currentPage().getParameters().get('materialName');
    String materialCode = Apexpages.currentPage().getParameters().get('materialCode');
    String expDate = Apexpages.currentPage().getParameters().get('expDate');
    String nexeoApprover = Apexpages.currentPage().getParameters().get('nexeoMainApprover');
    String mg2 = Apexpages.currentPage().getParameters().get('mg2');
    String mg4 = Apexpages.currentPage().getParameters().get('mg4');
    String newChanged = Apexpages.currentPage().getParameters().get('newChanged');
    String materialNameBuy = Apexpages.currentPage().getParameters().get('materialNameBuy');
    String created = Apexpages.currentPage().getParameters().get('created');
    
    
    if(!expDate.equals('')){
        String[] expDateArray = expDate.split('/');
        Integer d = Integer.valueOf(expDateArray[0]);
        Integer m = Integer.valueOf(expDateArray[1]);
        Integer y = Integer.valueOf(expDateArray[2]);
        expDt = Date.newInstance(y,m,d);
        
    }
    
    //divName = divisionName;
    
   
 
    soql = 'Select Id,Region_Code__c,LastModifiedDate,LastModifiedBy.name,name,Agreement_Number__c,Upfront_Cost__c,Status__c,SAP_Transfer__c,Support_Type__c,Customer_Name__c,Material_Description_Selling__c,Material_Description_Buying__c,New_or_Changed__c,Supplier_Name__c,Supplier_Supported_Price__c,Units__c,Currency__c,Dis1_Sell__c,Dis2_Sell__c,Purchase_Cost__c,Dis1_Buy__c,Dis2_Buy__c,Requested_Rebate_Amount__c,Effective_Date__c,Expiration_Date__c from Price_Support__c where Archieved__c=false';
    if (!agreementId.equals(''))
      soql += ' and Agreement_Number__c LIKE \''+String.escapeSingleQuotes(agreementId)+'%\'';
    if (!divisionName.equals('')) 
      soql += ' and Division_Name__c = \''+divisionName+'\'';
    if (!status.equals(''))
      soql += ' and Status__c = \''+status+'\'';
    if (!sapTransfer.equals(''))
      soql += ' and SAP_Transfer__c = \''+sapTransfer+'\'';
    if (!salesOrg.equals(''))
      soql += ' and Sales_Organisation__c = \''+salesOrg+'\'';
    if (!supportType.equals(''))
     soql += ' and Support_Type__c = \''+supportType+'\'';
    if (!nexeoGroupName.equals(''))
      soql += ' and Nexeo_Group__c = \''+nexeoGroupName+'\'';
    /*if (!supplierGroupName.equals(''))
      soql += ' and Supplier_Group__c = \''+supplierGroupName+'\'';*/
    if (!customerName.equals(''))
      soql += ' and CustomerName_Mail__c LIKE \'%'+String.escapeSingleQuotes(customerName)+'%\''; 
    if (!customerNumber.equals(''))
      soql += ' and Customer_Number__c LIKE \'%'+String.escapeSingleQuotes(customerNumber)+'%\''; 
    if (!region.equals(''))
      soql += ' and Region_Code__c LIKE \'%'+String.escapeSingleQuotes(region)+'%\'';
    if (!sellerName.equals(''))
      soql += ' and Seller__c LIKE \'%'+String.escapeSingleQuotes(sellerName)+'%\''; 
    if (!supplierName.equals(''))
      soql += ' and Supplier_Name__c LIKE \'%'+String.escapeSingleQuotes(supplierName)+'%\''; 
    if (!supplierNumber.equals(''))
      soql += ' and Supplier_Number__c LIKE \'%'+String.escapeSingleQuotes(supplierNumber)+'%\''; 
    if (!materialName.equals(''))
      soql += ' and Material_Description_Selling__c LIKE \'%'+String.escapeSingleQuotes(materialName)+'%\'';
    if (!materialCode.equals(''))
      soql += ' and Material_Code_Selling__c LIKE \'%'+String.escapeSingleQuotes(materialCode)+'%\'';
    if (expDate!=null && !expDate.equals(''))
      soql += ' and Expiration_Date__c =:expDate';
    if (!nexeoApprover.equals(''))
      soql += ' and Nexeo_Main_Approver_Name__c LIKE \'%'+String.escapeSingleQuotes(nexeoApprover)+'%\'';
    if (!mg2.equals(''))
      soql += ' and Material_Group_2_Buying__c LIKE \'%'+String.escapeSingleQuotes(mg2)+'%\'';
   if (!mg4.equals(''))
       soql += ' and Material_Group_4_Buying__c LIKE \'%'+String.escapeSingleQuotes(mg4)+'%\'';
    if (!newChanged.equals(''))
      soql += ' and New_or_Changed__c = \''+newChanged+'\'';
    if (!materialNameBuy.equals(''))
      soql += ' and Material_Description_Buying__c LIKE \'%'+String.escapeSingleQuotes(materialNameBuy)+'%\'';
    if (!created.equals('')&&created.equals('Today'))
      soql += ' and CreatedDate__c =:todaysDate';
    if (!created.equals('')&&created.equals('Earlier'))
      soql += ' and CreatedDate__c <:todaysDate';
    
    
    System.debug('-------expDt---------'+expDt);
    // run the query again
    runQuery();
    
    return null;
  }
    /**  
    * @Name statusList
    * @Purpose This method is used to get the picklist values for Status
    * @param 
    * @return 
    * @Author  Deepak
    */
  // use apex describe to build the picklist values
  public List<SelectOption> statusList {
    get {
      if (statusList == null) {
 
        statusList = new List<SelectOption>();
        statusList.add(new SelectOption('',''));
        Schema.DescribeFieldResult field = Price_Support__c.Status__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          statusList.add(new SelectOption(f.getLabel(),f.getLabel()));
 
      }
      return statusList;          
    }
    set;
  }
  /**  
    * @Name sapStatusList
    * @Purpose This method is used to get the picklist values for SAP Transfer
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> sapStatusList {
    get {
      if (sapStatusList == null) {
 
        sapStatusList = new List<SelectOption>();
        sapStatusList.add(new SelectOption('',''));
        Schema.DescribeFieldResult field = Price_Support__c.SAP_Transfer__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          sapStatusList.add(new SelectOption(f.getLabel(),f.getLabel()));
 
      }
      return sapStatusList;          
    }
    set;
  }
   /**  
    * @Name divisionList
    * @Purpose This method is used to get the picklist values for Division
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> divisionList {
    get {
      if (divisionList == null) {
 
        divisionList = new List<SelectOption>();
        divisionList.add(new SelectOption('',''));
        Schema.DescribeFieldResult field = Price_Support__c.Division_Name__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          divisionList.add(new SelectOption(f.getLabel(),f.getLabel()));
 
      }
      return divisionList;          
    }
    set;
  }
  /**  
    * @Name salesOrgList
    * @Purpose This method is used to get the picklist values for Sales Org
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> salesOrgList {
    get {
      if (salesOrgList == null) {
 
        salesOrgList = new List<SelectOption>();
        salesOrgList.add(new SelectOption('',''));
        Schema.DescribeFieldResult field = Price_Support__c.Sales_Organisation__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          salesOrgList.add(new SelectOption(f.getLabel(),f.getLabel()));
 
      }
      return salesOrgList;          
    }
    set;
  }
  /**  
    * @Name supportTypeList
    * @Purpose This method is used to get the picklist values for Support Type
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> supportTypeList {
    get {
      if (supportTypeList == null) {
 
        supportTypeList = new List<SelectOption>();
        supportTypeList.add(new SelectOption('',''));
        Schema.DescribeFieldResult field = Price_Support__c.Support_Type__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          supportTypeList.add(new SelectOption(f.getLabel(),f.getLabel()));
 
      }
      return supportTypeList;          
    }
    set;
  }
   /**  
    * @Name newChangedList
    * @Purpose This method is used to get the picklist values for New Or Changed
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> newChangedList {
    get {
      if (newChangedList == null) {
 
        newChangedList = new List<SelectOption>();
        newChangedList.add(new SelectOption('',''));
        Schema.DescribeFieldResult field = Price_Support__c.New_or_Changed__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          newChangedList.add(new SelectOption(f.getLabel(),f.getLabel()));
 
      }
      return newChangedList;          
    }
    set;
  }
  /**  
    * @Name getLimitList
    * @Purpose This method is used to get the  limit options
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> getLimitList(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        options.add(new SelectOption('200','200'));
        options.add(new SelectOption('300','300'));
        options.add(new SelectOption('500','500'));
        options.add(new SelectOption('1000','1000'));
        return options;

  }
  /**  
    * @Name nexeoGroupList
    * @Purpose This method is used to get the  values for Nexeo Group
    * @param 
    * @return 
    * @Author  Deepak
    */
  public List<SelectOption> nexeoGroupList{
    
    get{
        nexeoGroupList = new List<SelectOption>();
        nexeoGroupList.add(new SelectOption('',''));
        System.debug('------Inside Nexeo Group -------');
        System.debug('------divName -------'+Apexpages.currentPage().getParameters().get('divisionName'));
        System.debug('---------Division Name------------'+divisionName);
        String divName = Apexpages.currentPage().getParameters().get('divisionName');
        if(divName==null){
            divName = divisionName;
        }
        String soql = 'select Id,Group_Name__c,Division_Name__c,Main_Approver__r.name from Nexeo_Group__c where Division_Name__c ='+ '\''+divName+'\'' +'order by Division_Name__c,Group_Name__c limit 999';
        try {
          List<Nexeo_Group__c> nexeoGroups = Database.query(soql);
          for(Nexeo_Group__c grp:nexeoGroups){
            
            nexeoGroupList.add(new SelectOption(grp.Id,grp.Group_Name__c+'('+grp.Main_Approver__r.name+')'));
          
          }
          
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return nexeoGroupList;
    }
    set;
  
  }
  

  public List<SelectOption> DebitMemoList{
    
    get{
        DebitMemoList = new List<SelectOption>();
        DebitMemoList.add(new SelectOption('',''));
        //System.debug('------Inside Debit memo list -------');
        System.debug('------supplierName-------'+Apexpages.currentPage().getParameters().get('supplierName'));
        System.debug('---------supplierName------------'+supplierName);
        String divisionName= Apexpages.currentPage().getParameters().get('divisionName');
        String Suppname1= Apexpages.currentPage().getParameters().get('supplierName');
        //system.debug('---Suppname1---'+Suppname1);
        String salesorg= Apexpages.currentPage().getParameters().get('salesOrg');
        String Purcorg = salesorg.substring(0, 4);
        //system.debug('---Purcorg ---'+Purcorg);
        string srchstring = '%' + Suppname1 + '%'; 
        List<Supplier_Profile__c> sp=[select Id from Supplier_Profile__c where Supplier_Name__r.Name  LIKE :srchstring and Division_Name__c=:divisionName and Purchasing_Organization__c=:Purcorg];
        //system.debug('---sp---'+sp.size());
        Set<String> Str=new Set<String>();
        for(integer k=0;k<sp.size();k++){
        Str.add(sp[k].id);
        }
        
        List<Supplier_Profile__c> sp1= [select Supplier_Name__c from  Supplier_profile__c where Id IN:Str]; 
        set<Id> Str1=new set<Id>();
        for(integer s=0;s<sp1.size();s++){
        Str1.add(sp1[s].Supplier_Name__c);
        }
        
        List <Account> supplierList = [select SAP_PartnerFunctionCodeText__c,SAP_Vendor_Purchase_Org__c,SAP_PartnerFunctionText__c,SAP_Currency__c from Account where Id IN:Str1];
         system.debug('---supplierList ---'+supplierList.size());
        String partnerFuctions = null; 
        String partnerFuctionCodes = null;
        String purchaseOrg = null;
        if(supplierList!=null && !supplierList.isEmpty()){
            
            Account supplierObj = supplierList.get(0);
            partnerFuctions = supplierObj.SAP_PartnerFunctionText__c;
            partnerFuctionCodes = supplierObj.SAP_PartnerFunctionCodeText__c;
            purchaseOrg = supplierObj.SAP_Vendor_Purchase_Org__c;
            
            System.debug('------------partnerFuctions11----------'+partnerFuctions);
            System.debug('------------partnerFuctionCodes11----------'+partnerFuctionCodes);
            
            if(partnerFuctions==null){
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Partner Function is available for this Supplier.Please correct the Supplier Profile.');
                    
                ApexPages.getMessages().clear();
                    
                ApexPages.addMessage(myMsg);
                    
                return supplierDmContactNameList;
            }
            
            Map<String,String> partnerFunctionMap = new Map<String,String>();
            List<String> partnerFunctionList =null;
            List<String> partnerFuctionCodesList =null;
           
            supplierDmContactNumberList.clear();
            supplierDmContactNameList.clear();
            
            if(partnerFuctions!=null && partnerFuctions.length()>0){
                partnerFunctionList = partnerFuctions.split(',');
            }
            
            if(partnerFuctionCodes!=null && partnerFuctionCodes.length()>0){
                partnerFuctionCodesList = partnerFuctionCodes.split(',');
            }
            
            if(partnerFunctionList!=null && partnerFuctionCodesList!=null){
                
                if(partnerFunctionList.size()!=partnerFuctionCodesList.size()){
                
                    System.debug('-------------Partner Function Not Proper in SFDC----------');
                    
                }
                try{
                    Integer indx =0;
                
                    for(String functions: partnerFunctionList){
                        
                        if(functions.equalsIgnoreCase('ZA')){
                            
                            supplierDmContactNumberList.add(partnerFuctionCodesList.get(indx));
                        }
                        
                        indx++;
                        
                    }
                }catch(Exception e){
                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Partner Function Not Proper in SFDC');
                    
                    ApexPages.getMessages().clear();
                    
                    ApexPages.addMessage(myMsg);
                    
                    return supplierDmContactNameList;
                    
                    
                }
                
                
                 System.debug('-------------supplierDmContactNumberList Size----------'+supplierDmContactNumberList.size());
                  
                 //String purchaseOrg1=priceSupport.Purchasing_Organization__c.substring(0, 4);
                 
                 System.debug('-------------Purchase Org----------'+purchaseOrg);
                  
                 List <Account> acctList= [select Name,SAP_Supplier_Number__c,SAP_Account_Name_2__c, W_Account_Status__c, SAP_Accounting_group__c,SAP_Sales_Org__c,SAP_DivisionCode__c from Account where  SAP_Supplier_Number__c in : supplierDmContactNumberList and W_Account_Status__c = 'ACTIVE' and SAP_Accounting_group__c = 'ZREG' and SAP_Vendor_Purchase_Org__c=:purchaseOrg];           
                 
                 
                 Set<String> numberNameSet = new Set<String>();
                 Set<String> numberSet     = new Set<String>();  
                    for(i=0; i<acctList.size();i++){
     
                        String suppName = acctList[i].Name;
                        String suppNumber = acctList[i].SAP_Supplier_Number__c;
                         String Sacctname2 = acctList[i].SAP_Account_Name_2__c;
                         if(Sacctname2 !=null){
                         numberNameSet.add(suppNumber + '-' + Sacctname2 );
                         }
                         else{
                         numberNameSet.add(suppNumber + '-' + suppName );
                         }
                        
                    }   
                        
                       
                    for(String val:numberNameSet){
                        supplierDmContactNameList.add(new SelectOption(val,val));
                       
                    }  
                    
               system.debug('supplierDmContactNameList is '+supplierDmContactNameList );
               
               
                if(supplierDmContactNameList.isEmpty()){
                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Supplier Does not have an ZA Vendor');
                    
                    ApexPages.getMessages().clear();
                    
                    ApexPages.addMessage(myMsg);
                    
                    return supplierDmContactNameList;
                }
                
             
            }
                
        }
       return supplierDmContactNameList; 
  }
  set;
    }
  /**  
    * @Name supplierGroupList
    * @Purpose This method is used to get the  values for Supplier Group
    * @param 
    * @return 
    * @Author  Deepak
    */
   /*public List<SelectOption> supplierGroupList{
    
    get{
        supplierGroupList = new List<SelectOption>();
        supplierGroupList.add(new SelectOption('',''));
        System.debug('------Inside Supplier Group -------');
        System.debug('------divName -------'+Apexpages.currentPage().getParameters().get('divisionName'));
        System.debug('---------Division Name-------0-----'+divisionName);
        String divName = Apexpages.currentPage().getParameters().get('divisionName');
        if(divName==null){
            divName = divisionName;
        }
        String soql = 'select Id,Group_Name__c,Division_Name__c,Main_Approver__r.name from Supplier_Group__c where Division_Name__c ='+ '\''+divName+'\'' +'order by Division_Name__c,Group_Name__c limit 999';
        try {
           List<Supplier_Group__c> supplierGroups = Database.query(soql);
           for(Supplier_Group__c grp:supplierGroups){
            
            supplierGroupList.add(new SelectOption(grp.Id,grp.Group_Name__c+'('+grp.Main_Approver__r.name+')'));
          
          }
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return supplierGroupList;
    }
    set;
  }*/
  
  public List<SelectOption> materialGroup2List{
    
    get{
        if (materialGroup2List == null) {
            materialGroup2List = new List<SelectOption>();
            materialGroup2List.add(new SelectOption('',''));
            System.debug('------Inside materialGroup2List -------');
            
            String soql = 'select Material_Pricing_Group2_Code__c,Material_Pricing_Group2_Description__c from Material_Pricing_Group2__c where Deleted__c =false and  ( NOT Material_Pricing_Group2_Description__c like \'%MASKED%\') order by Material_Pricing_Group2_Code__c asc limit 999';
            try {
               List<Material_Pricing_Group2__c> materialGroup2 = Database.query(soql);
               for(Material_Pricing_Group2__c grp:materialGroup2){
                
                materialGroup2List.add(new SelectOption(grp.Material_Pricing_Group2_Code__c,grp.Material_Pricing_Group2_Code__c+'-'+grp.Material_Pricing_Group2_Description__c));
              
              }
            } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        return materialGroup2List;
    }
    set;
  }
  
  public List<SelectOption> materialGroup4List{
    
    get{
        if (materialGroup4List == null) {
            materialGroup4List = new List<SelectOption>();
            materialGroup4List.add(new SelectOption('',''));
            System.debug('------Inside materialGroup2List -------');
            
            String soql = 'select Material_Pricing_Group4_Code__c,Material_Pricing_Group4_Description__c from Material_Pricing_Group4__c where Deleted__c =false and  ( NOT Material_Pricing_Group4_Description__c like \'%MASKED%\') order by Material_Pricing_Group4_Code__c asc limit 999';
            try {
               List<Material_Pricing_Group4__c> materialGroup4 = Database.query(soql);
               for(Material_Pricing_Group4__c grp:materialGroup4){
                
                materialGroup4List.add(new SelectOption(grp.Material_Pricing_Group4_Code__c,grp.Material_Pricing_Group4_Code__c+'-'+grp.Material_Pricing_Group4_Description__c));
              
              }
            } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        return materialGroup4List;
    }
    set;
  }
  
  
    

    
  public void updateNexeoGroup(){
    
    String selectedRecords = Apexpages.currentPage().getParameters().get('selectedRecords');
    
    List<String> selectedSupports = selectedRecords.split(',');
    
    System.debug('-----Selected records----------'+selectedRecords);
    System.debug('--------New Nexeo Group -------'+newNexeoGroup);
    
    Nexeo_Group__c nexeoGrp = null;
    
    List<Nexeo_Group__c> newNexeoGroupList = [select Id,Group_Name__c,Division_Name__c,Main_Approver__c from Nexeo_Group__c where ID=:newNexeoGroup];
    
    List<Price_Support__c> supportList = [select Id,Nexeo_Group__c from Price_Support__c where Id IN:selectedSupports];
    List<Price_Support__c> newSupportList = new List<Price_Support__c>();
    
    
    for(Price_Support__c support:supportList){
    
        support.Nexeo_Group__c = newNexeoGroup;
        if(newNexeoGroupList!=null && !newNexeoGroupList.isEmpty()){
            support.Nexeo_Group_Name__c = newNexeoGroupList.get(0).Group_Name__c;
            support.Nexeo_Main_Approver__c = newNexeoGroupList.get(0).Main_Approver__c;
            support.OwnerId = newNexeoGroupList.get(0).Main_Approver__c;
        }
        newSupportList.add(support);
    }
    try{
        update newSupportList;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Nexeo Group Updated Successfully'));
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Exception :'+e.getMessage()));
    }
  }
  
  public void updateDebitMemo(){
      PageReference returnPage;
      String selectedRecords = Apexpages.currentPage().getParameters().get('selectedRecords');
      List<String> selectedSupports = selectedRecords.split(',');
      List<Price_Support__c> toBeUpdated = [Select Id,Support_Type__c, Status__c, Debit_Memo_Contact1__c, SAP_Transfer__c from Price_Support__c where id in:selectedSupports];
      for(integer i=0;i<toBeUpdated.size();i++)
      {
          toBeUpdated[i].Debit_Memo_Contact1__c = newDebitMemo;
          if(toBeUpdated[i].Support_Type__c == 'Rebate' && (toBeUpdated[i].Status__c =='Approved' || toBeUpdated[i].Status__c =='Expired'))
          {
              toBeUpdated[i].SAP_Transfer__c = 'Open';
          }
      }
      update toBeUpdated;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Debit Memo Updated Successfully'));
          
  }  
}