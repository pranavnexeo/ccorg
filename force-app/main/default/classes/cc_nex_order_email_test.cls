/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        03/29/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/27/2017
*
*   Short Description:  Test class for cc_nex_order_email class
*   **********************************************************************************************************************/

@isTest
public class cc_nex_order_email_test 
{
    private static testmethod void test_emailtocsr() 
    {
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
            Test.startTest();
            Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
            List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();
            
            insert storeFrontSettingsList ;
            List<String> orderIds = new List <String>();
            
            Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];
            
            ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
            insert userAccountGroup;
            
            Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
            insert userAccount;
            
            User csr_user = new User(
            FirstName         = 'Test',
            LastName          = 'Test',
            Email             = 'nkarthik@nexeosolutions.com',
            Alias             = 'tt',
            Username          = 'test+123@email.com',
            LocaleSidKey      = 'en_US',
            TimeZoneSidKey    = 'GMT',
            ProfileID         = p.id,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey  = 'UTF-8'
            );
            insert csr_user;
            
            SAP_Seller__c csr = new SAP_Seller__c(User__c = csr_user.Id, Name = '123');
            insert csr;
           
            Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
            insert userContact;
            
            User user = cc_imp_testUtils.createUser(userProfile, userContact,'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
            //insert user;
            
            userAccount.ZC_Partner__c = csr.Id;
            update userAccount;
        
            ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'country',
            '11111'
            );
            insert address;
        
            ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
            insert ccart;
            
            ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__ShipTo__c = address.Id, ccrz__Contact__c = userContact.id,ccrz__OriginatedCart__c = ccart.id, ccrz__Storefront__c = 'mynexeo', ccrz__Account__c = userAccount.id, ccrz__PONumber__c = '12345678', ccrz__RequestDate__c = date.today(), ccrz__EffectiveAccountID__c = userAccount.id);
            insert corder;
            
            ccrz__E_TransactionPayment__c paymentTransaction1 = new ccrz__E_TransactionPayment__c (ccrz__BillTo__c = userAccount.id,ccrz__CCOrder__c = corder.id,ccrz__storefront__c = 'mynexeo', ccrz__TransactionPaymentId__c = corder.id);
            paymentTransaction1.ccrz__AccountNumber__c = '1233564';
            insert paymentTransaction1;
            
            //System.debug('Order: ' +corder);
            Integer invocations = Limits.getEmailInvocations();
            
            Test.stopTest();
            //Commenting as current workflow is off
            //System.assertEquals(1, invocations, 'Issue in sending email to CSR for new order');

    }
    
    private static testmethod void test_emailtonexeo3demail() 
    {
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
            Test.startTest();
            Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
            List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();
            
            insert storeFrontSettingsList ;
            List<String> orderIds = new List <String>();
            
            Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];
            
            ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
            insert userAccountGroup;
            
            Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
            insert userAccount;
            
            User csr_user = new User(
            FirstName         = 'Test',
            LastName          = 'Test',
            Email             = 'nkarthik@nexeosolutions.com',
            Alias             = 'tt',
            Username          = 'test+123@email.com',
            LocaleSidKey      = 'en_US',
            TimeZoneSidKey    = 'GMT',
            ProfileID         = p.id,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey  = 'UTF-8'
            );
            insert csr_user;
            
            SAP_Seller__c csr = new SAP_Seller__c(User__c = csr_user.Id, Name = '123');
            insert csr;
                    
            Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
            insert userContact;
            
            User user = cc_imp_testUtils.createUser(userProfile, userContact,'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
            //insert user;
            
            userAccount.ZC_Partner__c = csr.Id;
            update userAccount;
        
            ccrz.cc_CallContext.currAccount = userAccount;
            ccrz.cc_CallContext.currAccountId = userAccount.Id; 
            ccrz.cc_CallContext.effAccount = userAccount;
            ccrz.cc_CallContext.effAccountId = userAccount.Id;
        
            ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
            insert ccart;
            
            ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__Contact__c = userContact.id,ccrz__OriginatedCart__c = ccart.id, ccrz__Storefront__c = 'nexeo3d', ccrz__Account__c = userAccount.id, ccrz__PONumber__c = '12345678', ccrz__RequestDate__c = date.today(), ccrz__EffectiveAccountID__c = userAccount.id);
            insert corder;
            

        
            ccrz__E_TransactionPayment__c paymentTransaction1 = new ccrz__E_TransactionPayment__c (ccrz__BillTo__c = userAccount.id,ccrz__CCOrder__c = corder.id,ccrz__storefront__c = 'nexeo3d');
            paymentTransaction1.ccrz__AccountNumber__c = '1233564';
            insert paymentTransaction1;
            
            //System.debug('Order: ' +corder);
            Integer invocations = Limits.getEmailInvocations();
            
            Test.stopTest();
            //Commenting as current workflow is off
            //System.assertEquals(1, invocations, 'Issue in sending email to CSR for new order');

    }    
}