/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        04/17/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/17/2017
*
*   Short Description:  Test class for CC_nex_Invoice class.
*   **********************************************************************************************************************/

@isTest
public class CC_nex_Invoice_Test  
{

    static testmethod void Test1()
    {            
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;
        
        List<String> orderIds = new List <String>();
        
        Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
        User user = (User) testData.get('testUser1'); 
        
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];
        
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
         Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc34534@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12300234534', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;
        
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;
        
       
        
        
        
        ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
        insert ccart;
        
        ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__Contact__c = userContact.id,ccrz__OriginatedCart__c = ccart.id, ccrz__Storefront__c = 'mynexeo', ccrz__Account__c = userAccount.id, ccrz__PONumber__c = '12345678', ccrz__RequestDate__c = date.today(), ccrz__OrderId__c = '12345');
        insert corder;
        
        Test.startTest();
        
        ccrz__E_Invoice__c cinvoice = new ccrz__E_Invoice__c(SAP_Order_ID__c = '12345', ccrz__InvoiceId__c = '6789', ccrz__Storefront__c = 'nexeo3d');
        insert cinvoice;
        
        Test.stopTest();
        
        ccrz__E_Invoice__c tinvoice = [Select Id, ccrz__InvoiceId__c from ccrz__E_Invoice__c];
        ccrz__E_Order__c torder = [Select Id, Invoice_Number__c from ccrz__E_Order__c];
        
        //System.assertEquals(tinvoice.ccrz__InvoiceId__c, torder.Invoice_Number__c, 'Invoice linking from invoice to order not matching');
    }
}