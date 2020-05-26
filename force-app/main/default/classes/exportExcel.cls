public class exportExcel {

        
   
    public string header{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    public class wrapper{
    
        public string Owner{get; set;}
        public string id{get; set;}
        public string OwnerDM{get; set;}
        public string Account_Type{get; set;}
        public string Account{get; set;}
        public string Opportunity_Name{get; set;}
        public string Target{get; set;}
        public string Stage_Name{get; set;}
        public string Call_Report_Date{get; set;}
        public string Opportunity_Overview{get; set;}
        public string Requested_Supplier{get; set;}
        public string SAP_Material{get; set;}
        public string Potential_CM{get; set;}
        public string Annual_Volume{get; set;}
          
 
 
        public string Close_Date{get; set;}
        public string Created_Date{get; set;}
        
        
        
        
    }
    public string paramid{get; set;} 
    public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;}  
      
   
 
 
 
 
    public exportExcel(){
            paramid = ApexPages.CurrentPage().getParameters().get('supid');
            Filetype = '';
            lstwrapper = new List<wrapper>();
            header = 'Salesforce Id,Created Date,Owner Name,Owner Manager Name,Account Type,Account,Opportunity Name,Target,Stage,Close Date,Call Report Date ,Opportunity Overview,Annual Volume, Potential CM,Requested Supplier,SAP Material\r\n';                     
    }
 
   
    public void exportToExcel(){
    
        SupplierPageSetting__c suppSetting = SupplierPageSetting__c.getValues('OpportunityOpenDate');
        Date DateRange = suppSetting.Opportunity_Date_Range__c; 
          string queryString = 'Select id, CreatedDate, Ownerid, Owner.Name, Opportunity_Owner_Manager__c, Account_Type__c,Account_Name__c, Name, Target__c, StageName, CloseDate, Recent_Call_Report_Notes_Date__c, Overview__c, Annual_Usage__c, Potential_CM__c, Requested_Supplier__c, Requested_Supplier__r.Name, SAP_Material__c, SAP_Material__r.Name from Opportunity where Requested_Supplier__c =: paramid and (NOT StageName LIKE \'Closed %\') and createddate >=: DateRange';
          List<Opportunity> lstOpps = DataBase.Query(queryString);
         
          if(lstOpps.size()>0){
              for(Opportunity Opp :lstOpps){
                  wrapper w = new wrapper();
                  w.id = opp.id;
                  w.Created_Date = string.valueOf(opp.CreatedDate);
                  w.Owner= opp.owner.name;
                  w.OwnerDM= opp.Opportunity_Owner_Manager__c;
                  w.Account_Type = opp.Account_Type__c ;
                  w.Account = opp.Account_Name__c;
                  w.Opportunity_Name = opp.Name;
                  w.Target = string.valueOf(opp.Target__c);
                  w.Stage_Name = opp.StageName;
                  w.Close_Date = string.valueOf(opp.CloseDate);
                  w.Call_Report_Date = string.valueOf(opp.Recent_Call_Report_Notes_Date__c);
                  w.Opportunity_Overview = opp.Overview__c;
                  w.Annual_Volume = string.valueOf(opp.Annual_Usage__c);
                  w.Potential_CM = string.valueOf(opp.Potential_CM__c);
                  w.Requested_Supplier = opp.Requested_Supplier__r.Name ;
                  w.SAP_Material = opp.SAP_Material__r.Name;
                  lstwrapper.add(w);               
              }             
          }
          system.debug('lstwrapper :'+lstwrapper.size());
    }
    
    public void exportToExcel1(){
    
        SupplierPageSetting__c suppSetting = SupplierPageSetting__c.getValues('OpportunityClosedDate');
        Date DateRange = suppSetting.Opportunity_Date_Range__c; 
          string queryString1 = 'Select id, CreatedDate, Ownerid, Owner.Name, Opportunity_Owner_Manager__c, Account_Type__c,Account_Name__c, Name, Target__c, StageName, CloseDate, Recent_Call_Report_Notes_Date__c, Overview__c, Annual_Usage__c, Potential_CM__c, Requested_Supplier__c, Requested_Supplier__r.Name, SAP_Material__c, SAP_Material__r.Name from Opportunity where Requested_Supplier__c =: paramid and StageName LIKE \'Closed %\' and closedate >=: DateRange';
          List<Opportunity> lstOpps1 = DataBase.Query(queryString1);
         
          if(lstOpps1.size()>0){
              for(Opportunity Opp1 :lstOpps1){
                  wrapper w1 = new wrapper();
                  w1.id = opp1.id;
                  w1.Created_Date = string.valueOf(opp1.CreatedDate);
                  w1.Owner= opp1.owner.name;
                  w1.OwnerDM= opp1.Opportunity_Owner_Manager__c;
                  w1.Account_Type = opp1.Account_Type__c ;
                  w1.Account = opp1.Account_Name__c;
                  w1.Opportunity_Name = opp1.Name;
                  w1.Target = string.valueOf(opp1.Target__c);
                  w1.Stage_Name = opp1.StageName;
                  w1.Close_Date = string.valueOf(opp1.CloseDate);
                  w1.Call_Report_Date = string.valueOf(opp1.Recent_Call_Report_Notes_Date__c);
                  w1.Opportunity_Overview = opp1.Overview__c;
                  w1.Annual_Volume = string.valueOf(opp1.Annual_Usage__c);
                  w1.Potential_CM = string.valueOf(opp1.Potential_CM__c);
                  w1.Requested_Supplier = opp1.Requested_Supplier__r.Name ;
                  w1.SAP_Material = opp1.SAP_Material__r.Name;
                  lstwrapper.add(w1);               
              }             
          }
          system.debug('lstwrapper :'+lstwrapper.size());
    }
 
    
   
 
}