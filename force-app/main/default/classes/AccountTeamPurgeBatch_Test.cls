@isTest

Public class AccountTeamPurgeBatch_Test{

    public static testMethod void testMe(){
          
            
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
       Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
      // insert a; 
            
             List<Account> acclist = new List<Account>();
         //   Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            
         //   Account a2 = new Account(Name = 'test1',type = 'Prospect');
           // acclist.add(a2);
            insert acclist;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = a.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
           // AccountTeamMember atm2 = new AccountTeamMember(AccountId = a2.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
          //  atmlist.add(atm2);
            
            insert atmlist;
            boolean test1 = true;
       Test.startTest();
       
    AccountTeamPurgeBatch ATP= new AccountTeamPurgeBatch(test1);
            ID idBatch = Database.executeBatch(ATP);
            ATP.execute(null,atmlist); 
       Test.stoptest();
    }
}