public with sharing class CustomContainerLookupController {
 
  public Container_Specification_Document__c account {get;set;} 
  public List<Container_Specification_Document__c> results{get;set;}
  public string searchString{get;set;} 
  public string passPackage{get;set;}
 
  public CustomContainerLookupController() {
    account = new Container_Specification_Document__c();
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }
 
  
  public PageReference search() {
    runSearch();
    return null;
  }
 
  
  private void runSearch() {
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<Container_Specification_Document__c> performSearch(string searchString) {
    passPackage = System.currentPageReference().getParameters().get('package');
    String status='Approved';
    String division='ECD';
    String soql = 'select id, name, Package_Type_lookup__c,Nexeo_Divisions_New__c,Status__c from Container_Specification_Document__c where Status__c =:status and Package_Type_lookup__c =: passPackage and Nexeo_Divisions_New__c includes (:division)' ;
    if(searchString != '' && searchString != null)
    soql = soql +  ' AND name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 
 
  }
 
  
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
 
}