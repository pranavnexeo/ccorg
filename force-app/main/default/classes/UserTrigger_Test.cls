@IsTest
public class UserTrigger_Test {
	
    @IsTest
    public static void insertUser() {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Profile userProfile = [SELECT Id,Name FROM Profile WHERE Name = 'CloudCraze Customer Community User MyNexeo'	LIMIT 1];

        cc_imp_StorefrontSettings__c customSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        
    	System.runAs ( thisUser ) {
        	if (null == customSetting) {
                  customSetting = new cc_imp_StorefrontSettings__c( name='mynexeo', Profile_Id__c = userProfile.Id);
        		  insert customSetting;
              } else if ( null == customSetting.Profile_Id__c){
                  			customSetting.Profile_Id__c = userProfile.Id;
                 	 		update customSetting;
              }
        }
        
        Profile userSysProfile = [SELECT Id,Name FROM Profile WHERE Name Like 'Sys%'	LIMIT 1];
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
            
            ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
            insert userAccountGroup;
            
            Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
            insert userAccount;
            
            Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
            insert userContact;
            
            User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
            insert portalUser;
        }
        
    }
    
    @IsTest
    public static void updateUser() {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Profile userProfile = [SELECT Id,Name FROM Profile WHERE Name = 'CloudCraze Customer Community User MyNexeo'	LIMIT 1];
        cc_imp_StorefrontSettings__c customSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        
    	System.runAs ( thisUser ) {
        	if (null == customSetting) {
                  customSetting = new cc_imp_StorefrontSettings__c( name='mynexeo', Profile_Id__c = userProfile.Id);
        		  insert customSetting;
              } else if ( null == customSetting.Profile_Id__c){
                  			customSetting.Profile_Id__c = userProfile.Id;
                 	 		update customSetting;
              }
        }
        
        Profile userSysProfile = [SELECT Id,Name FROM Profile WHERE Name Like 'Sys%'	LIMIT 1];
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
            UserRoleId		  = ur.Id,
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey  = 'UTF-8'
		);
        insert currentUser;
       
        
        	User portalUser;
    	System.runAs ( currentUser ) {
            
            Account userAccount = new Account  (Name='Test Account');
            insert userAccount;
            
            Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
            insert userContact;
            
            portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
            insert portalUser;
    	}
        
        System.runAs ( portalUser) {
            portalUser.LocaleSidKey = 'fr_CA';
            update portalUser;
        }
        
        
    }
}