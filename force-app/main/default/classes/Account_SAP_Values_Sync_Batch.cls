global class Account_SAP_Values_Sync_Batch implements Database.Batchable<SObject> {

global List<Integration_Table_Change__c> changes{get; set;}
global String q;
String callback;  
// Class Constructor - set query string
global Account_SAP_Values_Sync_Batch(String callback) {
  this.callback = callback;
  changes = [select id, Completed__c, Code_Field__c, code_value__c, Description_Field__c, Config_Table__c, Config_Code_Field__c, Config_Desc_Field__c, type__c, new_description__c, old_description__c 
                                              from Integration_Table_Change__c where Completed__c = false and type__c = 'Account' order by Config_Table__c, Config_Code_Field__c];
}
// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {
                                              
if(changes.size() > 0)
{
set<string> fields = new set<string>();
map<string, List<string>> wheres = new Map<string, List<string>>();

for(Integration_Table_Change__c c:changes)
{  fields.add(c.code_field__c);
   fields.add(c.description_field__c);
   if(wheres.containskey(c.code_field__c))
     wheres.get(c.code_field__c).add(c.code_value__c);
   else
     wheres.put(c.code_field__c, new List<String>{c.code_value__c});
}

q = 'select id ';
for(string s:fields)
  q += ', ' + s;

q += ' from Account where (';

string qstring = '';
boolean first = true;
for(string s:wheres.keyset())
{ 
 if(wheres.get(s).size() > 0)
 {
  if(first == false)
    qstring += ' OR ';
  first = false;
  qstring += s + ' IN ';
  string vals = '(';
  for(integer i=0; i<wheres.get(s).size(); i++)
  {   
     vals += '\'' + wheres.get(s).get(i) + '\'';
     if(i < (wheres.get(s).size() -1))
       vals+= ', ';
  }
  vals+= ') ';
  qstring += vals;
 }
}
q += qstring + ')';
system.debug(q);
return Database.getQueryLocator(q);
}
else
return Database.getQueryLocator('select id from Account limit 1');
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<Account> Accounts) {
  
 if(changes.size() > 0)
 {
  for(Account a:Accounts)
  {
    for(Integration_Table_Change__c c:changes)
    {
      if(a.get(c.code_field__c) == c.code_value__c && a.get(c.description_field__c) != c.new_description__c)
        a.put(c.description_field__c, c.new_description__c);
    }
  }
  update accounts;
 }
}

// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
  for(Integration_Table_Change__c c:changes)
    c.completed__c = true;
  upsert changes;
  
  /*Added as an enhacement on 23rd July 14- @Rajeev*/
  AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'Account_SAP_Values_Sync_Batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new Material_SAP_Values_Sync_Batch (str));
   /*End of enhancement*/
  
}
}