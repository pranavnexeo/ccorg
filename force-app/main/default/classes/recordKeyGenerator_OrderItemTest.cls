/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/14/2016
*   Author:              Akansha Gupta
*   Last Modified:       10/20/2016
*   Last Modified By:    Akansha Gupta
*
* **********************************************************************************************************************/

@isTest
Public class recordKeyGenerator_OrderItemTest {
    Static testMethod void myUnitTest() {

        Test.StartTest();
         /*  Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

    map<id,ccrz__E_Order__c> omap = new map<id,ccrz__E_Order__c>();

    ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
    insert userAccountGroup;

    Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
    insert userAccount;

    Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
    insert userContact;

    User user = cc_imp_testUtils.createUser(userProfile, userContact, 
      'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
    insert user;
    
    ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
    insert ccart;*/
    
    ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__OrderId__c = '00142');
    insert corder;    
    
    ccrz__E_Product__c ccp = new ccrz__E_Product__c(ccrz__ProductStatus__c = 'Blocked',ccrz__SKU__c='test233',NexeoMaterialId__c = 'test12',DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC');
    insert ccp;  
       
    ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c(ccrz__Order__c = corder.id,ccrz__Price__c=67, ccrz__Quantity__c=8, ccrz__SubAmount__c=67,ccrz__DisplayProduct__c = ccp.id);
    insert oi;
    ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c(ccrz__Order__c = corder.id,ccrz__Price__c=67, ccrz__Quantity__c=8, ccrz__SubAmount__c=67,ccrz__DisplayProduct__c = ccp.id);
    insert oi1;
    
    ccrz__E_TransactionPayment__c trans = new ccrz__E_TransactionPayment__c (ccrz__TransactionPaymentId__c = '6374',ccrz__CCOrder__c=corder.id);
    insert trans;
    
    corder.ccrz__OrderId__c = '01234';
    update corder;
            
        Test.StopTest();

    }
}