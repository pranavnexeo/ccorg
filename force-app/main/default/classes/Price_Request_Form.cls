Public Class Price_Request_Form{
Public List<Price_Request_Transaction__c> transactions{Get; set;}
Public List<double> Tiers{get ;set;}
Public String uomoptions{get; set;}
Public String sf1eoquomoptions {get;set;}
Public String sf1compuomoptions {get;set;}
Public String sf1priceuomoptions {get;set;}
Public String sf1voluomoptions {get;set;}
Public String upfront{get; set;}
Public String Date_Today{Get; set;}
Public String Date_One_Year{get; set;}
Public String Date_Todaynext{Get; set;}
Public String Date_One_Yearnext{get; set;}
Public String Competitor{get; set;}

Public String division{get; set;}
Public String CompetitorId{get; set;}
Public String volumeuom{get ;set;}
Public String priceuom{get ;set;}
Public String eoquom{get ;set;}
Public String eavuom{get ;set;}
Public String obtainedfrom{get ;set;}
Public String compuom{get ;set;}
Public String compprice{get ;set;}
Public Double eoq{get ;set;}
Public String CurrencyIsoCode{get; set;}
Public String CSP_Currency{get; set;}
Public Double TopTier{get; set;}
Map<String, Double> CurrencyMap{get; set;}
Public String PriceProtectionOptions{get; set;}
Public String pacCode{get; set;}

Public string Cformatval{get; set;}
Public string Mdescval{get; set;}
Public String suppvalue{get; set;}
Public String suppliername{get; set;}
Public String type{Get; Set;}
Public String vari{Get; Set;}

Public String typeoptions{get; set;}
Public String shipto{get; set;}
Public String material{get; set;}
Public String basecode{get; set;}
Public Boolean CSPExist{get;set;}
Public Boolean TargetExist{get;set;}

Public String accntmatId;
Public nexprice_mobileSetPrice ctrl;
Public String FreightTermOptions{get; set;}
Public String Freight{get; set;}
Public String freightMatch{get; set;}

Public String psrsupplier{get; set;}
Public String aggrnum{get; set;} 
Public String psreffdate{Get; set;}
Public String psrexpdate{get; set;}
Public String psregion{get; set;}
Public String regionoptions{get; set;}
Public Double suppPrice{get; set;}
Public Double suppdisc1 {get; set;}
Public String disc1type{get; set;}
Public String disc2type{get; set;}
Public String psruom{get; set;}
Public String plantid{get; set;}
Public String plantname{get; set;}
Public String psfreight{get; set;}

Public Price_Request_Form(){
   date_today = system.today().format();
   date_one_year = (system.today() + 365).format();
   
   date_todaynext =  (system.today() + 366).format();
   date_one_yearnext = (system.today() + 731).format();
   
   String opt= ApexPages.currentpage().getparameters().get('opt');
   System.debug('opt is:'+opt);
   
   psreffdate = date_today;
   psrexpdate = date_one_year;
   String psId= ApexPages.currentpage().getparameters().get('psId');
   System.debug('psId is:'+psId);
   List<SAP_Price_Support__c> ps = new List<SAP_Price_Support__c>();
   
   if(psId != '' && psId != null)
   {
       ps = [Select Id, Agreement_Number__c, Supplier_Name__c, Supplier_Number__c, Supplier_Supported_Price__c, X1st_Discount_Sell__c, Region_Code__c, Region_Description__c from SAP_Price_Support__c where id =: psId];
       if(ps.size()> 0)
       {
           psrsupplier = '';
           aggrnum = '';
           psregion = '';
           psruom = ''; 
           
           psrsupplier = ps[0].Supplier_Name__c+' - '+ps[0].Supplier_Number__c;                      
           aggrnum = ps[0].Agreement_Number__c;
           psregion = ps[0].Region_Code__c;
           system.debug('psregion is:'+psregion);
           suppPrice = ps[0].Supplier_Supported_Price__c;
           suppdisc1 = ps[0].X1st_Discount_Sell__c;
           if(aggrnum.contains('U')){
               upfront ='true';    
           }
           else{
               upfront ='false';
           }
       }
   }
   
   CurrencyMap = new Map<String, Double>();
    for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
    {
       if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, C.ConversionRate);
    }
  Tiers = new List<Double>();
  String ids = ApexPages.currentpage().getparameters().get('id');
  List<String> amids = new List<String>();
  if(ids != null && ids !='')
  amids = ids.split('-');
  system.debug('amids is:'+amids);
  
  List<Account_Material__c> ams = Account_Material_Functions.getAccountMaterials(amids);
  for(Account_material__c am:ams)
    system.debug(am.Account_Sold_To__c);
  system.debug(ams);
  uomoptions = '';
  sf1eoquomoptions = '';
  sf1compuomoptions = '';
  sf1priceuomoptions  = '';
  sf1voluomoptions = '';
    
  CompetitorId = '';
  typeoptions = '';
  vari = '';
  Competitor = '';
  volumeuom = '';
  priceuom = '';
  eoquom = '';
  
  obtainedfrom = '';
  compuom = '';
  compprice = '';
  //eoq = 0;
  suppvalue = '';
  Cformatval = '';
  Mdescval = '';
  CurrencyIsoCode = '';
  CSP_Currency = '';
  Set<String> validuoms = new Set<String>();
  shipto = '';
  division = '';
  material = '';
  basecode = '';
  CSPExist = false;
  TargetExist = false;
  Freight = '';
  freightMatch = '';
  
  boolean addtiers = true;
  
  //transactions = Account_material_functions.gettransactions(ams, new map<string, string>());
  

  
  List<String> comparelist = new list<String>();
  
  for(integer i=0; i<ams.size(); i++)
  {

        
   Account_Material__c am = ams.get(i); //ams[i];
   System.debug(' Am !!!!!!!!!'+am);
   System.debug(' Am target uom!!!!!!!!!'+am.Target_UoM__c); 
   shipto = am.Account_Name__c;
   division = am.Division_Desc__c;
   material = am.Material__c;
   basecode = am.Material_Base_Code__c;
   
   if(am.Freight_Terms__c != null && am.Freight_Terms__c != '')
       Freight = am.Freight_Terms__c;
   system.debug('freight on AM is:'+Freight);
   
   if(CompetitorId == '' && am.Competitor__c != null)
   { CompetitorId = am.Competitor__c; Competitor = am.Competitor__r.name.escapeHTML4(); }
  // if(CurrencyIsoCode == '')
  //   CurrencyIsoCode = am.CurrencyIsoCode;
  if(CSP_Currency == '')
      CSP_Currency = am.CSP_Currency__c;
   if(suppvalue == '')
       suppvalue = am.supplier__c;
   System.debug('Supplier frm Am !!!!!!!!!'+am.supplier__c); 
   System.debug('suppvalue  !!!!!!!!!'+suppvalue ); 
   Cformatval = am.Container_for_new_material__c;
   Mdescval = am.Material_Description__c;
   
   if(opt == 'Quote')
   {   
       type = 'Quote';
       vari = 'false';
       List<String> alltyp = new list<String>();
       alltyp.add('Quote');
       alltyp.add('CSP');
       for(string s:alltyp)
           typeoptions += '<option value="' + s + '">' + s + '</option>';
       System.debug('type is!!!'+type);
   }
   
   if(opt == 'CSP')
   {   
       type = 'CSP';
       vari = 'false';
       List<String> alltyp = new list<String>();
       alltyp.add('CSP');
       alltyp.add('Quote');
       for(string s:alltyp)
           typeoptions += '<option value="' + s + '">' + s + '</option>';
       System.debug('type is!!!'+type);
   }
   
   if(opt == 'RFQ')
   {   
       
       type = 'RFQ';
       vari = 'true';
       System.debug('type is!!!'+type);
   }
   
   if(am.CSP_Tier_UoM__c != '' && am.CSP_Tier_UoM__c != null)
       CSPExist = true;
       
   
   if(am.Target_UoM__c!= '' && am.Target_UoM__c!= null)
       TargetExist = true;
   
   if(volumeuom == '')
     if(am.CSP_Tier_UoM__c != '' && am.CSP_Tier_UoM__c != null) 
        volumeuom = am.CSP_Tier_UoM__c;
     else if(am.Target_Tier_UoM__c!= '' && am.Target_Tier_UoM__c!= null)
        volumeuom = am.Target_Tier_UoM__c;
     else
        volumeuom = 'LB'; 
        
   if(priceuom == '')
     if(am.CSP_UoM__c != '' && am.CSP_UoM__c != null)   
            priceuom = am.CSP_UoM__c;
     else if(am.Target_UoM__c != '' && am.Target_UoM__c != null)
        priceuom = am.Target_UoM__c;
     else
        priceuom = 'LB'; 
   
   psruom = priceuom;   
   eoq = am.Estimated_Order_Quantity__c;
   
   if(eoquom == '')
     if(am.Estimated_Order_Qty_UoM__c != '' && am.Estimated_Order_Qty_UoM__c != null)
        eoquom = am.Estimated_Order_Qty_UoM__c;
     else if(am.CSP_Tier_UoM__c != '' && am.CSP_Tier_UoM__c != null)
        eoquom = am.CSP_Tier_UoM__c;
     else if(am.Target_Tier_UoM__c != '' && am.Target_Tier_UoM__c != null)
        eoquom = am.Target_Tier_UoM__c;
     else
        eoquom = 'LB';
   
   if(compuom == '')
     if(am.Competitive_UoM__c != '' && am.Competitive_UoM__c != null)
        compuom = am.Competitive_UoM__c;
     else if(am.CSP_UoM__c != '' && am.CSP_UoM__c != null)  
        compuom = am.CSP_UoM__c;
     else if(am.Target_UoM__c!= '' && am.Target_UoM__c!= null)  
        compuom = am.Target_UoM__c;
     else
        compuom = 'LB';
        
   
   CSP_JSON_Response csps = null;
   if(am.SAP_Data__c != null)
     csps = (csp_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
   
   if(tiers.size() == 0 && csps != null )
   {
     if(csps.tbl_CSP_prices.size() > 0 && addtiers)
     {
     addtiers = false;
     String csp_effective_date = csps.tbl_csp_prices.get(0).csp_effective_date;
     for( CSP_JSON_Response.tbl_CSP_prices pr:csps.tbl_CSP_prices)
      if(pr.csp_volume  != null && pr.csp_volume != '' && pr.csp_effective_date == csp_effective_date)
        tiers.add(stringtodouble(pr.csp_volume));
     }
        
     if(csps.tbl_target_prices.size() > 0 && addtiers)
     {
     addtiers = false;
     for( CSP_JSON_Response.tbl_target_prices tar:csps.tbl_target_prices)
      if(tar.tier_volume != null && tar.tier_volume != '')
        tiers.add(stringtodouble(tar.tier_volume));
     }
   }
   system.debug(am.uoms__c);
   if(am.uoms__c != null && am.uoms__c != '')
   {
    if(i == 0)
      validuoms.addall(am.uoms__c.split(';'));
    else
    {
      List<String> templist = new list<String>();
      comparelist.clear();
      comparelist.addall(am.uoms__c.split(';'));
      for(integer j=0; j<comparelist.size(); j++)
        if(validuoms.contains(comparelist.get(j)))
          templist.add(comparelist.get(j));
      templist.sort();
      validuoms.clear();
      validuoms.addall(templist);
    }

   }   
  }
  if(tiers.size() == 0)
    tiers.add(1);
  system.debug('tiers: ' + tiers);
  toptier = tiers.remove(0);
  system.debug('tiers: ' + tiers);
  system.debug(validuoms);
 
  List<String> alluoms = new list<String>();
  alluoms.addall(validuoms);
  alluoms.sort();
  for(string s:alluoms){
    uomoptions += '<option value="' + s + '">' + s + '</option>';
    sf1eoquomoptions += '<option';
    if(s == eoquom)
        sf1eoquomoptions += ' selected="selected"';
    sf1eoquomoptions += ' value="' + s + '">' + s + '</option>';
    
    sf1compuomoptions += '<option';
    if(s == compuom)
        sf1compuomoptions += ' selected="selected"';
    sf1compuomoptions += '  value="' + s +'">' + s + '</option>';
    
    sf1priceuomoptions += '<option';
    if(s == priceuom)
        sf1priceuomoptions += ' selected="selected"';
    sf1priceuomoptions += '  value="' + s + '">' + s + '</option>';
    
    sf1voluomoptions += '<option';
    if(s == volumeuom)
        sf1voluomoptions += ' selected="selected"';
    sf1voluomoptions += '  value="' + s + '">' + s + '</option>';
    
    }
  
  List<Nexeo_Competitor__c> ncc = [Select id, Name, Nexprice_flag__c from Nexeo_Competitor__c where Nexprice_flag__c = true];
  for(Nexeo_Competitor__c n:ncc)
  {    suppliername+= '<option value="' + n.Name;
       if(suppvalue == n.Name)
         suppliername += ' selected="selected" ';
       suppliername += '">' + n.Name + '</option>';
  }
      
  priceprotectionoptions = getPriceProtection();
  regionoptions = getPSRegion();
  pacCode = getpacCode();
  FreightTermOptions = getFreightTerms();
  
  //if(Freight != '' && Freight != null)
  //    if(!FreightTermOptions.contains(Freight))
  //        freightMatch = 'No';
          
   for(Freight_Terms_Code__c f:Freight_Terms_Code__c.getall().values())
   {
       string freightval = f.Name+'-'+f.Description__c;
       
       if(freightMatch != 'Yes' && Freight != freightval)
            freightMatch = 'No';
       else 
            freightMatch = 'Yes';
   }
           
}

Public Price_Request_Form(nexprice_mobileSetPrice controllerParam){
   ctrl=controllerParam;
   
   List<Nexeo_Competitor__c> ncc = [Select id, Name, Nexprice_flag__c from Nexeo_Competitor__c where Nexprice_flag__c = true];
  for(Nexeo_Competitor__c n:ncc)
  {    suppliername+= '<option value="' + n.Name;
       if(suppvalue == n.Name)
         suppliername += ' selected="selected" ';
       suppliername += '">' + n.Name + '</option>';
  }
}



Public static string getPriceProtection(){
     String PriceProtection = '';
     List<String> protections = new list<String>();

     for(Price_Protection_Codes__c p:Price_Protection_Codes__c.getall().values())
     {
       if(p.code__c != null)
       protections.add(p.code__c + ' - ' + p.name);
       else
       protections.add(p.name);

     }
     protections.sort();
     for(String s:protections){
        PriceProtection +=  '<option value="' + s + '" label="' + s + '"';
        if(s == 'Default Price Protection')
          PriceProtection += ' selected="selected" ';
        PriceProtection += '>' + s + '</option>';
     }
     system.debug('PriceProtection:'+PriceProtection);
     return PriceProtection;
}

Public string getPSRegion(){
     String region = '';
     List<String> regionlst = new list<String>();

     for(PlantRegion__c p:PlantRegion__c.getall().values())
     {
       if(p.code__c != null)
       regionlst.add(p.code__c + ' - ' + p.name);
       else
       regionlst.add(p.name);

     }
     regionlst.sort();
     for(String s:regionlst){
        region +=  '<option value="' + s + '" label="' + s + '"';
        if(psregion != '' && psregion != null){
        if(s.contains(psregion))
          region += ' selected="selected" ';}
        region += '>' + s + '</option>';
     }
     system.debug('region:'+region);
     return region;
}


Private static string getpacCode(){
     String pacCodelist= '';
     List<String> pacCodes = new list<String>();
     for(PAC_Code__c p:PAC_Code__c.getall().values())
     {
       
       if(p.name != null)
           pacCodes.add(p.name + ' - ' + p.code__c);
       else
       pacCodes.add(p.name);

     }
     pacCodes.sort();
     
     for(String s:pacCodes){
        pacCodelist +=  '<option value="' + s + '" label="' + s + '"';
        pacCodelist += '>' + s + '</option>';
     }
     return pacCodelist;
}

Public List<List<String>> getFreightTerms2(){
     List<List<String>> toreturn = new List<List<String>>();
     
     List<String> freightList = new list<String>();
     for(Freight_Terms_Code__c f:Freight_Terms_Code__c.getall().values())
     {
       if(f.name != null)
           freightList.add(f.name + '-' + f.Description__c);
       else
           freightList.add(f.name);
     }
     freightList.add(freight);
     freightList.sort();
     
     for(String f:freightList){
        
        LIst<String> row = new List<String>();
        String FreightString =  '<option value="' + f + '" label="' + f + '"';
        if(Freight != null && Freight != '')
            if(f.contains(Freight))
                FreightString += ' selected="selected" ';
        FreightString += '>';
        row.add(freightString);
        row.add(f);
        row.add('</option>');
        toreturn.add(row);
     }
   
     return toreturn;

}


Public string getFreightTerms(){
String Freightstring = '';
     List<String> freightList = new list<String>();
     for(Freight_Terms_Code__c f:Freight_Terms_Code__c.getall().values())
     {
       if(f.name != null)
         if(freight != f.name + '-' + f.Description__c)
           freightList.add(f.name + '-' + f.Description__c);
       //else
         //  freightList.add(f.name);
     }
     freightList.add(freight);
     freightList.sort();
     
     for(String f:freightList){
        FreightString +=  '<option value="' + f + '" label="' + f + '"';
        if(Freight != null && Freight != '')
            if(f.contains(Freight))
                FreightString += ' selected="selected" ';
        FreightString += '>' + f.escapehtml4() + '</option>';
     }
     system.debug('FreightString :'+FreightString );
     return FreightString;

}

   
public static Double Stringtodouble(Double d){ return d; }
public static Double Stringtodouble(Decimal d){ return Double.valueof(d); }
public static Double stringtodouble(String sIn){
  string temp = '';
  if(sIn != '' && sIn != null)
  {
    if(sIn.contains('-'))
    {  temp = sIn.replaceall('-', '');
       temp = '-' + temp;
    }
    else{ temp = sIn; }
    if(temp.contains(','))
      temp = temp.replaceall(',','');
    return double.valueof(temp);
  }
  else{ return null; }
}
}