public with sharing class BaseCodeLookupController {
 

  public List<Material_Base_Code__c> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string codeordesc{get; set;}
  public String sortField{get; set;}
  public string sortArrow{get; set;}
  private Boolean sortASC{get; set;}
  private String originalSortField{get; set;}
  private string UP_IMAGE = '/img/sort_asc_arrow.gif';
  private string DOWN_IMAGE = '/img/sort_desc_arrow.gif';
  private Sort_Helper SH;

 
  public BaseCodeLookupController() {
   
    SH = new sort_Helper();
    sortASC = TRUE;
    sortArrow = UP_IMAGE;
    sortField = 'name';
    originalSortField = sortField;
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    codeordesc = 'name';
    if(SearchString.Length() > 0){ runSearch(); }  
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
    if(codeordesc == null){ codeordesc = 'Material_base_code_Description__c'; }
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<Material_Base_Code__c> performSearch(string searchString) {
 
    String s = String.escapeSingleQuotes(searchstring);
    List<String> sl = new list<string>();
    if(s.contains('*')){ sl = s.split('\\*'); }
    
    String soql = 'select id, name, material_base_code__c, material_base_Code_Description__c from Material_base_Code__c where';
          
    if(sl.size() > 0)
    {
      for(string st:sl){
      if(st.length() > 0){
      soql = soql + ' and ' + codeordesc + ' LIKE ';
      soql = soql + '\'%' + st + '%\'';
      }
      }
      soql = soql.replace('where and', 'where');
    }
    else
    {
      soql = soql + ' ' + codeordesc + ' LIKE \'%' + s +'%\'';
    }
    
    soql = soql + ' order by name ASC limit 1000 ';
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