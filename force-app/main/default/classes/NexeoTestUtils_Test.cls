/**
* Description: Class create to prevent have duplicated Test Code
* Date: 12 / 28 / 2017
* Developer: Ignacio Gonzalez
*/
@isTest
public class NexeoTestUtils_Test {

    /**
	* Initialize test data and return a map of objects created
	*
	* @return Map of objects inserted
	*/
    public static Map<String, SObject> initData() {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User testUser1 = null;
        User testUser2 = null;
        User testUser3 = null;
        User nexeoIntegrationUser = null;
        
        User firstUser = new User(Alias = 'tAstro15', Email='testusfirstUsererooo@testorg.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='testuserfirstUsernexeo1@gorg.com', IsActive = true);
        insert firstUser;
        
                User secondUser = new User(Alias = 'tAstro15', Email='testusfsecondUsererooo@testorg.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='testusersecondUsernexeo1@gorg.com', IsActive = true);
        insert secondUser;
        
        List<User> userList = [SELECT Id, Alias, Email, UserName, Ashland_Employee_Number__c, IsActive, ProfileId, LocaleSidKey, LanguageLocaleKey, LastName, FirstName from User Where Ashland_Employee_Number__c = 'A733472'];
        if (userList.isEmpty()) { 
             testUser1 = new User(Alias = 'tAstroS1', Email='testuserooo@testorg.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo1@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A733472');
            insert testUser1; 
        } else {
            testUser1 = userList.get(0);
        }
        userList = [SELECT Id from User Where Ashland_Employee_Number__c = 'A733416'];
        if (userList.isEmpty()) {
             testUser2 = new User(Alias = 'tAstroS2', Email='testuserooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo2@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A733416');
            insert testUser2; 
        } else {
            testUser2 = userList.get(0);
        }
        userList = [SELECT Id from User Where Ashland_Employee_Number__c = 'A123002'];
        if (userList.isEmpty()) {
            nexeoIntegrationUser = new User(Alias = 'tAstroS3', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo3@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
            insert nexeoIntegrationUser;
        } else {
            nexeoIntegrationUser = userList.get(0);
        }
        UserRole nexeoTestRole;
        
        testUser3 = new User(Alias = 't45troS1', Email='testuserooo@t45troS1.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
                  TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo1@t45troS1.com', IsActive = true);
          insert testUser3;      
        System.runAs(firstUser) {
            nexeoTestRole = new UserRole(DeveloperName = 'UnitTestRole', Name = 'UnitTestRole');
            insert nexeoTestRole;
        }
        
            
        Account testGeneralAccount; 
        Account testGeneralAccount2; 
        System.runAs(firstUser) {
            testGeneralAccount = new Account(SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            testGeneralAccount2 = new Account(SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '000001234310003031',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='12343',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            insert testGeneralAccount;
            insert testGeneralAccount2;
        }

        Map<String,SObject> resultMap = new Map<String,SObject>();

        resultMap.put('testUser1', testUser1);
        resultMap.put('testUser2', testUser2);
        resultMap.put('testUser3', testUser3);
        resultMap.put('firstUser', firstUser);
        resultMap.put('secondUser', secondUser);
        resultMap.put('nexeoIntegrationUser', nexeoIntegrationUser);
        resultMap.put('testGeneralAccount', testGeneralAccount);
        resultMap.put('testGeneralAccount2', testGeneralAccount2);
        resultMap.put('nexeoTestRole', nexeoTestRole);

        return resultMap;
    }
}