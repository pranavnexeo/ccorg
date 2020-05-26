@isTest
private class Mass_Email_Batch_Test {

  public static testMethod void test_Mass_Email_Wizard() {
      Test.startTest();
      set<id> cid = new set<id>();
      List<Contact> conList = new List<Contact>();
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
      Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
          
        Account account = new Account(Name = 'TestAccount',type= 'Customer',SAP_city__c='pune',SAP_State__c='MH',recordtypeid=RecordTypeId, AccountNumber = '1233456',SAP_Partner_Functions__c = 'Sold To');
        insert account;            
        Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = account.id);
        conList.add(con);
        insert conList;
        cid.add(conList[0].id);      
      EmailTemplate t = [select id from EmailTemplate where isActive = true limit 1];
      ApexPages.currentpage().getparameters().put('tid', t.id);
      string tempid = t.id;
      string testMail = ' hi, this is a test mail';
     
      Mass_Email_batch meb = new Mass_Email_batch(true,'test@mail.com','test',tempid,testmail);
      Mass_Email_batch meb1 = new Mass_Email_batch(true,'user@acme.com','test',tempid,'user@acme.com',cid);
      id idbatch = database.executebatch(meb);
      meb.execute(null,conList);
      id idbatch1 = database.executebatch(meb1);
      meb1.execute(null,conList);
      Test.stopTest();
  }
}