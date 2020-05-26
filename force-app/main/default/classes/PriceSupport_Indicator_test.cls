global class PriceSupport_Indicator_test implements Database.Batchable<SObject>{

string q;
//Datetime dt;
//Datetime dte;
Date d;
Date de;
string amids='a5oc00000000Btv';
private string callback;

global PriceSupport_Indicator_test(Boolean Flag,String callback){

//dt = system.now(); 
//dte = system.now()-1;
this.callback = callback;
d = system.today();
de = system.today()-1 ;


q = 'Select id, Approval_Date__c, Customer_Name__c, Material_Buying__c, region_code__c, Base_Material_Code_Buying__c, Effective_Date__c, Expiration_Date__c from SAP_Price_Support__c';

if(Flag)
    q+= ' where (((Effective_Date__c = YESTERDAY OR Effective_Date__c = TODAY ) AND (Expiration_Date__c > TODAY or Expiration_Date__c = null)) OR (Expiration_Date__c =: d OR Expiration_Date__c =: de or Expiration_Date__c = null)) And (NOT Customer_Name__c = Null) order by CreatedDate ASC'; //This will run for daily batch job
else
    q+= ' where Id = \'' + amids + '\''; //This will run first time for Existing records
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
    String region = '';
    String psCust = '%'+ lstBatchRecords[0].Customer_Name__c +'%';
    
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
            
        for(Account_Material__c am :amRecords)
        {
            updateFlag = False;
            if(am.Account__c == lstBatchRecords[0].Customer_Name__c && am.SAP_Material__c == lstBatchRecords[0].Material_Buying__c)
                updateFlag = True;
            else if(am.Account__r.SAP_Sold_To_Account_Id__c == lstBatchRecords[0].Customer_Name__c && am.SAP_Material__c == lstBatchRecords[0].Material_Buying__c)
                updateFlag = True;
            else if(am.Account__r.SAP_Payer_Account_Id__c != null && am.Account__r.SAP_Payer_Account_Id__c != ''){
                    if((am.Account__r.SAP_Payer_Account_Id__c).contains(lstBatchRecords[0].Customer_Name__c) && am.SAP_Material__c == lstBatchRecords[0].Material_Buying__c && (lstBatchRecords[0].region_code__c == 'ALL' || lstBatchRecords[0].region_code__c == region ))
                    updateFlag = True;}
            else if(am.Account__c == lstBatchRecords[0].Customer_Name__c && am.Material_Base__c == lstBatchRecords[0].Base_Material_Code_Buying__c )
                updateFlag = True;
            else if(am.Account__r.SAP_Sold_To_Account_Id__c == lstBatchRecords[0].Customer_Name__c && am.Material_Base__c == lstBatchRecords[0].Base_Material_Code_Buying__c )
                updateFlag = True;
            else if(am.Account__r.SAP_Payer_Account_Id__c != null && am.Account__r.SAP_Payer_Account_Id__c != ''){
                    if((am.Account__r.SAP_Payer_Account_Id__c).contains(lstBatchRecords[0].Customer_Name__c) && am.Material_Base__c == lstBatchRecords[0].Base_Material_Code_Buying__c  && (lstBatchRecords[0].region_code__c == 'ALL' || lstBatchRecords[0].region_code__c == region ))
                    updateFlag = True;}
                
            if(updateFlag == True){
                if(lstBatchRecords[0].Expiration_Date__c <= system.today() )
                {    
                    am.Price_Support_Indicator__c = 'No';
                    system.debug('toupdateNo:'+am.id);
                    toupdateNo.add(am);
                }
                else
                {
                    am.Price_Support_Indicator__c = 'Yes';
                    system.debug('toupdateYes:'+am.id);
                    toupdateYes.add(am);
                }
             }  
        }
        
        if(toupdateYes.size()>0)
            update toupdateYes;
        system.debug('toupdateYes:'+toupdateYes.size());
        
            
        if(toupdateNo.size()>0)
            update toupdateNo;
         system.debug('toupdateNo:'+toupdateNo.size());
         
         
    
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