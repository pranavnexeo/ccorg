/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        05/03/2018
*   Author:              Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for cc_mn_ctrl_shortCheckoutBIE
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class cc_mn_ctrl_shortCheckoutBIETest {

    @isTest 
    public static void insertCCOrder() {
        Map<String, SObject> m = cc_imp_testUtils.initData();
       //Insert custom setting for this test
       Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
       cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
	   insert myNexeoCustomSetting ;
        
        
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Sold To';        
        
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        
        shipToAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);
        
        ccrz__E_Cart__c cart = (ccrz__E_Cart__c) m.get('cart');
        cart.ccrz__EncryptedId__c = 'eb01bd35-a0f1-4485-83de-df45ceecb2b4';
        cart.ccrz__EffectiveAccountID__c = shipToAccount.Id;
        update cart;
        ccrz.cc_CallContext.currCartId = cart.ccrz__EncryptedId__c;
        System.currentPageReference().getParameters().put('cartId', cart.ccrz__EncryptedId__c);
        
        cc_mn_ctrl_shortCheckoutBIE shortCheckout = new cc_mn_ctrl_shortCheckoutBIE();
        }
        
 
    }    
}