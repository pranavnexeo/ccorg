public with sharing class CustomsiteLookupController1 {
 
  public User account {get;set;} 
  public List<User> results{get;set;}
  public string searchString{get;set;} 
  public string siteid{get;set;}
  public string sitename{get;set;}
  public string SiteFieldName{get;set;}
  public Incident_Approver__c incidentapp{get;set;} 
  public Incident_Record__c IncidentRecord{ get; set; }  
  public final Apexpages.Standardcontroller controller;   
  public CustomsiteLookupController1 () {
    account = new User();
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
    
  }
    public CustomsiteLookupController1 (Apexpages.Standardcontroller sc) {
    IncidentRecord=(Incident_Record__c)sc.getRecord();
    //system.debug('incident record'+IncidentRecord);
    this.controller=sc;
  }
 // public monthlyPlantHoursController(Apexpages.Standardcontroller sc){

   // }
           
   // public CustomsiteLookupController1(){}
 
  
  public PageReference search() {
    runSearch();
    return null;
  }
 
  
  private void runSearch() {
  //system.debug('site id is'+IncidentRecord.Nexeo_Location_Associated_with_incident__c);
    results = performSearch(searchString);               
  } 
 public List<Id> UserId = new list<Id>();
 
    public List<Id> IncidentApprover() {
       siteid= System.currentPageReference().getParameters().get('siteid');
       sitename= System.currentPageReference().getParameters().get('sitename');       
       SiteFieldName= System.currentPageReference().getParameters().get('txt');
        List<Incident_Approver__c> approverid= new List<Incident_Approver__c>();
        if(SiteFieldName.Contains('PersonswhocanperformRootCause')){
            approverid= [select id,Approver__c from Incident_Approver__c where Site_Information__c =:siteid and Division__c='Persons who can perform Root Cause Analysis'];
        }else if(SiteFieldName.Contains('Personswhocanfinalize')){
            approverid= [select id,Approver__c from Incident_Approver__c where Site_Information__c =:siteid and Division__c='Persons who can finalize and/or close incidents'];
        }else if(SiteFieldName.Contains('PersonswhocaninitiateaReliability')){
            approverid= [select id,Approver__c from Incident_Approver__c where Site_Information__c =:siteid and Division__c='Persons who can initiate a Reliability Incident'];
        }else if(SiteFieldName.Contains('Personswhocaninitiatetranslateprovide')){
            approverid= [select id,Approver__c from Incident_Approver__c where (Site_Information__c =:siteid or Site_Information__r.Name=:sitename)  and (Division__c='Persons who can initiate a Reliability Incident' or Division__c='Persons who translate/provide follow-up information')];
        }
        //approverid= [select id,Approver__c from Incident_Approver__c where Incident_Record_Name__c ='a4qL00000004C9r'];
        system.debug('approverid'+approverid);
        for(integer i=0;i<approverid.size();i++){
            UserId.add(approverid[i].Approver__c); 
        }
        return UserId;
    } 
    //system.debug('userid is'+UserId);
  // run the search and return the records found. 
  private List<User> performSearch(string searchString) {
  //system.debug('site id is'+IncidentRecord.Nexeo_Location_Associated_with_incident__c);
   IncidentApprover();
    
     system.debug('userid is'+UserId);
        List<User> soql = new List<User>();

    soql= [select Name from User where Id In :UserId] ;
    system.debug('user name is'+soql);
    //if(searchString != '' && searchString != null)
    //soql = soql +  ' AND name LIKE \'%' + searchString +'%\'';
    //soql = soql + ' limit 25';
    //System.debug(soql);
    return soql; 
 
  }
 
  
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
 
}