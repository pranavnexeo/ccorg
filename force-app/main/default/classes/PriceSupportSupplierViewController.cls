/**  
* @Name PriceSupportSupplierViewController
* @Purpose This is a controller class used for quick search page for supplier.
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class PriceSupportSupplierViewController {
    
  public String agreementId{get;set;}
  public String supportType{get;set;}
  public String status{get;set;}
  public String customerName{get;set;}
  public String materialName{get;set;}
  public String nexeoApprover{get;set;}
  public String supplierApprover{get;set;}
  public String supplierReference{get;set;}
  public String plant{get;set;}
  public String region{get;set;}
  
  public ApexPages.StandardSetController setCon{get;set;}
  public integer noOfRecords{get;set;}
  Public Integer size{get;set;} 
  
  Set<String> supplierGroupIds = new Set<String>();
    
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
  public PriceSupportSupplierViewController() {
    
    List<Supplier_Member__c> supplierMembers=[SELECT Approver__c,Supplier_Group__r.Id, Name__r.Id,Supplier_Group__r.Main_Approver__c FROM Supplier_Member__c where (Name__r.Id=:UserInfo.getUserId()  AND Approver__c=true ) OR Supplier_Group__r.Main_Approver__c=:UserInfo.getUserId()];
    for(Supplier_Member__c member:supplierMembers){
            
            if(member.Supplier_Group__r.Id!=null){
                supplierGroupIds.add(member.Supplier_Group__r.Id);
            }
    }
    
    System.debug('---------supplierGroupIds---------'+supplierGroupIds);
    
    soql = 'Select Id,name,Agreement_Number__c,Status__c,Region_Code__c,Support_Type__c,Customer_Name__c,Material_Description_Selling__c,Supplier_Name__c,Supplier_Supported_Price__c,Upfront_Cost__c,Purchase_Cost__c,Nexeo_Main_Approver_Name__c,New_or_Changed__c,Supplier_Reference__c,Hub_Name__c,Supplier_Main_Approver_Name__c,Units__c,Dis1_Sell__c,Dis2_Sell__c,Dis1_Buy__c,Dis2_Buy__c,Requested_Rebate_Amount__c,Effective_Date__c,Expiration_Date__c from Price_Support__c where Archieved__c=false AND (Supplier_Group__c IN:supplierGroupIds OR Supplier_Main_Approver__c='+'\''+UserInfo.getUserId()+'\')';
    runQuery();
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' limit '+limitVal));
        size = 200;
        setCon.setPageSize(size); 
        noOfRecords = setCon.getResultSize();
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
    
    
    String agreementId = Apexpages.currentPage().getParameters().get('agreementId');
    String supportType = Apexpages.currentPage().getParameters().get('supportType');
    String status = Apexpages.currentPage().getParameters().get('status');
    String customerName = Apexpages.currentPage().getParameters().get('customerName');
    String region = Apexpages.currentPage().getParameters().get('region');
    String materialName = Apexpages.currentPage().getParameters().get('materialName');
    String nexeoApprover = Apexpages.currentPage().getParameters().get('nexeoApprover');
    String supplierApprover = Apexpages.currentPage().getParameters().get('supplierApprover');
    String supplierReference = Apexpages.currentPage().getParameters().get('supplierReference');
    String plant = Apexpages.currentPage().getParameters().get('plant');
    
    
   
 
    soql = 'Select Id,name,Agreement_Number__c,Region_Code__c,Status__c,Support_Type__c,Customer_Name__c,Material_Description_Selling__c,Supplier_Name__c,Supplier_Supported_Price__c,Upfront_Cost__c,Purchase_Cost__c,Nexeo_Main_Approver_Name__c,New_or_Changed__c,Supplier_Reference__c,Hub_Name__c,Supplier_Main_Approver_Name__c,Units__c,Dis1_Sell__c,Dis2_Sell__c,Dis1_Buy__c,Dis2_Buy__c,Requested_Rebate_Amount__c,Effective_Date__c,Expiration_Date__c from Price_Support__c where Archieved__c=false AND (Supplier_Group__c IN:supplierGroupIds OR Supplier_Main_Approver__c='+'\''+UserInfo.getUserId()+'\')';
    if (!agreementId.equals(''))
      soql += ' and Agreement_Number__c LIKE \''+String.escapeSingleQuotes(agreementId)+'%\'';
    if (!supportType.equals(''))
     soql += ' and Support_Type__c = \''+supportType+'\'';
    if (!status.equals(''))
      soql += ' and Status__c = \''+status+'\'';
    if (!customerName.equals(''))
      soql += ' and CustomerName_Mail__c LIKE \'%'+String.escapeSingleQuotes(customerName)+'%\''; 
    if (!region.equals(''))
      soql += ' and Region_Code__c LIKE \'%'+String.escapeSingleQuotes(region)+'%\'';
    if (!materialName.equals(''))
      soql += ' and Material_Description_Selling__c LIKE \'%'+String.escapeSingleQuotes(materialName)+'%\'';
    if (!nexeoApprover.equals(''))
      soql += ' and Nexeo_Main_Approver_Name__c LIKE \'%'+String.escapeSingleQuotes(nexeoApprover)+'%\'';
    if (!supplierApprover.equals(''))
      soql += ' and Supplier_Main_Approver_Name__c LIKE \'%'+String.escapeSingleQuotes(supplierApprover)+'%\'';
    if (!supplierReference.equals(''))
      soql += ' and Supplier_Reference__c LIKE \'%'+String.escapeSingleQuotes(supplierReference)+'%\'';
    if (!plant.equals(''))
      soql += ' and Hub_Name__c LIKE \'%'+String.escapeSingleQuotes(plant)+'%\'';
   
   
    
    // run the query again
    runQuery();
    
    return null;
  }
 
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
  
  public List<SelectOption> nexeoGroupList{
    
    get{
        nexeoGroupList = new List<SelectOption>();
        nexeoGroupList.add(new SelectOption('',''));
        System.debug('------Inside Nexeo Group -------');
        System.debug('------divName -------'+Apexpages.currentPage().getParameters().get('divisionName'));
        String divName = Apexpages.currentPage().getParameters().get('divisionName');
        String soql = 'select Group_Name__c,Division_Name__c,Main_Approver__r.name from Nexeo_Group__c where Division_Name__c ='+ '\''+divName+'\'' +'order by Division_Name__c,Group_Name__c limit 999';
        try {
          List<Nexeo_Group__c> nexeoGroups = Database.query(soql);
          for(Nexeo_Group__c grp:nexeoGroups){
            
            nexeoGroupList.add(new SelectOption(grp.Group_Name__c,grp.Group_Name__c+'('+grp.Main_Approver__r.name+')'));
          
          }
          
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return nexeoGroupList;
    }
    set;
  
  }
  
   public List<SelectOption> supplierGroupList{
    
    get{
        supplierGroupList = new List<SelectOption>();
        supplierGroupList.add(new SelectOption('',''));
        System.debug('------Inside Supplier Group -------');
        System.debug('------divName -------'+Apexpages.currentPage().getParameters().get('divisionName'));
        String divName = Apexpages.currentPage().getParameters().get('divisionName');
        String soql = 'select Group_Name__c,Division_Name__c,Main_Approver__r.name from Supplier_Group__c where Division_Name__c ='+ '\''+divName+'\'' +'order by Division_Name__c,Group_Name__c limit 999';
        try {
           List<Supplier_Group__c> supplierGroups = Database.query(soql);
           for(Supplier_Group__c grp:supplierGroups){
            
            supplierGroupList.add(new SelectOption(grp.Group_Name__c,grp.Group_Name__c+'('+grp.Main_Approver__r.name+')'));
          
          }
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return supplierGroupList;
    }
    set;
  }

}