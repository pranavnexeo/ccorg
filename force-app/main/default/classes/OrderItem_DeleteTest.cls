/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/12/2016
*   Author:              Akansha Gupta
*   Last Modified:       10/19/2016
*   Last Modified By:    Akansha Gupta
*
**********************************************************************************************************************/

@isTest
private class OrderItem_DeleteTest {

  public static testMethod void test_DeleteRecord() 
  {
   
    ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__OrderNumber__c = 52634);
    insert corder;

    ccrz__E_OrderItem__c coi = new ccrz__E_OrderItem__c(ccrz__Order__c = corder.id,ccrz__Price__c = 23.12,ccrz__Quantity__c = 12.23,ccrz__SubAmount__c = 13.23);
    insert coi;
    
    coi.ccrz__OrderItemStatus__c = 'Deleted';
    update coi;


   }
    
    public static testMethod void test_UpdateCoupons() {
        
        
        
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
		userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
            List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
        
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;
        
        Account secondAcct = new Account  (Name='Effective Account 2');
        if(userAccountGroup != null){
            secondAcct.ccrz__E_AccountGroup__c = userAccountGroup.Id;
        }
        insert secondAcct;
        
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;
    
        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
          'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert user;

        ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
        insert ccart;
        
        ccrz__E_Order__c corder3D = new ccrz__E_Order__c(ccrz__Contact__c = userContact.id,ccrz__OriginatedCart__c = ccart.id, ccrz__EffectiveAccountID__c = secondAcct.id , ccrz__Storefront__c = 'nexeo3d');
        insert corder3D;
        ccrz__E_Coupon__c ccCoupon = new ccrz__E_Coupon__c();
        ccCoupon.ccrz__CouponCode__c = 'Test Work';
        ccCoupon.ccrz__CouponName__c = 'Test Work';
        ccCoupon.ccrz__MaxUse__c = 10;
        ccCoupon.ccrz__DiscountType__c = 'Percentage';
        ccCoupon.ccrz__CartTotalAmount__c = 1000.00;
        ccCoupon.ccrz__DiscountAmount__c = 10.00;
        ccCoupon.ccrz__CurrencyISOCode__c = 'USD';
        ccCoupon.ccrz__TotalUsed__c = 0;
        insert ccCoupon;
        ccrz__E_OrderItem__c  ordItem = new ccrz__E_OrderItem__c(ccrz__Order__c = corder3D.Id, ccrz__Coupon__c = ccCoupon.Id, Total_Used_Updated__c = false, ccrz__StoreId__c = 'nexeo3d', ccrz__Price__c = 23.12, ccrz__Quantity__c = 12.23, ccrz__SubAmount__c = 13.23);
        insert ordItem;
        }
    }

    }