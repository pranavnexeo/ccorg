@isTest
private class UpdateAcctCheckbox_Test {
   
    public static testMethod void testUpdateAcctCheckbox() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
   String userid = userinfo.getuserid();
          
   Account acc = new Account(Name='TestAcc',type = 'Customer',site = 'sitekhjkj');
          insert acc;
          
  Account acc1 = new Account(Name='TestAcc',type = 'Prospect',site = 'sitekhjkj');
          insert acc1;
           
   contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',No_Email__c = true);
           insert c; 
           
   Campaign camp = new Campaign(Name='test',CurrencyIsoCode='USD', Booth_Size__c = '20');
           insert camp ;
           
   Account_Related_to_Campaign__c acc_camp = new  Account_Related_to_Campaign__c(Account__c=acc.id,Campaign__c=camp.id,Customer_Account__c=false);
           insert acc_camp;
           //acc_cam.Customer_Account__c=true;
           
  Account_Related_to_Campaign__c acc_camp1 = new  Account_Related_to_Campaign__c(Account__c=acc1.id,Campaign__c=camp.id,Customer_Account__c=false);
           insert acc_camp1;
           
           //acc_camp.Customer_Account__c=true;
            
           }
    
   public static testMethod void testUpdatecampaignonAccount() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
   String userid = userinfo.getuserid();
          
   Account acc = new Account(Name='TestAcc',type = 'Customer',site = 'sitekhjkj');
          insert acc;
          
  Account acc1 = new Account(Name='TestAcc',type = 'Prospect',site = 'sitekhjkj');
          insert acc1;
       
   acc1.type = 'Customer';
   update acc1;
           
   contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',No_Email__c = true);
           insert c; 
           
  // Campaign camp = new Campaign(Name='test',CurrencyIsoCode='USD', Booth_Size__c = '20');
 //          insert camp ;
           
   //Account_Related_to_Campaign__c acc_camp = new  Account_Related_to_Campaign__c(Account__c=acc.id,Campaign__c=camp.id,Customer_Account__c=false);
      //     insert acc_camp;
           //acc_cam.Customer_Account__c=true;
           
  //Account_Related_to_Campaign__c acc_camp1 = new  Account_Related_to_Campaign__c(Account__c=acc1.id,Campaign__c=camp.id,Customer_Account__c=false);
    //       insert acc_camp1;
           
           //acc_camp.Customer_Account__c=true;
            
           }
}