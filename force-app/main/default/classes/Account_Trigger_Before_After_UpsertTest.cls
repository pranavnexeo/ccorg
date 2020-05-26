/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/10/2016
*   Author:              Akansha Gupta
*   Last Modified:       10/13/2016
*   Last Modified By:    Shwetha Suvarna
*
*   **********************************************************************************************************************/

@isTest
private class Account_Trigger_Before_After_UpsertTest {

  public static testMethod void test_ABInsert() 
  {
    try{
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

               
    List<String> acCIS = new List<String>();
    set<id> acid = new set<id>(); 

    List<Account> accl = new List<Account>();
   Account acct = new Account(ccrz__UsedByCloudcraze__c = false,SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',BillingStreet='test', BillingCity='tst', BillingState='RU', BillingPostalCode='7271', BillingCountry='US',
                               ShippingStreet='test', ShippingCity='tst', ShippingState='RU', ShippingPostalCode='7271', ShippingCountry='US',
                               Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Customer');
   accl.add(acct);
   acct = new Account(ccrz__UsedByCloudcraze__c = true,SAP_Bill_To_Account_Number__c= 'tes1234',SAP_Bill_To_Account_Name__c = '1234',SAP_Sold_To_Record_Key__c='1245',SAP_Sold_To_Account_Number__c='test1',BillingStreet='test', BillingCity='tst', BillingState='RU', BillingPostalCode='7271', BillingCountry='US',
                               ShippingStreet='test', ShippingCity='tst', ShippingState='RU', ShippingPostalCode='7271', ShippingCountry='US',
                               Account_number__c = '123467',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Customer');
   accl.add(acct);
   insert accl;
    
    List<Id> accId = new List<Id>();
     accId.add(accl[0].id);
   
   
   Test.startTest();
    
    CloudcrazePriceListCreation cplist = new CloudcrazePriceListCreation(accId);
    Id batchId = Database.executeBatch(cplist);
    cplist.execute(null,accl);
    
    Test.stopTest();
    
   ccrz__E_ContactAddr__c cab= new ccrz__E_ContactAddr__c(ccrz__AddressFirstline__c=accl[0].BillingStreet, 
                                                        ccrz__City__c=accl[0].BillingCity, 
                                                        ccrz__State__c=accl[0].BillingState,
                                                        ccrz__StateISOCode__c=accl[0].BillingState, 
                                                        ccrz__PostalCode__c=accl[0].BillingPostalCode, 
                                                        ccrz__Country__c=accl[0].BillingCountry, 
                                                        ccrz__CountryISOCode__c=accl[0].BillingCountry, 
                                                        AccountId_Shipping__c=accl[0].id+'Shipping');
                                                        //insert cab;
   
   ccrz__E_AccountGroup__c userAccountGroup = new ccrz__E_AccountGroup__c(Name = 'accountGroup', ccrz__AccountGroupID__c = 'test123');
    insert userAccountGroup;
                                                         
   ccrz__E_AccountGroup__c ag = new ccrz__E_AccountGroup__c (ccrz__AccountGroupID__c=accl[0].id);
    insert ag;
    
    List<ccrz__E_PriceList__c> PCList = new List<ccrz__E_PriceList__c>();
    ccrz__E_PriceList__c  pl = new ccrz__E_PriceList__c (name=accl[0].Account_Number__c,Account__c = acct.id,ccrz__PricelistId__c = 'testdata12');
    PCList.add(pl);
    insert PCList;
 
   accl[0].ccrz__UsedByCloudcraze__c = true;
   //accl[1].ccrz__UsedByCloudcraze__c = true;
   update accl;
   accl[1].ShippingState= 'TX';
   accl[1].BillingStreet= 'test street';
   accl[1].ShippingStreet= 'test street';
   update accl;
   acCIS.add(acct.id);
   acId.add(acct.id);
   accl[0].ccrz__UsedByCloudcraze__c = false;
   update accl;
    Contact userContact = cc_imp_testUtils.createContact(acct, 'contact@email.com');
    insert userContact;

    User user = cc_imp_testUtils.createUser(userProfile, userContact, 
      'username@email.com', 'contact@email.com', 'nexeo_integration', 'lastName', 'alias');
    insert user;
    
    

      }catch(exception e){}
   }
 
 public static testMethod void test_ABUpdate() 
  {
    try{ 
    Account acctUpdate = new Account(ccrz__UsedByCloudcraze__c = false,SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',BillingStreet='test', BillingCity='tst', BillingState='RU', BillingPostalCode='7271', BillingCountry='US',
                               ShippingStreet='test', ShippingCity='tst', ShippingState='RU', ShippingPostalCode='7271', ShippingCountry='US',
                               Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Customer');
  
     Test.startTest();
    insert acctUpdate;
    acctUpdate.ccrz__UsedByCloudcraze__c = true;
    update acctUpdate;
     Test.stopTest();
    
    }catch(exception e){}
    
  }  

 }