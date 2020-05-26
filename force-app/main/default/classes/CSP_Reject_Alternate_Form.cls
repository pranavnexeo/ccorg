Public Class CSP_Reject_Alternate_Form{
Public List<Price_Request_Transaction__c> transactions{Get; set;}
Public List<double> Tiers{get ;set;}
Public List<SAP_Price_Tier__c> SAPTiers{get ;set;}
Public SAP_Price_Tier__c toptier{Get; Set;}
Public String uomoptions{get; set;}
Public String Date_Today{Get; set;}
Public String Date_One_Year{get; set;}
Public string effdate{Get; set;}
Public string expdate{Get; set;}
Public string effdatenext{Get; set;}
Public string expdatenext{Get; set;}
Public String type{Get; Set;}
Public Static String pacCode{Get; Set;}
Public String application{Get; Set;}
Public String oem{Get; Set;}
Public String SpecifiedMaterial{Get; Set;}
Public String supplier{Get; Set;}
Public String description{Get; Set;}
Public String ExistingBusiness{Get; Set;}
Public String CompetitiveProducer{Get; Set;}
Public String competitivegrade{Get; Set;}
Public Decimal estanualVol{Get; Set;}
Public String estanualUom{Get; Set;}
Public String ContainerForNewMaterial{Get; Set;}
Public String drumdeposit{Get; Set;}

Public Decimal volume{get ;set;}
Public String volumeuom{get ;set;}
Public String priceuom{get ;set;}
Public String price{get ;set;}
//Public Decimal price{get ;set;}
Public String amid{get ;set;}
Public String reqtier{get ;set;}
Public Decimal eoq{get ;set;}
Public String eoquom{get ;set;}
Public String obtainedfrom{get ;set;}
Public String Competitor{get; set;}
Public String CompetitorId{get; set;}
Public String compuom{get ;set;}
Public Decimal compprice{get ;set;}
Public String CurrencyIsoCode{get; set;}
Map<String, Double> CurrencyMap{get; set;}
Public String PriceProt {Get; Set;}
Public String PriceProtectionOptions{get; set;}
Public String ReasonCode {Get; Set;}
Public String ReasonCodeOptions{get; set;}
Public String PACCodeOptions{get; set;}
Public String comments{get; set;}
Public String appcomments {Get; Set;}
Public String coordcomments {Get; Set;}

Public boolean dateflag {Get; Set;}
Public List<SAP_Price_Tier__c> SAPTiersnext{get ;set;}
Public List<SAP_Price_Tier__c> SAPTierscurr{get ;set;}
Public SAP_Price_Tier__c toptier2{Get; Set;}
Public Account_Material__c ams;

Public Decimal volume2{get ;set;}
Public String volumeuom2{get ;set;}
Public String priceuom2{get ;set;}
Public String price2{get ;set;}
//Public Decimal price2{get ;set;}
Public String FreightTermOptions{get; set;}
Public String Freight{get; set;}
Public String freightMatch{get; set;}

Public boolean prosmaterial{get; set;}

Account_Material__c AM;

Public CSP_Reject_Alternate_Form(){}

Public Void FormOnLoad(){
     system.debug('Begin');
     
  String ids = ApexPages.currentpage().getparameters().get('ids');
  String mat= ApexPages.currentpage().getparameters().get('mat');
  String opt= ApexPages.currentpage().getparameters().get('opt');
  system.debug('opt is:'+opt);
  system.debug('mat parameter is:'+mat);
  uomoptions = '';
  volumeuom = '';
  priceuom = '';
  eoquom = '';
  CurrencyIsoCode = '';
  type='';
  drumdeposit='';
  CompetitorId = '';
  Competitor = '';
  obtainedfrom = '';
  compuom = '';
  PriceProt = '';
  ReasonCode = '';
  comments = '';
  appcomments ='';
  coordcomments = '';
  pacCode= '';
  application='';
  oem='';
  SpecifiedMaterial= '';
  supplier= '';
  description= '';
  ExistingBusiness= '';
  CompetitiveProducer= '';
  competitivegrade= '';
  estanualUom= '';
  ContainerForNewMaterial= '';
  Freight = '';
  freightMatch = '';
  
   CurrencyMap = new Map<String, Double>();
    for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
    {
       if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, C.ConversionRate);
    }
    
    system.debug('Beginning');
    
  List <Price_Request_Transaction__c> prtrec = [select Id, 
  Requested_Effective_Date__c,
  Requested_Expiration_Date__c,
  currencyisocode,
  Type__c, 
  Prospect_Material__c,
  Reason_Code__c,
  Requested_Drum_Deposit__c,
  Quantity__c,
  Estimated_Order_Qty_UoM__c,
  Competitor__c,
  Competitor__r.name,
  Competitor_Obtained_From__c,
  Competitive_Price__c,
  Competitive_UoM__c,
  Requested_Price_Protection__c,
  comments__c,  
  Approval_Rejection_Comments__c,
  Coordinator_Comments__c,
  PAC_Code__c,
  Application__c,
  OEM__c,
  Specified_Material__c,
  Existing_Business_for_Customer__c,
  Competitive_Producer__c,
  Competitive_Grade__c,
  Estimated_Annual_Volume__c,
  Estimated_Annual_Volume_UOM__c,
  Description__c,
  Material_Supplier__c,
  Container_for_new_Material__c,
  Requested_Effective_Datenext__c,
  Requested_Expiration_Datenext__c,
  Account_Material__c, Requested_Tiers__c, SAP_Material__r.name, Freight_Terms__c, CSP_Currency__c
    from Price_Request_Transaction__c where Id =: ids];
    
    if(prtrec!= null && prtrec.size()>0){    
    amid = prtrec[0].Account_Material__c;
    
    System.debug('!@ prtrec'+prtrec);
    
    if(prtrec[0].Requested_Effective_Date__c != null)
        effdate = prtrec[0].Requested_Effective_Date__c.format();
    else
        effdate = '';
    
    if(prtrec[0].Requested_Expiration_Date__c != null)
        expdate = prtrec[0].Requested_Expiration_Date__c.format();
    else
        expdate = '';
    if(prtrec[0].Requested_Effective_Datenext__c != null)
        effdatenext = prtrec[0].Requested_Effective_Datenext__c.format();
    else{
            if(prtrec[0].Requested_Expiration_Date__c !=null){
                effdatenext = date.parse(expdate).addDays(1).format();
            }
        }
    
    if(prtrec[0].Requested_Expiration_Datenext__c != null)
        expdatenext = prtrec[0].Requested_Expiration_Datenext__c.format();
    else{
            if(prtrec[0].Requested_Effective_Date__c !=null){
                expdatenext = date.parse(effdatenext).addYears(1).format(); 
            }   
        }
    //if(CurrencyIsoCode == '')
        CurrencyIsoCode = prtrec[0].CSP_Currency__c;
        //CurrencyIsoCode = prtrec[0].currencyisocode;

    system.debug('PAC Code is:'+prtrec[0].PAC_Code__c);
    if(pacCode== '')
        pacCode= prtrec[0].PAC_Code__c;
    
    if(application== '')
        application= prtrec[0].Application__c;
    
    if(oem== '')
    oem= prtrec[0].OEM__c;
    
    if(Freight== '')
    Freight= prtrec[0].Freight_Terms__c;
    
    if(SpecifiedMaterial== '')
    SpecifiedMaterial= prtrec[0].Specified_Material__c;
    
    if(ExistingBusiness== '')
    ExistingBusiness= prtrec[0].Existing_Business_for_Customer__c;
    
    if(CompetitiveProducer== '')
    CompetitiveProducer= prtrec[0].Competitive_Producer__c;
    
    if(competitivegrade== '')
    competitivegrade= prtrec[0].Competitive_Grade__c;
    
    estanualVol= prtrec[0].Estimated_Annual_Volume__c == null ? 0 : prtrec[0].Estimated_Annual_Volume__c.intvalue();
    
    if(estanualUom== '')
    estanualUom= prtrec[0].Estimated_Annual_Volume_UOM__c;
    
    if(description== '')
    description= prtrec[0].Description__c;
    
    if(supplier== '')
    supplier= prtrec[0].Material_Supplier__c;
    system.debug('Supplier is;'+supplier);
    if(ContainerForNewMaterial== '')
    ContainerForNewMaterial= prtrec[0].Container_for_new_Material__c;
    
    
    if(type== '')
        type = prtrec[0].Type__c;
    
    //Added to predefault Type as CSP on form on click of Convert RFQ
    if(opt == 'convert')
         type = 'CSP';
        
    if(drumdeposit== '')
        drumdeposit = prtrec[0].Requested_Drum_Deposit__c;
    //if(eoq== '')
        system.debug(prtrec[0].Quantity__c);
        
        eoq = prtrec[0].Quantity__c == null ? 0 : prtrec[0].Quantity__c.intvalue();
        
    if(eoquom== '')
        eoquom = prtrec[0].Estimated_Order_Qty_UoM__c;
    if(CompetitorId == '' && prtrec[0].Competitor__c != null)
    { CompetitorId = prtrec[0].Competitor__c; 
      Competitor = prtrec[0].Competitor__r.name.escapeHTML4(); }
    if(obtainedfrom == '')
        obtainedfrom = prtrec[0].Competitor_Obtained_From__c;
    if(prtrec[0].Competitive_Price__c != null){
        if(CurrencyIsoCode.contains('4'))
            compprice = prtrec[0].Competitive_Price__c.setscale(4);
        else 
            compprice = prtrec[0].Competitive_Price__c.setscale(2);}
        
   // if(Decimal.valueof(compprice).scale()<2)
   //   Decimal.valueof(compprice).setscale(2);
    
    system.debug('compprice is : '+compprice);
    if(compuom == '')
        compuom = prtrec[0].Competitive_UoM__c;
    
    priceprotectionoptions = getPriceProtection();
    ReasonCodeOptions = getReasonCode();
    PACCodeOptions = getpacCode();
    FreightTermOptions = getFreightTerms();
    
   for(Freight_Terms_Code__c f:Freight_Terms_Code__c.getall().values())
   {
       string freightval = f.Name+'-'+f.Description__c;
       
       if(freightMatch != 'Yes' && Freight != freightval)
            freightMatch = 'No';
       else 
            freightMatch = 'Yes';
   }
    if(ReasonCode == '')
        ReasonCode = prtrec[0].Reason_Code__c;
        
    if(PriceProt == '')
        PriceProt = prtrec[0].Requested_Price_Protection__c;
    
            
    if(comments == '')
        comments = prtrec[0].Comments__c;
    if(appcomments == '')
        appcomments = prtrec[0].Approval_Rejection_Comments__c;
    if(coordcomments == '')
        coordcomments = prtrec[0].Coordinator_Comments__c;
        
    prosmaterial = prtrec[0].Prospect_Material__c;
    system.debug('prosmaterial is : '+prosmaterial);
   
    
    if(!prtrec[0].Prospect_Material__c)
        ams = Account_Material_Functions.getPricing(amid);
    else if(mat != null && mat != '')
        ams = Account_Material_Functions.getPricingRFQ(mat,amid).get(0);
    system.debug('Account Material returned:'+ams);
    
    }
         
  //Account_Material__c AccountMat =[Select id, UoMs__c from Account_Material__c where id =:amid];
   SAPTiers = new List<SAP_Price_Tier__c>();         
  for(SAP_Price_Tier__c spt:[select id, price__c, volume__c, price_uom__c, volume_uom__c, SAP_Price__c, tpi__c, sap_price__r.price_request_transaction__c,  Effective_Date__c, Expiration_Date__c, currencyisocode, req_price__c from SAP_Price_Tier__c 
                           where sap_price__r.type__c = 'Requested' and SAP_Price__r.price_request_Transaction__c =:ids ])
   {
      SAPTiers.add(spt);
   }
   //system.debug('SAP Tiers:'+SAPTiers);
  SAPTierscurr = new List<SAP_Price_Tier__c>();
  SAPTiersnext = new List<SAP_Price_Tier__c>();
  if(SAPTiers.size() > 0){
   string effdatecmp;
   string expdatecmp;
   
   for(SAP_Price_Tier__c spt:SAPTiers){
       
       effdatecmp = spt.Effective_Date__c.format();
       expdatecmp = spt.Expiration_Date__c.format();
       system.debug('effdatecmp :'+effdatecmp);
       system.debug('effdate :'+effdate);
       system.debug('effdatenext:'+effdatenext);
       spt.price__c = spt.price__c;
       spt.req_price__c = spt.req_price__c;
       spt.volume__c = spt.volume__c.intValue();
       if(expdate == expdatecmp){ 

           dateflag = true;
           SAPTierscurr.add(spt);
       }
       else if(expdatenext == expdatecmp)
       {
           dateflag = false;
           SAPTiersnext.add(spt);
       }
   }
   
  } 
  
   if(SAPTiers!= null && SAPTierscurr!= null && SAPTiers.size() == SAPTierscurr.size()){
   
    for(SAP_Price_Tier__c SAPtier :SAPTiers){
        SAP_Price_Tier__c tier = new SAP_Price_Tier__c();
        tier.req_price__c = SAPtier.req_price__c;
        tier.price__c = SAPtier.price__c;
        tier.volume__c = SAPtier.volume__c.intValue();
        SAPTiersnext.add(tier);
    }   
       
   }
   
   if(SAPTierscurr.size() > 0)
   toptier = SAPTierscurr.remove(0);
   if(SAPTiersnext.size() > 0)

   toptier2 = SAPTiersnext.remove(0); 
   
   if(toptier !=null){
  //if(volume == '')
     volume = toptier.volume__c == null ? 0:toptier.volume__c.intvalue();
      
  if(volumeuom == '')
     volumeuom = toptier.volume_uom__c;
     system.debug('Toptier volumeuom:'+volumeuom);
 
  price = toptier.req_price__c;
  //price = toptier.price__c.setscale(4);
  System.debug('!!@ price'+price);
  
  if(priceuom == '')
     priceuom = toptier.price_uom__c;
      system.debug('Toptier priceuom:'+priceuom);
  
   }
   
   if(toptier2 !=null){
  
     volume2 = toptier2.volume__c == null ? 0:toptier2.volume__c.intvalue();
      
     if(volumeuom2 == '')
         volumeuom2 = toptier2.volume_uom__c;
         system.debug('Toptier volumeuom:'+volumeuom2);
 
     //price2 = toptier2.price__c.setscale(4);
     price2 = toptier2.req_price__c;
  
  
     if(priceuom2 == '')
     priceuom2 = toptier2.price_uom__c;
     system.debug('Toptier priceuom:'+priceuom2);
  
   }
   
  system.debug('After spt query');  
  Set<String> validuoms = new Set<String>();
  
   
   if((mat != null && mat != '') || prosmaterial == false)
   if(ams.UoMs__c != null && ams.UoMs__c != '')
   {
   system.debug('Inside Validuoms');
   

      validuoms.addall(ams.UoMs__c.split(';'));


   }   
  
  List<String> alluoms = new list<String>();
  alluoms.addall(validuoms);
  alluoms.sort();
  for(string s:alluoms)
    uomoptions += '<option value="' + s + '">' + s + '</option>';
  system.debug('UoM:'+uomoptions);
  
  /*if(tiers.size() == 0)
    tiers.add(1);
    toptier = tiers.remove(0);*/
    
}

Private static string getPriceProtection(){
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
        if(s == 'Default Protection')
          PriceProtection += ' selected="selected" ';
        PriceProtection += '>' + s + '</option>';
     }
     return PriceProtection;
}

Private static string getpacCode(){
     String pacCodelist= '';
     List<String> pacCodes = new list<String>();

     for(PAC_Code__c p:PAC_Code__c.getall().values())
     {
       if(p.name != null)
       pacCodes.add(p.name + ' - ' + p.code__c);
       else
       pacCodes.add(p.code__c);

     }
     pacCodes.sort();
     system.debug('PAC Codes are:'+pacCodes);
     for(String s:pacCodes){
        pacCodelist +=  '<option value="' + s + '" label="' + s + '"';
        if(s == pacCode)
          pacCodelist += ' selected="selected" ';
        pacCodelist += '>' + s + '</option>';
     }
     return pacCodelist;
}

Private static string getReasonCode(){
     String ReasonCode = '';
     List<String> codes = new list<String>();

     for(Reason_Codes__c p:Reason_Codes__c.getall().values())
       codes.add(p.name);
     
     codes.sort();
     
     for(String s:codes){
        ReasonCode +=  '<option value="' + s + '" label="' + s + '"';
        ReasonCode += '>' + s + '</option>';
     }
     return ReasonCode;
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
        FreightString += '>' + f + '</option>';
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