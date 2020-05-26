Public Class Letter_Price_Controller{

Public Price_Letter__c Price_Letter{Get; set;}
Public List<Price_Letter_Item__c> Items{Get; set;}
Public List<SAP_Price_Tier__c> Quote_Tiers{Get; set;}
Public List<SAP_Price_Tier__c> CSP_Tiers{Get; set;}
Public List<Price_Letter_Location> locations{Get; set;}
Public List<Account_Material__c> ams{Get; set;}
Public integer size{get; set;}
Public Date tdate = system.today();

Public Letter_Price_Controller(ApexPages.standardcontroller sc){

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
List<SAP_Price_Tier__c> Tiers = [select id, currencyisocode, SAP_Currency__c, volume__c, volume_uom__c, 
                                        price__c, price_uom__c, effective_date__c, expiration_date__c, SAP_Price__r.type__c,
                                        SAP_Price__r.price_request_Transaction__c, SAP_Price__r.price_request_Transaction__r.Name from SAP_Price_tier__C where SAP_PRice__c IN :SAPPriceIds 
                                        order by volume__c, effective_date__c ASC];
                                        
                                        
Map<Id, Material_Sales_data2__c> Mat_map = new Map<id, Material_Sales_Data2__c>([select id, name, Name_w_o_G2__c from Material_Sales_Data2__c where id IN :materialids]);
Map<String, List<SAP_Price_Tier__c>> Tier_Map = new Map<String, List<SAP_Price_tier__c>>();
for(SAP_Price_Tier__c t:Tiers)
{
  if(Tier_map.containskey(t.sap_price__r.type__c + t.sap_price__r.price_request_Transaction__c))
    Tier_map.get(t.sap_price__r.type__c + t.sap_price__r.price_request_Transaction__c).add(t);
  else
    tier_Map.put(t.sap_price__r.type__c + t.sap_price__r.price_request_Transaction__c, new List<SAP_Price_tier__c>{t});
}    

List<Price_Request_Transaction__c> Transactions = [select id, Name, account_material__r.CSP_Currency__c, account_material__r.Approx_Package_Weight__c,account_material__r.freight_terms__c,SAP_Material__c, account_material__c,account_material__r.Seller_Name__c, customer_s_Material_number__c, ship_to__c, ship_to__r.name, ship_to__r.accountnumber, ship_to__r.full_address__c, sold_to__r.name, sold_to__r.accountnumber, corporate_account__r.name, corporate_account__r.accountnumber, corporate_account__r.full_address__c, sold_to__c, sold_to__r.full_address__c, corporate_account__c, CSP_Currency__c
                                                   from Price_Request_Transaction__c where id IN :Transactionids
                                                   order by SAP_Material__r.name ASC];
Map<Id, Account> Account_Map = new map<Id, Account>([Select id, name, accountnumber from Account where id IN :accountids order by Name]);
Set<String> LocationSet = new Set<String>();
for(Price_Request_Transaction__c t:Transactions)
{

  List<SAP_Price_Tier__c> Req = new List<SAP_Price_Tier__c>();
  List<SAP_Price_tier__c> CSP = new list<SAP_Price_tier__c>();
  
  
  if(Tier_Map.containskey('Requested' + t.id))
    Req = Tier_Map.get('Requested' + t.id);
  if(Tier_Map.containskey('CSP' + t.id))
    CSP = tier_Map.get('CSP' + t.id);
   
  if(LocationSet.contains('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c))
  { 
    for(Price_Letter_Location location:Locations)
    { 
      if(location.id == ('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c)){
        
        decimal newPrice;
        decimal currentPrice;
        decimal minQTY;
        string effDate;
        string volUOM;
        string priceUOM;
        
        string curr = t.account_material__r.CSP_Currency__c;
        String approxweight = t.account_material__r.Approx_Package_Weight__c;  
        String freightTerms = t.account_material__r.freight_terms__c.split('-')[1];     
        String accountteam = t.account_material__r.seller_name__c;
        String custmatnum= t.customer_s_Material_number__c;
        
        if(CSP.size()==0 && req.size()==0){
            tierinfo ti = new tierinfo(newPrice,currentPrice, minQTY,
                          effDate, volUOM, priceUOM, approxweight, curr,
                          mat_map.get(t.sap_material__c).Name_w_o_G2__c,null,accountTeam, custmatnum);
                         
             location.tierlist.add(ti);
        }
        else{
            
               if(CSP.size()>req.size()){
               system.debug('csp>req');
               
                  for(integer j=0;j<CSP.size();j++){
                      
                      newprice = null;
                      currentPrice = null;
                      //currentPrice = CSP[j].Price__c;
                      minQTY= CSP[j].Volume__c;
                      volUOM= CSP[j].Volume_UOM__c;
                      priceUOM= CSP[j].Price_UOM__c;
                      if(CSP[j].Effective_Date__c > tdate)
                          newPrice = CSP[j].Price__c;
                      else
                          currentPrice = CSP[j].Price__c;
                          
                      if(Req.size()>j){
                          if(newPrice != null)
                              newPrice = Req[j].Price__c;
                          effDate= formatdate(req[j].Effective_Date__c);
                      }else{
                          effDate= formatdate(CSP[j].Effective_Date__c);
                      }
                      
                      
                     
                     tierinfo ti = new tierinfo(newPrice,currentPrice, minQTY,
                             effDate, volUOM, priceUOM, approxweight, curr,
                             mat_map.get(t.sap_material__c).Name_w_o_G2__c,freightTerms,accountTeam, custmatnum);
                                 
                     location.tierlist.add(ti);
                  }
                  
                }
                else
                { 
                
                     for(integer j=0;j<Req.size();j++){
                      
                      currentPrice = null;
                      newPrice = null;
                      //newPrice = req[j].Price__c;
                      
                      minQTY= req[j].Volume__c;
                      volUOM= req[j].Volume_UOM__c;
                      priceUOM= req[j].Price_UOM__c;
                      effDate= formatdate(req[j].Effective_Date__c);
                      
                      if(CSP.size()>j){
                      if(CSP[j].Effective_Date__c >= tdate)
                          newPrice = CSP[j].Price__c;
                      else
                          currentPrice = CSP[j].Price__c;
                      }
                      
                      if(newPrice == null)
                          newPrice = req[j].Price__c;
                          
                          
                      tierinfo ti = new tierinfo(newPrice,currentPrice, minQTY,
                             effDate, volUOM, priceUOM, approxweight, curr,
                                 mat_map.get(t.sap_material__c).Name_w_o_G2__c,freightTerms,accountTeam, custmatnum);
                                 
                     location.tierlist.add(ti);
                   }
                }
             }                    
          }
      }
   }
   else
      {  
          Price_Letter_Location loc = new Price_Letter_Location(t, mat_map.get(t.sap_material__c), Req, CSP);
          locations.add(loc);
          LocationSet.add('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c);
      }
 }
 size = locations.size();

}

public String getHeaderDetailLine() {   
  String result;
  result = getLongDate();
  return result;
}
public String getHeaderDetailLineCanadian() {   
  String result;
  result = getLongDatecanadian();
  return result;
}

public String getHeaderDetailLineFrench() {   
  String result;
  result = getLongDateFrench();
  return result;
}

public String getLongDate() {
  String LongDate = '';
  Datetime cDT = System.now();
  LongDate = cDT.format('MMMM d, yyyy');
  return LongDate;
}
public String getLongDatecanadian() {
  String LongDate = '';
  Datetime cDT = System.now();
  LongDate = cDT.format('dd MMMM, yyyy');
  return LongDate;
}

public String getLongDateFrench() {
  String LongDate = '';
  Datetime cDT = System.now();
  String sLocale = UserInfo.getLocale();
    if(sLocale == 'en_CA')
      LongDate = cDT.format('dd MMMM, yyyy');
    else
      LongDate = cDT.format('dd MMMM, yyyy');
  return LongDate;
}


Public Class Price_Letter_Location{

 Public String Id{Get; set;}
 Public List<Location> CorpSoldShip{get; set;}
 Public List<tierInfo> tierList{get; set;}
 Public Price_Request_Transaction__c Trans{Get; set;}
 Public Date tdate = system.today();

 Public Price_Letter_Location(Price_Request_Transaction__c t, Material_Sales_Data2__c m, List<SAP_Price_tier__c> Req, List<SAP_Price_tier__c> CSP )
 {
   tierList = new List<tierinfo>();
   CorpSoldShip = new List<Location>();
    
   id = ('' + t.corporate_account__c + t.sold_to__c + t.ship_to__c);
     if(t.ship_to__r != null)
     CorpSoldShip.add(new location('Ship To', t.Ship_to__r));
       
    decimal newPrice;
    decimal currentPrice;
    decimal minQTY;
    string effDate;
    string volUOM;
    string priceUOM;
    string curr = t.account_material__r.CSP_Currency__c;
    string approxweight = t.account_material__r.Approx_Package_Weight__c;
    //system.debug('test:'+t.account_material__r.freight_terms__c);
    String freightTerms;
    //if((t.account_material__r.freight_terms__c).contains(','))
        freightTerms = t.account_material__r.freight_terms__c.split('-')[1];
    system.debug('test:'+freightTerms);
    String accountteam = t.account_material__r.seller_name__c;
    String custmatnum= t.customer_s_Material_number__c;
    
   
        if(CSP.size()==0 && req.size()==0){
            tierinfo ti = new tierinfo(newPrice,currentPrice, minQTY,
                         effDate, volUOM, priceUOM, approxweight, curr,
                         m.Name_w_o_G2__c,null,accountTeam, custmatnum);
                         
            tierlist.add(ti);
            
        }
        else{
            if(CSP.size()>req.size()){
          
              for(integer j=0;j<CSP.size();j++){
                  
                  newPrice = null;
                  currentPrice = null;
                  //currentPrice = CSP[j].Price__c;
                  minQTY= CSP[j].Volume__c;
                  volUOM= CSP[j].Volume_UOM__c;
                  priceUOM= CSP[j].Price_UOM__c;
                  
                  if(CSP[j].Effective_Date__c > tdate)
                          newPrice = CSP[j].Price__c;
                  else
                          currentPrice = CSP[j].Price__c;
                  
                  if(Req.size()>j){
                      if(newPrice == null)
                              newPrice = Req[j].Price__c;
                      
                      effDate= formatDate(req[j].Effective_Date__c);
                  }else{
                      effDate= formatDate(CSP[j].Effective_Date__c);
                  }
                 
                 tierinfo ti = new tierinfo(newPrice,currentPrice, minQTY,
                         effDate, volUOM, priceUOM, approxweight, curr,
                             m.Name_w_o_G2__c,freightTerms,accountTeam, custmatnum);
                             
                 tierlist.add(ti);
              }
              
            }else{  
                 for(integer j=0;j<Req.size();j++){
                  
                  currentPrice =null;
                  newPrice = null;
                  //newPrice = req[j].Price__c;
                  minQTY= req[j].Volume__c;
                  volUOM= req[j].Volume_UOM__c;
                  priceUOM= req[j].Price_UOM__c;
                  effDate= formatDate(req[j].Effective_Date__c);
                  
                  if(CSP.size()>j){
                      if(CSP[j].Effective_Date__c >= tdate){
                          newPrice = CSP[j].Price__c;
                          effDate= formatDate(CSP[j].Effective_Date__c);}
                      else
                          currentPrice = CSP[j].Price__c;
                  }
                      
                      if(newPrice == null)
                          newPrice = req[j].Price__c;
                  
                  tierinfo ti = new tierinfo(newPrice,currentPrice, minQTY,
                         effDate, volUOM, priceUOM, approxweight, curr,
                             m.Name_w_o_G2__c,freightTerms,accountTeam, custmatnum);
                             
                 tierlist.add(ti);
               }
            }
            
        }
        
        
    }
    
 }

 


public class tierInfo{

    Public string newPrice{get; set;}
    Public string currentPrice{get; set;}
    Public decimal minQTY{get; set;}
    Public string effDate{get; set;}
    Public string volUOM{get; set;}
    Public string priceUOM{get; set;}
    Public string approxweight{get; set;}
    Public string materialname{get; set;}
    Public string freightTerms{get; set;}
    Public string accountTeam{get; set;}
    Public string custmatNum{get; set;}
    Public string curr{get; set;}
    
    public String formatPrice(Decimal price,String priceUOM,String curr){
        String retvalue = '';
        if(price == null)
            retvalue = '';
        else
         retvalue = '$' + ' ' + retvalue + price.toPlainString() + ' ' + priceUOM + ' ' + curr;
      
        return retvalue;   
    }
    
         public tierinfo(Decimal newPrice,decimal currentPrice, decimal minQTY,
         string effDate, string volUOM, string priceUOM, string approxweight, string curr,
         string materialname,string freightTerms,string accountTeam, string custmatnum){
         
             this.newPrice = formatPrice(NewPrice,priceUOM,curr);
             this.currentPrice= formatPrice(currentPrice,priceUOM,curr);
             if(this.currentPrice == '' && this.newPrice == '')
                 this.currentPrice = 'Please call for Pricing';
             this.minQTY= minQTY;
             this.effDate= effDate;
             this.volUOM= volUOM;
             this.priceUOM= priceUOM;
             this.curr= curr;
             this.approxweight= approxweight;
             this.materialname= materialname;
             this.freightTerms= freightTerms;
             this.accountTeam= accountTeam;
             this.custmatnum= custmatnum;
             
         }

}

Public Class Location{

Public String type{get; set;}
Public Account a{get; set;}
public string anumber{get;set;}
Public Location(String Type, Account acct)
{
this.type = type; 
this.a = acct;
anumber = acct.AccountNumber.replaceFirst( '^0+', '').trim();
}
}

Public static String formatDate(date d){
  if(d != null)
    return d.format();
  else
    return '';
}



}