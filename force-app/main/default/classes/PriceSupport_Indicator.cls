global class PriceSupport_Indicator implements Database.Batchable<SObject>{

string q;
//Datetime dt;
//Datetime dte;
Date d;
Date de;
Integer jobNumber;
private string callback;

global PriceSupport_Indicator(Integer batchNumber,Boolean Flag,String callback){

//dt = system.now(); 
//dte = system.now()-1;
this.callback = callback;
d = system.today();
de = system.today()-1 ;
jobNumber = batchNumber;
//string psId='a5nc0000000DBx1AAG';

q = 'Select id, Approval_Date__c, Customer_Name__c, Material_Buying__c, region_code__c, Base_Material_Code_Buying__c, Effective_Date__c, Expiration_Date__c, processed__c, Deletion_Indicator__c from SAP_Price_Support__c';

if(Flag)
    q+= ' where Processed__c = \'N\' And (NOT Customer_Name__c = Null) order by CreatedDate ASC'; //This will run for daily batch job id= \'a5nc0000000DCPo\''; 
else
    q+= ' where Effective_Date__c<=TODAY and (Expiration_Date__c >= TODAY or Expiration_Date__c = null) And (NOT Customer_Name__c = null) and job_number__c =: jobNumber order by CreatedDate ASC'; //This will run first time for Existing records
}

global Database.QueryLocator start(Database.BatchableContext bcMain) {
system.debug('q:'+q);
return Database.getQueryLocator(q);
}


global void execute(Database.BatchableContext bcMain, List<SAP_Price_Support__c> lstBatchRecords) {

    List<Account_Material__c> amRecords = new List<Account_Material__c>();
    Boolean updateFlag = False; 
    List<Account_Material__c> toupdateYes = new List<Account_Material__c>();
    List<Account_Material__c> toupdateNo = new List<Account_Material__c>();  
    List<Account_Material__c> toupdate = new List<Account_Material__c>();
    List<Price_Support_Junction__c> toInsertPS = new List<Price_Support_Junction__c>();
    String region = '';
    String psCust = '%'+ lstBatchRecords[0].Customer_Name__c +'%';
    Boolean updatePSrecord = False;
    system.debug('lstBatchRecords[0].Customer_Name__c:'+lstBatchRecords[0].Customer_Name__c);
    system.debug('lstBatchRecords[0].Material_Buying__c:'+lstBatchRecords[0].Material_Buying__c);
    system.debug('lstBatchRecords[0].Base_Material_Code_Buying__c:'+lstBatchRecords[0].Base_Material_Code_Buying__c);
    system.debug('lstBatchRecords[0].id:'+lstBatchRecords[0].id);
    
    
        amRecords = [Select id, Account__c, Account__r.SAP_Sold_To_Account_Id__c, Account__r.SAP_Payer_Account_Id__c, Account__r.SAP_ShippingPlant__c, Account__r.SAP_DivisionCode__c, SAP_Material__c, Material_Base__c, Price_Support_Indicator__c from Account_Material__c 
                where (Account__c =:lstBatchRecords[0].Customer_Name__c OR Account__r.SAP_Sold_To_Account_Id__c  =:lstBatchRecords[0].Customer_Name__c OR Account__r.SAP_Payer_Account_Id__c LIKE :psCust)
                 AND (SAP_Material__c =: lstBatchRecords[0].Material_Buying__c OR Material_Base__c =:lstBatchRecords[0].Base_Material_Code_Buying__c) AND (prospect_material__c != true)];
        
        
        //***** Added 4/28 by Matt R. ****
        set<string> amsoldtoids = new set<String>();
        set<id> amids = new set<id>();
        for(Account_Material__c am: amRecords) 
           amids.add(am.id);

        for(Account a:[ select id, SAP_Sold_To_Account_Id__c from Account where
                           Id =:lstBatchRecords[0].Customer_Name__c OR 
                           SAP_Sold_To_Account_Id__c  =:lstBatchRecords[0].Customer_Name__c OR
                           SAP_Payer_Account_Id__c LIKE :psCust
                      ]){ amsoldtoids.add(a.SAP_Sold_To_Account_Id__c); }
                      
        amRecords.addall(
            [Select id, Account__c, Account__r.SAP_Sold_To_Account_Id__c, Account__r.SAP_Payer_Account_Id__c, Account__r.SAP_ShippingPlant__c, Account__r.SAP_DivisionCode__c, SAP_Material__c, Material_Base__c, Price_Support_Indicator__c from Account_Material__c 
                where 
                Account__r.SAP_Payer_Account_Id__c = '' AND (NOT ID IN :amids) AND Account__r.SAP_Sold_To_Account_Id__c IN :amsoldtoids AND
               (SAP_Material__c =: lstBatchRecords[0].Material_Buying__c OR Material_Base__c =:lstBatchRecords[0].Base_Material_Code_Buying__c)
           ]);
        
        //***** END ****
        system.debug('lstBatchRecords:'+lstBatchRecords);
        system.debug('amRecords.size():'+amRecords.size());
        
        if(amRecords.size()>0){ 
            String PlantDiv = amRecords[0].Account__r.SAP_ShippingPlant__c + amRecords[0].Account__r.SAP_DivisionCode__c ;
            
            List <SAP_Plant_Region__c> PlantRegion = [Select Id,Division_Code__c,Plant_Division__c, SAP_Plant__r.Plant_Code__c, Region__r.Region_Code__c, Region__r.Region_Description__c  from SAP_Plant_Region__c where Plant_Division__c  =:PlantDiv];
            if(PlantRegion.size()>0)
                region = PlantRegion[0].Region__r.Region_Code__c;
            }
         
         List<Price_Support_Junction__c> psj = new List<Price_Support_Junction__c>();
         psj = [Select Nexprice_CPI__c from Price_Support_Junction__c where SAP_Price_Support__c =: lstBatchRecords[0].id];
         Set<Id> psjSet = new Set<Id>(); //((new Map<Id, Price_Support_Junction__c>(psj)).keySet()); 
         if(psj.size()>0){
             for(Price_Support_Junction__c p :psj)
                 psjSet.add(p.Nexprice_CPI__c);   
             system.debug('psj is:'+psj[0].id);}
        
        for(Account_Material__c am :amRecords)
        {
            updateFlag = False;
            if(am.Account__c == lstBatchRecords[0].Customer_Name__c && am.SAP_Material__c == lstBatchRecords[0].Material_Buying__c)
                updateFlag = True;
            else if(am.Account__r.SAP_Sold_To_Account_Id__c == lstBatchRecords[0].Customer_Name__c && am.SAP_Material__c == lstBatchRecords[0].Material_Buying__c)
                updateFlag = True;
            else if(am.Account__c == lstBatchRecords[0].Customer_Name__c && am.Material_Base__c == lstBatchRecords[0].Base_Material_Code_Buying__c )
                updateFlag = True;
            else if(am.Account__r.SAP_Sold_To_Account_Id__c == lstBatchRecords[0].Customer_Name__c && am.Material_Base__c == lstBatchRecords[0].Base_Material_Code_Buying__c )
                updateFlag = True;
            else if(am.Account__r.SAP_Payer_Account_Id__c != null && am.Account__r.SAP_Payer_Account_Id__c != ''){
                    if((am.Account__r.SAP_Payer_Account_Id__c).contains(lstBatchRecords[0].Customer_Name__c) && am.Material_Base__c == lstBatchRecords[0].Base_Material_Code_Buying__c  && (lstBatchRecords[0].region_code__c == 'ALL' || lstBatchRecords[0].region_code__c == region ))
                    {updateFlag = True;}
                    else if((am.Account__r.SAP_Payer_Account_Id__c).contains(lstBatchRecords[0].Customer_Name__c) && am.SAP_Material__c == lstBatchRecords[0].Material_Buying__c && (lstBatchRecords[0].region_code__c == 'ALL' || lstBatchRecords[0].region_code__c == region ))
                    {updateFlag = True;}
                  }
                
            if(updateFlag == True){
                if(lstBatchRecords[0].Expiration_Date__c < system.today() || lstBatchRecords[0].Effective_Date__c > system.today() || lstBatchRecords[0].Deletion_Indicator__c == 'X')
                {    
                    am.Price_Support_Indicator__c = 'No';
                    system.debug('toupdateNo:'+am.id);
                    toupdate.add(am);
                }
                else if(lstBatchRecords[0].Effective_Date__c <= system.today() || lstBatchRecords[0].Expiration_Date__c == null)
                {
                    am.Price_Support_Indicator__c = 'Yes';
                    
                    if(!psjSet.contains(am.id)){
                        Price_Support_Junction__c p = new Price_Support_Junction__c();
                        p.Nexprice_CPI__c = am.id;
                        p.SAP_Price_Support__c = lstBatchRecords[0].id;
                        toInsertPS.add(p);
                    }
                    system.debug('toupdateYes:'+am.id);
                    toupdate.add(am);
                    
                }
             }  
        }
        
        if((lstBatchRecords[0].Effective_Date__c <= system.today() && lstBatchRecords[0].Expiration_Date__c < system.today()) || lstBatchRecords[0].Deletion_Indicator__c == 'X')
        {    
            lstBatchRecords[0].processed__c = 'O';
            system.debug('Processed Expired Y:'+lstBatchRecords[0].id);
        }
        else if(lstBatchRecords[0].Effective_Date__c <= system.today()) // || lstBatchRecords[0].Expiration_Date__c < system.today() || lstBatchRecords[0].Deletion_Indicator__c == 'X')
        {    
            lstBatchRecords[0].processed__c = 'Y';
            system.debug('Processed Y:'+lstBatchRecords[0].id);
        }
        else if(lstBatchRecords[0].Effective_Date__c > system.today())
        {
            lstBatchRecords[0].processed__c = 'N';
            system.debug('Processed N:'+lstBatchRecords[0].id);
        }
        
        
        
        if(toupdate.size()>0)
            update toupdate;  
                      
        if(toInsertPS.size() > 0)                    
            insert toInsertPS;
            
        /*if(toupdateYes.size()>0)
            update toupdateYes;
        if(toupdateNo.size()>0)
            update toupdateNo;
         
        if(updatePSrecord)*/
        
        update lstBatchRecords[0];
         
    
}


global void finish(Database.BatchableContext bc){
    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'PriceSupport_Indicator(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{'NexeoSFDCSupport@nexeosolutions.com'});
        mail.setReplyTo('NexeoSFDCSupport@nexeosolutions.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Price Support - Batch Job Completed');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
}

}