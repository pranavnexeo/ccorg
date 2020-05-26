Public Class AM_CSPTier{

    Public Id recordid{get; set;}
    Public CSP_JSON_Response csps {get; set;}
    Public List<CSP_JSON_Response.tbl_target_prices> target;
    Public List<CSP_JSON_Response.tbl_csp_Prices> csptier;
    Public Boolean isCSPTableBlank; 
    Public Boolean isTargetTableBlank {get; set;}
    
    
    Public AM_CSPTier(){
    
        isCSPTableBlank = false;
        isTargetTableBlank = false;
     
    }
    Public static Double ConvertCurrency(Double iValue, String sFrom, String sTo, Map<String, Double> conversionmap)
    {
       if(conversionmap.containskey(sFrom) && conversionmap.containskey(sTo))
       {
       Double baseunit = iValue * conversionmap.get(sTo);
       return (baseunit / conversionmap.get(sFrom));
       }
       else
        return iValue;
    }
    
    Public static String formatDate(date d){
      if(d != null)
        return d.format();
      else
        return '';
    }
    Public static Date stringtodate(string s){
      
      date d = null;
      try{
        d = Date.valueof(s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6)); 
      }catch(exception e){system.debug('***DATE CONVERT ERROR***: ' + s + ' ERROR: ' + e.getmessage());} 
      return d;
    }
    
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
    
    Public List<CSP_JSON_Response.tbl_target_prices> gettarget(){
        List<Account_Material__c> ams = [Select SAP_Data__c,currencyisocode from Account_Material__c where id = :recordid];
        target = new List<CSP_JSON_Response.tbl_target_prices>();
        Map<String, Double> CurrencyMap = new Map<String, Double>();
        for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
        {
             if(c.isocode != '' && c.isocode != null)
               CurrencyMap.put(c.IsoCode, C.ConversionRate);
        } 
            
        for(Account_Material__c am:ams){
            
            if(am.SAP_Data__c != null)
                csps = (csp_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
            
            
            for(CSP_JSON_Response.tbl_target_prices t:csps.tbl_target_prices){ 
                
                if(t.target_price != ''){
       
                    String curr = '';
                    Double tarPrice;
                    if(t.target_price_currency != null)
                        if(t.target_price_currency.length() > 3)
                            curr = t.target_price_currency.substring(0,3);
                        else
                            curr = t.target_price_currency;              
                  
                    if(t.target_price_unit != '')
                        if(curr != am.currencyisocode)
                            t.target_price = String.valueof(convertcurrency(stringtodouble(t.target_price), curr, am.currencyisocode, CurrencyMap));
                        else
                            t.target_price = String.valueof(stringtodouble(t.target_price));
                            
                }
                
                target.add(t);
             }
           
        }
    
        return target;
    }
    
    Public List<CSP_JSON_Response.tbl_csp_Prices> getcsptier(){
        csptier= new List<CSP_JSON_Response.tbl_csp_Prices>();
        List<Account_Material__c> ams = [Select SAP_Data__c from Account_Material__c where id = :recordid];
        
        for(Account_Material__c am:ams){
            
            if(am.SAP_Data__c != null)
                csps = (csp_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
            
            for(CSP_JSON_Response.tbl_csp_Prices t:csps.tbl_csp_prices){ 
                
                if(t.csp_effective_date != null && t.csp_effective_date != ''){
                     t.CSP_effective_date = formatDate(stringtodate(t.csp_effective_date));
                }
                if(t.csp_expiration_date != null && t.csp_expiration_date != ''){
                     t.csp_expiration_date = formatDate(stringtodate(t.csp_expiration_date));
                }

                csptier.add(t);
             
            }
           
        }
     
     return csptier;
    }


}