/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:       04/04/2017
*   Author:             Rohini Bharambe
*   Last Modified:      04/04/2017
*   Last Modified By:   Rohini Bharambe
*
*   Short Description:  This is a batch class for creating CC Products, CC Account Group, CC Account Group Price List, 
    CC Price List, CC Price ListItem when a Customer is marked as WEB Customer from SAP.
*   **********************************************************************************************************************/

global class CloudcrazePriceListCreation implements Database.Batchable<SObject> {

    string query;
    List<Id> batchProcessId = new List<Id>();
    Integer str_getDMLStatements;
    Integer str_getQueries;
    
    global CloudcrazePriceListCreation(List<Id> toProcess){
    batchProcessId = toProcess;
        
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext bcMain){
        query = 'Select id,ccrz__UsedByCloudcraze__c,SAP_DivisionCode__c from Account where Id IN :batchProcessId';
        //and SAP_DivisionCode__c = '31'
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bcMain, List<Account> lstAccount){
        //List<Customer_Product_Info__c> lstCPI = new List<Customer_Product_Info__c>();
        List<Material_Sales_Data2__c> lstMaterials = new List<Material_Sales_Data2__c>();
        List<Material_Sales_Data2__c> lstMaterialsToUpdate = new List<Material_Sales_Data2__c>();
        List<Account_Material__c> amList = new List<Account_Material__c>();
        //Set<Id> cpiId = new Set<Id>();
        //List<Id> lstMaterialIds = new List<Id>();
        //Adding Set instead of listt to remove duplicates
        Set<Id> lstMaterialIds = new Set<Id>();
        List<Id> lstAcctIds = new List<Id>();
        
        for(Account a :lstAccount){
            lstAcctIds.add(a.Id);
        }
        
        amList = [Select Id,Created_From_CPI__c,Account_Division_Code__c,Material_Division__c,Hidden__c,Account__c,SAP_Material__c 
                    from Account_Material__c 
                    where Account__c IN : lstAcctIds 
                    and Hidden__c = false 
                    and valid_for_portal__c = true 
                    and CPI_Deletion_Flag__c != 'X' 
                    and Created_From_CPI__r.CPI_Record_Type__c='1' ];
        
        /*for(Account_Material__c acc : amList){
            if(acc.Account_Division_Code__c == acc.Material_Division__c){
                cpiId.add(acc.Created_From_CPI__c);
            }
            else if(acc.Account_Division_Code__c == '36' && acc.Material_Division__c == '31'){
                cpiId.add(acc.Created_From_CPI__c);
            }
        }
        
        if(!cpiId.isempty())
            lstCPI = [SELECT Id, Material_Number__c, SAP_Material__c FROM Customer_Product_Info__c where Id IN : cpiId  and CPI_Record_Type__c='1' and Deletion_Indicator__c != 'X'];
        
        system.debug('lstCPI size$$%:'+lstCPI.size());*/
        
        for(Account_Material__c nxcpi :amList){
            if(nxcpi.SAP_Material__c != null)
                lstMaterialIds.add(nxcpi.SAP_Material__c);
        }
        
        lstMaterials = [Select Id, Create_CC_Product__c from Material_Sales_Data2__c where Id IN : lstMaterialIds];
        
        if(lstMaterials.size()>0){
        system.debug('lstMaterials size$$%:'+lstMaterials.size());}
        
        for(Material_Sales_Data2__c msd :lstMaterials){
            if(msd.Create_CC_Product__c == false){
                    msd.Create_CC_Product__c = true; 
            lstMaterialsToUpdate.add(msd);}
        }
        
        if(lstMaterialsToUpdate.size()>0){ system.debug('lstMaterialsToUpdate %%%:'+lstMaterialsToUpdate.size());
        update lstMaterialsToUpdate;
        }
        
        Cloudcraze_Product_Function.add_AccountGroupCreation(lstAcctIds);
        str_getDMLStatements = Limits.getDMLStatements();
        str_getQueries = Limits.getQueries();
        
    }
    
    global void finish(Database.BatchableContext bcMain){
        /*AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
                
        
        string str = '';
        str += 'CloudcrazePriceListCreation (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        str += 'str_getDMLStatements :: '+str_getDMLStatements +'\n';
        str += 'str_getQueries :: '+str_getQueries +'\n';
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{'rbharambe@nexeosolutions.com'});
        mail.setReplyTo('rbharambe@nexeosolutions.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('CloudcrazePriceListCreation - Batch Job Completed');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });*/
        
    }
    
}