@isTest
private class cc_mn_hk_EffectiveAccountTest {
    
    @isTest static void test_fetchAccounts() {
        Map<String, Object> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;

        
        User u = (User)dataMap.get('portalUser');
        Account act = (Account)dataMap.get('userAccount');
        Contact ct = (Contact)dataMap.get('userContact');

        act.SAP_Sold_To_Account_Id__c = act.Id;
        update act;
        ct.cc_imp_Is_MyNexeo_Admin__c = true;
        update ct;

        List<ccrz__E_AccountAddressBook__c> addrBkList = new List<ccrz__E_AccountAddressBook__c>();
        ccrz__E_AccountAddressBook__c adr = (ccrz__E_AccountAddressBook__c)dataMap.get('shippingAddressBook');
        adr.ccrz__Default__c = true;
        //adr.OwnerId = u.Id;
        addrBkList.add(adr);

        adr = (ccrz__E_AccountAddressBook__c)dataMap.get('billingAddressBook');
        adr.ccrz__Default__c = true;
        addrBkList.add(adr);
        //adr.OwnerId = u.Id;
        update(addrBkList);

        List<Account> accountList;

        Map<String,Object> inputData = new Map<String, Object>();
        inputData.put(ccrz.cc_hk_EffectiveAccount.PARAM_FETCH_MODE, ccrz.cc_hk_EffectiveAccount.PARAM_FETCH_MODE);
        inputData.put(ccrz.cc_hk_EffectiveAccount.PARAM_ASSIGNED_ACCT_MODE, ccrz.cc_hk_EffectiveAccount.ASSIGNED_ACCOUNT_ONLYEMPTY);

        ccrz.cc_CallContext.currUserId = u.Id;
        ccrz.cc_CallContext.currAccountId = act.Id;

        Map<String, Object> results;

        Test.startTest();

        cc_mn_hk_EffectiveAccount hook = new cc_mn_hk_EffectiveAccount();
        String assignedAccount;
        Boolean includeAllAccounts = true;

        results = hook.fetchAccounts(inputData);                

        Test.stopTest();

        System.assert(results != null, 'results should contain 1 account');
        System.assert(results.size() == 1, 'results should contain 1 account');
        }
    }
}