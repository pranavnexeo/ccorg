/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/30/2016
*    Author:             Francisco Garcia
*   Last Modified:       10/26/2018
*   Last Modified By:    Francisco Garcia
*
*   Short Description:  Get Pricing data from SAP real time. 
*                    - Cutting decimals for Min Qty in containers.
*   **********************************************************************************************************************/


public class PricingCustomerPortal {

    public boolean getPricingFromSAP(List<Account> AccountsToPricing){
       
       CC_SFDC_Settings__c cusSetting=CC_SFDC_Settings__c.getInstance('CPI_MyNexeo');
       Date dontdisplay_Date = date.newInstance(1999,01,01);
       
       Set<String> CISAccountNumbers=new Set<String>();
       List<CSP_JSON_Request_Item> SAP_Requests = new List<CSP_JSON_Request_Item>();
     
        
        for(Account act:AccountsToPricing){ //Create a Set of Account_Number__c from the List of Accounts Parameter.
            if(notNullOrVoid(act.Account_Number__c) && notNullOrVoid(act.SAP_DivisionCode__c) && act.SAP_DivisionCode__c!='34'){//Validate to avoid nulls or Empty strings.
                CISAccountNumbers.add(act.Account_Number__c);
            }
        }

        List<Id> ccPriceListIds=new List<Id>();
        Map<String,Id> CISAccNumAndPriceListId=new Map<String,Id>();
        //System.debug(LoggingLevel.INFO,'FGG CISAccountNumbers Size '+CISAccountNumbers.Size());
        System.debug('Number of Account : '+CISAccountNumbers.Size());
        System.debug('Check point 1 : '+Limits.getQueryRows());
        System.debug('Check point 1 : '+Limits.getDMLRows());
        
        for(ccrz__E_PriceList__c PriceList:[select id,ccrz__PricelistId__c from ccrz__E_PriceList__c where ccrz__PricelistId__c in: CISAccountNumbers]){
            ccPriceListIds.add(PriceList.id);
            CISAccNumAndPriceListId.put(PriceList.ccrz__PricelistId__c, PriceList.id);
        }
        System.debug('Number of pricelists for the Accounts : '+ccPriceListIds.Size());
        System.debug('Check point 2 : '+Limits.getQueryRows());
        System.debug('Check point 2 : '+Limits.getDMLRows());
        
        Map<Id,ccrz__E_PriceListItem__c> PriceListAndItems=new Map<Id,ccrz__E_PriceListItem__c>();  
        List<ccrz__E_PriceListItem__c> priceItemstoUpdate=new List<ccrz__E_PriceListItem__c>();
        List<ccrz__E_PriceListItem__c> PriceListItems=[select Container_Weight__c,Material_Container_Abbreviation__c,ccrz__Product__c,ccrz__StartDate__c,ccrz__Pricelist__c from ccrz__E_PriceListItem__c where CPI_Deletion_Indicator__c!='X' and  ccrz__Pricelist__c in:ccPriceListIds];
        set<String> productIds=new set<String>();
        set<Id> priceListItemsId= new set<ID>();
        
                for(ccrz__E_PriceListItem__c plItems:PriceListItems){
                    
                    date endDate = date.newInstance(1999,12,31);
                    plItems.ccrz__Price__c=0;
                    plItems.ccrz__StartDate__c=endDate;
                    plItems.ccrz__EndDate__c=endDate;
                    plItems.ccrz__UnitOfMeasure__c='';
                    plItems.PriceUoM__c='';
                    plItems.volumeUom__c='';
                    plItems.ccrz__MinQty__c=0;
                    plItems.Container_Weight__c='';
                    priceItemstoUpdate.add(plItems);
                    productIds.add(plItems.ccrz__Product__c);
                    priceListItemsId.add(plItems.Id);
                } 
        
        System.debug('Number of pricelists items for pricelists of the Accounts : '+PriceListItems.Size());
        System.debug('Check point 3 : '+Limits.getQueryRows());
        System.debug('Check point 3 : '+Limits.getDMLRows());
        
        
        
      
        Map<Id,String> salesUOMmap=new Map<Id,String>();
        Map<Id,String> productMap=new Map<Id,String>();
        for(ccrz__E_Product__c products:[select Id,Product_Number__c, Sales_UoM__c,Material_Container_Abbreviation__c from ccrz__E_Product__c where Id in:ProductIds]){
            salesUOMmap.put(products.Id,products.Material_Container_Abbreviation__c);
            productMap.put(products.Id, products.Product_Number__c);
            
        }
     
        System.debug('Number of products for pricelists of the Accounts : '+productMap.keySet().Size());
        System.debug('Check point 4 : '+Limits.getQueryRows());
        System.debug('Check point 4 : '+Limits.getDMLRows());
        
        //update priceItemstoUpdate;
        List<CSP_JSON_Request_Item> requestList=new List<CSP_JSON_Request_Item>(); 
        //System.debug(priceItemstoUpdate.size()+' has been updated to $0.');
        for(Account acct:AccountsToPricing){
            for(String idMap:CISAccNumAndPriceListId.keySet()){
                 if(acct.Account_Number__c==idMap){    
                     for(ccrz__E_PriceListItem__c pli:PriceListItems){
                         
                         if(CISAccNumAndPriceListId.get(idMap)==pli.ccrz__Pricelist__c){
                             //System.debug('Request:PLI:'+pli.id+' Ship To:'+acct.Ship_To_Number__c+' Sold To:'+acct.Sold_To_Customer_Number__c+' Product Id:'+pli.ccrz__Product__c);
                                CSP_JSON_Request_Item cspRequest = new CSP_JSON_Request_Item(
                                                   'X',
                                                   acct.Account_Number__c, 
                                                   acct.Sold_To_Customer_Number__c,
                                                   '',
                                                   productMap.get(pli.ccrz__Product__c),//MaterialNumber
                                                   '1',
                                                   pli.Material_Container_Abbreviation__c,
                                                   pli.Id, 
                                                   '',
                                                   acct.SAP_Sales_Org__c,
                                                   acct.SAP_DistChannel__c);
                             requestList.add(cspRequest);
                         }
                     }
                                 
                             }
                         }
                     }
                 //System.debug('CallOut Request Total:'+requestList.size());
                 System.debug('SAP request count :'+requestList.size());
        List<ccrz__E_PriceListItem__c>pliToUpdate=new List<ccrz__E_PriceListItem__c>();
        if(requestList.size() != null){
        List<CSP_JSON_Response> SAP_Responses = CSP_JSON_Request.submit_Request_m(requestList);
        //List<CSP_JSON_Response.tbl_csp_prices> listcspPrices = new List<CSP_JSON_Response.tbl_csp_prices>();
        //System.debug('FGG CallOut Responses Total:'+SAP_Responses.size());     
        System.debug('SAP response count :'+SAP_Responses.size()); 
          if(SAP_Responses.size()>0){
                
                
                Map<ID, List<CSP_JSON_Response.tbl_csp_prices>>  mapPLI= new Map<ID, List<CSP_JSON_Response.tbl_csp_prices>>();
                Map<ID, List<CSP_JSON_Response.tbl_sales_units>>  mapSalesUnits= new Map<ID, List<CSP_JSON_Response.tbl_sales_units>>();
                
              for(CSP_JSON_Response csp:SAP_Responses)
                {
                    List<CSP_JSON_Response.tbl_csp_prices> listcspPrices = new List<CSP_JSON_Response.tbl_csp_prices>();
                    List<CSP_JSON_Response.tbl_sales_units> listSalesUnits = new List<CSP_JSON_Response.tbl_sales_units>();                   
                    //system.debug('Id: ' + csp.sfdc_account_id);
                    for(ccrz__E_PriceListItem__c pli:PriceListItems){
                        system.debug('FGG-sfdc_account_id:'+csp.sfdc_account_id);
                        system.debug('FGG-pli.id:'+pli.Id);                        
                        if(csp.sfdc_account_id==pli.Id){                                                                    
                                //listcspPrices=csp.tbl_csp_prices;
                            for(CSP_JSON_Response.tbl_csp_prices cspPrices:csp.tbl_csp_prices){
                                
                                if(System.Date.today()<=stringtodate(cspPrices.csp_expiration_date) && System.Date.today()>=stringtodate(cspPrices.csp_effective_date)){
                                    listcspPrices.add(cspPrices);   
                         
                                }
                            }
                            
                            mapSalesUnits.put(pli.Id, csp.tbl_sales_units);
                            mapPLI.put(pli.Id, listcspPrices);
                            if(listcspPrices.size()>0){                               
                               	/*
                                TierPricingCustomerPortal tpcp=new TierPricingCustomerPortal();
                                tpcp.createCCPriceModifier(listcspPrices,pli);
                                */                                
								//System.debug('FGG cspPrices'+listcspPrices[0]);
                                
                                CSP_JSON_Response.tbl_csp_prices cspPrices=listcspPrices[0];
                                
                                
                            if(notNullorVoid(cspPrices.csp_price)){
                                //System.debug('FGG csp_price'+cspPrices.csp_price);
                                Map<String, Double> conversionmap=new Map<String, Double>();   
                                
                                conversionmap=Account_Material_Functions.getConversionMap(csp.tbl_sales_units); 
                                System.debug('FGG conversion Map Key'+conversionmap.keyset());
                                System.debug('FGG conversion Map Values'+conversionmap.values());
                                
                                
                                 string unitFrom=checkOtherNames(cspPrices.csp_uom);                                
                                string unitTo=checkOtherNames(pli.Material_Container_Abbreviation__c);
                                System.debug('FGG'+conversionmap+'-'+cspPrices.csp_volume+'-'+unitFrom+'-'+unitTo);
                                    
                                Decimal price=Account_Material_Functions.ConvertUnits(conversionmap,stringtodouble(cspPrices.csp_price), unitFrom, unitTo, true);                                                               
                                Decimal tvol=Account_Material_Functions.ConvertUnits(conversionmap, stringtodouble(cspPrices.csp_volume), unitFrom,unitTo, false);
                                tvol=tvol.setScale(1);
                                Decimal weight=Account_Material_Functions.ConvertUnits(conversionmap,1,unitTo,UnitFrom,false);
                                //System.debug('FGGA conversionMap '+conversionmap);
                                //System.debug('FGGA cspPrices.csp_volume '+cspPrices.csp_volume);
                                //System.debug('FGGA: ConvertPricing '+conversionmap+' iValue'+stringtodouble(cspPrices.csp_price)+' UnitFrom '+unitFrom+' UnitTo '+UnitTo+' ConvertedValue '+price);
                                //System.debug('FGGA: ConvertVolume '+conversionmap+' iValue'+stringtodouble(cspPrices.csp_volume)+' UnitFrom '+unitFrom+' UnitTo '+UnitTo+' ConvertedValue '+tvol);
                                
                                //Public static Double ConvertUnits(Map<String, Double> conversionmap, Double iValue, String sUnitFrom, String sUnitTo, boolean invert){
                    
                                //pli.ccrz__Price__c=stringtodecimal(cspPrices.csp_price);
                                if(price != 0)
                                {
                                    pli.ccrz__Price__c=price;//.setScale(2, RoundingMode.HALF_UP);                                
                                }
                                else
                                {
                                    pli.ccrz__Price__c=price;
                                    if(!cusSetting.Get_Products_Zero_Price__c)
                                    {
                                        pli.ccrz__EndDate__c=dontdisplay_Date;
                                        pli.ccrz__StartDate__c=dontdisplay_Date;                
                                    }                                    
                                }
                                //pli.ccrz__Price__c=cspPrices.csp_price;
                                //pli.ccrz__UnitOfMeasure__c=cspPrices.csp_uom;
                                pli.ccrz__StartDate__c=stringtodate(cspPrices.csp_effective_date);
                                pli.ccrz__EndDate__c=stringtodate(cspPrices.csp_expiration_date).AddDays(1);
                                pli.CSP_Experation_Date__c=stringtodate(cspPrices.csp_expiration_date);
                                pli.CurrencyIsoCode=cspPrices.csp_currency.substring(0,3);
                                pli.Currency_ISO_Code__c=cspPrices.csp_currency.substring(0,3);
                                
                                //System.debug('FGG csp '+csp.sales_unit);
                                if(cspPrices.csp_scale_uom==cspPrices.csp_uom){  
                                    if(tvol>=1){
                                        System.debug('FGG - Pricing tvol '+tvol+' MinQty '+tvol.setScale(0,RoundingMode.UP));
                                        pli.ccrz__MinQty__c=tvol.setScale(0,RoundingMode.UP); 
                                        //System.debug('FGG UNITS from '+unitFrom+' and Units to '+unitTo +' '+pli.ccrz__Price__c+' CSP_SCALE_UOM '+cspPrices.csp_scale_uom+' csp.sales_unit '+csp.sales_unit+' CSP_UOM '+cspPrices.csp_uom+' TVOL'+tvol+' CSP_VOLUME '+cspPrices.csp_volume);           
                                    }else{
                                        pli.ccrz__MinQty__c=1;                                        
                                    }
                                }else{
                                        pli.ccrz__MinQty__c=stringtodecimal(cspPrices.csp_volume);        
                                }   
                                pli.Container_Weight__c=String.valueOf(weight.setScale(0,RoundingMode.UP))+' '+unitFrom;
                                   
                                //if(UnitFrom!=UnitTo)
                                //pli.ccrz__MinQty__c=stringtodecimal(cspPrices.csp_volume);
                                //pli.ccrz__MinQty__c=stringtodecimal(cspPrices.csp_volume);
                                pli.ccrz__UnitOfMeasure__c=pli.Material_Container_Abbreviation__c;
                                pli.volumeUom__c=pli.Material_Container_Abbreviation__c;
                                pli.PriceUoM__c=cspPrices.csp_uom;      
                                //system.debug('FGG csp_uom'+cspPrices.csp_uom);
                            }
                                 else{
                                pli.ccrz__Price__c=0;
                                if(!cusSetting.Get_Products_Zero_Price__c)
                                {
                                    pli.ccrz__EndDate__c=dontdisplay_Date;
                                    pli.ccrz__StartDate__c=dontdisplay_Date;                
                                }                               
                            }
                            }
                            else{
                                pli.ccrz__Price__c=0;
                                if(!cusSetting.Get_Products_Zero_Price__c)
                                {
                                    pli.ccrz__EndDate__c=dontdisplay_Date;
                                    pli.ccrz__StartDate__c=dontdisplay_Date;
                                }                                   
                            }
                            //pli.ccrz__UnitOfMeasure__c=csp.base_price_uom;                            
                        }                                                
                    } 
                }
             System.debug('Check point 5 : '+Limits.getQueryRows());
             System.debug('Check point 5 : '+Limits.getDMLRows());
                
             DeleteTierPricingCustomerPortal deleteTiers=new DeleteTierPricingCustomerPortal();
             deleteTiers.deleteTiers(priceListItemsId);
             
             System.debug('Check point 6 : '+Limits.getQueryRows());
             System.debug('Check point 6 : '+Limits.getDMLRows());
                
             //HideorNotProductsZeroPrice(priceListItemsId);   
             TierPricingCustomerPortal tpcpbulk=new TierPricingCustomerPortal();
             tpcpbulk.createCCPriceModifierBulk(mapPLI,mapSalesUnits);
                
             System.debug('Check point 7 : '+Limits.getQueryRows());
             System.debug('Check point 7 : '+Limits.getDMLRows());
            }
        }
        else{
                    return false;                    
		}
        Savepoint sp= Database.setSavepoint();
        
        try{
            
        update priceItemstoUpdate; // Update all priceItems to 0
        update PriceListItems;// update all priceItems to SAP Prices
        }catch(Exception ex){
            System.debug('Customer Portal Pricing Exception '+ex.getMessage()+ ' '+ex.getLineNumber());
            Database.rollback(sp);
            return false;
        }
        return true;
            //checkDisplayorNotZeroPricing(PriceListItems);     
    }
    public string checkOtherNames(string unitFrom){
        CC_MyNexeo_Convertions__c cusSetconv=CC_MyNexeo_Convertions__c.getInstance(unitFrom);
        if(cusSetconv==null){            
            //System.debug('FGGB'+unitFrom);
            return unitFrom;            
        }else{
            //System.debug('FGGB unitName:'+unitFrom+' Same As: '+cusSetconv.Same_As__c);
            return cusSetconv.Same_As__c;                       
        }
        
        
    }
    public void checkDisplayorNotZeroPricing(List<ccrz__E_PriceListItem__c> PriceListItems){
      
        CC_SFDC_Settings__c cusSetting=CC_SFDC_Settings__c.getInstance('CPI_MyNexeo');
        if(cusSetting!=null){
            if(!cusSetting.Get_Products_Zero_Price__c){
             Date endDate = date.newInstance(1999,01,01);
            for(ccrz__E_PriceListItem__c pli:PriceListItems){                
                if(pli.ccrz__Price__c==0){
                    //System.debug('Hidding pricelistItem: '+pli.Id);
                    pli.ccrz__EndDate__c=endDate;
                    pli.ccrz__StartDate__c=endDate;
                }
            }
            update PriceListItems;
            }  }
        
        
    }
       public Decimal stringtodecimal(String sIn){
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
    return decimal.valueof(temp.trim());
  }
  else{ return null; }
}
    public Double stringtodouble(String sIn){
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
    Public Date stringtodate(string s){
  
  date d = null;
  try{
    d = Date.valueof(s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6)); 
  }catch(exception e){system.debug('***DATE CONVERT ERROR***: ' + s + ' ERROR: ' + e.getmessage());} 
  return d;
}
    public boolean notNullorVoid(string toEvaluate){
        if(toEvaluate==null || toEvaluate=='')
            return false;
            else
                return true;
    }
}