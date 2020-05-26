global class Update_OppSearchTerm implements Database.Batchable<sObject>
{
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
      query = 'SELECT Id,Opportunity_Search_Phrase__c,Search_Term__c FROM Opportunity where RecordType.Name LIKE \'%Distribution%\'';
       system.debug('total records'+query);
      return Database.getQueryLocator(query);
     
}
global void execute(Database.BatchableContext BC, List<sObject> scope)
{
    list<Opportunity> opp = new list<Opportunity>();
    system.debug('Inside Execute method');
    for(sObject s : scope)
    {
        Opportunity a = (Opportunity)s;
        if(a.Opportunity_Search_Phrase__c != null)
        {
         a.Search_Term__c=a.Opportunity_Search_Phrase__c;
         opp.add(a);
        }
     }
update opp;
}

global void finish(Database.BatchableContext BC)
{
}

// Test method 
 static testMethod void Update_OppSearchTerm() {
 Update_OppSearchTerm  bc = new Update_OppSearchTerm();
     
 List <Opportunity> accns = new List<Opportunity>();
 for(integer i = 0; i<200; i++){
   Opportunity a = new Opportunity(Name='testOpp'+i,StageName='Quotation',CloseDate=system.today()); 
   accns.add(a);
}
 insert accns;
 bc.query = 'Select Id,Opportunity_Search_Phrase__c,Search_Term__c,StageName,CloseDate From Opportunity Limit 200';
         
 Test.startTest();
 Database.executeBatch(bc,200);
 Test.stopTest();
}
}