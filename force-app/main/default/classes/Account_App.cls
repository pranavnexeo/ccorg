Public Class Account_App{

Public List<Account_Entry> tree{get; set;}

Public Account_App(ApexPages.standardcontroller sc){
  
  tree = new List<Account_Entry>();
  map<string, Account_Entry> soldtos = new map<string, Account_Entry>();
  map<string, Account_Entry> corps = new map<string, Account_Entry>();
  string id = ((account)sc.getrecord()).id;
  set<string> ids = new set<String>();
  map<string, map<string, string>> relmap = CISRelationships_Functions.Lookup_Related_Accounts(new set<string>{id});
  map<string, Account_Entry> aemap = new map<string, Account_Entry>();
  for(map<string, string> themap:relmap.values())
  {  ids.addall(themap.keyset());
     ids.addall(themap.values()); 
  }
  Map<id, Account> amap = new map<Id, Account>([select id, name, accountnumber, owner.name, SAP_Street__c, SAP_City__c, 
                                                SAP_State__c, SAP_Zip_Code__c, sales_area__c, SAP_Customer_Group_desc__c, 
                                                SAP_Sales_Org__c,   SAP_Sales_Org_desc__c, SAP_DistChannel__c, SAP_Dist_Channel_Desc__c,
                                                SAP_DivisionCode__c,    SAP_Division_desc__c,
                                                SAP_Customer_Group_1_desc__c, SAP_Sales_District_Desc__c, SAP_Sales_Office_Desc__c, SAP_Sales_Group_desc__c
                                                from Account where id IN :ids]);
                                                
  for(string s:relmap.get('SoldTos').keyset())
  {
    if(!soldtos.containskey(relmap.get('SoldTos').get(s)))
      soldtos.put(relmap.get('SoldTos').get(s), new Account_Entry('Sold To', amap.get(relmap.get('SoldTos').get(s)), (relmap.get('SoldTos').get(s) == id)));
    soldtos.get(relmap.get('SoldTos').get(s)).children.add(new Account_Entry('Ship To', amap.get(s), (s == id)));
  }
  for(string s:relmap.get('CorpIds').keyset())
  {
    if(!corps.containskey(relmap.get('CorpIds').get(s)))
      corps.put(relmap.get('CorpIds').get(s), new Account_Entry('Corp Acct', amap.get(relmap.get('CorpIds').get(s)), (relmap.get('CorpIds').get(s) == id)));
    if(soldtos.containskey(s) && corps.containskey(relmap.get('CorpIds').get(s)))
      corps.get(relmap.get('CorpIds').get(s)).children.add(soldtos.get(s));
  }
  
  
  if(corps.values().size() > 0)
    tree.addall(corps.values());
  if(soldtos.values().size() > 0 && tree.size() == 0)
    tree.addall(soldtos.values());

}
Public Class Account_Entry{

Public Account parent{get; set;}
Public List<Account_Entry> children{Get; set;}
Public boolean showaccount{get; set;}
Public String type{get; set;}

Public Account_Entry(String type, Account a, boolean sa){
  this.type = type;
  parent = a;
  children = new List<Account_Entry>(); 
  showaccount = sa;
}

}
}