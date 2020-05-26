Global Class Price_Request_Transaction{

Public Price_Request_Transaction__c trans{get; set;}
Public SAP_Price List_Prices{Get; set;}
Public SAP_Price CSP_Prices{get; set;}
Public SAP_Price Target_Prices{Get; set;}
Public SAP_Price Requested_Tiers{get; set;}
Public List<SelectOption> getconversions(){return unitconversions; } 
private List<SelectOption> unitconversions{get; set;}
private List<String> SalesUnits{get; set;}
Public List<String> getSalesUnitsList(){ return SalesUnits; }
public Map<String, Double> conversionmap{get; set;}

Public void setconversions(List<CSP_JSON_Response.tbl_sales_units> units)
{
   SalesUnits = new List<String>();
   List<SelectOption> returnlist = new list<SelectOption>();
   String conversiondata = '';
   for(CSP_JSON_Response.tbl_sales_units u:units)
   {
     if(u.numerator != '' && u.denominator != '')
     ConversionData += u.Sales_unit + '>' + (Double.valueof(u.numerator) / Double.valueof(u.denominator)) + ';';
     returnlist.add(new SelectOption(u.sales_unit, u.sales_unit));
     SalesUnits.add(u.Sales_Unit);
     if(u.numerator != '' && u.denominator != '')
     conversionmap.put(u.sales_unit, (Double.valueof(u.numerator) / Double.valueof(u.denominator)));
   }
   system.debug('SalesUnits: ' + SalesUnits);
   unitconversions = returnlist;
   trans.unit_conversion_data__c = ConversionData;
}


Public String getTopCSP(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).Price__c); 
  else return '';
}
Public String getTopCSPEffDate(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).effective_date__c); 
  else return '';
}
Public String getTopCSPExpDate(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).expiration_date__c); 
  else return '';
}
Public String getTopDrumDeposit(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).drum_deposit_code__c); 
  else return '';
}
Public String getTopPriceProtectionDesc(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).Price_Protection_desc__c); 
  else return '';
}

Public String getTopCSPVolume(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).Volume__c); 
  else return '';
}
Public String getTopCSPVolUom(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).Volume_uom__c); 
  else return '';
}
Public String getTopCSPPriceUom(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(CSP_Prices.SAP_Tiers.get(0).Price_uom__c); 
  else return '';
}
Public String getTopTarget(){
  if(Target_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(Target_Prices.SAP_Tiers.get(0).Price__c); 
  else return '';
}
Public String getTopTargetVolume(){
  if(Target_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(Target_Prices.SAP_Tiers.get(0).Volume__c); 
  else return '';
}
Public String getTopTargetPriceUoM(){
  if(Target_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(Target_Prices.SAP_Tiers.get(0).Price_uom__c); 
  else return '';
}
Public String getTopTargetVolumeUoM(){
  if(Target_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(Target_Prices.SAP_Tiers.get(0).Volume_uom__c); 
  else return '';
}
Public String getTopTargetEffDate(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(Target_Prices.SAP_Tiers.get(0).effective_date__c); 
  else return '';
}
Public String getTopTargetExpDate(){
  if(CSP_Prices.SAP_Tiers.size() > 0)
    return  String.valueof(Target_Prices.SAP_Tiers.get(0).expiration_date__c); 
  else return '';
}
Public String getTopTPI(){
  if(CSP_Prices.SAP_Tiers.size() > 0 && Target_Prices.SAP_Tiers.size() > 0)
    if( CSP_Prices.SAP_Tiers.get(0).Price__c != null && Target_Prices.SAP_Tiers.get(0).Price__c != null && Target_Prices.SAP_Tiers.get(0).Price__c != 0 )
     return  String.valueof(((CSP_Prices.SAP_Tiers.get(0).Price__c / Target_Prices.SAP_Tiers.get(0).Price__c) * 100).setScale(2)) + '%'; 
    else return '';
  else return '';
}

Public Price_Request_Transaction(Price_Request_Transaction__c a){
 trans = a;
 List_Prices = new SAP_Price();
 CSP_Prices = new SAP_Price();
 Target_Prices = new SAP_Price();
 Requested_Tiers = new SAP_Price();
 conversionmap = new map<String, Double>();
 unitconversions = new list<SelectOption>();
 SalesUnits = new List<String>();

}
Public Double ConvertUnitsTo(Double iValue, String sUnitFrom, String sUnitTo, boolean invert){
   system.debug('conversion map: ' + conversionmap);
   system.debug('invert: ' + invert + ' iValue: ' + ivalue + ' sUnitFrom: ' + sUnitFrom + ' sUnitTo: ' + sUnitTo);
   if(conversionmap != null && conversionmap.size()>0){
       if(invert)
       {
         Double baseunit = iValue / conversionmap.get(sUnitFrom);
         system.debug('result: ' + (baseunit * conversionmap.get(sUnitTo)));
         return (baseunit * conversionmap.get(sUnitTo));
       }
       else
       {
         Double baseunit = iValue * conversionmap.get(sUnitFrom);
         system.debug('result: ' + (baseunit / conversionmap.get(sUnitTo)));
         return (baseunit / conversionmap.get(sUnitTo));
       
       }
    }else{
        return 0.0;
    }
}
}