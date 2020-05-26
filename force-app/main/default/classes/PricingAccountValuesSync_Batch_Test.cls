@isTest
Private class PricingAccountValuesSync_Batch_Test{
//static User TestUser;
static testmethod void testaccountvaluesnc() {
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
Account a = new Account(name = 'Test Account1',sap_salesgroup__c = '1000');
insert a;
Map<Id, User> usersmap = new map<id, user>();
List<Account> st=new List<Account>();
st.add(a);
Database.BatchableContext bc;
PricingAccountValuesSync_Batch obj=new PricingAccountValuesSync_Batch();
obj.start(bc);
obj.execute(bc,st);
obj.finish(bc);
 
}}