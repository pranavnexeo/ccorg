global class Account_Material_Search{

public List<Account_Material__c> amlist{get; set;}
public Account_Material_Search(Apexpages.standardcontroller sc){
   string q = 'select id ';
   for(Schema.FieldSetMember fsm:SObjectType.Account_Material__c.FieldSets.Account_material_Search.getFields())
     q += ', ' +  fsm.getFieldPath();
   q += ' from Account_material__c where Account__c = \'' + sc.getrecord().id + '\' and CPI_Deletion_Flag__c != \'X\' and Prospect_Material__c = false order by Material__c';

   string accountid = '';
   
   if(apexpages.currentpage().getparameters().containskey('id'))
     accountid = apexpages.currentpage().getparameters().get('id');
   
   if(apexpages.currentpage().getparameters().containskey('q'))
     amlist = amsearch(apexpages.currentpage().getparameters().get('q'), accountId);
   else
     amlist = database.query(q);
     
   system.debug(apexpages.currentpage().getparameters());
}

public string getrow(){ return '<div class="row">'; }
public string getrowclose(){ return '</div>'; }

@remoteaction
public static void getPricing(string AccountMatId){
    Account_Material_Functions.getPricing(AccountMatId);
}
public static List<Account_Material__c> amsearch(string q, string AccountId){
  string q1 = 'select id ';
  for(Schema.FieldSetMember fsm:SObjectType.Account_Material__c.FieldSets.Account_material_Search.getFields())
     q1 += ', ' +  fsm.getFieldPath();
   q1 += ' from Account_material__c where Account__c = \'' + AccountId + '\' AND (';
  for(Schema.FieldSetMember fsm:SObjectType.Account_Material__c.FieldSets.Account_material_Search.getFields())
    if(fsm.gettype().name() != 'boolean')
     q1 += fsm.getFieldPath() + ' LIKE \'%' + String.escapesinglequotes(q) + '%\' OR ' ;
  q1 = q1.substring(0, q1.length() - 3);
  q1 += ') and CPI_Deletion_Flag__c != \'X\' and Prospect_Material__c = false  and (NOT Account__r.name LIKE \'%DO NOT USE%\') AND Account__r.Inactive_Account__c != true and (NOT SAP_Material__r.NAME LIKE \'%DO NOT USE%\') and SAP_Material__r.Marked_for_Deletion__c != \'true\' and (NOT SAP_Material__r.Material_Base_Code_Desc__c LIKE \'%DO NOT USE%\') order by Material__c ';
  system.debug(q1);
  return database.query(q1);
}
}