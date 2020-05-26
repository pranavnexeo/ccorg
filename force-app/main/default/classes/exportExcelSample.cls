public class exportExcelSample {

        
   
    public string header{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    public class wrapper{     
                
                
        public string Sampleid{get; set;}
        public string Samplematid{get; set;}
        public string SampleMatname{get; set;}
        public string samplesapmatid{get; set;}
        public string samplesapmat{get; set;}
        public string SampleName{get; set;}
        public string SampleOpp{get; set;}
        public string SampleAccount{get; set;}
        public string OwnerName{get; set;}
        public string CreatedDate{get; set;}
        public string Status{get; set;}
        public string Supplier{get; set;}
               
    }
    public string paramid{get; set;} 
    public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;}  
      
   
 
 
 
 
    public exportExcelSample(){
            paramid = ApexPages.CurrentPage().getParameters().get('supid');
            Filetype = '';
            lstwrapper = new List<wrapper>();
            header = 'Sample Material Id,Sample Material Name,Sample Request Id,Sample Request #,SAP Material Name, Account, Opportunity, Owner, Created Date, Status, Supplier\r\n';                     
    }
 
   
    
 
    public void exportToExcelSample(){
          
          String sup_name = [SELECT id, Name FROM Nexeo_Competitor__c where id=: paramid].name;
          string queryString = 'Select id, Name,SAP_Material_MSD2__c,SAP_Material_MSD2__r.name,Sample_Request__c,Sample_Request__r.name, Account_Name__c, Opportunity__c,Opportunity__r.name, Sample_Request__r.Owner.Name, Sample_Request__r.CreatedDate,Sample_Request__r.Status__c, Requested_Supplier2__c from Sample_Material__c where Requested_Supplier2__c =: sup_name';
          List<Sample_Material__c> lstSampleRequest = DataBase.Query(queryString);
         
          if(lstSampleRequest.size()>0){
              for(Sample_Material__c sr: lstSampleRequest){
                  wrapper w = new wrapper();
                  w.Samplematid = sr.id;
                  w.SampleMatname = sr.name;
                  w.sampleid = sr.Sample_Request__c;
                  w.samplename = sr.Sample_Request__r.name;
                  w.samplesapmatid = sr.SAP_Material_MSD2__c;
                  w.samplesapmat = sr.SAP_Material_MSD2__r.name;
                  w.CreatedDate = string.valueOf(sr.Sample_Request__r.CreatedDate);
                  w.OwnerName = sr.Sample_Request__r.Owner.Name;                  
                  w.SampleAccount = sr.Account_Name__c ;
                  w.SampleOpp = sr.Opportunity__r.name;
                  w.Status= sr.Sample_Request__r.Status__c;                
                  w.Supplier = sr.Requested_Supplier2__c ;
                  lstwrapper.add(w);               
              }             
          }
          system.debug('lstwrapper :'+lstwrapper.size());
    }
   
 
}