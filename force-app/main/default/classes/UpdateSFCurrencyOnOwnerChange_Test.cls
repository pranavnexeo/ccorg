@isTest
private class UpdateSFCurrencyOnOwnerChange_Test {
    
    public static final String CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME   = 'CloudCraze Customer Community User Nexeo3D';
    //public static final String STOREFRONT_NAME                                = cc_Tyco_Constants.STORE_TYCO_SOURCE_TAGS;
    public static final String USER_LANGUAGE                                = 'en_US';
    public static final String ACCOUNT_NAME                                 = 'TestAccount';
    public static final String ACCOUNTGROUP_NAME                            = 'TestAccountGroup';
    public static ccrz__E_AccountGroup__c testAccountGroup {
        get {
            if (testAccountGroup == null) {
                testAccountGroup = new ccrz__E_AccountGroup__c( Name = ACCOUNTGROUP_NAME );
                insert testAccountGroup;
            }
            return testAccountGroup;
        }
        private set;
    }

    public static String generateRandomString(Integer len) {
        final String RANDOM_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String returnValue = '';
        Integer random;
        do {
            random = Math.mod(Math.abs(Crypto.getRandomInteger()),RANDOM_CHARS.length());
            returnValue += RANDOM_CHARS.substring(random,random + 1);
        } while (returnValue.length() < len);

        return returnValue;
    }

    public static Account testAccount {
        get {
            if (testAccount == null) {
                 
                testAccount = new Account(
                        Name                    = ACCOUNT_NAME,
                        ccrz__E_AccountGroup__c = testAccountGroup.Id,
                        OwnerId                 = UserInfo.getUserId(),
                        Type                    = 'Customer',
                        BillingStreet           = generateRandomString(32),
                        BillingCity             = generateRandomString(32)
                );
                insert testAccount;
            }
            return testAccount;
        }
        private set;
    }
    public static User testUser {
        get {
            if (testUser == null) {
                setupTestUser();
            }
            return testUser;
        }
        private set;
    }

    public static User testUser2 {
        get {
            if (testUser2 == null) {
                setupTestUser();
            }
            return testUser2;
        }
        private set;
    }

    public static void setupTestUser() {

        Contact contactCC = new Contact(
                FirstName = 'CloudCraze',
                LastName  = 'TestUser',
                Email = 'test1234@test.com',
                AccountId = testAccount.Id
        );
        insert contactCC;

        Contact contactCC2 = new Contact(
                FirstName = 'CloudCraze',
                LastName  = 'TestUser',
                Email = 'test123@test.com',
                AccountId = testAccount.Id
        );
        insert contactCC2;

        Profile profile = [SELECT Id
        FROM Profile
        WHERE Name = :CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME LIMIT 1];
		id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User testOwner = [SELECT TimeZoneSidKey, UserRoleId
        FROM User
        WHERE Id = :UserInfo.getUserId()];
        userRole ur = [SELECT id from userrole  where developername= 'SELLER_CHEM_EM_CMFG_WEST' limit 1];
        String emailAddress = String.valueOf(System.now().getTime() + '@cc-test.mail');
        testUser = new User(
                Alias                    = 'cctest',
                Email                    = emailAddress,
                EmailEncodingKey         = 'UTF-8',
                LastName                 = 'TestUser',
                LanguageLocaleKey        = 'en_US',
                LocaleSidKey             = 'en_US',
                ProfileId                = ProfileId,
                TimeZoneSidKey           = testOwner.TimeZoneSidKey,
                Username                 = emailAddress,
                isActive                 = true,
                //ContactId                = contactCC.Id,
                Contact                  = contactCC,
                  //UserRoleId               = ur.id,
                ccrz__CC_CurrencyCode__c = 'USD'
        );
        insert testUser;

        //update testUser.Contact;

        /*String emailAddress2 = String.valueOf(System.now().getTime() + '@cc-test1.mail');
        testUser2 = new User(
                Alias                    = 'cctest2',
                Email                    = emailAddress2,
                EmailEncodingKey         = 'UTF-8',
                LastName                 = 'TestUser',
                LanguageLocaleKey        = 'en_US',
                LocaleSidKey             = 'en_US',
                ProfileId                = profile.Id,
                TimeZoneSidKey           = testOwner.TimeZoneSidKey,
                Username                 = emailAddress2,
                isActive                 = true,
                ContactId                = contactCC2.Id,
                Contact                  = contactCC2,
                  UserRoleId               = ur.id,
                ccrz__CC_CurrencyCode__c = 'USD'
        );
        insert testUser2;

        update testUser2.Contact;*/
    }

    @isTest static void testTriggerOnCart() {
       Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        //userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhsddc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A1230sd02', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        System.runAs(nexeoIntegrationUser){
            
            ccrz__E_Cart__c a = new ccrz__E_Cart__c();
            a.ccrz__CurrencyISOCode__c = 'USD';
            a.CurrencyIsoCode = 'USD';
            insert a;
            System.debug('a ' + a.Id);
            System.debug('@@Insert worked');
            a.OwnerId = testUser.Id;
            Database.SaveResult result = Database.update(a,false);
            System.debug('@@Update worked');
            System.debug('@@Errors='+ result.getErrors());
            System.debug('a ' + a.Id);
            String cartId = a.Id;
            List<ccrz__E_Cart__c> cart = [select Id,CurrencyIsoCode,ccrz__CurrencyISOCode__c from ccrz__E_Cart__c where Id =: cartId limit 1];
            System.assertEquals(cart.get(0).CurrencyIsoCode,cart.get(0).ccrz__CurrencyISOCode__c);
            
        }
        Test.stopTest();
    }
    
    
    
}