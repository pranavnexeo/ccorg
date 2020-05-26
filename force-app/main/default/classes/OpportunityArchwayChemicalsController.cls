public with sharing class OpportunityArchwayChemicalsController{
        
        public Opportunity opp{get;set;}
        public Opportunity oppCloned{get;set;}
        public ApexPages.StandardController controller{get; set;}
        public List<SelectOption> contacts{get; set;}
        public String selectedcontact{get;set;}
        public boolean displayPopup{get; set;}
        public Contact contact{get;set;}
        public String CloneRec{get; set;}
        public String  recTypeId {get; set;}
        public Boolean checkVal{get;set;} 
        public id churnid{get;set;}
        public id oppid{get;set;}
        Public Account Acc{get; set;}
        public boolean firstSave{get;set;}
        
        public map<String, Decimal> probabilityStageNameMap{get; set;}
        Public List<SalesChurn__c> sclist = new List<SalesChurn__c>();
        Public List<Opportunity> opplists = new List<Opportunity>();
        
        public OpportunityArchwayChemicalsController(ApexPages.StandardController controller){
            if (probabilityStageNameMap == null) {
                 probabilityStageNameMap = new Map<String, Decimal>();
                 for (OpportunityStage oppStage : [Select MasterLabel, DefaultProbability
                                                   From OpportunityStage]) {
                   probabilityStageNameMap.put(oppStage.MasterLabel, oppStage.DefaultProbability);
                 }
               }
        
            CloneRec = ApexPages.currentPage().getParameters().get('Clone');
            if (!Test.isRunningTest()){
            system.debug('test+++++');
            controller.addFields(new List<String>{'contact__c'});
            }
            this.controller = controller;
            opp = (Opportunity)controller.getRecord();
            if(apexpages.currentpage().getparameters().containskey('aid')){
              opp.accountid = apexpages.currentpage().getparameters().get('aid');
              firstSave = true;
            }
           
            if(opp.Target__c == true)
            checkVal = true;
            else checkVal = false;
            contacts = new List<SelectOption>();
            contacts.add(new SelectOption('','--None--'));
            displayPopup = false;
            contact = new Contact();
            populateContact();
            churnid = apexpages.currentpage().getparameters().get('churnid');
            system.debug('churnid'+churnid);

 if(opp.accountid != null && firstSave == true){
    Acc = [select id, Name,Account_Search_Phrase__c,SAP_City__c,SAP_Division_Desc__c,SAP_Sales_District_Desc__c,SAP_Sales_Group_Desc__c , SAP_Sales_Office_Desc__c,SAP_State__c,SAP_Zip_Code__c,Type,Lead_Source_User__c,AccountNumber,Approval_Status__c,RecordtypeId from Account where id = :opp.accountid limit 1];
        opp.leadsource_user__c = acc.lead_source_user__c;
        }
            
        }
            
            
            
        public String Subtitle {
         get {
          if (opp.Name != null){
           Subtitle = opp.Name;
           firstSave = True;
          }
          else {
            Subtitle = 'Create New Opportunity';
            firstSave = False;
          }
          return Subtitle;          
        }
        set;
       }
    public PageReference changeStageName() {
 
   String stageName = ApexPages.currentPage().getParameters().get('stageName');
   if (probabilityStageNameMap.containsKey(StageName)) {
     opp.Probability = probabilityStageNameMap.get(StageName);
   }
  

   return null;
 }
        
       
       public void populateContact(){
          if(opp.Accountid != null){            
            List<Contact> contactlist = [select Id,Name from Contact where accountid = :opp.Accountid order by Name limit 1000];       
            for(Contact c:contactlist){
              contacts.add(new selectoption(c.id,c.Name));
            }
          }    
       }    
         
      
      public void makeTargetRequired(){   
          String check = ApexPages.currentPage().getParameters().get('firstParam');
          //checkVal = (check == 'true') ? true : false;
          if(check == 'true'){ opp.target_date__c = system.today(); }
          else{ opp.target_date__c = null; }
          
      }
         
      
      public PageReference customSave(){
          PageReference pageref = null;
          if(CloneRec == 'Yes'){
            oppCloned= opp.Clone(false,true);
             if(oppCloned.contact__c != null)
              oppCloned.Contact__c = oppCloned.contact__c;
               oppCloned.RecordTypeId = ApexPages.currentPage().getParameters().get('rid');
             try{
               insert oppCloned;
               pageref = new Pagereference('/'+oppCloned.Id);
              }
             Catch(Exception e){
               
              } 
            }
           
          else{
           opp.Contact__c = opp.contact__c;
                    
           opp.RecordTypeId = ApexPages.currentPage().getParameters().get('rid');
           pageref = controller.save();
           
          // if(churnid != '' || churnid != null)
           //{
           opp.ChurnOpportunity__c = churnid;
           oppid = controller.getId();
           
           sclist = [select id,ChurnOpportunity__c from SalesChurn__c where id =:churnid];  
           if(sclist.size()>0)
           {       
           sclist[0].ChurnOpportunity__c = oppid;
           update sclist;
           
           opplists = [select id, ChurnOpportunity__c from Opportunity where id =:oppid];  
           if(opplists.size()>0)
           {
           opplists[0].ChurnOpportunity__c = sclist[0].id;
           update opplists;
           }
           }
          // }
                              
           }
        
        return pageref;
      
      }

      
      public void closePopup(){        
        displayPopup = false;    
      }     
      
      
      public void showPopup(){  
        displayPopup = true;
      }
      
    
     public PageReference createcontact(){
       contact.AccountId = opp.AccountId;
       upsert contact;
       contacts.clear();
       populateContact();
       closePopup();
      return null;
   }

}