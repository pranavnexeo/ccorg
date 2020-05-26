/**  
* @Name CustomCustomerLookUpController
* @Purpose This is a controller class used to show custom look up for Customer .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class CustomCustomerLookUpController {

  public List <Account> results{get;set;}
  public string searchString{get;set;} // search keyword
  public string customerNumber{get;set;}
  private String customerType;
  private String salesOrg;
  private String divisionNo;
  private String distChannel;
  private String actualSalesOrg;
  public String actualCustType{get;set;}
  public boolean soldTo{set;get;}
  public List<accountWrapper> display_list {get; set;} 
  
/**  
* @Name CustomCustomerLookUpController
* @Purpose This is used to set initial search parameters for custom look up.
* @param 
* @return 
* @Author  Deepak
*/
  public CustomCustomerLookUpController() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    salesOrg = System.currentPageReference().getParameters().get('salesOrg');
    customerType = System.currentPageReference().getParameters().get('customerType');
    divisionNo = System.currentPageReference().getParameters().get('divisionNo');
    distChannel = System.currentPageReference().getParameters().get('distChannel');
    actualSalesOrg = salesOrg.split('-')[0];
    if(customerType!=null && customerType!='' && customerType.contains('-')){
        actualCustType = customerType.split('-')[1];
    }else{
        actualCustType = '';
    }
    runSearch();  
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
  
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);   
    display_list = getRegions(results);
    
  } 
  /**  
* @Name performSearch
* @Purpose This is used to perform search operation
* @param String
* @return List<Account>
* @Author  Deepak
*/  
  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {

    String soql = 'select id,name,SAP_Customer_Number__c,SAP_Accounting_Group__c, SAP_ShippingPlant__c,SAP_DivisionCode__c ,sales_area__c,SAP_SalesGroup__c,Owner.Name,SAP_Partner_Functions__c,State_City_Country__c,SAP_Street__c from Account where Type=\'Customer\' and SAP_DivisionCode__c=\''+divisionNo+'\' and SAP_DistChannel__c=\''+distChannel+'\' and SAP_Sales_Org__c LIKE \'%' + actualSalesOrg +'%\''+'and SAP_Partner_Functions__c LIKE \'%' + actualCustType +'%\'';
    if(searchString != '' && searchString != null)
      soql = soql +  ' and name LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\'';
    if(customerNumber !='' && customerNumber!=null)
      soql = soql +  ' and SAP_Customer_Number__c LIKE \'%' + String.escapeSingleQuotes(customerNumber) +'%\'';
    soql = soql + ' limit 25';
    System.debug('---soql----'+soql);
    return database.query(soql); 

  }
  
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
    
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
/**  
* @Name getSoldTos
* @Purpose This is used to get the sold to parties for a payer customer
* @param 
* @return 
* @Author  Manish
* @Purpose- End Markets - Adding Regions
*/  
 public void getSoldTos(){
    
    System.debug('--------Inside Sold To--------');
    String customerNumbr = System.currentPageReference().getParameters().get('custNo');
    System.debug('---customerNumbr----'+customerNumbr);
    soldTo = true;
    
    List<String> accountIds = new List<String>();

    List<CISRelationships__c> relationShips = [select Source_Customer__c from CISRelationships__c where Customer_Type__c=:actualCustType and Customer_Number__c=:customerNumbr and Source_Customer_Active_Account__c='Yes' ];
    
    for(CISRelationships__c cisRel:relationShips){
        accountIds.add(cisRel.Source_Customer__c);
    }
    
    List<Account> shipToList = new List<Account>();
    
    if(actualCustType == 'Sold To'){
        shipToList = [Select id,name,SAP_Sold_To_Account_Id__c, SAP_ShippingPlant__c,SAP_DivisionCode__c,SAP_Customer_Number__c,SAP_Accounting_Group__c,sales_area__c,SAP_SalesGroup__c,Owner.Name,SAP_Partner_Functions__c,State_City_Country__c,SAP_Street__c from Account where Id IN :accountIds and SAP_DivisionCode__c=:divisionNo];
    }
    else{
        shipToList = [Select id,name,SAP_Sold_To_Account_Id__c, SAP_ShippingPlant__c,SAP_DivisionCode__c, SAP_Customer_Number__c,SAP_Accounting_Group__c,sales_area__c,SAP_SalesGroup__c,Owner.Name,SAP_Partner_Functions__c,State_City_Country__c,SAP_Street__c from Account where SAP_Sold_To_Account_Id__c IN :accountIds and SAP_DivisionCode__c=:divisionNo];
    }
    System.debug('---shipToList ----'+shipToList);
    display_list = getRegions(shipToList);
         
    
 }
  
  private List<accountWrapper> getRegions(List<Account> shipToList){
    
    List <String> PlantList = new List<String>();
    Map<Id,String> shipDivMap = new Map<Id,String>();
    for(Account ac:shipToList){
        PlantList.add(ac.SAP_ShippingPlant__c + ac.SAP_DivisionCode__c );
        shipDivMap.put(ac.id,(ac.SAP_ShippingPlant__c+ac.SAP_DivisionCode__c));
    }
    List <SAP_Plant_Region__c> PlantRegionList = [Select Id,Division_Code__c,Plant_Division__c, SAP_Plant__r.Plant_Code__c, Region__r.Region_Code__c, Region__r.Region_Description__c  from SAP_Plant_Region__c where Plant_Division__c In :PlantList];
    Map<String,String> plantRegionMap = new Map<String,String>();
    
    for(SAP_Plant_Region__c spr:PlantRegionList){
        plantRegionMap.put(spr.Plant_Division__c,spr.Region__r.Region_Code__c);
    }
    
    display_list = new List<accountWrapper>();
    
    for(Account a:shipToList)    
        display_list.add(new accountWrapper(a,plantRegionMap.get(shipDivMap.get(a.id)) ));
        
    return display_list;
   
   }     
        
   public class accountWrapper {
        public Account act {get; set;} //Account object
        public String region{get; set;} 
       
        
        public accountWrapper(Account a, String regionVal) {
            this.act = a; //assign account
            this.region= regionVal; 
           
       }
   }    
 
}