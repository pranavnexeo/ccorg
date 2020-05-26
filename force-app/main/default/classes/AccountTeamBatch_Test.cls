@isTest
 Private Class AccountTeamBatch_Test{
  
      Public static testmethod void TestThisBatch(){
      
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        //insert a; 
         
          SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
          SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
          insert ssd;
          
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
          insert ST;
          
          List<Account> acclist = new List<Account>();
        //  Account a1 = new Account(Name = 'test',type = 'Prospect',primary_seller__c = u.id,ZH_Partner__c = ss.id);
        //  insert a1;
         // Account a = new Account(Name = 'test',type = 'Customer',primary_seller__c = u.id,Parent = a1,ZH_Partner__c = ss.id,YI_Partner__c = ST.id,YY_Partner__c = ST.id,YZ_Partner__c = ST.id,ZC_Partner__c = ss.id,ZU_Partner__c = ss.id);
         acclist.add(a);
          insert acclist;
            
          List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
          AccountTeamMember atm = new AccountTeamMember(AccountId = a.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
          atmlist.add(atm);
          insert atmlist;
                    
          Map<Id, List<String>> bmap = new Map<Id, List<String>>();
          
          //SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          string test1;
          Test.startTest();
       
          AccountTeamBatch atb = new AccountTeamBatch (system.today()-1, test1,true,true);
          ID idBatch = Database.executeBatch(atb);
          atb .execute(null,acclist); 
          Test.stoptest();
      
      
      }
      Public static testmethod void TestThisBatch1(){
      
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
       Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
      // insert a; 
          
         // Map<Id, List<String>> bmap = new Map<Id, List<String>>();
          
          
          SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
          SAP_Seller__History sh= new SAP_Seller__History (parentId=ss.id);
          //insert sh;
          
          SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
          insert ssd;
          
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
          insert ST;
          
          List<Account> acclist = new List<Account>();
          //Account a1 = new Account(Name = 'test',type = 'Prospect',primary_seller__c = u.id,ZH_Partner__c = ss.id);
         // insert a1;
         // Account a = new Account(Name = 'test',type = 'Prospect',primary_seller__c = u.id,Parent = a1,ZH_Partner__c = ss.id,YI_Partner__c = ST.id,YY_Partner__c = ST.id,YZ_Partner__c = ST.id, ZC_Partner__c = ss.id,ZU_Partner__c = ss.id);
          acclist.add(a);
          insert acclist;
            
          List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
          AccountTeamMember atm = new AccountTeamMember(AccountId = a.id, UserId = u.id,  TeamMemberRole = 'National Seller');
          atmlist.add(atm);
          insert atmlist;
          
          string test1;
          Test.startTest();
       
          AccountTeamBatch atb = new AccountTeamBatch (system.today()-1,test1,true,true);
          ID idBatch = Database.executeBatch(atb);
          atb .execute(null,acclist); 
          Test.stoptest();
      
      
      }
    
}