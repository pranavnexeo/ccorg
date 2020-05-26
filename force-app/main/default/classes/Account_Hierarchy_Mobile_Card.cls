public class Account_Hierarchy_Mobile_Card{

public Id Account_Id{Get; set;}
public Account thisAccount{get; set;}
public Account sold_to{get; set;}
public Account corp{get; set;}

public Account_Hierarchy_mobile_card(){
  system.debug('Account_Id: ' + Account_Id);
  init(Account_Id);
}
public Account_Hierarchy_Mobile_Card(apexpages.standardcontroller sc){
  init(sc.getrecord().id);
}

private void init(string id){
  thisAccount = database.query(getqueryfields() + ' SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c, Id from Account where id = :id limit 1');
  
  system.debug(thisAccount);
  corp = new Account();
  
  system.debug('corp: ' + thisAccount.SAP_Corporate_Account_Id__c);
  if(thisAccount.SAP_Corporate_Account_Id__c != null)  
     corp = database.query(getqueryfields() + ' Id from Account where id = \'' + thisAccount.SAP_Corporate_Account_Id__c + '\' limit 1');
  
  system.debug('sold to: ' + thisAccount.SAP_Sold_To_Account_Id__c);
  sold_to = new Account();
  
  system.debug(getqueryfields() + ' Id from Account where id = \'' + thisAccount.SAP_Sold_To_Account_Id__c + '\' limit 1');
  if(thisAccount.SAP_Sold_To_Account_Id__c != null)
     sold_to = database.query(getqueryfields() + ' Id from Account where id = \'' + thisAccount.SAP_Sold_To_Account_Id__c + '\' limit 1');   
}

private static string getqueryfields(){
  string query = 'select ';
  for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.SF1_Account_Hierarchy.getFields()) {
            query += f.getFieldPath() + ',';
  }
  return query;
}
}