// Class Name: Account_Directory_batch
// Developer Name: Matt
// Functionality Description:  Batch Class to mirror Account table in Account Directory.
// Last Modified By: Developer Name: Sneha Likhar  Date: 09/15/2015.
// Reason of Change: INC000003596094 & INC000003597956 (e.g Relationship Manager issue)
// Last Modified By: Developer Name: Sneha Likhar  Date: 10/06/2015. (mm/dd/yyyy)
// Reason of Change: Enh Res-2011(Account Directory Tab for RTK accounts)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


global class Account_Directory_batch implements Database.Batchable<SObject>{
global string q;
global Id pros;
global Id cust;
global Id rtk;
global Map<String,Id> recTypeMap;

global Account_Directory_batch (integer lim){
        /*Modified by Rajeev*/
        //Getting RecordTypeId
        recTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        pros = recTypeMap.get('Distribution Prospect');
        rtk = recTypeMap.get('Distribution RTK Prospect');
        cust = recTypeMap.get('Distribution Customer');
        //Query records based on above data
        q = 'Select Id, Name, Prospect_Division__c, Prospect_Sales_Group__c, CIS_Prospect_Number__c, RecordTypeId, AccountNumber, Account_Number__c, SAP_Division_Desc__c, Full_Address__c, SAP_Sales_Group_Desc__c, Type, sales_area__c, Relationship_Manager__c, owner.email, ownerid, shippinglatitude, shippinglongitude ';
        q += 'from Account where ((RecordTypeId = :pros) ';
        q += 'OR (RecordTypeId = :rtk) ';
        q += 'OR (RecordTypeId = :cust)) ';
        q += 'AND (NOT Name Like \'%DO NOT%\') ';
        q += 'AND (NOT Name Like \'%MASKED%\') '; 
        if(lim > 0)
          q += 'limit ' + lim;
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
/*Modified by Rajeev*/
global void execute(Database.BatchableContext bcMain, List<Account> alist){
      List<Account_Directory__c> adlist = new List<Account_Directory__c>();
      List<Account_Directory__c> prospectlist = new List<Account_Directory__c>();
      for(Account a:alist){
        if(a.Type == 'Customer'){
         Account_Directory__c AD = new Account_Directory__c(
            name = a.name,
            Account_Number__C = a.accountnumber,
            Record_Key__c = a.Account_Number__c,
            Full_Address__c = a.Full_Address__c,
            Division__c = a.SAP_Division_Desc__c,
            Sales_Area__c = a.sales_area__c,
            Sales_Group__c = a.SAP_Sales_Group_Desc__c,
            Type__c = a.Type,
            Owner_Name__c = a.Relationship_Manager__c,
            Owner_Email__c = a.owner.email,
            Account_Location__latitude__s = a.shippinglatitude,
            Account_Location__longitude__s = a.shippinglongitude,
            Ownerid = a.ownerid,
            Account_Id__c = a.id  
          );
         adlist.add(AD);
      
      }else{
      /*Modified by Rajeev --- Added separately for Prospects*/
       if(a.Type == 'Prospect'){
         Account_Directory__c AD1 = new Account_Directory__c(); 
           if(a.name != null) 
            AD1.name = a.name;
           if(a.accountnumber != null) 
            AD1.Account_Number__c = a.accountnumber;
           if(a.CIS_Prospect_Number__c != null) 
            AD1.Record_Key__c = a.CIS_Prospect_Number__c;
           if(a.Full_Address__c != null) 
            AD1.Full_Address__c = a.Full_Address__c;
           if(a.Prospect_Division__c != null) 
            AD1.Division__c = a.Prospect_Division__c;
           if(a.sales_area__c != null) 
            AD1.Sales_Area__c = a.sales_area__c;
           if(a.Prospect_Sales_Group__c != null) 
            AD1.Sales_Group__c = a.Prospect_Sales_Group__c;
           if(a.Type != null) 
            AD1.Type__c = a.Type;
           if(a.Relationship_Manager__c != null) 
            AD1.Owner_Name__c = a.Relationship_Manager__c;
           if(a.owner.email != null) 
            AD1.Owner_Email__c = a.owner.email;
           if(a.shippinglatitude != null) 
            Ad1.Account_Location__latitude__s = a.shippinglatitude;
           if(a.shippinglongitude != null) 
            Ad1.Account_Location__longitude__s = a.shippinglongitude;
           if(a.ownerid != null) 
            Ad1.Ownerid = a.ownerid;
           if(a.Id != null) 
            Ad1.Account_Id__c = a.id;
           
          prospectlist.add(AD1);
         }
        } 
      }    
      List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
      try {
            ur = Database.upsert(adlist, Account_Directory__c.Record_Key__c, false);
            system.debug(ur);
        } catch(DmlException de) { System.debug(de.getMessage());} 
        
      if(prospectlist != null && prospectlist.size()>0){
      
      /*Added by Rajeev*/
      List<Database.Upsertresult> pr =  new List<Database.Upsertresult>();
      try {
           pr = Database.upsert(prospectlist, Account_Directory__c.Record_Key__c,false);
           } catch(DmlException de) { System.debug(de.getMessage());} }                   
   }
   
//Added by Rajeev   
//Finish Method
global void finish(Database.BatchableContext bcMain){
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
        String str = '';
        str += 'Account_Directory_batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'NexeoSFDCSupport@nexeosolutions.com'});
        mail.setReplyTo('NexeoSFDCSupport@nexeosolutions.com');
        mail.setSenderDisplayName('Account_Directory_batch');
        mail.setSubject('Account_Directory_batch');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
}