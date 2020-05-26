public with sharing class cc_imp_hlpr_PriceListHelper {

    // Queries the AccountGroupPriceLists and orders them in ascending order.
    public static List<ccrz__E_AccountGroupPriceList__c> queryAccountGroupPriceListsByAccount(Id accountGroupId, String currencyCode){
        List<ccrz__E_AccountGroupPriceList__c> agpList = [
            SELECT
                Id
                , ccrz__Sequence__c
                , ccrz__PriceList__c
            FROM
                ccrz__E_AccountGroupPriceList__c
            WHERE
                ccrz__AccountGroup__c = :accountGroupId AND
                ccrz__PriceList__r.ccrz__CurrencyISOCode__c = :currencyCode
            ORDER BY
                ccrz__Sequence__c
        ];

        System.debug('queryAccountGroupPriceListsByAccount: ' + JSON.serializePretty(agpList));
        return agpList;
    }
  public static List<ccrz__E_PriceListItem__c> queryPriceListItemsByProductAndPriceListES(List<Id> productIds, List<Id> priceListIds){
//This Method was created to remove the conditions on the query only for ES customers. FGG.03/21/2018
        System.debug('queryPriceListItemsByProductAndPriceList productIds: ' + JSON.serializePretty(productIds));
        System.debug('queryPriceListItemsByProductAndPriceList priceListIds: ' + JSON.serializePretty(priceListIds));
        Date theDay = Date.today();
        List<ccrz__E_PriceListItem__c> items = [
            SELECT
                Id
                , ccrz__PriceList__c
                , ccrz__Product__c
                , PriceUoM__c
                , volumeUom__c
                , ccrz__UnitOfMeasure__c
                , ccrz__Price__c
                , ccrz__MinQty__c
                , CPI__c
                , CPI_Plant__c
                , CPI_Freight_Terms__c
                , CPI__r.Material_Number__c
                , CPI__r.Customer_Material_Number__c
                , CPI__r.Material_Description__c
                , ccrz__Product__r.Product_Number__c
                , Currency_ISO_Code__c
                , Price_with_Currency__c
            	,Material_Container_Abbreviation__c
            FROM
                ccrz__E_PriceListItem__c
            WHERE
                ccrz__Product__c in :productIds
            AND
                ccrz__PriceList__c in :priceListIds
        ];
        System.debug('queryPriceListItemsByProductAndPriceList: ' + JSON.serializePretty(items));
        return items;
    }
    public static List<ccrz__E_PriceListItem__c> queryPriceListItemsByProductAndPriceList(List<Id> productIds, List<Id> priceListIds){

        System.debug('queryPriceListItemsByProductAndPriceList productIds: ' + JSON.serializePretty(productIds));
        System.debug('queryPriceListItemsByProductAndPriceList priceListIds: ' + JSON.serializePretty(priceListIds));
        Date theDay = Date.today();
        List<ccrz__E_PriceListItem__c> items = [
            SELECT
                Id
                , ccrz__PriceList__c
                , ccrz__Product__c
                , PriceUoM__c
                , volumeUom__c
                , ccrz__UnitOfMeasure__c
                , ccrz__Price__c
                , ccrz__MinQty__c
                , CPI__c
                , CPI_Plant__c
                , CPI_Freight_Terms__c
                , CPI__r.Material_Number__c
                , CPI__r.Customer_Material_Number__c
                , CPI__r.Material_Description__c
                , ccrz__Product__r.Product_Number__c
                , Currency_ISO_Code__c
                , Price_with_Currency__c
            	,Material_Container_Abbreviation__c  
            	,Container_Weight__c
            FROM
                ccrz__E_PriceListItem__c
            WHERE
                ccrz__Product__c in :productIds
            AND
                ccrz__PriceList__c in :priceListIds
            AND
                ccrz__StartDate__c <= :theDay
            AND
                ccrz__EndDate__c >= :theDay
            AND
                ccrz__Product__r.ccrz__StartDate__c <= :theDay
            AND
                ccrz__Product__r.ccrz__EndDate__c >= :theDay
            AND
                ccrz__Product__r.ccrz__ProductStatus__c in ('Released','Not Orderable')

        ];
        System.debug('queryPriceListItemsByProductAndPriceList: ' + JSON.serializePretty(items));
        return items;
    }

    public static ccrz__E_PriceListItem__c findPriceListItemByPriceListSequence(Id productId, List<Map<Id,ccrz__E_PriceListItem__c>> priceLists){
        ccrz__E_PriceListItem__c price = null;
        for(Map<Id, ccrz__E_PriceListItem__c> pliMap :priceLists){
            ccrz__E_PriceListItem__c pli = pliMap.get(productId);
            if(pli != null && pli.ccrz__Price__c != null){
                price = pli;
                break;
            }
        }

        System.debug('findPriceListItemBySequence: ' + productId);
        System.debug('findPriceListItemBySequence: ' + JSON.serializePretty(priceLists));
        System.debug('findPriceListItemBySequence: ' + JSON.serializePretty(price));
        return price;
    }
 public static Map<Id, ccrz__E_PriceListItem__c> getPriceListItemsBySequenceES(List<Id> productIdList) {

        Id accountGroupId;
        try { 
            accountGroupId = ccrz.cc_CallContext.effAccountGroup.Id;
        }
        catch(Exception e){
            // no-op OK.  Try currAccountGroup.Id instead
        }
        if (accountGroupId == null) {
            try {
            accountGroupId = ccrz.cc_CallContext.currAccountGroup.Id;
            }
            catch(Exception e){
            }
        }
        List<ccrz__E_AccountGroupPriceList__c> accountGroupPriceLists = queryAccountGroupPriceListsByAccount(accountGroupId, ccrz.cc_CallContext.userCurrency);

        List<Map<Id, ccrz__E_PriceListItem__c>> priceListProductsBySequence = new List<Map<Id, ccrz__E_PriceListItem__c>>();
        Map<Id, Map<Id, ccrz__E_PriceListItem__c>> priceListToProductMap = new Map<Id, Map<Id, ccrz__E_PriceListItem__c>>();

        for (ccrz__E_AccountGroupPriceList__c agpl :accountGroupPriceLists){
            Map<Id, ccrz__E_PriceListItem__c> productToPliMap = new Map<Id, ccrz__E_PriceListItem__c>();
            priceListProductsBySequence.add(productToPliMap);
            priceListToProductMap.put(agpl.ccrz__PriceList__c, productToPliMap);
        }

        List<ccrz__E_PriceListItem__c> priceListItems = queryPriceListItemsByProductAndPriceListES(productIdList, new List<Id>(priceListToProductMap.keySet()));


        // Put the price list items in the priceListToProductMap
        for(ccrz__E_PriceListItem__c pli :priceListItems){
            // Get the priceListToProductMap for the price list item
            Map<Id, ccrz__E_PriceListItem__c> theMap = priceListToProductMap.get(pli.ccrz__PriceList__c);

            // Put the pli into the priceListToProductMap
            theMap.put(pli.ccrz__Product__c, pli);
        }

        // product id => selected price list item
        Map<Id, ccrz__E_PriceListItem__c> selectedPricingMap = new Map<Id, ccrz__E_PriceListItem__c>();
        for(ccrz__E_PriceListItem__c pli :priceListItems){
            selectedPricingMap.put(pli.ccrz__Product__c, findPriceListItemByPriceListSequence(pli.ccrz__Product__c, priceListProductsBySequence));
        }

        return selectedPricingMap;

    }

    public static Map<Id, ccrz__E_PriceListItem__c> getPriceListItemsBySequence(List<Id> productIdList) {

        Id accountGroupId;
        try { 
            accountGroupId = ccrz.cc_CallContext.effAccountGroup.Id;
        }
        catch(Exception e){
            // no-op OK.  Try currAccountGroup.Id instead
        }
        if (accountGroupId == null) {
            try {
            accountGroupId = ccrz.cc_CallContext.currAccountGroup.Id;
            }
            catch(Exception e){
            }
        }
        List<ccrz__E_AccountGroupPriceList__c> accountGroupPriceLists = queryAccountGroupPriceListsByAccount(accountGroupId, ccrz.cc_CallContext.userCurrency);

        List<Map<Id, ccrz__E_PriceListItem__c>> priceListProductsBySequence = new List<Map<Id, ccrz__E_PriceListItem__c>>();
        Map<Id, Map<Id, ccrz__E_PriceListItem__c>> priceListToProductMap = new Map<Id, Map<Id, ccrz__E_PriceListItem__c>>();

        for (ccrz__E_AccountGroupPriceList__c agpl :accountGroupPriceLists){
            Map<Id, ccrz__E_PriceListItem__c> productToPliMap = new Map<Id, ccrz__E_PriceListItem__c>();
            priceListProductsBySequence.add(productToPliMap);
            priceListToProductMap.put(agpl.ccrz__PriceList__c, productToPliMap);
        }

        List<ccrz__E_PriceListItem__c> priceListItems = queryPriceListItemsByProductAndPriceList(productIdList, new List<Id>(priceListToProductMap.keySet()));


        // Put the price list items in the priceListToProductMap
        for(ccrz__E_PriceListItem__c pli :priceListItems){
            // Get the priceListToProductMap for the price list item
            Map<Id, ccrz__E_PriceListItem__c> theMap = priceListToProductMap.get(pli.ccrz__PriceList__c);

            // Put the pli into the priceListToProductMap
            theMap.put(pli.ccrz__Product__c, pli);
        }

        // product id => selected price list item
        Map<Id, ccrz__E_PriceListItem__c> selectedPricingMap = new Map<Id, ccrz__E_PriceListItem__c>();
        for(ccrz__E_PriceListItem__c pli :priceListItems){
            selectedPricingMap.put(pli.ccrz__Product__c, findPriceListItemByPriceListSequence(pli.ccrz__Product__c, priceListProductsBySequence));
        }

        return selectedPricingMap;

    }

    public static List<PriceListItemTier> getPriceListItemTier(Id priceListItemId) {
        List<PriceListItemTier> tiers = new List<PriceListItemTier>();
        List<ccrz__E_RuleTargetPLI__c> pliRules = [SELECT ccrz__E_Rule__c, ccrz__E_Rule__r.Name, ccrz__E_Rule__r.ccrz__RuleType__c FROM ccrz__E_RuleTargetPLI__c WHERE ccrz__E_PriceListItem__c = :priceListItemId];

        if (pliRules != null && !pliRules.isEmpty()) {
        
            List<ccrz__E_RulePricingModifier__c> rpms = [SELECT ccrz__PriceModifier__r.ccrz__Amount__c, ccrz__PriceModifier__r.ccrz__Quantity__c, ccrz__PriceModifier__r.ccrz__DiscountType__c, ccrz__PriceModifier__r.Base_Price__c, ccrz__PriceModifier__r.Base_Price_UOM__c,ccrz__PriceModifier__r.Amount_UOM__c,ccrz__PriceModifier__r.Quantity_UOM__c  FROM ccrz__E_RulePricingModifier__c WHERE ccrz__Rule__c = :pliRules[0].ccrz__E_Rule__c];
            for (ccrz__E_RulePricingModifier__c rpm : rpms) {
                PriceListItemTier tier = new PriceListItemTier();
                String quantity = rpm.ccrz__PriceModifier__r.Quantity_UOM__c;
                if (quantity != null) {
                    //tier.lowerBound = quantity.setScale(0).format();
                    tier.lowerBound = quantity;
                }
                tier.valueType = rpm.ccrz__PriceModifier__r.ccrz__DiscountType__c;
                tier.amount = rpm.ccrz__PriceModifier__r.Amount_UOM__c;
                tier.baseAmount = rpm.ccrz__PriceModifier__r.Base_Price_UOM__c;
                tiers.add(tier);
            }
        }
        
        return tiers;
    }
       public static List<PriceListItemTier> getPriceListItemTierFGG(Id priceListItemId) {
        List<PriceListItemTier> tiers = new List<PriceListItemTier>();
        List<ccrz__E_RuleTargetPLI__c> pliRules = [SELECT ccrz__E_Rule__c, ccrz__E_Rule__r.Name, ccrz__E_Rule__r.ccrz__RuleType__c FROM ccrz__E_RuleTargetPLI__c WHERE ccrz__E_PriceListItem__c = :priceListItemId];

        if (pliRules != null && !pliRules.isEmpty()) {
        
            List<ccrz__E_RulePricingModifier__c> rpms = [SELECT ccrz__PriceModifier__r.ccrz__Amount__c, ccrz__PriceModifier__r.ccrz__Quantity__c, ccrz__PriceModifier__r.ccrz__DiscountType__c, ccrz__PriceModifier__r.Base_Price__c, ccrz__PriceModifier__r.Base_Price_UOM__c,ccrz__PriceModifier__r.Amount_UOM__c,ccrz__PriceModifier__r.Quantity_UOM__c  FROM ccrz__E_RulePricingModifier__c WHERE ccrz__Rule__c = :pliRules[0].ccrz__E_Rule__c];
            for (ccrz__E_RulePricingModifier__c rpm : rpms) {
                PriceListItemTier tier = new PriceListItemTier();
                String quantity = String.valueOf(rpm.ccrz__PriceModifier__r.ccrz__Quantity__c);
                if (quantity != null) {
                    //tier.lowerBound = quantity.setScale(0).format();
                    tier.lowerBound = quantity;
                }
                tier.valueType = rpm.ccrz__PriceModifier__r.ccrz__DiscountType__c;
                tier.amount = rpm.ccrz__PriceModifier__r.Amount_UOM__c;
                tier.baseAmount = rpm.ccrz__PriceModifier__r.Base_Price_UOM__c;
                tiers.add(tier);
            }
        }
        
        return tiers;
    }
    
    // priceListItemId, Price Tier Item Tier
    public static Map<Id,  List<PriceListItemTier>> getPriceListItemTierBulk(List<Id> priceListItemsIds) {
        Map<Id,  List<PriceListItemTier>> tiers = new Map<Id,  List<PriceListItemTier>>();
        Map<Id, List<ccrz__E_RuleTargetPLI__c>> pliRules = new Map<Id, List<ccrz__E_RuleTargetPLI__c>>(); // Id = ccrz__E_PriceListItem__c
        Map<Id, Id> rulesIds = new Map<Id, Id>();// pliRule.ccrz__E_Rule__c, ccrz__E_PriceListItem__c
	
        for (ccrz__E_RuleTargetPLI__c pliRule:[SELECT ccrz__E_Rule__c, ccrz__E_Rule__r.Name, ccrz__E_Rule__r.ccrz__RuleType__c, ccrz__E_PriceListItem__r.ccrz__Product__c,
              ccrz__E_PriceListItem__c FROM ccrz__E_RuleTargetPLI__c WHERE ccrz__E_PriceListItem__c IN:priceListItemsIds ORDER BY CreatedDate DESC]) {
  
                  List<ccrz__E_RuleTargetPLI__c> rulesOfThisPli = pliRules.get(pliRule.ccrz__E_PriceListItem__c);
                  if(rulesOfThisPli == null) {
                      rulesOfThisPli = new List<ccrz__E_RuleTargetPLI__c>();
                  }
                  
                  if (rulesOfThisPli.isEmpty()) {
                      rulesOfThisPli.add(pliRule);
                      rulesIds.put(pliRule.ccrz__E_Rule__c, pliRule.ccrz__E_PriceListItem__r.ccrz__Product__c);
                      pliRules.put(pliRule.ccrz__E_PriceListItem__c, rulesOfThisPli);
                  }
         }

        if (!pliRules.isEmpty()) {
      
            List<ccrz__E_RulePricingModifier__c> rpms = [SELECT ccrz__PriceModifier__r.ccrz__Amount__c, ccrz__PriceModifier__r.ccrz__Quantity__c, 
                                                         ccrz__PriceModifier__r.ccrz__DiscountType__c, ccrz__PriceModifier__r.Base_Price__c, 
                                                         ccrz__PriceModifier__r.Base_Price_UOM__c,ccrz__PriceModifier__r.Amount_UOM__c,ccrz__PriceModifier__r.Quantity_UOM__c,
                                                         ccrz__Rule__c
                                                         FROM ccrz__E_RulePricingModifier__c WHERE ccrz__Rule__c IN: rulesIds.keySet() ];
            
            for (ccrz__E_RulePricingModifier__c rpm : rpms) {
                Id priceListItemId = rulesIds.get(rpm.ccrz__Rule__c);
                PriceListItemTier tier = new PriceListItemTier();
                String quantity = rpm.ccrz__PriceModifier__r.Quantity_UOM__c;
                if (quantity != null) {
                    //tier.lowerBound = quantity.setScale(0).format();
                    tier.lowerBound = quantity;
                }
                tier.valueType = rpm.ccrz__PriceModifier__r.ccrz__DiscountType__c;
                tier.amount = rpm.ccrz__PriceModifier__r.Amount_UOM__c;
                tier.baseAmount = rpm.ccrz__PriceModifier__r.Base_Price_UOM__c;
                List<PriceListItemTier> tiersByProduct = tiers.get(priceListItemId);
                  if(tiersByProduct == null) {
                      tiersByProduct = new List<PriceListItemTier>();
                }
                tiersByProduct.add(tier);    
                tiers.put(priceListItemId,tiersByProduct);
            }
        }
        
        return tiers;
    }    
    /*
  public static Map<Id,PriceListItemTier> getPriceListItemTierBulk(List<ccrz__E_PriceListItem__c> priceListItemId) {
        System.debug('FGGT income PricelistITems'+priceListItemId.size());
        List<ccrz__E_RuleTargetPLI__c> pliRules = [SELECT ccrz__E_Rule__c, ccrz__E_Rule__r.Name, ccrz__E_Rule__r.ccrz__RuleType__c,ccrz__E_PriceListItem__c FROM ccrz__E_RuleTargetPLI__c WHERE ccrz__E_PriceListItem__c in: priceListItemId];
        System.debug('FGGT pliRules '+pliRules.size()); 
      Map<Id,PriceListItemTier> returnMap=new Map<Id,PriceListItemTier>();
        if (pliRules != null && !pliRules.isEmpty()) {
       System.debug('FGGT ID rule '+pliRules[0].ccrz__E_Rule__c);
            List<ccrz__E_RulePricingModifier__c> rpms = [SELECT ccrz__EndDate__c,ccrz__PriceModifier__r.ccrz__Amount__c, ccrz__PriceModifier__r.ccrz__Quantity__c, ccrz__PriceModifier__r.ccrz__DiscountType__c, ccrz__PriceModifier__r.Base_Price__c, ccrz__PriceModifier__r.Base_Price_UOM__c,ccrz__Rule__c  FROM ccrz__E_RulePricingModifier__c WHERE ccrz__Rule__c = :pliRules[0].ccrz__E_Rule__c];
            System.debug('FGGT rpms '+rpms.size()); 
            for(ccrz__E_RuleTargetPLI__c pliRule : pliRules){
            List<PriceListItemTier> tiers = new List<PriceListItemTier>();
                for (ccrz__E_RulePricingModifier__c rpm : rpms) {
                    PriceListItemTier tier = new PriceListItemTier();
                    String quantity = String.valueOf(rpm.ccrz__PriceModifier__r.ccrz__Quantity__c);
                    if (quantity != null) {
                        //tier.lowerBound = quantity.setScale(0).format();
                        tier.lowerBound = quantity;
                    }
                    System.debug('FGGT amount '+rpm.ccrz__EndDate__c);
                    System.debug('FGGT amount '+rpm.ccrz__PriceModifier__r.ccrz__Amount__c);
                    System.debug('FGGT amount '+rpm.ccrz__PriceModifier__r.Base_Price_UOM__c);                    
                    tier.valueType = rpm.ccrz__PriceModifier__r.ccrz__DiscountType__c;
                    tier.amount = String.valueOf(rpm.ccrz__PriceModifier__r.ccrz__Amount__c);
                    tier.baseAmount = rpm.ccrz__PriceModifier__r.Base_Price_UOM__c;
                    tiers.add(tier);
                    returnMap.put(pliRule.ccrz__E_PriceListItem__c, tier);
                    tier=null;
                    System.debug('FGGT Tier Added '+pliRule.ccrz__E_PriceListItem__c +' Amount:'+rpm.ccrz__PriceModifier__r.ccrz__Amount__c+' baseAmount '+rpm.ccrz__PriceModifier__r.Base_Price_UOM__c+' Quantity');
                }
                //returnMap.put(pliRule.ccrz__E_PriceListItem__c, tiers);
            }
        }
        
        return returnMap;
    }*/
    public class PriceListItemTier {
        public String lowerBound {get; set;}
        public String valueType {get; set;} 
        public String amount {get; set;}
        public String baseAmount {get; set;}
    }

}