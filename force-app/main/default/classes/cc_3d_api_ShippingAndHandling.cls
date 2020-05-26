global class cc_3d_api_ShippingAndHandling extends ccrz.cc_api_ShippingAndHandling {

    private static final Integer API_VERSION = 3;
    public static final String CART_ITEMS_KEY = 'ECartItemsS';
    public static final String PRODUCT_KEY = 'product';
    public static final String SFID_KEY = 'sfid';
    public static final String PRODUCT_ITEM_KEY = 'productItem';
    public static final String QUANTITY_KEY = 'quantity';
    public static final String PRODUCT_WEIGHT_KEY = 'productWeight';

    public static final String US_COUNTRY_CODE = 'US';
    public static final String PR_COUNTRY_CODE = 'PR';
    public static final String ES_COUNTRY_CODE = 'ES';

    public static final String AK_STATE_CODE = 'AK';
    public static final String HI_STATE_CODE = 'HI';

    public static final String STANDARD_SHIPPING_OPTION = 'Standard';
    public static final String STANDARD_SHIPPING_OPTION_VALUE = 'Standard (default)';
    public static final String TWODAY_SHIPPING_OPTION = '2-Day';
    public static final String TWODAY_SHIPPING_OPTION_VALUE = '2-Day';
    public static final String OVERNIGHT_SHIPPING_OPTION = 'Overnight';
    public static final String OVERNIGHT_SHIPPING_OPTION_VALUE = 'Standard Overnight';

    public static final String FEDEX_LABEL = 'FedEx';

    public static final Decimal KGM_TO_LBS = 2.20462262185;

    global override List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName) {
        
        List<ccrz.cc_ctrl_hlpr_ShippingOption> shipOptionsList = new List<ccrz.cc_ctrl_hlpr_ShippingOption>();

        Map<String, Object> cart = getCart(cartId);
        if (cart != null) {
            try {
                Decimal cartWeight = calculateCartWeight(cart)/1000;

                if (countryCode == US_COUNTRY_CODE || countryCode == PR_COUNTRY_CODE) {
                    Decimal cartWeightPounds = cartWeight * KGM_TO_LBS;
                    List<cc_3d_Zone_Shipping_Rule__c> rules = getZoneShippingRules(cartWeightPounds);
                    Map<String, ccrz.cc_ctrl_hlpr_ShippingOption> optionMap = new Map<String, ccrz.cc_ctrl_hlpr_ShippingOption>();
                    if (rules != null) {
                        Integer zone = getZipCodeZone(zipCode);
                        for (cc_3d_Zone_Shipping_Rule__c r : rules) {
                            if (r.Shipping_Option__c == STANDARD_SHIPPING_OPTION) {
                                Decimal cost = 0;
                                if (countryCode == PR_COUNTRY_CODE) {
                                    cost = r.PR_Cost__c;
                                }
                                else if (stateCode == AK_STATE_CODE) {
                                    cost = r.AK_Cost__c;
                                }
                                else if (stateCode == HI_STATE_CODE) {
                                    cost = r.HI_Cost__c;
                                }
                                if (cost != null) {
                                    ccrz.cc_ctrl_hlpr_ShippingOption o = new ccrz.cc_ctrl_hlpr_ShippingOption(FEDEX_LABEL, STANDARD_SHIPPING_OPTION_VALUE, cost);
                                    optionMap.put(STANDARD_SHIPPING_OPTION, o);
                                }
                            }
                            else if (r.Shipping_Option__c == TWODAY_SHIPPING_OPTION) {
                                if (zone != null) {
                                    Decimal cost = getCostForZone(zone, r);
                                    if (cost != null) {
                                        ccrz.cc_ctrl_hlpr_ShippingOption o = new ccrz.cc_ctrl_hlpr_ShippingOption(FEDEX_LABEL, TWODAY_SHIPPING_OPTION_VALUE, cost);
                                        optionMap.put(TWODAY_SHIPPING_OPTION, o);
                                    }
                                }
                            }
                            else if (r.Shipping_Option__c == OVERNIGHT_SHIPPING_OPTION) {
                                if (zone != null) {
                                    Decimal cost = getCostForZone(zone, r);
                                    if (cost != null) {
                                        ccrz.cc_ctrl_hlpr_ShippingOption o = new ccrz.cc_ctrl_hlpr_ShippingOption(FEDEX_LABEL, OVERNIGHT_SHIPPING_OPTION_VALUE, cost);
                                        optionMap.put(OVERNIGHT_SHIPPING_OPTION, o);
                                    }
                                }
                            }
                        }
                        ccrz.cc_ctrl_hlpr_ShippingOption o = optionMap.get(STANDARD_SHIPPING_OPTION);
                        if (o != null) {
                            shipOptionsList.add(o);
                        }
                        o = optionMap.get(TWODAY_SHIPPING_OPTION);
                        if (o != null) {
                            shipOptionsList.add(o);
                        }
                        o = optionMap.get(OVERNIGHT_SHIPPING_OPTION);
                        if (o != null) {
                            shipOptionsList.add(o);
                        }
                    }
                }
                else if (countryCode == ES_COUNTRY_CODE) {
                    List<cc_3d_Shipping_Rule__c> rules = getShippingRules(countryCode, cartWeight);
                    if (rules != null) {
                        cc_3d_Shipping_Rule__c rule = findRuleForZip(zipCode, rules);
                        if (rule != null) {
                            ccrz.cc_ctrl_hlpr_ShippingOption o = new ccrz.cc_ctrl_hlpr_ShippingOption(rule.Shipping_Company_Name__c, rule.Delivery_Type__c, rule.Shipping_Cost__c);
                            shipOptionsList.add(o);
                        }
                    }
                }
                else {
                    List<cc_3d_Shipping_Rule__c> rules = getShippingRules(countryCode, cartWeight);
                    if (rules != null) {
                        Integer count = 1;
                        for (cc_3d_Shipping_Rule__c rule : rules) {
                            ccrz.cc_ctrl_hlpr_ShippingOption o = new ccrz.cc_ctrl_hlpr_ShippingOption(rule.Shipping_Company_Name__c,  rule.Delivery_Type__c, rule.Shipping_Cost__c);
                            shipOptionsList.add(o);
                            count++;
                        }
                    }
                }
            }
            catch (Exception e) {
                System.debug(System.LoggingLevel.ERROR, e.getMessage());
            }
        }
        return shipOptionsList;
    }

    private List<cc_3d_Shipping_Rule__c> getShippingRules(String countryCode, Decimal weight) {
        List<cc_3d_Shipping_Rule__c> rules = [
            SELECT 
                Id, Country_Code__c, Delivery_Type__c, Postal_Code_From__c, Postal_Code_To__c, Shipping_Cost__c, Weight_From__c, Weight_To__c, Shipping_Company_Name__c
            FROM 
                cc_3d_Shipping_Rule__c
            WHERE 
                Country_Code__c = :countryCode AND
                Weight_From__c <= :weight AND Weight_To__c >= :weight
        ];
        return rules;
    }

    private Integer getZipCodeZone(String zipCode) {
        Integer zone = null;
        if (zipCode != null && zipCode.length() > 4) {
            String zipCodePrefix = zipCode.substring(0,3);
            List<cc_3d_Zip_Code_Zone__c> zones = [
                SELECT 
                    Id, Zip_Code__c, Zone__c
                FROM 
                    cc_3d_Zip_Code_Zone__c
                WHERE 
                    Zip_Code__c = :zipCode OR
                    Zip_Code__c = :zipCodePrefix
            ];
            if (zones != null && zones.size() == 1 && zones[0].Zone__c != null) {
                zone = zones[0].Zone__c.intValue();
            }
        }
        return zone;
    }

    private List<cc_3d_Zone_Shipping_Rule__c> getZoneShippingRules(Decimal weight) {
        Decimal roundedWeight = weight.round(System.RoundingMode.CEILING);

        List<cc_3d_Zone_Shipping_Rule__c> rules = [
            SELECT 
                Id, Shipping_Option__c, Weight__c, AK_Cost__c, HI_Cost__c, PR_Cost__c, Zone_2_Cost__c, Zone_3_Cost__c, Zone_4_Cost__c, Zone_5_Cost__c, Zone_6_Cost__c, Zone_7_Cost__c, Zone_8_Cost__c, Zone_9_Cost__c, Zone_10_Cost__c, Zone_11_Cost__c, Zone_12_Cost__c, Zone_13_Cost__c, Zone_14_Cost__c, Zone_15_Cost__c, Zone_16_Cost__c
            FROM 
                cc_3d_Zone_Shipping_Rule__c
            WHERE 
                Weight__c = :roundedWeight
        ];
        return rules;
    }

    public Decimal getCostForZone(Integer zone, cc_3d_Zone_Shipping_Rule__c rule) {
        Decimal cost = null;
        if (zone == 2) {
            cost = rule.Zone_2_Cost__c;
        }
        else if (zone == 3) {
            cost = rule.Zone_3_Cost__c;
        }
        else if (zone == 4) {
            cost = rule.Zone_4_Cost__c;
        }
        else if (zone == 5) {
            cost = rule.Zone_5_Cost__c;
        }
        else if (zone == 6) {
            cost = rule.Zone_6_Cost__c;
        }
        else if (zone == 7) {
            cost = rule.Zone_7_Cost__c;
        }
        else if (zone == 8) {
            cost = rule.Zone_8_Cost__c;
        }
        else if (zone == 9) {
            cost = rule.Zone_9_Cost__c;
        }
        else if (zone == 10) {
            cost = rule.Zone_10_Cost__c;
        }
        else if (zone == 11) {
            cost = rule.Zone_11_Cost__c;
        }
        else if (zone == 12) {
            cost = rule.Zone_12_Cost__c;
        }
        else if (zone == 13) {
            cost = rule.Zone_13_Cost__c;
        }
        else if (zone == 14) {
            cost = rule.Zone_14_Cost__c;
        }
        else if (zone == 15) {
            cost = rule.Zone_15_Cost__c;
        }
        else if (zone == 16) {
            cost = rule.Zone_16_Cost__c;
        }
        return cost;
    }

    public Map<String, Object> getCart(String theId) {
        Map<String, Object> data = null;

        Map<String, Object> request = new Map<String,Object>{
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                }       
            },
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION, 
            ccrz.ccAPICart.CART_ID => theId
        };
  
        Map<String,Object> response = null;
  
        try {
            response = ccrz.ccAPICart.fetch(request);
            Boolean isSuccess = (Boolean) response.get(ccrz.ccAPI.SUCCESS);
            if (isSuccess) {
                List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) response.get(ccrz.ccAPICart.CART_OBJLIST);
                if (outputCartList != null && !outputCartList.isEmpty()) {
                    data = outputCartList[0];
                    List<Map<String, Object>> productList = (List<Map<String, Object>>) response.get(ccrz.ccAPIProduct.PRODUCTLIST);

                    if (productList != null && !productList.isEmpty()) {
                        addProductToCart(data, productList);
                    }
                }
            }
        }
        catch(Exception e) 
        {
             System.debug(System.LoggingLevel.ERROR, e.getMessage());
            throw new ShippingException('Could not determine shipping options.'+e.getMessage()+e.getCause()+e.getLineNumber());
        }
        return data;
    }

    private void addProductToCart(Map<String, Object> cart, List<Map<String, Object>> productList) {
        Map<String, Map<String, Object>> productMap = new Map<String, Map<String, Object>>();
        for (Map<String, Object> m : productList) {
            String key = (String) m.get(SFID_KEY);
            productMap.put(key, m);
        }
        List<Map<String, Object>> items = (List<Map<String, Object>>) cart.get(CART_ITEMS_KEY);

            for (Map<String, Object> item : items) {
            String key = (String) item.get(PRODUCT_KEY);
            Map<String, Object> productItem = productMap.get(key);
            item.put(PRODUCT_ITEM_KEY, productItem);
        }  
    }

    private Decimal calculateCartWeight(Map<String, Object> data) {
        Decimal weight = 0;
        List<Map<String, Object>> items = (List<Map<String, Object>>) data.get(CART_ITEMS_KEY);
        for (Map<String, Object> item : items) {
            Map<String, Object> productItem = (Map<String, Object>) item.get(PRODUCT_ITEM_KEY);
            Decimal productWeight = (Decimal) productItem.get(PRODUCT_WEIGHT_KEY);
            Decimal productQuantity = (Decimal) item.get(QUANTITY_KEY);
            weight += productWeight*productQuantity;
        }
        return weight;
    }

    private cc_3d_Shipping_Rule__c findRuleForZip(String zipCode, List<cc_3d_Shipping_Rule__c> rules) {
        Integer zip = Integer.valueOf(zipCode);
        cc_3d_Shipping_Rule__c rule = null;
        for (cc_3d_Shipping_Rule__c r : rules) {
            Integer toZip = Integer.valueOf(r.Postal_Code_To__c);
            Integer fromZip = Integer.valueOf(r.Postal_Code_From__c);
            if (zip >= fromZip &&  zip  <= toZip) {
                rule = r;
                break;
            }
        }
        return rule;
    }

    public class ShippingException extends Exception {}

}