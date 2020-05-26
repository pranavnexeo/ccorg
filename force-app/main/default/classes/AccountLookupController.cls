public with sharing class AccountLookupController {
 
  public Account account {get;set;} // new account to create
  public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public String owner{get; set;}
  public string type{get; set;}
  public string NameOrNumber{get; set;}
  public string Division{get; set;}
  public String sortField{get; set;}
  public string sortArrow{get; set;}
  private Boolean sortASC{get; set;}
  private String originalSortField{get; set;}
  private string UP_IMAGE = '/img/sort_asc_arrow.gif';
  private string DOWN_IMAGE = '/img/sort_desc_arrow.gif';
  private Sort_Helper SH;
 
  public AccountLookupController() {
  
    SH = new sort_Helper();
    sortASC = TRUE;
    sortArrow = UP_IMAGE;
    sortField = 'Owner_Name__c';
    originalSortField = sortField;
    
    account = new Account();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    nameornumber = 'name';
    if(searchstring.length() > 0 ){  runSearch(); }  
  }
 
  // Sort Results
  public Pagereference sortResults(){
     system.debug('sortASC Start: ' + sortASC);
     sh = new sort_helper();
     sh.originalList = results;
     if(sortField == originalSortField)
     { 
        sortASC = !sortASC;
        if(sortASC){
          sortArrow = UP_IMAGE;        
        }
        else{   
          sortArrow = DOWN_IMAGE;          
        }
     }
     else
     {
        sortArrow = UP_IMAGE;
        sortASC = TRUE;
     }
     system.debug('sortASC END: ' + sortASC);
     
     results = sh.getsortedList(sortField, sortASC);
     originalSortField = sortField;
     return null;
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
 
  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {
 
    String s = String.escapeSingleQuotes(searchstring);
    List<String> sl = new list<string>();
    if(s.contains('*')){ sl = s.split('\\*'); }
    
    String soql = 'select id,name,Account_name_new__c, owner_name__c, Full_address__c, sales_area__c, sap_sales_office_desc__c, sap_Sales_group_Desc__c, accountnumber from account where active_account__c != \'No\'';        
    if(sl.size() > 0)
    {
      for(string st:sl){
      if(st.length() > 0){
      soql = soql + ' and ' + nameornumber + ' LIKE ';
      soql = soql + '\'%' + st + '%\'';
      }
      }
    }
    else
    {
      soql = soql + ' and ' + nameornumber + ' LIKE \'%' + s +'%\'';
    }
    if(owner == 'My Accounts')
    {  soql = soql + 'and ownerid = \'' + userinfo.getuserid() + '\''; }
    
    if(type == 'Prospect')
    {  soql = soql + ' and type = \'Prospect\''; }
    if(type == 'Customer')
    {  soql = soql + ' and type = \'Customer\''; }
    if(division == 'Chemicals')
    {  soql = soql + ' and ( SAP_Division_Desc__c = \'Nexeo Chem\' or SAP_DivisionCode__c = \'31\')'; }
    if(division == 'Composites')
    {  soql = soql + ' and ( SAP_Division_Desc__c = \'Nexeo Composites\' or SAP_DivisionCode__c = \'33\')'; }   
    if(division == 'Env Services')
    {  soql = soql + ' and ( SAP_Division_Desc__c = \'Nexeo Env Svcs\' or SAP_DivisionCode__c = \'34\')'; }  
    if(division == 'Plastics')
    {  soql = soql + ' and ( SAP_Division_Desc__c = \'Nexeo Plastics\' or SAP_DivisionCode__c = \'32\')'; }
    if(division == 'Nexeo Small Package')
    {  soql = soql + ' and ( SAP_Division_Desc__c = \'Nexeo Small Package\' or SAP_DivisionCode__c = \'36\')'; }
        
    soql = soql + ' order by owner_name__c ASC limit 1000 ';
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