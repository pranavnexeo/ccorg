global with sharing class Accountdata{

global integer total{get; set;}
global List<row> rows{get; set;}
global accountdata(String OwnerId, String SoldToSearch, String flag, String q){
   rows = new List<Row>();
   set<String> accountids = new set<String>();
   Set<String> IdSet = new set<String>();
       
   List<String> fields = new List<String>{'name', 'SAP_Sold_To_Account__c', 'SAP_Corporate_Account__c','SAP_city__c', 'SAP_State__c', 'accountnumber', 'owner.name'};
   
  string query = 'select id,SAP_Sold_To_Account_Id__c,Name,accountnumber,sap_city__c, SAP_Corporate_Account__c, owner.name,sap_state__c, SAP_Sold_To_Account__c, ownerid from Account where type = \'Customer\' and recordtype.name = \'Distribution Customer\' and ownerid = \'' + ownerid + '\'';
  if(q != null && q != '')
  {
    query += ' and (';
    for(integer i=0; i<fields.size(); i++)
    { string s = fields.get(i);
      if(i != 0)
        query += ' OR ';
      query += s + ' LIKE \'%' + q.replaceall(' ', '%') + '%\'';
    }
    query += ')';
  }
  
  if(SoldToSearch != '' && SoldToSearch != null){
    query += ' and  SAP_Sold_To_Account_Id__c  = \'' + SoldToSearch+ '\'';
  }

  system.debug('Query: ' + query);
      
   for(Account a:Database.query(query)){
       if(flag == '' || (flag != '' && a.SAP_Sold_To_Account_Id__c == a.Id) ){
           String Id = a.Id;
           String Corp = a.SAP_Corporate_Account__c;
           String SoldTo = a.SAP_Sold_To_Account__c;
           String ShipTo = a.Name.escapeEcmaScript();
           String ShiptoNum = a.accountnumber;
           String shipcity = a.sap_city__c;
           String shipstate = a.sap_state__c;
           String ownername = a.owner.name;
           rows.add(new row(id, corp, soldto, shipto, shiptonum, shipcity, shipstate, ownername));
       }
   }
}



global class row{
  Public String Id{get; set;}
  Public String Corp{get; set;}
  Public String ShipTo{get; set;}
  Public String SoldTo{get; set;}
  Public String ShipToAcctNum{get; set;}
  Public String ShipCity{get; set;}
  Public String ShipState{get; set;}
  Public String OwnerName{get; set;}
  
  Public row(String id, String Corp, String SoldTo, String ShipTo, String ShipToNum,  String ShipCity, String ShipState, String OwnerName)
  {
    this.id = Id;
    this.corp = corp;
    this.SoldTo = SoldTo;
    this.Shipto = ShipTo;
    this.ShipToAcctNum = ShipToNum;
    this.ShipCity = ShipCity;
    this.ShipState = ShipState;
    this.ownername = ownername;
  }

}
}