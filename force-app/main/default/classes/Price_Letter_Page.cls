Public Class Price_Letter_Page{

Public Price_Letter__c Price_Letter{Get; set;}
Public List<Price_Letter_Item__c> Items{Get; set;}
Public List<SAP_Price_Tier__c> Quote_Tiers{Get; set;}
Public List<SAP_Price_Tier__c> CSP_Tiers{Get; set;}
Public List<Price_Letter_Location> locations{Get; set;}
Public integer size{get; set;}

Public Price_Letter_Page(ApexPages.standardcontroller sc){

Set<Id> AccountIds = new Set<Id>();
Set<Id> TransactionIds = new Set<Id>();
Set<Id> SAPPriceIds = new Set<Id>();
Set<Id> MaterialIds = new Set<Id>();
Locations = new list<Price_Letter_Location>();  
  
Price_Letter = (Price_Letter__c)sc.getrecord();


Items = [select id, 
   quote_tiers__c,
   quote_Tiers__r.price_request_Transaction__c,
   quote_tiers__r.price_request_Transaction__r.ship_to__c,
   quote_tiers__r.price_request_Transaction__r.sold_to__c,
   quote_tiers__r.price_request_Transaction__r.corporate_account__c,
   Quote_tiers__r.Price_request_transaction__r.SAP_Material__c,
   Quote_tiers__r.Price_request_transaction__r.SAP_Material__r.Name_w_o_G2__c,
   CSP_Tiers__c,
   csp_tiers__r.price_Request_Transaction__c,
   csp_tiers__r.price_request_Transaction__r.ship_to__c,
   csp_tiers__r.price_request_Transaction__r.sold_to__c,
   csp_tiers__r.price_request_Transaction__r.corporate_account__c,
   CSP_Tiers__r.Price_Request_Transaction__r.SAP_Material__c,
   CSP_Tiers__r.Price_request_transaction__r.SAP_Material__r.Name_w_o_G2__c,
   Price_Letter__c
   from Price_Letter_Item__c where Price_Letter__c = :Price_Letter.id];
for(Price_Letter_Item__c i:items)
{
  MaterialIds.add(i.quote_tiers__r.price_request_transaction__r.sap_material__c);
  MaterialIds.add(i.CSP_tiers__r.price_request_transaction__r.sap_material__c);
  SAPPriceIds.add(i.quote_tiers__c);
  SAPPriceIds.add(i.CSP_Tiers__c);
  TransactionIds.add(i.quote_tiers__r.price_request_transaction__c);
  TransactionIds.add(i.csp_tiers__r.price_request_transaction__c);
  accountids.add(i.quote_tiers__r.price_request_Transaction__r.ship_to__c);
  accountids.add(i.quote_tiers__r.price_request_Transaction__r.sold_to__c);
  accountids.add(i.quote_tiers__r.price_request_Transaction__r.corporate_account__c);
  accountids.add(i.csp_tiers__r.price_request_Transaction__r.ship_to__c);
  accountids.add(i.csp_tiers__r.price_request_Transaction__r.sold_to__c);
  accountids.add(i.csp_tiers__r.price_request_Transaction__r.corporate_account__c);

}
List<SAP_Price_Tier__c> Tiers = [select id, currencyisocode, volume__c, volume_uom__c, 
                                        price__c, price_uom__c, effective_date__c, expiration_date__c, SAP_Price__r.type__c,
                                        SAP_Price__r.price_request_Transaction__c from SAP_Price_tier__C where SAP_PRice__c IN :SAPPriceIds 
                                        order by volume__c ASC];
                                        
                                        
Map<Id, Material_Sales_data2__c> Mat_map = new Map<id, Material_Sales_Data2__c>([select id, name, Name_w_o_G2__c from Material_Sales_Data2__c where id IN :materialids]);
Map<String, List<SAP_Price_Tier__c>> Tier_Map = new Map<String, List<SAP_Price_tier__c>>();
for(SAP_Price_Tier__c t:Tiers)
{
  if(Tier_map.containskey(t.sap_price__r.type__c + t.sap_price__r.price_request_Transaction__c))
    Tier_map.get(t.sap_price__r.type__c + t.sap_price__r.price_request_Transaction__c).add(t);
  else
    tier_Map.put(t.sap_price__r.type__c + t.sap_price__r.price_request_Transaction__c, new List<SAP_Price_tier__c>{t});
}    

List<Price_Request_Transaction__c> Transactions = [select id, SAP_Material__c, account_material__c, customer_s_Material_number__c, ship_to__c, ship_to__r.name, ship_to__r.accountnumber, ship_to__r.full_address__c, sold_to__r.name, sold_to__r.accountnumber, corporate_account__r.name, corporate_account__r.accountnumber, corporate_account__r.full_address__c, sold_to__c, sold_to__r.full_address__c, corporate_account__c, currencyisocode 
                                                   from Price_Request_Transaction__c where id IN :Transactionids
                                                   order by SAP_Material__r.name ASC];
Map<Id, Account> Account_Map = new map<Id, Account>([Select id, name, accountnumber from Account where id IN :accountids order by Name]);
Set<String> LocationSet = new Set<String>();
for(Price_Request_Transaction__c t:Transactions)
{

  List<SAP_Price_Tier__c> Requested = new List<SAP_Price_Tier__c>();
  List<SAP_Price_tier__c> CSP = new list<SAP_Price_tier__c>();
  
  if(Tier_Map.containskey('Requested' + t.id))
    Requested = Tier_Map.get('Requested' + t.id);
  if(Tier_Map.containskey('CSP' + t.id))
    CSP = tier_Map.get('CSP' + t.id);

  if(LocationSet.contains('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c))
  {
    for(Price_Letter_Location location:Locations)
    { 
      if(location.id == ('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c))
        location.items.add(new Price_Letter_Item(t.customer_s_material_number__c, mat_map.get(t.sap_material__c), Requested, CSP));
    }
  }
  else
  {
      Price_Letter_Location loc = new Price_Letter_Location(t, mat_map.get(t.sap_material__c), Requested, CSP);
      locations.add(loc);
      LocationSet.add('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c);
  }
}
size = locations.size();

}

public String getHeaderDetailLine() {   
  String result;
  result = 'Information as of ' + getLongDate();
  return result;
}

public String getHeaderDetailLineFrench() {   
  String result;
  result = 'Valide en date du ' + getLongDateFrench();
  return result;
}

public String getLongDate() {
  String LongDate = '';
  Datetime cDT = System.now();
  LongDate = cDT.format('EEEE, MMMM d, yyyy');
  return LongDate;
}

public String getLongDateFrench() {
  String LongDate = '';
  Datetime cDT = System.now();
  String sLocale = UserInfo.getLocale();
    system.debug('Locale is:'+UserInfo.getLocale());
    if(sLocale == 'en_CA')
      LongDate = cDT.format('EEEE, d MMMM, yyyy');
    else
      LongDate = cDT.format('EEEE, MMMM d, yyyy');
  return LongDate;
}


Public Class Price_Letter_Location{

 Public String Id{Get; set;}
 Public List<Location> CorpSoldShip{get; set;}
 Public List<Price_Letter_Item> Items{get; set;}
 Public Price_Request_Transaction__c Trans{Get; set;}

 Public Price_Letter_Location(Price_Request_Transaction__c t, Material_Sales_Data2__c m, List<SAP_Price_tier__c> Req, List<SAP_Price_tier__c> CSP )
 {
   CorpSoldShip = new List<Location>();
   id = ('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c);
   items = new list<Price_Letter_Item>();
   items.add(new Price_Letter_Item(m, req, csp));
   if(t.corporate_account__r != null)
     CorpSoldShip.add(new location('Corporate', t.corporate_account__r));
   if(t.sold_to__r != null)
     CorpSoldShip.add(new location('Sold To', t.Sold_to__r));
   if(t.ship_to__r != null)
     CorpSoldShip.add(new location('Ship To', t.Ship_to__r));

 }
 
 public void addItem(Material_Sales_Data2__c m, List<SAP_Price_tier__c> Req, List<SAP_Price_tier__c> CSP)
 { items.add(new Price_Letter_Item(m, req, csp)); }
 
}

Public Class Price_Letter_Item{

Public List<SAP_Price_Tier__c> CSP_Tiers{Get; set;}
Public List<SAP_Price_Tier__c> Quote_Tiers{get; set;}
Public Material_Sales_Data2__c material{get; set;}
Public string customermaterialnumber{get; set;}

Public Price_Letter_Item(Material_Sales_Data2__c m, List<SAP_Price_Tier__c> req, List<SAP_Price_tier__c> CSP)
{ 
   if(CSP.size()>0)
      CSP_Tiers = CSP;
   else
      CSP_Tiers = req;
  Quote_Tiers = req;
  Material = m;
  customermaterialnumber = '';
}
Public Price_Letter_Item(String custmatnum, Material_Sales_Data2__c m, List<SAP_Price_Tier__c> req, List<SAP_Price_tier__c> CSP)
{ 
  if(CSP.size()>0)
      CSP_Tiers = CSP;
  else
      CSP_Tiers = req;
  Quote_Tiers = req;
  Material = m;
  customermaterialnumber = custmatnum;
}
}
Public Class Location{

Public String type{get; set;}
Public Account a{get; set;}

Public Location(String Type, Account acct)
{ this.type = type; this.a = acct; }

}
}