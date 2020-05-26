/**  
* @Name CustomMaterialLookupController
* @Purpose This is a controller class used to show custom look up for Material .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class CustomMaterialLookupController {

  public List<Material_Sales_Data2__c> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string materialCode{get;set;}
  private String salesOrg;
  private String actualSalesOrg;
  
  /**  
* @Name CustomMaterialLookupController
* @Purpose Constructor used to set initial search parameters for custom look up.
* @param 
* @return 
* @Author  Deepak
*/
  public CustomMaterialLookupController() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    salesOrg = System.currentPageReference().getParameters().get('salesOrg');
    actualSalesOrg = salesOrg.split('-')[0];
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
  } 
  
  /**  
* @Name performSearch
* @Purpose This is used to perform search operation
* @param String
* @return List<Material_Sales_Data2__c>
* @Author  Deepak
*/   
  // run the search and return the records found. 
  private List<Material_Sales_Data2__c> performSearch(string searchString) {

    String soql = 'select id, name,Material_Number__c,SALES_ORG_CODE__C,Material_Desc__c from Material_Sales_Data2__c where (DIST_CHANNEL_CODE__C=\'30\' OR DIST_CHANNEL_CODE__C=\'99\') and SALES_ORG_CODE__C LIKE \'%' + actualSalesOrg +'%\'';
    if(searchString != '' && searchString != null)
      soql = soql +  ' and name LIKE \'%' + String.escapeSingleQuotes(searchString) +'%\'';
    if(materialCode !='' && materialCode!=null)
      soql = soql +  ' and Material_Number__c LIKE \'%' + String.escapeSingleQuotes(materialCode) +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
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
 
}