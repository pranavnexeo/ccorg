@isTest
private class contactdata_Test {

      static User TestUser;
      static Approval_Process_Email_Notification__C emailnotification;

      public static testMethod void testmycontactdata() {
                
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
                User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
                insert u;
              Account a = new Account(name = 'test',ownerid=u.id);
              insert a;
              
              Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
              
              Account acc = new Account(Name = 'TestAccount',type= 'Customer',SAP_city__c='pune',SAP_Sold_To_Account__c = '1234',SAP_Sold_To_Account_Id__c = a.id,SAP_State__c='MH',recordtypeid=RecordTypeIdAccount, AccountNumber = '1233456',ownerid=u.id, SAP_Partner_Functions__c = 'Sold To',SAP_Corporate_Account__c = '1234',SAP_Corporate_Account_Id__c = a.id);
              insert acc;            
              Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acc.id);
              insert con;
              
              List<String> accId = new List<String>();
              accId.add(acc.id);
              accId.add(a.id);
              
              contactdata controllerr = new contactdata(acc.ownerid,acc.id,'jo');
              contactdata controller2 = new contactdata('jo',accId);
             
             }
     }