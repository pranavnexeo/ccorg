/* 
* Description: Test class for the cc_hk_MyNexeoMenu
* Date: 09 / 02 / 2018
* Developer: Ignacio Gonzalez
*/
@IsTest(SeeAllData = false)
public class cc_hk_MyNexeoMenu_Test {
    
    static {
                Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
                User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdcbestnameever@gorg2.com.mx', IsActive = true, FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        System.runAs(nexeoIntegrationUser) {

        
                cc_imp_StorefrontSettings__c customSettings = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert customSettings;
        }
    }
    
    public static Map<String, Object> MENU_ITEM_MAP = new Map<String, Object>{
        'MENU' => new List<ccrz.cc_bean_MenuItem>{
            new ccrz.cc_bean_MenuItem('a6w44000000GoRDAA0', 'My Pricing', '/mynexeo/ccrz__CCPage?pageKey=mypricing', false, 'PLA65'),
            new ccrz.cc_bean_MenuItem('a6w44000000TSaDAAW', 'Waste Summary', '/mynexeo/ccrz__CCPage?pageKey=LifeCycle', false, 'ES70')
        }
    };
  
    
        // We are going to simulate that is a guest user
    	@isTest 
    	public static void guestUserMenu() {
            cc_imp_testUtils.initData();


            Test.startTest();
           // List<sObject> ls = Test.loadData(ccrz__E_Menu__c.sObjectType, 'MenuStaticResource');
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPage(pageRef);
            cc_imp_StorefrontSettings__c mynexeosettings = cc_imp_StorefrontSettings__c.getValues('mynexeo');
            ccrz.cc_CallContext.currUserId = mynexeosettings.guest_User_ID__c;
            cc_hk_MyNexeoMenu menuGenerator = new cc_hk_MyNexeoMenu();
            menuGenerator.fetch(new Map<String,Object>());
            Test.stopTest();
        }

        // We are going to simulate that is a guest user
    	@isTest 
    	public static void accountUserMenuSAPDivison34() {
            cc_imp_testUtils.initData();
            Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            Test.startTest();
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPage(pageRef);
			Account acc = new Account(Name = 'Test', SAP_DivisionCode__c = '34', AccountNumber = '5466889');
            insert acc;
            ccrz.cc_CallContext.effAccountId = acc.Id;            
            cc_imp_StorefrontSettings__c mynexeosettings = cc_imp_StorefrontSettings__c.getValues('mynexeo');
			
            cc_hk_MyNexeoMenu menuGenerator = new cc_hk_MyNexeoMenu();
            menuGenerator.fetch(new Map<String,Object>());
            Test.stopTest();
        }
        }

         // We are going to simulate that is a guest user
    	@isTest 
    	public static void accountUserMenuSAPDivison30() {
			cc_imp_testUtils.initData();
            Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            Test.startTest();
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPage(pageRef);
			Account acc = new Account(Name = 'Test', SAP_DivisionCode__c = '30', AccountNumber = '546688909');
            insert acc;
            ccrz.cc_CallContext.effAccountId = acc.Id;            
            cc_imp_StorefrontSettings__c mynexeosettings = cc_imp_StorefrontSettings__c.getValues('mynexeo');
			
            cc_hk_MyNexeoMenu menuGenerator = new cc_hk_MyNexeoMenu();
            menuGenerator.fetch(new Map<String,Object>());
            Test.stopTest();
        }
        }

}