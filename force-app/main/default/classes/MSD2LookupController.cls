public with sharing class MSD2LookupController {
 
  public Account account{get; set;}
  public List<Material_Sales_Data2__c> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public String packtype{get; set;}
  Public String aid{get; set;}
  public string CustomerCodes{get; set;}
  public string SalesOrg{get; set;}
  public string distchannel{get; set;}
  public string division{get; set;}
  public boolean renderSalesOrg{get; set;}
  public boolean renderdistchannel{get; set;}
  public boolean renderdivision{get; set;}
  public String sortField{get; set;}
  public string sortArrow{get; set;}
  public Boolean searchAllMat{get; set;}
  private Boolean sortASC{get; set;}
  private String originalSortField{get; set;}
  private string UP_IMAGE = '/img/sort_asc_arrow.gif';
  private string DOWN_IMAGE = '/img/sort_desc_arrow.gif';
  private Sort_Helper SH;
 
  public MSD2LookupController() {
   
    SH = new sort_Helper();
    sortASC = TRUE;
    sortArrow = UP_IMAGE;
    sortField = 'name';
    originalSortField = sortField;
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    aid = System.currentPageReference().getParameters().get('aid');
    if(aid != null && aid != ''){
    account = [select id, SAP_DivisionCode__c, SAP_Sales_Org__c, SAP_DistChannel__c, SAP_Division_Desc__c, SAP_Sales_Org_Desc__c from Account where id = :aid limit 1];
    rendersalesorg = true;
    renderdistchannel = true;
    renderdivision = true;
    }
    else{
    rendersalesorg = false;
    renderdistchannel = false;
    renderdivision = false;
    }
    
    searchAllMat = false;
    customercodes = 'no';
    SalesOrg = 'all';
    distchannel = '30';
    division = 'all';
    packtype = 'all';
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
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<Material_Sales_Data2__c> performSearch(string searchString) {
 
    String s = String.escapeSingleQuotes(searchstring);
    List<String> sl = new list<string>();
    if(s.contains('*')){ sl = s.split('\\*'); }
    
    String soql = 'select id, name, Sales_Org_Code__c, SalesOrg_Desc__c, Division_Code__c, Division_Desc__c, ';
    soql += 'Dist_Channel_Code__c, DistChannel_Desc__c, Material_Base_Code__c, Material_Base_Code_Desc__c, PH4_Supplier__c, ';
    soql += 'PH6_Segment_Code__c, PH7_SubSegment__c,Escape_Material_Name__c from material_Sales_Data2__c '; 
    soql += 'where marked_for_deletion__c = \'FALSE\'';
            
    if(sl.size() > 0)
    {
      for(string st:sl){
      if(st.length() > 0){
      soql = soql + ' and name LIKE ';
      soql = soql + '\'%' + st + '%\'';
      }
      }
    }
    else
    {
      soql = soql + ' and name LIKE \'%' + s +'%\'';
    }
    
    if(salesorg != 'all' && rendersalesorg == true){
    soql = soql + ' and Sales_Org_Code__c = \'' + account.SAP_Sales_Org__c + '\''; 
    } 
   if(packtype != 'all'){
    soql = soql + ' and name LIKE \'%' + packtype + '%\''; 
    }
    if(distchannel != 'all' && renderdistchannel == true){
    soql = soql + ' and Dist_Channel_Code__c = \'30\''; 
    }
    if(division != 'all' && renderdivision == true){
    soql = soql + ' and Division_Code__c = \'' + account.SAP_DivisionCode__c + '\''; 
    }
    if(customercodes == 'no'){
    soql = soql + ' and Customer_Repack__c = \'FALSE\''; 
    }
    if(searchAllMat == false){
    //add the filter for external material group
    soql = soql + ' and Material_General_Data__r.Ext_Material_Group_Code__c = \'101\'';
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