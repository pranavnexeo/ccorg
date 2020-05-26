/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/27/2016
*    Author:             Francisco Garcia
*   Last Modified:       11/21/2017
*   Last Modified By:    Francisco Garcia
*
*   Short Description:   Test class for PriceListAfterInsert 
*   **********************************************************************************************************************/
@isTest(seeAllData = false)
public class PriceListAfterInsert_Test {
        
    static Account testingAccount;
    static Contact userContact;
    static User portalUser;
    static User nexeoIntegrationUser;
    static ccrz__E_PriceList__c priceListTest;
    
    
    public static void setUpData() {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
        testingAccount=new Account();
        testingAccount.name='TestAccount1';
        testingAccount.Account_Number__c='1234567890';
        testingAccount.Type='Customer';
        testingAccount.Street_Address__c='x';
        testingAccount.SAP_City__c='Houston';
        testingAccount.SAP_Zip_Code__c='77380';
        testingAccount.CurrencyIsoCode='USD';
        testingAccount.SAP_Account_Name_2__c='';
        testingAccount.AccountNumber='P27212780';
        testingAccount.SAP_Corporate_Account__c='N/A';      
        insert testingAccount; 
        
        
        Profile p = [SELECT Id,Name FROM    Profile WHERE Name = 'CloudCraze Customer Community User MyNexeo' LIMIT 1];
        
        userContact = cc_imp_testUtils.createContact(testingAccount, 'contacttestign@email.com');
        insert userContact;
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];    
        portalUser = cc_imp_testUtils.createUser(p, userContact, 'usernameign@email.com', 'contacttestign@email.com', 'firstName', 'lastName', 'alias');
        portaluser.UserRoleId=ur.id;
          //  insert portalUser;
        
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', 'mynexeo');
        priceList.PriceListType__c = 'CPIPriceList';
        insert priceList;
        }
    }
    
    public static testMethod void MyTest(){
        setUpData();
        Account acct=new Account();
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
    
        ccrz__E_PriceList__c plist=new ccrz__E_PriceList__c();  
        plist.PriceListType__c='CPIPriceList';
        plist.ccrz__PricelistId__c = acct.Account_Number__c;
        insert plist;       
		Test.startTest();    
        RecursiveHandler.isFirstTime = true;
        update plist;
        Test.stopTest();
    
    }
    
    public static testMethod void insertPriceListWithCurrency() {
        setUpData();
        //String beforePriceListCreation = [SELECT ccrz__CC_CurrencyCode__c FROM User Where Id =: portalUser.Id].ccrz__CC_CurrencyCode__c;
        Test.startTest();
            priceListTest=new ccrz__E_PriceList__c();
            priceListTest.ccrz__PricelistId__c='1234567890';    
            priceListTest.PriceListType__c='CPIPriceList';
            priceListTest.ccrz__CurrencyISOCode__c = 'CAD';
            priceListTest.ccrz__Storefront__c = 'mynexeo'; 
            insert priceListTest;
            
        Test.stopTest();
        //String afterPriceListCreation = [SELECT ccrz__CC_CurrencyCode__c FROM User Where Id =: portalUser.Id].ccrz__CC_CurrencyCode__c;
    }
    
    public static testMethod void updatePriceListWithCurrency() {
      setUpData();  
      Test.startTest(); 
            ccrz__E_PriceList__c priceListtoUpdate=[select id,ccrz__CurrencyISOCode__c from ccrz__E_PriceList__c Limit 1];
            priceListtoUpdate.ccrz__CurrencyISOCode__c = 'MXN';
            update priceListtoUpdate;
        Test.stopTest();
        
    }
    
    
}