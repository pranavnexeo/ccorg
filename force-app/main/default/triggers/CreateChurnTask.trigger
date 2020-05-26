trigger CreateChurnTask on SalesChurn__c (after insert) {
  Set<Id> Ids=new set<Id>();
  List<SalesChurn__c> saleschurnlist=new List<SalesChurn__c>();
  List<SalesChurn__c> toupdatesaleschurn=new List<SalesChurn__c>();
  List<Task> tasklist= new List<Task>();
  
  for(Saleschurn__c s:Trigger.new){
        Ids.add(s.id); 
       
      }
  saleschurnlist =[Select Id,Material_code__c,Material_Code__r.Material_Desc__c,Account_Number__r.SAP_DivisionCode__c,Material_Code__r.Material_General_Data__c,Material_Code__r.Material_General_Data__r.Material_Base_Code__c,Churn_Date__c,Base_Code_Description__c,ShipTo_Name__c,Name,ownerid,Account_Number__r.Specialty_Seller__c,Account_Number__r.OwnerId from SalesChurn__c where id IN:Ids];
  
  for(SalesChurn__c  sc:saleschurnlist){
      system.debug('sc.Account_Number__r.OwnerId is ****'+sc.Account_Number__r.OwnerId);
      system.debug('sc.ownerid is ****'+sc.ownerid);
      if(sc.Material_Code__r.Material_General_Data__r.Material_Base_Code__c != null || sc.Material_Code__r.Material_General_Data__r.Material_Base_Code__c != ''){
          sc.Base_Code__c = sc.Material_Code__r.Material_General_Data__r.Material_Base_Code__c;
      }
      if(sc.Account_Number__r.SAP_DivisionCode__c =='31'){
          if(sc.Account_Number__r.Specialty_Seller__c != null){
              sc.ownerid=sc.Account_Number__r.Specialty_Seller__c;
          }
          else{
              sc.ownerid=sc.Account_Number__r.OwnerId;
          }
      }
      else{
          if(sc.ownerid!=sc.Account_Number__r.OwnerId){
             sc.ownerid=sc.Account_Number__r.OwnerId;
            }
      }
       
       toupdatesaleschurn.add(sc);
       
      }
  update toupdatesaleschurn;
  
  Set<Id> userIds=new set<Id>();
  List<String> rolenames = new List<String>{'VP Composites','DM US Plas Mid Atl','DM CHEM IM ERIE','DM CHEM HIIL SE'};
  for(Role_Reportee__c r : [Select Id,Role__c,User__c from Role_Reportee__c where Role__c In:rolenames]){
      userIds.add(r.User__c);
  }
  for(SalesChurn__c  sc : saleschurnlist){
      
        if(userIds.contains(sc.Account_Number__r.OwnerId)){
            Task tk= new Task();
            string subject='Complete ';
            
            if(sc.Churn_Date__c !=null){
              DateTime dt = DateTime.newInstance(sc.Churn_Date__c, Time.newInstance(0, 0, 0, 0));
              subject  = subject + dt.format('MMM YYYY');
            }
            
            if(sc.ShipTo_Name__c !=null){
              subject = subject + ' Churn Record ' + sc.Name;  
              subject =subject +' for Customer '+ sc.ShipTo_Name__c;
            }
            if(sc.Material_Code__c !=null){
               subject =subject + ' and Material '+sc.Material_Code__r.Material_Desc__c;
            }
         
            
            tk.Subject=subject;
            tk.ownerid=sc.ownerid;
            tk.WhatId=sc.id;
            tk.Description=sc.Base_Code_Description__c;
            tk.ActivityDate=date.Today();
            tk.Status = 'In Progress';
            tk.Type='Churn';
            tasklist.add(tk);
        }
  }
  if(tasklist.size()>0)
      insert tasklist;
}