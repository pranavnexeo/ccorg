/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        07/11/2017
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:   
*
*   Short Description:  Update Pricing for customer who login in the last 3 weeks.
*   **********************************************************************************************************************/


global class updateCPPricingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
        
        Set<Id> acctoReprice=new Set<Id>();
        global String query;
        global String Profile_Id;
        global Integer Last_Login_Date;      
        
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
            
            Last_Login_Date = 0;
            // get Custom Settings Value
            CC_SFDC_Settings__c CPPricingBatch = CC_SFDC_Settings__c.getValues('CPPricingBatchConfig');
            If(CPPricingBatch != null){
                If(!String.IsEmpty(CPPricingBatch.Profile_Id__c))
                    Profile_Id = CPPricingBatch.Profile_Id__c;
                
                If(!String.IsEmpty(CPPricingBatch.Number_Of_Last_Login_Days__c))
                    Last_Login_Date = Integer.ValueOf(CPPricingBatch.Number_Of_Last_Login_Days__c);
                
            }
            query = 'SELECT AccountId,ContactId,FirstName,Full_Name__c,LastLoginDate,ProfileId FROM User';
            if(!Test.isRunningTest()){
                query = query+' WHERE ProfileId in (\''+Profile_Id+'\') AND LastLoginDate >= LAST_N_DAYS:'+Last_Login_Date+' AND ACCOUNTID<>\'\'';
                query = query+' ORDER BY LastLoginDate ASC LIMIT 49999';
            }else{
                query = query+' ORDER BY LastLoginDate ASC LIMIT 1';
            }
            return Database.getQueryLocator(query);
        }
      
        // Execute Logic
        global void execute(Database.BatchableContext BC, List<user>Users){
           
            if(Users.size()>0){
        
                for(User usr:Users){
                    acctoReprice.add(usr.AccountId);                                                   
                }
                
                List<Account> accounts = new List<Account>([SELECT Id, Name,SAP_DivisionCode__c, Account_Number__c, Ship_To_Number__c, Sold_To_Customer_Number__c, SAP_Sales_Org__c, SAP_DistChannel__c FROM Account WHERE Id in:acctoReprice FOR UPDATE]);
            
                PricingCustomerPortal pricingObject= new PricingCustomerPortal();
                pricingObject.getPricingFromSAP(accounts); 
            
            }
                                   
        }
        
        //Finesh Logic
        global void finish(Database.BatchableContext BC){}
}