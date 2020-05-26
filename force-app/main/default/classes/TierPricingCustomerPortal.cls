/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/13/2016
*    Author:             Francisco Garcia
*   Last Modified:       Francisco Garcia
*   Last Modified By:    10/26/2018
*
*   Short Description:  Stored tier pricing in cc objects.  
*   **********************************************************************************************************************/

public class TierPricingCustomerPortal {
           public date endDate = date.newInstance(2099,01,01);
     public string createCCPriceModifierBulk(Map<id, List<CSP_JSON_Response.tbl_csp_prices>>  mapPLI, Map<ID, List<CSP_JSON_Response.tbl_sales_units>>  mapSalesUnits){
        System.debug('FGG Number received '+mapPLI.size());
        List<ccrz__E_PriceModifier__c> lstPriceModifier= new List<ccrz__E_PriceModifier__c>();
         Map<id, List<ccrz__E_PriceModifier__c>>  mapPLIwithPriceModifier= new Map<id, List<ccrz__E_PriceModifier__c>>();
         Map<id, String> mapSalesUOM= new Map<Id,String>();   
         
         List<ccrz__E_Rule__c> lstrules=new List<ccrz__E_Rule__c>();
         Map<Id,Id> mapProductIds=new Map<Id,Id>();
         Map<Id,String> mapContainer=new Map<Id,String>();
         Map<Id,String> mapDivisions=new Map<Id,String>();
          for(ccrz__E_PriceListItem__c pli:[select ccrz__Product__r.DivisionCode__c,Id,Name,CurrencyIsoCode,ccrz__Product__c,Material_Container_Abbreviation__c from ccrz__E_PriceListItem__c where Id in:mapPLI.keySet()]){
          mapProductIds.put(pli.Id,pli.ccrz__Product__c);
          mapContainer.put(pli.id,pli.Material_Container_Abbreviation__c);
          mapDivisions.put(pli.id,pli.ccrz__Product__r.DivisionCode__c);
         }  
          for(ccrz__E_Product__c products:[select Id,Sales_UoM__c,Material_Container_Abbreviation__c from ccrz__E_Product__c where Id in:mapProductIds.values()]){
          mapSalesUOM.put(products.id,products.Material_Container_Abbreviation__c);
         }  
         
         
         
         //Rule
         for(ccrz__E_PriceListItem__c pli:[select Id,Name,CurrencyIsoCode,ccrz__Product__c from ccrz__E_PriceListItem__c where Id in:mapPLI.keySet()]){
         ccrz__E_Rule__c rule=new ccrz__E_Rule__c();
            rule.ccrz__Enabled__c=true;
            rule.ccrz__StartDate__c=System.Date.today();
            rule.ccrz__EndDate__c=endDate;
            rule.ccrz__Name__c='PLI-'+pli.Name+'-tiered-pricing-rule';
            rule.ccrz__CurrencyISOCode__c=pli.CurrencyIsoCode;
            rule.ccrz__RuleSource__c='Pricing';
            rule.ccrz__RuleType__c='Tiered';
            rule.ccrz_pricelistitem__c=pli.Id;
            lstrules.add(rule);
         }  
         System.debug('lstrules '+lstrules);
         insert lstrules;
         //priceModifiers  
         for(id plitem:mapPLI.keySet()){
                 List<CSP_JSON_Response.tbl_csp_prices> tblcspprices=new List<CSP_JSON_Response.tbl_csp_prices>();              
                 tblcspprices=mapPLI.get(plitem);    
                    
                 if(tblcspprices!=null){
                    System.debug('FGG inside IF');
                    for(CSP_JSON_Response.tbl_csp_prices cspPrices: tblcspprices){               
                        ccrz__E_PriceModifier__c priceMod=new ccrz__E_PriceModifier__c();
                        priceMod.ccrz__DiscountType__c='Price';                
                        Map<String, Double> conversionmap=new Map<String, Double>();   
                        conversionmap=Account_Material_Functions.getConversionMap(mapSalesUnits.get(plitem)); 
                        PricingCustomerPortal pcp=new PricingCustomerPortal();
                        string unitFrom=pcp.checkOtherNames(cspPrices.csp_uom);                       
						string unitTo=pcp.checkOtherNames(mapContainer.get(plitem));                                
                        Decimal price=Account_Material_Functions.ConvertUnits(conversionmap,stringtodouble(cspPrices.csp_price), unitFrom, unitTo, true);                                                                                              
                        //Decimal price=Account_Material_Functions.ConvertUnits(conversionmap,stringtodouble(cspPrices.csp_price), cspPrices.csp_uom, mapsalesuom.get(mapProductIds.get(plitem)), true);                           
                        //backup before convert quantity 
                        //
                          System.debug('FGGT: TierConvertUnits '+conversionmap+' iValue'+stringtodouble(cspPrices.csp_price)+' UnitFrom '+unitFrom+' UnitTo '+UnitTo);
                          /*      
                        if(unitFrom!=unitTo){
                        Decimal tvol=Account_Material_Functions.convertunits(conversionmap, stringtodouble(cspPrices.csp_volume), mapsalesuom.get(mapProductIds.get(plitem)),cspPrices.csp_uom, true );
                        if(tvol.setScale(0,RoundingMode.HALF_UP)==0){
                            priceMod.ccrz__Quantity__c=0;
                        }else{
                            priceMod.ccrz__Quantity__c=tvol.setScale(0,RoundingMode.HALF_UP);
                            }
                             System.debug('FGGV: TierConvertVolume '+conversionmap+' iValue'+stringtodouble(cspPrices.csp_volume)+' UnitFrom '+mapsalesuom.get(mapProductIds.get(plitem))+' UnitTo '+cspPrices.csp_uom);
                        }else{
                            
                            
                        priceMod.ccrz__Quantity__c=stringtodecimal(cspPrices.csp_volume);  
                        }*/
                       	//priceMod.ccrz__Quantity__c=stringtodecimal(cspPrices.csp_volume); 
                       	//
                       //Decimal tvol=Account_Material_Functions.ConvertUnits(conversionmap, stringtodouble(cspPrices.csp_volume), unitFrom,unitTo, false);
                       	Decimal tvol;
                        if(pcp.checkOtherNames(cspPrices.csp_scale_uom)!=unitTo){
                       		tvol=Account_Material_Functions.ConvertUnits(conversionmap,stringtodouble(cspPrices.csp_volume), unitFrom, unitTo, false);                               
                        }
                        else{
                            tvol=stringtodouble(cspPrices.csp_volume);
                        }
                        tvol=tvol.setScale(1);
                        priceMod.ccrz__Quantity__c=tvol.setScale(0,RoundingMode.UP);
                        //priceMod.Amount_UOM__c=cspPrices.csp_currency+' $ '+price.setScale(2, RoundingMode.HALF_UP) +' / '+unitTo;
                        if(mapDivisions.get(plitem)=='32'){
                            Decimal weight;
                             if(pcp.checkOtherNames(cspPrices.csp_scale_uom)!=unitTo){
                                weight=Account_Material_Functions.ConvertUnits(conversionmap,stringtodouble(String.valueOf(tvol.setScale(0,RoundingMode.UP))), unitTo, unitFrom, false);                                                                                             
                            }
                            else{
                                weight=stringtodouble(cspPrices.csp_volume);
                            }
                        //CHEMICALS                        
                        	priceMod.Amount_UOM__c=weight.setScale(0,RoundingMode.UP)+' '+cspPrices.csp_scale_uom;                        
                        }else{
                            //Other DIvisions
                            Decimal weight;
                             if(pcp.checkOtherNames(cspPrices.csp_uom)!=unitTo){
                                weight=Account_Material_Functions.ConvertUnits(conversionmap,stringtodouble(cspPrices.csp_volume), unitTo, unitFrom, false);                                                                                             
                            }
                            else{
                                weight=stringtodouble(cspPrices.csp_volume);
                            }
                            
                            
                            
                            
                        	priceMod.Amount_UOM__c=weight.setScale(0,RoundingMode.UP)+' '+cspPrices.csp_uom;                                
                        }
                        //priceMod.Quantity_UOM__c=cspPrices.csp_volume+' '+unitTo;
                        priceMod.Quantity_UOM__c=tvol.setScale(0,RoundingMode.UP)+' '+unitTo;
                        //pli.ccrz__Price__c=stringtodecimal(cspPrices.csp_price);
                        //pli.ccrz__Price__c=price.setScale(2, RoundingMode.HALF_UP);
                        priceMod.ccrz__Amount__c=price;
                        priceMod.Base_Price__c=stringtodecimal(cspPrices.csp_price);    
                        priceMod.Base_Price_UOM__c=cspPrices.csp_currency+' $'+cspPrices.csp_price+ '/ '+cspPrices.csp_uom;    
                        //priceMod.Base_Price_UOM__c=cspPrices.csp_volume+' '+cspPrices.csp_uom;
                        //priceMod.ccrz__Amount__c=stringtodecimal(cspPrices.csp_price);
                        priceMod.ccrz_PriceListItem__c=plitem;
                        lstPriceModifier.add(priceMod);
                    }
                                      
                }
             else{
                 System.debug('FGG tblcspprices empty '+plitem);
                 
                 
             }
         }
         system.debug('lstPriceModifier '+lstPriceModifier);
         insert lstPriceModifier;
         
            List<ccrz__E_RulePricingModifier__c> listrulePM= new List<ccrz__E_RulePricingModifier__c>();
         for(ccrz__E_PriceModifier__c pm:lstPriceModifier){
            ccrz__E_RulePricingModifier__c rpm= new ccrz__E_RulePricingModifier__c();
            rpm.ccrz__EndDate__c=endDate;
            rpm.ccrz__StartDate__c=System.Date.today();
             for(ccrz__E_Rule__c rule:lstrules){
                 if(pm.ccrz_PriceListItem__c==rule.ccrz_pricelistitem__c){
                    rpm.ccrz__Rule__c=rule.Id;   
                 }
             }
            rpm.ccrz__PriceModifier__c=pm.Id;
            listrulePM.add(rpm);  
         }
         system.debug('listrulePM '+listrulePM);
         insert listrulePM;
         system.debug('FGG map Size mapPLIwithPriceModifier '+mapPLIwithPriceModifier.size());
          
         List<ccrz__E_RuleTargetPLI__c> lsttargetPLI=new List<ccrz__E_RuleTargetPLI__c>();
            
         for(ccrz__E_Rule__c rule:lstrules){
            ccrz__E_RuleTargetPLI__c ruletpli=new ccrz__E_RuleTargetPLI__c();
            ruletpli.ccrz__E_Rule__c=rule.Id;
            ruletpli.ccrz__E_PriceListItem__c=rule.ccrz_pricelistitem__c;
            lsttargetPLI.add(ruletpli);
         }
             insert lsttargetPLI;             
        
         
        return '';
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
   /*
    public string createCCPriceModifier(List<CSP_JSON_Response.tbl_csp_prices> listcspPrices, ccrz__E_PriceListItem__c pli){
        List<ccrz__E_PriceModifier__c> lstPriceModifier= new List<ccrz__E_PriceModifier__c>();
        if(listcspPrices.size()>0){
            for(CSP_JSON_Response.tbl_csp_prices cspPrices: listcspPrices){               
                ccrz__E_PriceModifier__c priceMod=new ccrz__E_PriceModifier__c();
                priceMod.ccrz__DiscountType__c='Price';                
                priceMod.ccrz__Quantity__c=stringtodecimal(cspPrices.csp_volume);  
                priceMod.ccrz__Amount__c=stringtodecimal(cspPrices.csp_price);
                
                lstPriceModifier.add(priceMod);
            }

            ccrz__E_Rule__c rule=new ccrz__E_Rule__c();
            rule.ccrz__Enabled__c=true;
            rule.ccrz__StartDate__c=System.Date.today();
            rule.ccrz__EndDate__c=endDate;
            rule.ccrz__Name__c='PLI-Tiered-Pricing';
            rule.ccrz__CurrencyISOCode__c=pli.CurrencyIsoCode;
            rule.ccrz__RuleSource__c='Pricing';
            rule.ccrz__RuleType__c='Tiered';
            insert rule;
            ccrz__E_RuleTargetPLI__c ruletpli=new ccrz__E_RuleTargetPLI__c();
            ruletpli.ccrz__E_Rule__c=rule.Id;
            ruletpli.ccrz__E_PriceListItem__c=pli.Id;
            insert ruletpli;
            insert lstPriceModifier;  
            System.debug('FGG ruleid:'+rule.Name);
            createJunctionRulePricingModifier(lstPriceModifier,rule);
        }      
        return '';
    }
    public void createJunctionRulePricingModifier(List<ccrz__E_PriceModifier__c> lstPriceModifier, ccrz__E_Rule__c rule){
        System.debug('FGG RuleID '+rule.Id+' ruleName '+rule.Name);
         List<ccrz__E_Rule__c> rules=[select name from ccrz__E_Rule__c where id=:rule.Id];           
          List<ccrz__E_PriceModifier__c> priceModifier=[select name from ccrz__E_PriceModifier__c where id in:lstPriceModifier];
        
        List<ccrz__E_RulePricingModifier__c> listrulePM= new List<ccrz__E_RulePricingModifier__c>();
        for(ccrz__E_PriceModifier__c pm:priceModifier){
            ccrz__E_RulePricingModifier__c rpm= new ccrz__E_RulePricingModifier__c();
            rpm.ccrz__EndDate__c=endDate;
            rpm.ccrz__StartDate__c=System.Date.today();
            rpm.ccrz__Rule__c=rules[0].id;
            rpm.ccrz__PriceModifier__c=pm.Id;
            listrulePM.add(rpm);
            
        }
        insert listrulePM;
        
    }
*/
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
}