global class Update_AccntSearchTerm implements Database.Batchable<sObject>{
public String query;
public datetime myDateTime = datetime.now();
public integer yr= myDateTime.year();
public integer mn= myDateTime.month();
public integer dy= myDateTime.day();
public String email;
public Id toUserId;
public Id fromUserId;
public user u;

global database.querylocator start(Database.BatchableContext BC)
{
        system.debug('Inside querylocator method');
      string cstr='checked';
      query = 'SELECT Id,Account_Search_Phrase__c,Search_Term__c FROM Account where Inactive_Account__c=false and RecordType.Name LIKE \'%Distribution%\'';
       system.debug('total records'+query);
      return Database.getQueryLocator(query);
     
}
global void execute(Database.BatchableContext BC, List<sObject> scope)
{
    list<Account> acc = new list<Account>();
    system.debug('Inside Execute method');
    
    Map<Id,CISRelationships__c > SoldToNickNames = new Map<ID, CISRelationships__c>();
   
    Set<ID> accIds = new Set<ID>();
    
    for(sObject s : scope){
      accIds.add(s.id);
    }
    
    for(CISRelationships__c CIS : [select id, Target_Customer__c, Source_Customer__c, 
                     // Target_customer_nickname__c, Source_Customer_Nickname__c, 
                      Source_Customer_SAP_Partner_Functions__c, Target_Customer_SAP_Partner_Functions__c
                      from CISRelationships__c where Target_Customer__c IN :accIds and Source_Customer_SAP_Partner_Functions__c LIKE '%Sold%' ]
       )
   {   SoldToNickNames.put(CIS.Target_Customer__c, CIS);  }
   
    for(sObject s : scope)
    {
        Account a = (Account)s;
        boolean updaterecord = false;
        /*if(SoldToNickNames.containskey(s.id))
         {
         a.Nickname__c = SoldToNickNames.get(s.id);
         updaterecord = true; 
         }*/
         
        if(a.Account_Search_Phrase__c != null)
        {
         a.Search_Term__c=a.Account_Search_Phrase__c;       
         updaterecord = true;
        }
        if(updaterecord){ acc.add(a); }
     }
update acc;
}

global void finish(Database.BatchableContext BC)
{
}


// Test method 
 static testMethod void Update_SearchTerm() {
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
 Update_AccntSearchTerm  bc = new Update_AccntSearchTerm ();
     
 List <Account> accns = new List<Account>();
 for(integer i = 0; i<10; i++){
   Account a = new Account(Name='testAccount'+i); 
   accns.add(a);
}
 insert accns;
 bc.query = 'Select Id,Account_Search_Phrase__c,Search_Term__c From Account where Inactive_Account__c=false Limit 200';
         
 Test.startTest();
 Database.executeBatch(bc,200);
 Test.stopTest();
}
}