/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        07/07/2017
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Test UpdatePricingLastRefreshed Class.
*   **********************************************************************************************************************/
@isTest
public class UpdatePricingLastRefreshedTest { 

    
    static testMethod void testUpdateLasttimeRefreshed(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Account acct= new Account();                                  
        acct.name='TestAccount';        
        acct.Account_Number__c='123456789';
        acct.Type='Customer';
        acct.Street_Address__c='x';
        acct.SAP_City__c='Houston';
        acct.SAP_Zip_Code__c='77380';
        acct.CurrencyIsoCode='USD';
        acct.SAP_Account_Name_2__c='';
        acct.AccountNumber='P2721278';
        acct.SAP_Corporate_Account__c='N/A';                       
        insert acct; 
        
        List<id> recordIDs=new List<Id>();
        recordIDs.add(acct.Id);                
        UpdatePricingLastRefreshed.updateLasttimeRefreshed(recordIDs);                                        
    }        
}