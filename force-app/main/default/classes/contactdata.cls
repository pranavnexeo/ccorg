global with sharing class contactdata  {

global integer total{get; set;}
global List<row> rows{get; set;}
global contactdata(String OwnerId, String AccountId, String q){
   rows = new List<Row>();
   set<String> accountids = new set<String>();
   accountids.add(AccountId);
   Map<String, Map<String, String>> relmap = CISRelationships_Functions.Lookup_Related_Accounts(new set<String>{accountid});
   for(Map<String, String> m:relmap.values()){
      accountids.addall(m.keyset());
      accountids.addall(m.values());
   }
   
   system.debug('SoldTos: '+relmap.get('SoldTos').keyset());
   
   
   system.debug('AccountIds: ' + accountids);
   List<String> fields = new List<String>{'name', 'email', 'firstname', 'lastname'};
   
   string query = 'select id, name, email, firstname, lastname, account.SAP_City__C, Account.sap_state__c, account.name, account.accountnumber, accountid from Contact where Account.ownerid = \'' + ownerid + '\' and accountid IN :accountids';
  if(q != null && q != '')
  {
    query += ' and (';
    for(integer i=0; i<fields.size(); i++)
    { string s = fields.get(i);
      if(i != 0)
        query += ' OR ';
      query += s + ' LIKE \'%' + q + '%\'';
    }
    query += ')';
  }
  system.debug('QUERY: ' + query);
   accountids.add(accountid);
   Map<Id, Account> accounts = new Map<Id, Account>([select id, name, SAP_City__c, SAP_State__c, accountnumber, owner.managerid, owner.name from Account where id IN :accountids OR id = :accountid order by Name]);
  String Id = '';
  String Corp = '';
  String ShipTo = '';
  String SoldTo = '';
  String ContactFirstName = '';
  String ContactLastName = '';
  String Email = '';
  String ShipCity = '';
  String SHipState = '';
  
   for(Contact contact:database.query(query))
   {
     String sh = contact.accountid;
     
     string so = '';
     if(relmap.get('SoldTos').containskey(sh))
        so = relmap.get('SoldTos').get(sh);
     String c = '';
     
     if(so != '' && relmap.get('CorpIds').size() > 0)
     {
       if(relmap.get('CorpIds').containskey(so))
        c = relmap.get('CorpIds').get(so);
     }
     id =  contact.id;
     if(c != null && c != '')
     { Corp =  accounts.get(c).name + ' - ' + accounts.get(c).accountnumber;
     }
     else
     { Corp = 'N/A';
     }
     
     system.debug('Account Key Set: ' + accounts.keyset());
     system.debug('c: ' + c + 'so: '+ so + ' sh: ' + sh);

     if(so != null && so != '')
     SoldTo = accounts.get(so).Name + ' - ' + accounts.get(so).AccountNumber;
     
     system.debug('Contains Key: ' + accounts.containskey(sh));
     if(sh != null && sh != '')
     {
       system.debug('ShipTo: ' + accounts.get(sh));
     ShipTo = Contact.Account.Name + ' - ' + Contact.Account.accountnumber;
     shipcity = Contact.Account.sap_city__c;
     shipstate = Contact.Account.sap_state__c;
     }
     ContactFirstName = contact.FirstName;
     ContactLastName = contact.LastName;
     Email = Contact.Email;
  
     system.debug('FirstName: ' + ContactFirstName);
     system.debug('ContactLastName : ' + ContactLastName );
     system.debug('Email : ' + Email );
     rows.add(new row(id, corp, soldto, shipto, shipcity, shipstate, Contact.FirstName, Contact.LastName, Email, null));
   }     
}

global contactdata(String q, List<String> AccountId){
   rows = new List<Row>();
   system.debug('AccId:'+AccountId);
   set<String> relatedAccounts = new set<String>();
   
   String Id = '';
   String Corp = '';
   String ShipTo = '';
   String SoldTo = '';
   String ContactFirstName = '';
   String ContactLastName = '';
   String Email = '';
   String ShipCity = '';
   String ShipState = '';
   Boolean Nexpriceletter;
  
   for(Account a:[select id, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c from Account
                           where id IN :AccountId
                           AND (NOT Name like '%DO NOT USE%')])
         {
                relatedAccounts.add(a.id);
                
                if(a.SAP_Sold_To_Account_Id__c != null && a.SAP_Sold_To_Account_Id__c != '')
                	relatedAccounts.add(a.SAP_Sold_To_Account_Id__c);
                if(a.SAP_Corporate_Account_Id__c != null && a.SAP_Corporate_Account_Id__c != '')	
                	relatedAccounts.add(a.SAP_Corporate_Account_Id__c);
                
         }
  system.debug('related account:'+relatedAccounts);
  
  List<String> fields = new List<String>{'name', 'email', 'firstname', 'lastname'};
         
  String query = 'select id, name, email, firstname, lastname, neXprice_Price_Letters__c, account.SAP_City__C, Account.sap_state__c, account.name, account.accountnumber, accountid, account.SAP_Corporate_Account__c, account.SAP_Sold_To_Account__c from Contact where accountid IN :relatedAccounts';
  
  if(q != null && q != '')
  {
    query += ' and (';
    for(integer i=0; i<fields.size(); i++)
    { string s = fields.get(i);
      if(i != 0)
        query += ' OR ';
      query += s + ' LIKE \'%' + q + '%\'';
    }
    query += ')';
  }
  
  system.debug('QUERY: ' + query);
  for(Contact contact:database.query(query))
   {
       id =  contact.id;
       String sh = contact.accountid;
       if(contact.account.SAP_Corporate_Account__c != null && contact.account.SAP_Corporate_Account__c != '')
       { Corp =  contact.account.SAP_Corporate_Account__c;
        }
        else
        { Corp = 'N/A';
         }
     
     system.debug('c: ' + Corp);
     if(contact.account.SAP_Sold_To_Account__c != null && contact.account.SAP_Sold_To_Account__c != '')
         SoldTo = contact.account.SAP_Sold_To_Account__c;
     
     system.debug('SoldTo: ' + SoldTo);
     if(sh != null && sh != '')
     {
        system.debug('ShipTo: ' + sh);
        ShipTo = Contact.Account.Name + ' - ' + Contact.Account.accountnumber;
        shipcity = Contact.Account.sap_city__c;
        shipstate = Contact.Account.sap_state__c;
     }
     ContactFirstName = contact.FirstName;
     ContactLastName = contact.LastName;
     Email = Contact.Email;
     Nexpriceletter = Contact.neXprice_Price_Letters__c;
  
     system.debug('FirstName: ' + ContactFirstName);
     system.debug('ContactLastName : ' + ContactLastName );
     system.debug('Email : ' + Email );
     rows.add(new row(id, corp, soldto, shipto, shipcity, shipstate, Contact.FirstName, Contact.LastName, Email, Nexpriceletter));
   }
}

global class row{
  Public String Id{get; set;}
  Public String Corp{get; set;}
  Public String ShipTo{get; set;}
  Public String SoldTo{get; set;}
  Public String ContactFirstName{get; set;}
  Public String ContactLastName{Get; set;}
  Public String Email{get; set;}
  Public String ShipCity{get; set;}
  Public String ShipState{get; set;}
  Public String Name{get; set;}
  Public Boolean Nexpriceletter{get; set;}
  
  Public row(String id, String corp, String soldto, String shipto, String shipcity, String shipstate, String firstname, String lastname, String email, Boolean nexpriceletter)
  {
    this.id = id;
    this.corp = corp;
    this.SoldTo = soldto;
    this.ShipTo = shipto;
    this.ShipCity = shipcity;
    this.ShipState = shipstate;
    system.debug('FirstName: ' + FirstName);
    this.ContactFirstname = firstname;
    this.ContactLastName = lastname;
    this.email = email;
    this.Nexpriceletter = nexpriceletter;
    name = '';
    if(ContactFirstName != null)
    name += ContactFirstName;
    if(ContactLastName != null)
    name += ' ' + ContactLastName;
    if(ContactFirstName == null && ContactLastName == null && email != null)
    name = email;


  }

}
}