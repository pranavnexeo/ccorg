public class Delete_CSP {
    
   Public Delete_CSP(){}
  
   @RemoteAction
   Public Static List<Account_Material__c> getRecordsToDisplay(String paramid) {
        system.debug('paramid is:'+paramid);
        List<Price_Support_Ids__c> PSIds = new List<Price_Support_Ids__c>();
        List<String> amids = new List<String>();
        PSIds = [Select Ids__c from Price_Support_Ids__c where Id =: paramid];
        
        if(PSIds.size()>0)
            amids = PSIds[0].Ids__c.split('-');
        system.debug('amids:'+amids);
               
        List<Account_Material__c> amList = [select id , inner_table__c, Account_Name__c,  Account_Sold_To__c, material__c, customer_material_number__c,plant_code__c from Account_material__c where Id IN :amids];
     
        return amList; 
    }
   
   
   
   /*This method invokes on click of Delete*/
   @RemoteAction
   Public static void deleteCSP(List<String> recordIds){
   
     //Initializing variables
     List<Account_Material__c> AccMaterials = new List<Account_Material__c>();
     List<Account_material__c> toHide = new List<Account_material__c>();
     List<Account_Material__c> ListAccMatToDelete = new List<Account_Material__c>();
     List<Account_Material__c> prospectCPIs = new List<Account_Material__c>();
     
     
     //Query Account Material records based on the record ids we are getting from the page. 
     if(recordIds != null && recordIds.size()>0)
        AccMaterials = [select Id,Account__c,Created_From_CPI__c,Created_From_CPI__r.CPI_Created_Date__c,SAP_Material__c from Account_material__c where Id IN :recordIds];   
       
     List<String> acctList = new List<String>();
     List<String> matList = new List<String>();
     //Run a loop to capture the Ids of Account Material records based on Create from CPI field
     for(Account_material__c am : AccMaterials){
          if(am.sap_material__c!=null){
              if(am.Created_From_CPI__c == null){
                  ListAccMatToDelete.add(am);
              }else{
                  am.hidden__c = true;
                  toHide.add(am);
              }
              acctList.add(am.Account__c);
              matList.add(am.SAP_Material__c);
          }else{
              prospectCPIs.add(am);
          
          }
     }
     
     List<Account_Material__c> checkDuplicateacctmats= [select id, Account__c, Created_From_CPI__c, SAP_Material__c, Account_Material_Id__c from Account_Material__c where Account__c IN :acctList and SAP_Material__c IN :matList and (not id in: recordIds) order by createddate desc];
     Map<String, Account_Material__c> amMap = new Map<String, Account_Material__c>();
     
     for(Account_Material__c am: checkDuplicateacctmats){
        if(am.created_from_cpi__c == null)
          amMap.put(''+am.account__c + am.SAP_Material__c, am);
        else if ((!(amMap.containskey(''+am.account__c + am.SAP_Material__c)))&&(!(amMap.containskey(''+am.created_from_cpi__c + am.account__c + am.SAP_Material__c))))
          amMap.put(''+am.created_from_cpi__c + am.account__c + am.SAP_Material__c, am);
        
     }
     
     //Delete Account Materials that are not created from CPI 
     if(ListAccMatToDelete != null && ListAccMatToDelete.size()>0){
         updatePriceLetterItems(amMap,ListAccMatToDelete);
         updatePRTs(amMap,ListAccMatToDelete);
         delete ListAccMatToDelete;
     }
     
     if(prospectCPIs != null && prospectCPIs .size()>0){
         deleteProspectCPIs(prospectCPIs);    
     
     }
     
     if(toHide!= null && toHide.size()>0){
         update toHide;    
     
     }
     
     
   }
   
   
   public static void deleteProspectCPIs(list<account_material__c> ams){
       
       list<Price_Letter_Item__c> price_letter_Items = [Select id from Price_Letter_Item__c where Account_Material__c in :ams];
       if(price_letter_Items.size()>0)
           delete price_letter_Items ;
       
       list<Price_Request_Transaction__c> price_req_trans = [Select id,Account_Material__c from Price_Request_Transaction__c where Account_Material__c in :ams];
       for(Price_Request_Transaction__c p: price_req_trans)
           p.Account_Material__c = null;
       update price_req_trans;
       
       delete ams;
   }
   
   
   public static void updatePriceLetterItems(Map<String, Account_Material__c> amMap,list<account_material__c> ams){
           list<Price_Letter_Item__c> price_letter_Items = [Select id,Account_Material__c,Account_Material__r.account__c , Account_Material__r.SAP_Material__c , Account_Material__r.created_from_cpi__c from Price_Letter_Item__c where Account_Material__c in :ams];
           list<Price_Letter_Item__c> price_letter_Items_toupdate = new list<Price_Letter_Item__c>();
           list<Price_Letter_Item__c> price_letter_Items_todelete = new list<Price_Letter_Item__c>();
           
           for(Price_Letter_Item__c p: price_letter_Items){
               if(amMap.containskey(''+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c)){
                   p.Account_Material__c = amMap.get(''+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c).Id;
                   price_letter_Items_toupdate.add(p);
               }
               else if(amMap.containskey(''+p.Account_Material__r.created_from_cpi__c+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c)){
                   p.Account_Material__c = amMap.get(''+p.Account_Material__r.created_from_cpi__c+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c).Id;
                   price_letter_Items_toupdate.add(p);
               }else
                   price_letter_Items_todelete.add(p);
           }
           
           if(price_letter_Items_toupdate.size()>0)
               update price_letter_Items_toupdate;
               
           if(price_letter_Items_todelete.size()>0)
               delete price_letter_Items_todelete;
   }
   
         
    
   public static void updatePRTs(Map<String, Account_Material__c> amMap,list<account_material__c> ams){
       
       list<Price_Request_Transaction__c> price_req_trans = [Select id,Account_Material__c,Account_Material__r.account__c , Account_Material__r.SAP_Material__c , Account_Material__r.created_from_cpi__c from Price_Request_Transaction__c where Account_Material__c in :ams];
       
       for(Price_Request_Transaction__c p: price_req_trans)
           if(amMap.containskey(''+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c))
               p.Account_Material__c = amMap.get(''+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c).Id;
           else if(amMap.containskey(''+p.Account_Material__r.created_from_cpi__c+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c))
               p.Account_Material__c = amMap.get(''+p.Account_Material__r.created_from_cpi__c+p.Account_Material__r.account__c +p.Account_Material__r.SAP_Material__c).Id;
           else
               p.Account_Material__c=null;
   
       if(price_req_trans.size()>0)
           update price_req_trans;
  }
     
   
    Public static string getDateFormat(){
      date d = Date.valueof('1999-01-22');
      string dformat = d.format();
      string f = '';
    
      if(dformat.indexof('22') < dformat.indexof('01'))
        f = 'dd/mm';
      else
        f = 'mm/dd';
      if(dformat.indexof('01') < dformat.indexof('1999'))
        f = f + '/yy';
      else
        f = 'yy/' + f;
      return f;
      
    }


  
  }