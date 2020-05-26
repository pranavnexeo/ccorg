global with sharing class nexprice_mobileSetPrice{

global Price_Request_Form ctrl;


Public String amId {get; set;}
Public String Date_Today{get; set;}
Public String Date_One_Year{get; set;}
Public String type{get; set;}
Public String typeoptions{get; set;}
Public String CurrencyIsoCode{get; set;}
Public String CurrencyOptions{get; set;}
Public Double eoq{get ;set;}
Public String uomoptions{get; set;}
Public combogriddata CompetitorData{get;set;}
Public String CompetitorList{get; set;}
Public List<Nexeo_Competitor__c> nc{get;set;}
Public String CompetitorId{get; set;}
Public String volumeuom{get ;set;}
Public String priceuom{get ;set;}
Public String eoquom{get ;set;}
Public String sf1eoquomoptions {get;set;}
Public String sf1compuomoptions {get;set;}
Public String sf1priceuomoptions {get;set;}
Public String sf1voluomoptions {get;set;}

Public String obtainedfrom{get ;set;}
Public String compuom{get ;set;}
Public String compprice{get ;set;}
Public Double TopTier{get; set;}
Public List<double> Tiers{get ;set;}
Public String shipto{get; set;}
Public String division{get; set;}
Public String material{get; set;}
Public String basecode{get; set;}
Public String PriceProtectionOptions{get; set;}
Public Boolean CSPExist{get;set;}
Public Boolean TargetExist{get;set;}

Public nexprice_mobileSetPrice(){}
Public nexprice_mobileSetPrice(apexpages.standardcontroller sc){
//amId = Apexpages.currentpage().getparameters().get('ids');
amId = sc.getrecord().id;
system.debug('amid is::'+amId);
Price_Request_Form setform = new Price_Request_Form();
system.debug('CurrencyISO:'+setform.currencyisocode);
  
  
  type='Quote';
  typeoptions = '';
  eoquom = '';
  uomoptions = '';
  CompetitorId = '';
  //Competitor = '';
  volumeuom = '';
  priceuom = '';
  compuom = '';
  compprice = '';
 
  CurrencyIsoCode = '';
  PriceProtectionOptions= '';
  
  shipto = '';
  division = '';
  material = '';
  basecode = '';
  CurrencyOptions = '';
  sf1eoquomoptions = '';
  sf1compuomoptions = '';
  sf1priceuomoptions = '';
  sf1voluomoptions = '';
  CSPExist = false;
  TargetExist = false;
  
  Datetime dt_today = Datetime.now();
  Datetime dt_today1 = Datetime.now().addyears(1);
  Date_Today = dt_today.format('yyyy-MM-dd');
  Date_One_Year = dt_today1.format('yyyy-MM-dd');

  system.debug('Date_Today:'+Date_Today);
  system.debug('Date_One_Year:'+Date_One_Year);
  
  currencyisocode = setform.currencyisocode;
  
  List<String> alltypes = new list<String>();
  alltypes.add('CSP');
  alltypes.add('Quote');
  for(string s:alltypes)
        typeoptions += '<option value="' + s + '">' + s + '</option>';
  
  
  List<String> allcurrencies = new list<String>();
  allcurrencies.add('USD - US Dollar');
  allcurrencies.add('CAD - Canadian Dollar');
  
  for(string s:allcurrencies){
        CurrencyOptions += '<option ';
        if(s.substring(0,3) == currencyisocode)
            CurrencyOptions += ' selected="selected"';
        CurrencyOptions += 'value="' + s.substring(0,3) + '">' + s + '</option>';
  }
  
  eoq = setform.eoq;
  eoquom = setform.eoquom;
  sf1eoquomoptions = setform.sf1eoquomoptions;
  sf1compuomoptions = setform.sf1compuomoptions;
  sf1priceuomoptions = setform.sf1priceuomoptions;
  sf1voluomoptions = setform.sf1voluomoptions;
 
    
  uomoptions = setform.uomoptions;
  CompetitorId = setform.CompetitorId;
  system.debug('CompetitorId :'+CompetitorId );
  
  division = setform.division;

 // system.debug('division is: '+division);
  //CompetitorData = Nexprice.getComboGridData('','Nexeo_Competitor__c', 'Name', 'status__c = \'Active\' and Competitor_or_Supplier__c = \'Competitor\'', 'Name ASC', '1000');
  nc = [Select Name, Id from Nexeo_Competitor__c where status__c = 'Active' and competes_with__c INCLUDES (: division) and Competitor_or_Supplier__c = 'Competitor' order by Name ASC LIMIT 1000];
  system.debug('nc is: '+nc);
   for(Nexeo_Competitor__c s: nc){
       CompetitorList += '<option';
       if(CompetitorId != null && CompetitorId != '')
           if(s.Id == CompetitorId)
               CompetitorList += ' selected="selected"';
       CompetitorList += ' value="' + s.Id +'">' + s.Name + '</option>';
   }
  
  system.debug('CompetitorList :'+CompetitorList);
  compuom = setform.compuom;
  toptier = setform.toptier;
  volumeuom = setform.volumeuom;
  priceuom = setform.priceuom;
  tiers = setform.tiers;
  shipto = setform.shipto;
  material = setform.material;
  basecode = setform.basecode;
  PriceProtectionOptions = setform.PriceProtectionOptions;
  CSPExist = setform.CSPExist;
  TargetExist = setform.TargetExist;
  
  
}


Public nexprice_mobileSetPrice(Price_Request_Form controllerParam){
    ctrl=controllerParam;
}

Public static string getDateFormat(){
  date d = Date.valueof('1999-01-22');
  string dformat = d.format();
  string f = '';

  if(dformat.indexof('22') < dformat.indexof('01'))
    f = 'dd/mm';
  else
    f = 'mm/dd';
  if(dformat.indexof('01') < dformat.indexof('1999'))
    f = f + '/yy';
  else
    f = 'yy/' + f;
  return f;
  
}
@RemoteAction
public static List<Price_Request_Transaction__c> SubmitForm12(Boolean sforcecheck, String deviceType, List<String> amids, List<formData> data, string operation){
  List<Price_Request_Transaction__c> prt = new List<Price_Request_Transaction__c>();
  Boolean CMflag;
  CMflag = false;
  prt = nexprice.SubmitForm12(sforcecheck, deviceType, amids, data, operation, CMflag);
 
   
   return prt;      
      
}

/*


@RemoteAction 
Public Static String getTargetTier(){
String amId= Apexpages.currentpage().getparameters().get('ids');
system.debug('ids is:'+amId);


}*/

}