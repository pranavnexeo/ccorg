public without sharing class Account_Trigger_Functions {

    public static void processBeforeUpsert(List<Account> alist, boolean isupdate, Map<ID, Account> oldmap) {
        system.debug('SOQL Limit:1: ' + limits.getAggregateQueries());
        Account_Populate_Owner_Name_Field(alist);
        system.debug('SOQL Limit:2: ' + limits.getAggregateQueries());
        Account_Details_Processing_Before(alist, isupdate, oldmap);
        system.debug('SOQL Limit:3: ' + limits.getAggregateQueries());
        Populate_CountryCode_on_Account(alist);
        system.debug('SOQL Limit:4: ' + limits.getAggregateQueries());
        setAccountFields1(alist);
        system.debug('SOQL Limit:5: ' + limits.getAggregateQueries());
        setCustomerHierarchyAccount(alist);
        system.debug('SOQL Limit:6: ' + limits.getAggregateQueries());
        setCustomerGroup5Desc(alist);
        system.debug('SOQL Limit:7: ' + limits.getAggregateQueries());
        Account_Last_Modified(alist);
        system.debug('SOQL Limit:8: ' + limits.getAggregateQueries());
        if(test.isrunningtest() == false) {
        PopulateAccountDetails(alist);
        
        }
            Set<Id> ids = new Set<Id>();
            for(Account a:alist){
               ids.add(a.id);
            }

    }
    
   
    //****This method is added as "Account relationships enhancement" to populate BillTo/SoldTo/Payer details on Account.***
    //****Author @Rajeev****  
    
    Public Static void PopulateAccountDetails(List<Account> acclist){
        
        Map<Id,List<String>> recordkeysmap1 = new Map<Id,List<String>>();
        Map<Id,List<String>> recordkeysmap2 = new Map<Id,List<String>>();
        Map<Id,List<String>> recordkeysmap3 = new Map<Id,List<String>>();
        Map<String,Account> amap = new Map<String,Account>();   
        List<String> sapPayer = new List<String>();
        List<String> sapBillto = new List<String>();
        List<String> sapSoldto = new List<String>();
        
    
        
     //Capture BillTo/Payer/SoldTo details only when the required fields are not null.    
           for(Account a : acclist){
           
                if(a.SAP_Bill_To_Account_Number__c != null && a.SAP_Bill_To_Account_Number__c != '' && a.SAP_Bill_To_Record_Key__c != null && a.SAP_Bill_To_Record_Key__c != ''){
                    List<String> billtolst = new List<String>();
                    billtolst = (a.SAP_Bill_To_Record_Key__c).split(',');
                    
                    for(String s: billtolst)
                        sapBillto.add(s); 
                    recordkeysmap1.put(a.id,billtolst);
                   } 
                if(a.SAP_Payer_Account_Number__c != null && a.SAP_Payer_Account_Number__c != '' && a.SAP_Payer_Account_Key__c != null && a.SAP_Payer_Account_Key__c != ''){   
                    List<String> payerlst = new List<String>();
                    payerlst = (a.SAP_Payer_Account_Key__c).split(',');
                    for(String s:payerlst)
                        sapPayer.add(s); 
                    recordkeysmap2.put(a.id,payerlst);
                                        
                   }
                if(a.SAP_Sold_To_Account_Number__c != null && a.SAP_Sold_To_Account_Number__c != '' && a.SAP_Sold_To_Record_Key__c != null && a.SAP_Sold_To_Record_Key__c != ''){
                    List<String> soldtolst = new List<String>();
                    soldtolst = (a.SAP_Sold_To_Record_Key__c).split(',');
                    for(String s:soldtolst)
                        sapSoldto.add(s); 
                    recordkeysmap3.put(a.id,soldtolst);
                    
                   }         
                }
     //Query Account information based on above details. 
             
        List<Account> alist = [Select Id,AccountNumber,ParentId,Account.Owner.name,Account_number__c,Name,
                               Parent.ZH_Partner__r.User__c,
                               ZH_Partner__r.User__c
        
                               from Account where 
                               (Account_number__c In :sapBillto) OR
                                (Account_number__c In :sapPayer) OR
                                (Account_number__c In :sapSoldto)];
         
       if(alist != null && alist.size()>0){ 
            for(Account a : alist){
             if(a.Account_number__c != null && a.Account_number__c != '')
                amap.put(a.Account_number__c,a);
                }       
            }
     //Finally, populate account details on Account page.   
        for(Account a : acclist){ 
             if(recordkeysmap1.size()>0 && !recordkeysmap1.isEmpty()){
               if(a.SAP_Bill_To_Account_Number__c != null && a.SAP_Bill_To_Account_Number__c != '' && a.SAP_Bill_To_Record_Key__c != null && a.SAP_Bill_To_Record_Key__c != ''){
                   List<String> billto = new List<String>();
                   billto = recordkeysmap1.get(a.id); 
                   
                   for(integer i=0; i<billto.size(); i++){
                    if(amap.get(billto[i]) != null){
                    if(i==0)
                        a.SAP_Bill_To_Account_Name__c = amap.get(billto[i]).name;
                    //change sourabh
                    else{
                        system.debug('^^^'+a.SAP_Bill_To_Account_Name__c);
                        system.debug('$$$'+amap.get(billto[i]).name);
                        If(a.SAP_Bill_To_Account_Name__c !=null || a.SAP_Bill_To_Account_Name__c !='')
                        {
                         a.SAP_Bill_To_Account_Name__c = '';
                         }
                        system.debug('###'+a.SAP_Bill_To_Account_Name__c);
                        a.SAP_Bill_To_Account_Name__c = amap.get(billto[i]).name; 
                        system.debug('###'+a.SAP_Bill_To_Account_Name__c);
                        }                                      
                    if(i==0)
                        a.SAP_Bill_To_Account_ID__c = amap.get(billto[i]).id;
                    else{
                        If(a.SAP_Bill_To_Account_ID__c !=null || a.SAP_Bill_To_Account_ID__c !='')
                        {
                         a.SAP_Bill_To_Account_ID__c = '';
                        }
                        a.SAP_Bill_To_Account_ID__c = amap.get(billto[i]).id;
                        }                                      
                        
                                           
                    if(i==0)
                        a.SAP_Bill_To_Account_Owner__c = amap.get(billto[i]).Owner.Name;
                    else{
                        system.debug('^^^'+a.SAP_Bill_To_Account_Name__c);
                        system.debug('$$$'+amap.get(billto[i]).name);
                        If(a.SAP_Bill_To_Account_Owner__c !=null || a.SAP_Bill_To_Account_Owner__c !='')
                        {
                         a.SAP_Bill_To_Account_Owner__c = '';
                         }
                        system.debug('###'+a.SAP_Bill_To_Account_Owner__c);
                        a.SAP_Bill_To_Account_Owner__c = amap.get(billto[i]).Owner.Name; 
                        system.debug('###'+a.SAP_Bill_To_Account_Owner__c);
                       // a.SAP_Bill_To_Account_Owner__c = a.SAP_Bill_To_Account_Owner__c + ',' + amap.get(billto[i]).Owner.Name;
                        }             
                    
                    }
                   }
                  }
                 }
             if(recordkeysmap2.size()>0 && !recordkeysmap2.isEmpty()){     
               if(a.SAP_Payer_Account_Number__c != null && a.SAP_Payer_Account_Number__c != '' && a.SAP_Payer_Account_Key__c != null && a.SAP_Payer_Account_Key__c != ''){ 
                    List<String> payers = new List<String>();
                    payers = recordkeysmap2.get(a.id);
                   
                    for(integer i=0;i<payers.size();i++){
                     if(amap.get(payers[i]) != null){
                     system.debug('a.SAP_Payer_Account_Name__c:'+a.SAP_Payer_Account_Name__c);
                        if(i==0)
                            a.SAP_Payer_Account_Name__c = amap.get(payers[i]).name;
                        else{ 
                            If(a.SAP_Payer_Account_Name__c !=null || a.SAP_Payer_Account_Name__c !=''){
                                a.SAP_Payer_Account_Name__c = '';
                            }
                            a.SAP_Payer_Account_Name__c = amap.get(payers[i]).name; 
                        }
                        
                        if(i==0)
                            a.SAP_Payer_Account_Id__c = amap.get(payers[i]).id;  
                        else{
                            If(a.SAP_Payer_Account_Id__c !=null || a.SAP_Payer_Account_Id__c !=''){
                                a.SAP_Payer_Account_Id__c = '';
                            }
                            a.SAP_Payer_Account_Id__c = amap.get(payers[i]).id;              
       
                            }                     
                        if(i==0) 
                            a.SAP_Payer_Account_Owner__c = amap.get(payers[i]).Owner.Name;
                        else{
                            If(a.SAP_Payer_Account_Owner__c !=null || a.SAP_Payer_Account_Owner__c !='')
                            {
                             a.SAP_Payer_Account_Owner__c = '';
                            }
                            system.debug('###'+a.SAP_Payer_Account_Owner__c); 
                            a.SAP_Payer_Account_Owner__c = amap.get(payers[i]).Owner.Name;   
                        }
                            
                     }
                    }
                   }
                  }
             if(recordkeysmap3.size()>0 && !recordkeysmap3.isEmpty()){     
               if(a.SAP_Sold_To_Account_Number__c != null && a.SAP_Sold_To_Account_Number__c != '' && a.SAP_Sold_To_Record_Key__c != null && a.SAP_Sold_To_Record_Key__c != ''){
                    List<String> soldto = new List<String>();
                    soldto = recordkeysmap3.get(a.id); 
                    
                    for(integer i=0; i< soldto.size(); i++){
                      if(amap.get(soldto[i]) != null){
                        if(i==0)
                            a.SAP_Sold_To_Account_Name__c = amap.get(soldto[i]).name;
                        else
                            a.SAP_Sold_To_Account_Name__c = a.SAP_Sold_To_Account_Name__c + ',' + amap.get(soldto[i]).name;
                                                
                        if(i==0)
                            a.SAP_Sold_To_AccountId__c = amap.get(soldto[i]).id;
                        else
                            a.SAP_Sold_To_AccountId__c = a.SAP_Sold_To_AccountId__c + ',' + amap.get(soldto[i]).id;
                        
                        if(i==0)
                            a.SAPSoldToAccountOwner__c= amap.get(soldto[i]).Owner.name;
                        else
                            a.SAPSoldToAccountOwner__c= a.SAPSoldToAccountOwner__c + ',' + amap.get(soldto[i]).Owner.name;
                      
                      }     
                     }
                    }
                   }
                  }   
                }
              
    //***** End of enhancement *****
    
    public static void processAfterInsert(List<Account> alist){
       Account_Details_Processing_After_Insert(alist);
       system.debug('SOQL Limit:9: ' + limits.getAggregateQueries());
    }
    
    public static void ProcessBeforeUpdate(List<Account> alist, Map<ID, Account> oldmap){
       
       Account_Converted_From_Prospect(alist, oldmap);
       system.debug('SOQL Limit:10: ' + limits.getAggregateQueries());
       if(test.isrunningtest() == false)
          Account_Relationships(alist);

    }

    private static void Account_Converted_From_Prospect(list<account> alist, Map<ID, Account> oldmap) {

      for(Account a : alist){
         Account oldAccount = oldmap.get(a.Id);
         if(a.Type == 'Customer' && oldAccount.Type == 'Prospect')
         {a.Prospect_Converted_Date__c = system.today();}
      }
    }
    
    @TestVisible
    private static void Account_Relationships(List<Account> accounts){
    Map<Id, Account> amap;
    Set<String> ids = new set<String>();    
    Set<String> aids = new Set<String>();
    for(account a:accounts)
    { if(a.id != null)
       ids.add(a.id);
       if(a.parentid != null)
        ids.add(a.parentid);
    }
    
    Map<String, Map<String, String>> relmap = CISRelationships_Functions.Lookup_Related_Accounts(ids);
    for(Map<String, String> m:relmap.Values())
    {   ids.addall(m.keyset());
        ids.addall(m.values());
    }
    if(!ids.isEmpty()){
    amap = new Map<Id,Account>([select id, name, accountnumber, SAP_Sales_Office__c, SAP_Sales_Office_Desc__c, ZH_Partner__c, ZH_Partner__r.User__c, parent.ZH_Partner__c,SAP_DivisionCode__c,parent.ZH_Partner__r.User__c, ownerid, owner.name
            from Account where id IN :ids limit 50000]);
    }
    for(account a:accounts)
    {
      if(a.SAP_Partner_Functions__c != null)
      {
        if(a.SAP_Partner_Functions__c.contains('SOLD'))
        {
           a.SAP_Sold_To_Account_Id__C = a.id;
           a.SAP_Sold_To_Account__c = a.accountnumber + ' - ' + a.name;
           a.Sold_To_Customer_Number__c = a.accountnumber;
           a.SAP_Sold_To_Account_Owner__c = a.Primary_Seller__c;
           a.SAP_Sold_To_Account_Owner_Name__c = a.Primary_Seller__c;
        }
        else
        {
            if(relmap.get('SoldTos').containskey(a.id))
            {  a.SAP_Sold_To_Account_Id__c = relmap.get('SoldTos').get(a.id);
               a.SAP_Sold_To_Account__c = amap.get(a.SAP_Sold_to_Account_Id__c).accountnumber + ' - ' + amap.get(a.SAP_Sold_to_Account_Id__c).name;
               a.Sold_To_Customer_Number__c = amap.get(a.SAP_Sold_to_Account_Id__c).accountnumber;
               a.SAP_Sold_To_Account_Owner__c = a.Primary_Seller__c;
           a.SAP_Sold_To_Account_Owner_Name__c = a.Primary_Seller__c;
            } 
        } 
        if(amap.get(a.id).Parent.ZH_Partner__c != null){
           a.SAP_Corporate_Account_Manager__c = amap.get(a.id).parent.ZH_Partner__r.User__c;
         }   
      }
      else
      {
         a.SAP_SOld_To_Account__c = 'N/A';
         a.SAP_SOld_To_Account_Id__c = '';
         a.Sold_To_Customer_Number__c = '';
         a.SAP_Sold_To_Account_Owner__c = null;
         a.SAP_Sold_To_Account_Owner_Name__c = '';
         
         if(a.ZH_Partner__c != null){
           a.SAP_Corporate_Account_Manager__c = amap.get(a.id).ZH_Partner__r.User__c;
        }
      }
      
      if(a.parentid != null)
      {
         if(amap.containskey(a.parentid))
         {
          a.SAP_Corporate_Account_Id__c = a.parentid;
          a.SAP_Corporate_Account__c = amap.get(a.parentid).accountnumber + ' - ' + amap.get(a.parentid).name;
          a.SAP_Corporate_Account_Manager__C = amap.get(a.parentid).ownerid;
          a.Corporate_Account_Manager__c = amap.get(a.parentid).owner.name;
          a.HQ_Seller__c = amap.get(a.parentid).owner.name;
          a.HQ_Sales_Office__c = amap.get(a.parentid).SAP_Sales_Office__c;
          a.HQ_Sales_Office_Desc__c = amap.get(a.parentid).SAP_Sales_Office_Desc__c;
         }
      }
      else
      {
         if(a.SAP_Sold_To_Account_Id__c != '')
         {  if(relmap.get('CorpIds').containskey(a.SAP_Sold_To_Account_Id__c))
            {
             if(relmap.get('CorpIds').containskey(a.SAP_Sold_To_Account_Id__c) != null )
             {
               if(amap.containskey(relmap.get('CorpIds').get(a.SAP_Sold_To_Account_Id__c)))
               {
                a.SAP_Corporate_Account_Id__c = relmap.get('CorpIds').get(a.SAP_Sold_To_Account_Id__c);
                a.SAP_Corporate_Account__c = amap.get(a.SAP_Corporate_Account_Id__c).accountnumber + ' - ' + amap.get(a.SAP_Corporate_Account_Id__c).name;
                a.SAP_Corporate_Account_Manager__c = amap.get(a.SAP_Corporate_Account_Id__c).ownerid;
                a.Corporate_Account_Manager__c = amap.get(a.SAP_Corporate_account_id__c).owner.name;
                a.HQ_Seller__c = amap.get(a.SAP_Corporate_account_id__c).owner.name;
                a.HQ_Sales_Office__C =  amap.get(a.SAP_Corporate_account_id__c).SAP_Sales_Office__c;
                a.HQ_Sales_Office_Desc__C =  amap.get(a.SAP_Corporate_account_id__c).SAP_Sales_Office_Desc__c;
               }
             }
             else
           {
             a.SAP_Corporate_Account_Id__c = '';
             a.SAP_Corporate_Account__c = 'N/A';
             
             if(a.SAP_Accounting_Group__c != 'Parent')
             {
               a.SAP_Corporate_Account_Manager__c = null;
               a.Corporate_Account_Manager__c = '';
               a.HQ_Seller__c = '';
               a.HQ_Sales_Office_Desc__c = '';
               a.HQ_Sales_Office__c = '';
             }
           }
          }
            else
           {
             a.SAP_Corporate_Account_Id__c = '';
             a.SAP_Corporate_Account__c = 'N/A';
             if(a.SAP_Accounting_Group__c != 'Parent')
             {
               a.SAP_Corporate_Account_Manager__c = null;
               a.Corporate_Account_Manager__c = '';
               a.HQ_Seller__c = '';
               a.HQ_Sales_Office_Desc__c = '';
               a.HQ_Sales_Office__c = '';
             }
           }
         }
         else
         {
          a.SAP_Corporate_Account_Id__c = '';
          a.SAP_Corporate_Account__c = 'N/A';
          if(a.SAP_Accounting_Group__c != 'Parent')
          {
            a.SAP_Corporate_Account_Manager__c = null;
            a.Corporate_Account_Manager__c = '';
            a.HQ_Seller__c = '';
            a.HQ_Sales_Office_Desc__c = '';
            a.HQ_Sales_Office__c = '';
          }
         }
      }
      
   }   
      
}

    @TestVisible
    private static void Account_Last_Modified(List<Account> alist){
       Profile p = [select id, name from Profile where id = :UserInfo.getProfileId() limit 1];
       for (Account a:alist)  {    
         IF(p.Name != 'System Administrator' && p.Name != 'System Administrator - SSO Enabled'){
         a.Last_Modified_By__c = a.lastmodifiedbyid;
         a.Last_Modified_Date_time__C = a.lastmodifieddate;
         }
       }
    }
    @TestVisible
       private static void Account_Populate_Owner_Name_Field(List<Account> alist) {
    /* list<string> saptid = new list<string>();
    map<string,SAP_Territory__c> sapTerritorymap = new map<string,SAP_Territory__c>();
    for(Account a : alist){
        saptid.add(a.YZ_Partner__c);
        sapTerritorymap.put(a.YZ_Partner__c,a.YZ_Partner__r);
        
    }      
          
        
    map<string,SAP_Territory__c> accountIdWFUsermap = new map<string,SAP_Territory__c>();
    for(SAP_Territory__c objSapt : [SELECT ID,ZS_Partner__r.User__c from SAP_Territory__c where Id =: accountIdWFUsermap.keyset()]){
        accountIdWFUsermap.put(objSapt.id,objSapt);
    
    }  */ 
   //For all the accounts inserted or updated capture the OwnerIds
   Set<id> userids = new Set<id>();
   //Set<id> useridsco = new Set<id>();
   map<string,SAP_Territory__c> sapspmap = new map<string,SAP_Territory__c>();
   map<string,SAP_Territory__c> sapcomap = new map<string,SAP_Territory__c>();
   map<string,SAP_Territory__c> sapyimap = new map<string,SAP_Territory__c>();
   map<string,SAP_Seller__c> sapssmap = new map<string,SAP_Seller__c>();
   User u = new User();
   nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
   if(settings!= null){
       String userId = settings.Nexeo_Integration_User_Id__c;
       if(userId != null){
        u = [select id from user where id =: userId];
       } 
   }
   else{
       u = [select id from User where name =: 'Nexeo_Integration User' LIMIT 1];
   }
   for(Account a : alist){
       If(a.YZ_Partner__c != null){
           sapspmap.put(a.YZ_Partner__c,a.YZ_Partner__r);
       }    
       If(a.YI_Partner__c != null){
           sapyimap.put(a.YI_Partner__c,a.YI_Partner__r);
       }  
       If(a.YY_Partner__c != null){
           sapcomap.put(a.YY_Partner__c,a.YY_Partner__r);
       }
       If(a.YZ_Partner__c == null && a.YY_Partner__c == null && a.ZH_Partner__c != null){
          system.debug('^^^');
          sapssmap.put(a.ZH_Partner__c,a.ZH_Partner__r) ;
       }   
   }
   for(SAP_Seller__c objtsap : [SELECT id,user__c from SAP_Seller__c where Id =: sapssmap.keyset()]){
        sapssmap.put(objtsap.id,objtsap);  
   }
   for(SAP_Territory__c objtsap : [SELECT ID,
                                          ZS_Partner__r.User__c,YS_Partner__r.user__r.isactive,
                                          ZS_Partner__c,YS_Partner__r.user__c,ZS_Partner__r.User__r.isactive,
                                          YS_Partner__c,
                                          SAP_Sales_DOG__r.SAP_Sales_District_Desc__c,
                                          SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c,
                                          SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c
                                           from SAP_Territory__c where Id =: sapspmap.keyset()]){
        sapspmap.put(objtsap.id,objtsap);  
   }
   for(SAP_Territory__c objtsap : [SELECT ID,
                                          ZS_Partner__r.User__c,ZS_Partner__r.User__r.isactive,
                                          ZS_Partner__c,
                                          YS_Partner__r.user__c,YS_Partner__r.user__r.isactive,
                                          YS_Partner__c,
                                          SAP_Sales_DOG__r.SAP_Sales_District_Desc__c,
                                          SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c,
                                          SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c 
                                          from SAP_Territory__c where Id =: sapcomap.keyset()]){
        sapcomap.put(objtsap.id,objtsap);  
   }
   for(SAP_Territory__c objtsap : [SELECT ID,
                                          ZS_Partner__r.User__c,ZS_Partner__r.User__r.isactive,
                                          ZS_Partner__c,
                                          YS_Partner__r.user__c,YS_Partner__r.user__r.isactive,
                                          YS_Partner__c,
                                          SAP_Sales_DOG__r.SAP_Sales_District_Desc__c,
                                          SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c,
                                          SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c 
                                          from SAP_Territory__c where Id =: sapyimap.keyset()]){
        sapyimap.put(objtsap.id,objtsap);  
   }
   for(Account a : alist){
       If(a.YI_Partner__c != null){
           If(sapyimap.get(a.YI_Partner__c).ZS_Partner__r.User__c != null){ 
               system.debug('---'+sapyimap);
               system.debug('+++'+sapyimap.get(a.YI_Partner__c).ZS_Partner__r.User__c);
               a.Informational_Seller__c = sapyimap.get(a.YI_Partner__c).ZS_Partner__r.User__c;
           }
       }
       system.debug('++'+alist);
       boolean isCommodity = (
                              (a.SAP_Customer_Group_2__c == 'COM') ||
                              (a.SAP_Customer_Group_2__c != 'SPC' && a.SAP_Customer_Group_2__c != 'COM')
                             );
       boolean isSpecialty = (a.SAP_Customer_Group_2__c == 'SPC');
       
       If(a.YZ_Partner__c != null){
            If(sapspmap.get(a.YZ_Partner__c).ZS_Partner__r.User__c != null){
              if(isSpecialty){
                a.primary_Seller__c = sapspmap.get(a.YZ_Partner__c).ZS_Partner__r.User__c;
                system.debug('****'+sapspmap.get(a.YZ_Partner__c).ZS_Partner__r.User__r.isactive);
                system.debug('*****'+a.primary_Seller__c);
                If(sapspmap.get(a.YZ_Partner__c).ZS_Partner__r.User__r.isactive == true){
                    a.ownerid = a.primary_Seller__c;
                }    
                if(a.primary_seller__c == null || sapspmap.get(a.YZ_Partner__c).ZS_Partner__r.User__r.isactive == false){ 
                    a.ownerid = u.id;
                    a.primary_seller__c = a.ownerid;   
                }
              }
              a.Specialty_Seller__c = sapspmap.get(a.YZ_Partner__c).ZS_Partner__r.User__c;
              if(a.Specialty_seller__c == null){ a.Specialty_seller__c = a.ownerid; }
            }    
            If(sapspmap.get(a.YZ_Partner__c).YS_Partner__r.User__c != null){      
              if(isSpecialty){
                a.primary_Sales_support__c = sapspmap.get(a.YZ_Partner__c).YS_Partner__r.User__c;
              }
              a.Specialty_sales_support__c = sapspmap.get(a.YZ_Partner__c).YS_Partner__r.User__c;
            }
            if(isSpecialty){
              system.debug('1234'+isSpecialty);
              a.Primary_SAP_Sales_District__c = sapspmap.get(a.YZ_Partner__c).SAP_Sales_DOG__r.SAP_Sales_District_Desc__c;
              a.Primary_SAP_Sales_Office__c = sapspmap.get(a.YZ_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c;
              a.Primary_SAP_Sales_Group__c = sapspmap.get(a.YZ_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c;
              system.debug('dist'+a.Primary_SAP_Sales_District__c );
              system.debug('off'+a.Primary_SAP_Sales_Office__c );
              system.debug('grp'+a.Primary_SAP_Sales_Office__c );
           }
            a.Specialty_Sales_District__c = sapspmap.get(a.YZ_Partner__c).SAP_Sales_DOG__r.SAP_Sales_District_Desc__c;
            a.Specialty_Sales_Office__c = sapspmap.get(a.YZ_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c;
            a.Specialty_Sales_Group__c = sapspmap.get(a.YZ_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c;
       }    
       If(a.YY_Partner__c != null){
            If(sapcomap.get(a.YY_Partner__c).ZS_Partner__r.user__c != null){
              if(isCommodity){
                a.primary_Seller__c = sapcomap.get(a.YY_Partner__c).ZS_Partner__r.user__c;
                If(sapcomap.get(a.YY_Partner__c).ZS_Partner__r.user__r.isactive == true){
                    a.ownerid = a.primary_Seller__c;
                }else{
                    a.ownerid =u.id;
                 }                   
                if(a.primary_seller__c == null || sapcomap.get(a.YY_Partner__c).ZS_Partner__r.user__r.isactive == false){ 
                    a.ownerid = u.id;
                    a.primary_seller__c = a.ownerid; 
                }
              }
              a.Gen_Comm_Seller__c = sapcomap.get(a.YY_Partner__c).ZS_Partner__r.user__c;
              if(a.Gen_Comm_Seller__c == null){ a.Gen_Comm_Seller__c = a.ownerid; }
            }    
            If(sapcomap.get(a.YY_Partner__c).YS_Partner__r.user__c != null){
              if(isCommodity){  
                a.primary_Sales_Support__c = sapcomap.get(a.YY_Partner__c).YS_Partner__r.user__c; 
              }
              a.Gen_Comm_Sales_support__c = sapcomap.get(a.YY_Partner__c).YS_Partner__r.user__c;          
            }
            if(isCommodity){
              system.debug('1234'+isCommodity);
              a.Primary_SAP_Sales_District__c = sapcomap.get(a.YY_Partner__c).SAP_Sales_DOG__r.SAP_Sales_District_Desc__c;
              a.Primary_SAP_Sales_Office__c = sapcomap.get(a.YY_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c;
              a.Primary_SAP_Sales_Group__c = sapcomap.get(a.YY_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c;
            }
            a.Gen_Comm_Sales_District__c = sapcomap.get(a.YY_Partner__c).SAP_Sales_DOG__r.SAP_Sales_District_Desc__c;
            a.Gen_Comm_Sales_Office__c = sapcomap.get(a.YY_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Office_Desc__c;
            a.Gen_Comm_Sales_Group__c = sapcomap.get(a.YY_Partner__c).SAP_Sales_DOG__r.SAP_Sales_Group_Desc__c;
             
         }   
         if(isCommodity && a.YY_Partner__c == null && a.YZ_Partner__c == null && a.SAP_Account_Group__c == '0012' && a.ZH_Partner__c != null){
             a.ownerid = sapssmap.get(a.ZH_Partner__c).User__c;
         }
         if(isCommodity && a.YY_Partner__c == null && a.YZ_Partner__c == null && a.SAP_Account_Group__c == '0012' && a.ZH_Partner__c == null){
             a.ownerid = u.id;
         }   
         If(a.YZ_Partner__c == null){ 
                a.Specialty_Seller__c = null;
                a.Specialty_Sales_Support__c = null;
                a.Specialty_Sales_District__c = '';
                a.Specialty_Sales_Office__c = '';
                a.Specialty_Sales_Group__c = ''; 
        }     
        If(a.YY_Partner__c == null){
               a.Gen_Comm_Seller__c = null;
               a.Gen_Comm_Sales_Support__c = null;
               a.Gen_Comm_Sales_Group__c = '' ;
               a.Gen_Comm_Sales_Office__c = '' ;
               a.Gen_Comm_Sales_District__c = '' ;
        }
        //If Both YY and YZ are null
        if(a.YY_Partner__c == null && a.YZ_Partner__c == null){
              a.Primary_SAP_Sales_Office__c ='';
              a.Primary_SAP_Sales_Group__c = '';
              a.Primary_SAP_Sales_District__c = '';    
              if(a.type != 'Prospect'){
                  a.Primary_Seller__c = null;
              }
              a.Primary_Sales_Support__c = null;
        }  
        
     }   
  }
    @TestVisible
    private static void Populate_CountryCode_on_Account(list<Account> alist){
     
   //For all the accounts inserted or updated capture the Coutnry
   Set<String> countries = new Set<String>();
   for(Account a : alist){
    countries.add(a.SAP_Country__c);
   }

   //Query all Country Codes for the countries
   
   List<Country_Code__c> codes = [select Country__c, Code__c From Country_Code__c where Country__c IN :countries];
   Map<String,String> countryCodeMap = new Map<String,String>();
   for(Country_Code__c code: codes) {countryCodeMap.put(code.Country__c,code.Code__c);}
   
   //For all of the accounts being inserted or updated retrieve and populate the Country Code
   for(Account a : alist)
    {
    if (a.Country_Code__c != countryCodeMap.get(a.SAP_Country__c))
       {
       a.Country_Code__c = countryCodeMap.get(a.SAP_Country__c);
       }
    }
   }
    
    private static void Account_Details_Processing_Before(List<Account> alist, boolean isupdate, Map<Id, Account> oldmap){
    
    
    List<Account> accountUpdates = new List<Account>();
    Map<String, String> sapSalesOrgDesc = new Map<String, String>();
    List<String> sapSalesOrgs = new List<String>();
    List <String> addressLines;
    Set<String> plantCodes = new Set<String>();
    Map<String, Id> plantMap = new Map<String, Id>();
    String AccountAddress = '';
    
    //Retrieving Map of all Account Record Type Ids and their values Customer/Vendor and Prospect/Other 
    Map<Id, String> accRecordTypeMap = RecordType_Functions.RetrieveAccRecordTypeMap();
    Map<String, Id> accRecTypeNameMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    
    //Getting RecordTypeId for Aqualon Account without using SOQL       
    //Map<String, Schema.RecordTypeInfo> rtMapByNameAcc = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    //Id accRecordTypeId = rtMapByNameAcc.get('Aqualon Account').getRecordTypeId();
    Id accRecordTypeId = accRecTypeNameMap.get('Aqualon Account');

        for(Account a : alist)  {
           
            if(a.SAP_ShippingPlant__c != null && a.SAP_ShippingPlant__c != ''){
              plantCodes.add(a.SAP_ShippingPlant__c);
            }
            // Processing for Prospect Pricing
            if( a.RecordTypeID == accRecTypeNameMap.get('Aqualon Prospect') ||    
            a.RecordTypeID == accRecTypeNameMap.get('Distribution Prospect') ||
            a.RecordTypeID == accRecTypeNameMap.get('Valvoline DIFM Prospect') ||
            a.RecordTypeID == accRecTypeNameMap.get('Valvoline DIY Prospect') ||
            a.RecordTypeID == accRecTypeNameMap.get('Water Prospect') ||
            a.RecordTypeID == accRecTypeNameMap.get('Distribution Prospect - Plastics') ||
            a.RecordTypeID == accRecTypeNameMap.get('Distribution RTK Prospect') ||
            a.RecordTypeID == accRecTypeNameMap.get('Performance Materials Prospect')) {
            if(a.primary_seller__c == null){ a.primary_seller__c = a.ownerid; }
            else{ a.ownerid = a.primary_seller__c; }

            if(a.country_picklist__c != NULL){
            a.billingcountry = String_Functions.inParenthesis(a.country_picklist__c);
            a.SAP_Country__c = String_Functions.inParenthesis(a.country_picklist__c);}
            
            if(a.Prospect_Sales_Org__c != NULL){
            a.SAP_Sales_Org__C = String_Functions.inParenthesis(a.Prospect_Sales_Org__c);
            a.SAP_Sales_Org_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_Org__c);}
            
            if(a.Prospect_Division__c != NULL){
            a.SAP_Divisioncode__C = String_Functions.inParenthesis(a.Prospect_Division__c);
            a.SAP_Division_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Division__c);}
            
            if(a.Prospect_Dist_Channel__c != NULL){
            a.SAP_DistChannel__C = String_Functions.inParenthesis(a.Prospect_Dist_Channel__c);
            a.SAP_Dist_Channel_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Dist_Channel__c);}
            
            if(a.Prospect_Sales_District__c != NULL){
            a.SAP_SalesDistrict__c = String_Functions.inParenthesis(a.Prospect_Sales_District__c);
            a.SAP_Sales_District_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_District__c);}
            
            if(a.Prospect_Sales_Office__c != NULL){
            a.SAP_Sales_Office__c = String_Functions.inParenthesis(a.Prospect_Sales_Office__c);
            a.SAP_Sales_Office_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_Office__c);}
            
            if(a.Prospect_Sales_Group__c != NULL){
            a.SAP_SalesGroup__c = String_Functions.inParenthesis(a.Prospect_Sales_Group__c);
            a.SAP_Sales_Group_Desc__c = String_Functions.BeforeParenthesis(a.Prospect_Sales_Group__c);}
            
            if(a.Prospect_Customer_Group__c != NULL){
            a.SAP_Customer_Group__c = String_Functions.inParenthesis(a.Prospect_Customer_Group__c);
            a.SAP_Customer_Group_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group__c);}
            
            if(a.Prospect_Customer_Group1__c != NULL){
            a.SAP_Customer_Group_1__c = String_Functions.inParenthesis(a.Prospect_Customer_Group1__c);
            a.SAP_Customer_Group_1_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group1__c);}
            
            /*if(a.Prospect_Customer_Group2__c != NULL){
            a.SAP_Customer_Group_2__c = String_Functions.inParenthesis(a.Prospect_Customer_Group2__c);
            a.SAP_Customer_Group_2_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group2__c);}*/
            
           /* //Added by annes on 05/17/2012
            if(a.Prospect_Customer_Group_4__c != NULL){
            a.SAP_Customer_Group_4__c = String_Functions.inParenthesis(a.Prospect_Customer_Group_4__c);
            a.SAP_Customer_Group_4_Desc__c = String_Functions.beforeParenthesis(a.Prospect_Customer_Group_4__c);}*/
        }
            
            // Processing for non-Aqualon
            
            if (a.RecordTypeId != accRecordTypeId)
            {
            
                      //Processing for Customer/Vendor Account Record Types
                      if(accRecordTypeMap.get(a.RecordTypeId) == 'Customer/Vendor' )
                      {
                         //Data.com Processing - Prevent anyone but integration user from changing Account Name for Customers
                         if(isupdate == true && 
                            !userinfo.getname().toUpperCase().contains('INTEGRATION'))
                         {
                            a.Name = oldmap.get(a.id).name;
                         }
                      }

                        
                        addressLines = new List<String>();
                        addressLines.add(a.SAP_Street__c);
                        addressLines.add(a.SAP_StreetSuppl1__c);
                        addressLines.add(a.SAP_StreetSuppl2__c);
                        addressLines.add(a.SAP_StreetSuppl3__c);
                        
                       // if(accRecTypeNameMap.get('Data.com Prospect') != a.RecordTypeId){ 
                     
                         if((accRecTypeNameMap.get('Data.com Prospect') != a.RecordTypeId && accRecTypeNameMap.get('Distribution Prospect') != a.RecordTypeId ) || ( userinfo.getname().toUpperCase().contains('INTEGRATION'))){                  
                   
                        //Copy custom address fields value to standard address fields
                            a.BillingStreet = Address_Functions.convert4LineAddressto1(addressLines);
                            a.BillingCity = a.SAP_City__c;
                            a.BillingState = a.SAP_State__c;
                            a.BillingPostalCode = a.SAP_Zip_Code__c;
                            a.BillingCountry = a.SAP_Country__c;
                        }              
                    //}
                    
                    /*
                    //Processing for Prospect/Vendor Account Record Types
                    else if(accRecordTypeMap.get(a.RecordTypeId) == 'Prospect/Other' && a.recordtypeid != accRecTypeNameMap.get('Water Prospect'))
                    {
                        //Copy standard address field values to custom address fields
                        List<String> billingStreet  = Address_Functions.convert1LineAddressto4(a.BillingStreet);
                        if(billingStreet.size()>0) a.SAP_Street__c = billingStreet[0];
                        else a.SAP_Street__c = '';
                        if(billingStreet.size()>1) a.SAP_StreetSuppl1__c = billingStreet[1];
                        else a.SAP_StreetSuppl1__c = '';
                        if(billingStreet.size()>2) a.SAP_StreetSuppl2__c = billingStreet[2];
                        else a.SAP_StreetSuppl2__c = '';
                        if(billingStreet.size()>3) a.SAP_StreetSuppl3__c = billingStreet[3];
                        else a.SAP_StreetSuppl3__c = '';
                        a.SAP_City__c = a.BillingCity;
                        a.SAP_State__c = a.BillingState;
                        a.SAP_Zip_Code__c = a.BillingPostalCode;
                        a.SAP_Country__c = a.BillingCountry;
                    }
                    */
                      
                                                    
                // Populate Full_Address Field
                addressLines = new List<String>();
                addressLines.add(a.SAP_Street__c);
                addressLines.add(a.SAP_StreetSuppl1__c);
                addressLines.add(a.SAP_StreetSuppl2__c);
                addressLines.add(a.SAP_StreetSuppl3__c);
                
                AccountAddress = Address_Functions.FormatAddressforTextArea(addressLines,
                                                                            a.SAP_City__c,
                                                                            a.SAP_State__c,
                                                                            a.SAP_Zip_Code__c,
                                                                            a.SAP_Country__c);
        
                a.Full_Address__c = AccountAddress;
                system.debug('Full Address'+a.Full_Address__c);
    
                // Populate the Account Number Field (only if it is a Customer)
                if(a.SAP_Customer_Number__c != null) 
                   a.AccountNumber = a.SAP_Customer_Number__c;
                else if (isUpdate)
                   a.AccountNumber = a.CIS_Prospect_Number__c;
                
                // Populate Billing and Shipping Addresses appropriately
                Boolean populateShipping = true;
                Boolean populateBilling = true;
                
                //Handle Aqualon - Bypass Address updates - RecordType = "Aqualon Account"
                //if (a.RecordTypeId == '012500000009W8gAAE') {populateShipping = false; populateBilling = false;}
                
                //if (a.SAP_Partner_Functions__c != null)  {
                //    populateShipping = a.SAP_Partner_Functions__c.contains('Ship To');
                //    populateBilling = a.SAP_Partner_Functions__c.contains('Bill To');
                //}
                
                //if ((populateShipping == false) && (populateBilling == false)) {populateShipping = true;}
                
                //if(accRecTypeNameMap.get('Data.com Prospect') != a.RecordTypeId){  
                 
                   if((accRecTypeNameMap.get('Data.com Prospect') != a.RecordTypeId && accRecTypeNameMap.get('Distribution Prospect') != a.RecordTypeId ) || ( userinfo.getname().toUpperCase().contains('INTEGRATION'))){                  
                     if (populateShipping == true){
                        
                            a.ShippingStreet = Address_Functions.convert4LineAddressto1(addressLines);
                            a.ShippingCity = a.SAP_City__c;
                            a.ShippingState = a.SAP_State__c;
                            a.ShippingPostalCode = a.SAP_Zip_Code__c;
                            a.ShippingCountry = a.SAP_Country__c;
                        
                    }
            
                    if (populateBilling == true){
                        
                            a.BillingStreet = Address_Functions.convert4LineAddressto1(addressLines);
                            a.BillingCity = a.SAP_City__c;
                            a.BillingState = a.SAP_State__c;
                            a.BillingPostalCode = a.SAP_Zip_Code__c;
                            a.BillingCountry = a.SAP_Country__c;
                            
                    }
                } 
                
                // For all the accounts being inserted or updated, take the necessary action on the 'Active Account' field
        
                // Values for the 'Active Account' field:
                // 'YES' = means that the account is active
                // 'NO' = means that the account is inactive
        
                // Values for the 'Inactive Account' field
                // 'TRUE'  = means that the account is inactive
                // 'FALSE' = means that the account is active
           
                // Values for the 'Prospect Status' field
                // 'OPEN' = means that the Prospect account is active
                // 'INACTIVE' = means that the Prospect record is inactive
        
                if(a.type == 'Prospect' || a.type == 'Other CAM Acct' || a.type == 'University' || a.type == 'Customers Customer')  {
                   if(a.cis_prospect_status__c == 'Inactive')
                      a.active_account__c = 'No';
                   else
                      a.active_account__c = 'Yes';
                }
                else if (a.type == 'Customer' || a.type == 'Vendor' || a.type == 'KNA1')  {
                   if (a.inactive_account__c)
                      a.active_account__c = 'No';
                   else
                      a.active_account__c = 'Yes';                        
                }
                else if (a.type == 'Marked for Deletion')  {
                   if(a.cis_prospect_status__c == 'Inactive' || a.inactive_account__c)
                      a.active_account__c = 'No';
                   else
                      a.active_account__c = 'Yes';                     
                } 
                
                
                        
                // Enter the street address of the customer into the Street Address field
                // Get the address from the ShippingStreet field (this field is configured above)
                a.street_address__c = a.ShippingStreet;
                
                // Enter the State, City and Country of the customer into the State_City_Country field       
                   a.state_city_country__c = Address_Functions.FormatCustomerLocation(a.SAP_State__c, a.SAP_City__c, a.SAP_Country__c);  
                   
        
                // Get a list of all the Sales Orgs that are in the 'Customer' type accounts to be created/updated.
                if(a.type == 'Customer')
                   sapSalesOrgs.add(a.SAP_Sales_Org__c);
                }
            else
                //Processing for Aqualon
                {
                //a.AccountNumber = a.Ship_To_Customer_Number__c;
                a.street_address__c = a.ShippingStreet;
                a.state_city_country__c = Address_Functions.FormatCustomerLocation(a.ShippingState, a.ShippingCity, a.ShippingCountry);        
                }       
            }
            
            // end of For Loop
    
        // Get the various Sales Org Descriptions and add them to the map by
//        sapSalesOrgDesc = SAP_Sales_Org_Lookup_Functions.getSalesOrgDescriptions(sapSalesOrgs);
        
        // This For Loop handles the Sales Orgs and Description for each 'Customer' type account        
        
        for(SAP_Plant__c p:[select id, Plant_Code__c from SAP_Plant__c where Plant_Code__c IN :plantcodes]){
          plantMap.put(p.Plant_Code__c, p.id);
        }
          
        for(Account a : alist)  {
        
            if(plantmap.containskey(a.SAP_ShippingPlant__c)){
              a.SAP_Plant__c = plantMap.get(a.SAP_ShippingPlant__c);
            }else{
              a.SAP_Plant__c = null;
            }
            // Processing for non-Aqualon
           
            if (a.RecordTypeId != accRecordTypeId)
                {
                   if (a.type == 'Customer')  {
//                      a.sales_area__c = a.SAP_Sales_Org__c + ' / ' + a.SAP_DistChannel__c + ' / ' + a.SAP_DivisionCode__c + '\n' + sapSalesOrgDesc.get(a.SAP_Sales_Org__c) + ' / ' + a.SAP_Dist_Channel_Desc__c + ' / ' +  a.SAP_Division_Desc__c;
                      //a.sap_sales_org_desc__c = sapSalesOrgDesc.get(a.SAP_Sales_Org__c);
                      a.sales_area__c = a.SAP_Sales_Org__c + ' / ' + a.SAP_DistChannel__c + ' / ' + a.SAP_DivisionCode__c + '\n' + a.SAP_Sales_Org_Desc__c + ' / ' + a.SAP_Dist_Channel_Desc__c + ' / ' +  a.SAP_Division_Desc__c;
                   }
                }
            else
                {
                a.sales_area__c = a.Industry;
                // + ' - ' + a.PAC_Industry_Segment__c;   
                }
        }
    }
    
    
    private static void Account_Details_Processing_After_Insert(List<Account> alist){
    
    Map<String, Id> accRecTypeNameMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    List<Account> prospectUpdates = new List<Account>();
    Id accRecordTypeId = accRecTypeNameMap.get('Aqualon Account');
    
    // If the new Account is a Prospect, the AccountNumber field will not populate with the Prospect Number because
    // the Prospect Number does not get generated until after the Prospect has been created. AfterInsert is needed
    // Following Code runs only on New Prospects

       List<Account> prospects = [SELECT Id, AccountNumber, RecordTypeId, CIS_Prospect_Number__c FROM Account WHERE Type in ('Prospect', 'Other') AND Id IN :alist];
       
       for(Account a : prospects)  {
        
            // Processing for non-Aqualon
            if (a.RecordTypeId != accRecordTypeId)
                {
                // Populate the Account Number Field (only if it is a Prospect)
                a.AccountNumber = a.CIS_Prospect_Number__c;
                prospectUpdates.add(a);
                }
            else
                {
                //Processing for Aqualon
               // a.AccountNumber = a.Ship_To_Customer_Number__c;
                //prospectUpdates.add(a);
                }
       }
       if (prospectUpdates.size() != 0) { update(prospectUpdates);}
    }
    
    private static void setAccountFields1(List<Account> alist) {
        Map<String, String> amap = getIndustryNames(alist);
        Map<String, String> bmap = getPaymentTermDescs(alist);
        String akey, bkey;
        for (Account a : alist) {
            akey = a.SAP_Industry_Key__c;
            bkey = a.SAP_Payment_Terms__c;
            if (akey != null && amap.containsKey(akey)) {
                a.SAP_Industry_Key_Desc__c = amap.get(akey);
            }
            if (bkey != null && bmap.containsKey(bkey)) {
                a.SAP_Payment_Terms_Desc__c = bmap.get(bkey);
            }
        }
    }
    
    private static Map<String, String> getIndustryNames(List<Account> alist) {
        Set<String> aset = new Set<String>();
        for (Account a : alist) {
            if (a.SAP_Industry_Key__c != null) {
                aset.add(a.SAP_Industry_Key__c);
            }
        }
        return SAP_Queries_Functions.getIndustryNames(aset);
    }
    
    private static Map<String, String> getPaymentTermDescs(List<Account> alist) {
        Set<String> aset = new Set<String>();
        for (Account a : alist) {
            if (a.SAP_Payment_Terms__c != null) {
                aset.add(a.SAP_Payment_Terms__c);
            }
        }
        return SAP_Queries_Functions.getPaymentTermDescs(aset);
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static String getAccountKey(Account a) {
        String s = a.Customer_Hierarchy_Number__c + a.SAP_Sales_Org__c + 
                   a.SAP_DistChannel__c + a.SAP_DivisionCode__c;
        return s;
    }
    @TestVisible
    private static void setCustomerHierarchyAccount(List<Account> alist) {
        Set<String> accNums = new Set<String>();
        for (Account a : alist) {
            if (!isNull(a.Customer_Hierarchy_Number__c)) {
                accNums.add(getAccountKey(a));
            }
        }
        Map<String, Id> accNumIdMap = new Map<String, Id>();
        for (Account a : [select Id, Account_Number__c 
                            from Account where Account_Number__c in :accNums]) {
            accNumIdMap.put(a.Account_Number__c, a.Id);
        }
        /*for (Account a : alist) {
            Id accId = null; String s = getAccountKey(a);
            if (accNumIdMap.containsKey(s)) {accId = accNumIdMap.get(s);}
            a.Customer_Hierarchy_Account__c = accId;
        }*/
    }
    @TestVisible
    private static void setCustomerGroup5Desc(List<Account> alist) {
        Set<String> cs = new Set<String>(); String c;
        for (Account a : alist) {c = a.SAP_Customer_Group_5__c; if (!isNull(c)) {cs.add(c);}}
        if (cs.isEmpty()) {return;}
        List<SAP_Customer_Group5__c> ds = [SELECT Customer_Group5_Code__c, Customer_Group5_Name__c  
                                            FROM SAP_Customer_Group5__c WHERE Deleted__c = false
                                             AND Customer_Group5_Code__c in :cs];
        if (ds == null || ds.isEmpty()) {return;}
        Map<String, String> amap = new Map<String, String>();
        for (SAP_Customer_Group5__c d : ds) {amap.put(d.Customer_Group5_Code__c, d.Customer_Group5_Name__c);}
        for (Account a : alist) {
            c = a.SAP_Customer_Group_5__c;
            if (!isNull(c) && amap.containsKey(c)) {a.SAP_Customer_Group_5_Desc__c = amap.get(c);}
        }
    }
    
}