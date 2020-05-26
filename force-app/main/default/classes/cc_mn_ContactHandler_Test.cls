@IsTest
public class cc_mn_ContactHandler_Test {
    
        static User portalUser;
        static Account portalAccount;
        static ccrz__E_PriceList__c portalPriceList;
        static ccrz__E_AccountGroup__c portalAccountGroup;
        static Contact portalContact;
    
        static void setupUpTestData() {
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            Id ProfileId = [select id from Profile where name= 'CloudCraze Customer Community User MyNexeo'].Id;
            cc_imp_StorefrontSettings__c customSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        
            System.runAs ( thisUser ) {
                if (null == customSetting) {
                      customSetting = new cc_imp_StorefrontSettings__c( name='mynexeo', Profile_Id__c = ProfileId);
                      insert customSetting;
                  } else if ( null == customSetting.Profile_Id__c){
                                customSetting.Profile_Id__c = ProfileId;
                                update customSetting;
                  }
            }
            
            Profile userSysProfile = [SELECT Id,Name FROM Profile WHERE Name Like 'Sys%'    LIMIT 1];
            UserRole ur = new UserRole(Name = 'CEO');
            insert ur;
            String username = 'username' + String.valueOf(DateTime.now().getTime()) + '@email.com.test';
            User currentUser = new User(
                FirstName         = 'firstName',
                LastName          = 'lastName',
                Email             = username,
                Alias             = 'alias1',
                Username          = username,
                LocaleSidKey      = 'en_US',
                TimeZoneSidKey    = 'GMT',
                ProfileID         = userSysProfile.id,
                UserRoleId        = ur.Id,
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey  = 'UTF-8'
            );
            insert currentUser;
       
            System.runAs (currentUser) {
            
                portalPriceList = new ccrz__E_PriceList__c(ccrz__CurrencyISOCode__c = 'USD', ccrz__Enabled__c = true,   ccrz__EndDate__c = Date.today().addDays(100),
                                                        ccrz__StartDate__c = Date.today(),  ccrz__Storefront__c = 'mynexeo',  CurrencyIsoCode = 'USD');
                insert portalPriceList;
                
                portalAccount = new Account(ccrz__UsedByCloudcraze__c = true, Phone = '1234', Name = 'Test Account', Type = 'Customer'
                                                );
                insert portalAccount;
                
                portalAccountGroup = new ccrz__E_AccountGroup__c(Account__c = portalAccount.Id, ccrz__AccountGroupID__c = portalAccount.Id,     
                                                                    ccrz__PriceListSelectionMethod__c = 'Sequence Order', CurrencyIsoCode = 'USD');
                insert portalAccountGroup;
                
                portalAccount.ccrz__E_AccountGroup__c = portalAccountGroup.Id;
                portalAccount.cc_imp_MyProductList__c = portalPriceList.Id;
                update portalAccount;
                
                Lead objLead = new lead();
                objLead.lastname='test';
                objLead.email='test@gmail.com';
                objLead.Company ='Tesr';
                 insert objlead;
                 
                 LiveChatVisitor visit = new LiveChatVisitor();
                 insert visit;
                 LiveChatTranscript objT = new LiveChatTranscript();
                 
                objT.Body='hi';
                objT.leadid = objLead.id;
                objT.LiveChatVisitorID =visit.id;
                insert objT;
                
                lead objL =[select id from lead where id=:objlead.id];
                 portalContact = new Contact (FirstName = 'Astro',lead_id__c=objL.id, LastName = 'Salesforce Guy', Email = 'astro@testastro.com', AccountId = portalAccount.Id, user_Locale__c = 'fr_CA');
                 insert portalContact;
                //Getting a profile for use with the test user
                Profile p = [SELECT Id FROM Profile WHERE Name = 'CloudCraze Customer Community User MyNexeo' limit 1]; //   CloudCraze Customer Community User MyNexeo
                // In order to have a unique User Name accross all salesforce orgs
                String uniqueUserName = 'testuser1' + DateTime.now().getTime() + '@testorg.com';
                portalUser = new User(UserName = uniqueUserName, Email = 'testuser1@test.com', ProfileId = p.Id, LastName='Manager',
                                        Alias = 'test1', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                                        LocaleSidKey='fr_CA', TimeZoneSidKey='America/Los_Angeles', ContactId = portalContact.Id);
                insert portalUser;
                
                portalContact.user_Locale__c = 'en_CA';
                update portalContact;
            }
            
        }
        
        // We are going to simulate that the contact related to the user has been created
        @isTest static void insertAndUpdatePortalContact() {
             setupUpTestData();
             // In order to simulate that we are the user that is logged in to the Portal
        }

}