public with sharing class apexjsoncontroller {

    public string projectid{get;set;}
    private final ART_Project__c project;
    private final ApexPages.StandardController projectController;
    //public List<String> jsonStringlist{get;set;}
    public string result1{get;set;}
    
    public Integer milestoneSize{get;set;}
   
    
    public apexjsoncontroller() {
        jsonString();
           
    }  
    
    public class milestone{
          public String frm {get;set;}
          public String to{get;set;}
   
          //public String desc{get;set;}
          public String label{get;set;}
          
          public String customClass{get;set;}
          
          public void setToDate(String val)
          {
              to = setDate(val);
          }
          public void setFromDate(String val)
          {
              frm = setDate(val);
          }
          private String setDate(String val)
          {
              return '/Date('+val+')/';
          }  
    }
    
    public class Project{
        public String name{get;set;}
        public List<milestone> values{get;set;}
        public String dsc{get;set;}
    }
    
     
    public void jsonString(){
        result1 = '';
        milestoneSize = 0;
        projectId = '';
        List<String> jsonStringlist = new List<string>();
        string jsonString;
        List<Project> projLIst = new LIst<Project>();
        List<Milestone__c> milestone = new List<Milestone__c>();  
        projectId = ApexPages.currentPage().getParameters().get('projectId');
        milestone = [Select Id, Start__c, End__c,Actual_Start__c,Project__c,Project__r.Name,Actual_End__c,Name from Milestone__c where Project__c =: projectId];
       
        if(milestone!=null && milestone.size()>0){
            milestoneSize = milestone.size();
            for(Integer i=0;i<milestone.size();i++){
                if(milestone[i].Start__c != null && milestone[i].End__c != null){
                    System.debug('inside loop'+i);
                    Milestone mc = new Milestone();
                    mc.setFromDate(String.valueOf((milestone[i].Start__c).getTime()));
                    mc.setToDate(String.valueOf((milestone[i].End__c).getTime()));
                    mc.label = milestone[i].Name;
                    mc.customClass  = 'ganttGreen'; 
                    Project proj = new Project();
                    if(i==0)
                        proj.name = milestone[i].Project__r.Name;
                    else
                        proj.name = '';
                    proj.dsc = '';
                    List<Milestone> mcl = new List<Milestone>();
                    mcl.add(mc);
                    proj.values = mcl;  
                    projLIst.add(proj);
                }
            }
           
              
         } 
           result1 = JSON.serialize(projLIst);
         
           
    
    }
    

    
}