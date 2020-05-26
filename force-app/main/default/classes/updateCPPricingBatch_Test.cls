@isTest
private class updateCPPricingBatch_Test {
    
    public static testMethod void updateCPPricingBatch1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        Id RolId = [Select id from UserRole where Name='Seller US Plas Upper MW' LIMIT 1].id;

        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true, UserRoleId=RolId);
        
        Account a;
        Account acc;
        Contact con;
        System.RunAs(u){    
            //Adding code to prevent have hardcoded IDs
  			Map<String, SObject> testData = NexeoTestUtils_Test.initData();
            
            a = new Account(name = 'test',ownerid=u.id);
            insert a;   
            acc = new Account(Name = 'TestAccount',type= 'Customer',SAP_city__c='pune',SAP_Sold_To_Account__c = '1234',SAP_Sold_To_Account_Id__c = a.id,SAP_State__c='MH', AccountNumber = '1233456',ownerid=u.id, SAP_Partner_Functions__c = 'Sold To',SAP_Corporate_Account__c = '1234',SAP_Corporate_Account_Id__c = a.id);
            insert acc;            
            con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acc.id);
            insert con;
        }
        
        Profile p1 = [SELECT Id FROM Profile WHERE NAME='CloudCraze Customer Community User MyNexeo' LIMIT 1];
        User u1 = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1sfdc@gorg.com', IsActive = true, ContactId=con.id);
             
        System.RunAs(u){   
            CC_SFDC_Settings__c CC_SFDC = New CC_SFDC_Settings__c(Name='CPPricingBatchConfig');
            CC_SFDC.Profile_Id__c = p1.Id;
            CC_SFDC.Number_Of_Last_Login_Days__c = '15';
            Insert CC_SFDC;
        
            Test.startTest();
                updateCPPricingBatch obj = new updateCPPricingBatch();
                DataBase.executeBatch(obj); 
            Test.stopTest();
        }
        
    }
    /*
    public static testMethod void updateCPPricingBatch2() {
        test.startTest();
        User Us = [Select id, AccountId, LastLoginDate from User where AccountId != null AND ISActive=True AND LastLoginDate >= LAST_N_DAYS:21 LIMIT 1];
        
        System.RunAs(Us){
            database.executeBatch(new updateCPPricingBatch());
        }
        test.stopTest();
    }
    */
    
}