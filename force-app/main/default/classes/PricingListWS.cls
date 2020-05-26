/**
 * Class: PricingListWS
 * Description: API to fetch the pricing list by Conexiom
 * Author: Namrata Varma
 * */

@RestResource(urlMapping='/api/Account/*')
global with sharing class PricingListWS {
    @HttpPost
    global static String doPost() 
    {
        string mockResponse = '[{"business_line": "", "sold_to": "0000127771", "ship_to": "0000127771", "material_nbr": "000000000000069917", "lbs_unit": "", "sales_unit": "DR", "price_date": "11/19/2012", "return_type": "S", "return_message": "Price generated successfully", "sfdc_account_id": "001E000000CTuUXIA1", "sfdc_material_id": "a56c0000000Ce3fAAC", "last_changed": "21.11.2012", "last_changed_tim": "02:19:02", "avg_order_qty": "0.000 ", "avg_order_unit": "", "tbl_sales_units": [{"material_nbr": "000000000000069917", "sales_unit": "DR", "numerator": "17917 ", "denominator": "100 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "GLL", "numerator": "3270 ", "denominator": "1000 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "KG", "numerator": "1 ", "denominator": "1 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "LB", "numerator": "32523 ", "denominator": "71701 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "PAL", "numerator": "71668 ", "denominator": "100 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "RCU", "numerator": "17917 ", "denominator": "100 ", "base_unit": "KG"}], "tbl_csp_prices": [{"csp_tier": "1 ", "csp_price": "6.7100 ", "csp_volume": "1", "csp_price_unit": "1 ", "csp_uom": "GLL", "csp_currency": "USD", "csp_effective_date": "20121001", "csp_expiration_date": "99991231", "csp_price_protection_code": "Z5", "csp_price_protection_desc": "Qtrly - 1st of Qtr", "csp_drum_deposit_code": "", "csp_scale_uom": "DR", "csp_condition_nbr": "0035036317", "csp_sfdc_pricereq_nbr": "", "csp_tpi": ""}], "tbl_target_prices": [{"target_tier": "1 ", "tier_volume": "1.000 ", "target_price": "0.8900 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.8722", "exception2_price": "0.8544", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}, {"target_tier": "2 ", "tier_volume": "4.000 ", "target_price": "0.8600 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.8428", "exception2_price": "0.8256", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}, {"target_tier": "3 ", "tier_volume": "10.000 ", "target_price": "0.8400 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.8232", "exception2_price": "0.8064", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}, {"target_tier": "4 ", "tier_volume": "40.000 ", "target_price": "0.8100 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.7938", "exception2_price": "0.7776", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}]}]';
        string s = '';
        try{
            RestRequest req = RestContext.request;
            String requri = req.requestURI;
            requri = requri.substringAfter('Account/');
            System.debug('requri substring: '+ requri);
            List<String> requriParts = requri.split('/');
            System.debug('test parts:: '+ requriParts);
            List<Id> accIds = new List<Id>();
            
            if(requriParts.size()==3){
                String accNumber = requriParts[0];
                String materialCode = requriParts[1];
                String salesOrg = requriParts[2];
                
                Account result = [SELECT Id FROM Account WHERE AccountNumber = :accNumber and SAP_Sales_Org__c=:salesOrg];
                System.debug('result: '+result);
                
                accIds.add(result.Id);
                
                Map<Id, Account> accountMap = new Map<Id, Account>([select id from Account where SAP_Sold_To_Account_Id__c =: result.Id]);
                System.debug('accountMap: '+accountMap);
                accIds.addAll(accountMap.keySet());
                
                List<CSP_JSON_Request_Item> SAP_Requests = new List<CSP_JSON_Request_Item>();
                
                List<Account_Material__c> aids = [select id from Account_material__c where (NOT Account__r.name LIKE '%DO NOT%') AND Account__r.Inactive_Account__c != true  and (Account_Sold_To_Id_Ext__c =:result.Id  or Account__c IN :accIds)  and hidden__c = false and (created_from_cpi__c = null OR created_from_Cpi__r.deletion_indicator__c != 'X') order by Account__r.name, SAP_Material__r.name];
                System.debug('aids: '+aids);
                
                Map<Id, Account_material__c> ammap = new Map<Id, Account_Material__c>([select id, iDisplayIndex__c, SAP_Data_Refreshed__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Material__r.material_number__c,
                                                                                       Account__r.SAP_Sold_To_Account__c, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, created_from_cpi__C, Account__r.accountnumber, Account__r.id,Freight_Terms__c,
                                                                                       SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account__r.SAP_Sales_Org__c, Account__r.SAP_DistChannel__c from Account_Material__c where id in :aids and Account__r.id!=null]);
                System.debug('ammap: '+ammap);
                
                for(account_material__c m:ammap.values())      
                {
                    string materialnumber = m.SAP_Material__r.material_number__c;
                    if(materialnumber != '' && materialnumber != null)
                        materialnumber = materialnumber.replace('G2', '');
                    String SoldToNumber = '';
                    if(m.Account__r.SAP_Sold_To_Account__c != null && m.Account__r.SAP_Sold_To_Account__c != '')
                        SoldToNumber = m.Account__r.SAP_Sold_To_Account__c.substringBefore(' - ');
                    String isNew = '';
                    if(m.created_from_cpi__C == null)
                        isNew = 'X';
                    CSP_JSON_Request_Item c = new CSP_JSON_Request_Item(
                        isNew,
                        m.Account__r.accountnumber, 
                        SoldToNumber,
                        '',
                        materialnumber,
                        '1',
                        m.SAP_Material__r.Sales_UOM__r.Alternative_UOM__c,
                        m.id, 
                        '',
                        m.Account__r.SAP_Sales_Org__c,
                        m.Account__r.SAP_DistChannel__c);
                    SAP_Requests.add(c);
                }
                system.debug('SAP_Requests count: '+SAP_Requests.size());
                List<CSP_JSON_Response> SAP_Responses;
                if(SAP_Requests.size() != null){
                    //SAP_Responses = CSP_JSON_Request.submit_Request_m(SAP_Requests);
                    nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
                    
                    String endpoint = settings.Mini_EndPoint__c;
                    
                    if(SAP_Requests.size() > 0){
                        String JSONString = JSON.serialize(SAP_Requests);
                        Http http = new Http();
                        HttpRequest hreq = new HttpRequest();
                        hreq.setHeader('Content-Type', 'application/xml');  
                        hreq.settimeout(60000);
                        hreq.setBody(JSONString);    
                        hreq.setEndpoint(endpoint);
                        hreq.setMethod('POST');
                        
                        if(Test.isRunningTest())
                        {
                            s = mockResponse;
                        }else{
                            httpResponse res = http.send(hreq); 
                            s = res.getbody();
                        }
                        s = s.unescapeEcmaScript();
                        s = s.unescapeEcmaScript();
                    }  
                    
                    System.debug('SAP_Responses: '+s);
                    
                    List<Object> resultList = (List<Object>)JSON.deserializeUntyped(s); 
                    List<Object> responseList = new List<Object>();
                    String materialVal = '';
                    String salesOrgVal = '';
                    for(Object obj : resultList) { 
                        Map<String,Object> map1 = (Map<String,Object>)obj; 
                        for(String key : map1.keyset()) {
                            if(key=='material_nbr'){
                                materialVal = (String)map1.get(key);
                            }
                            if(key == 'sales_org'){
                                salesOrgVal = (String)map1.get(key);
                            }
                        }
                        System.debug('materialVal: '+materialVal);
                        System.debug('salesOrgVal: '+salesOrgVal);
                        if(materialVal == materialCode && salesOrgVal == salesOrg){
                            responseList.add(obj);
                        }
                    }
                    System.debug('responseList: '+responseList);
                    System.debug('responseList size: '+responseList.size());
                    
                    List<Object> SingleResponseList = new List<Object>();
                    if(responseList.size()>1){
                        SingleResponseList.add(responseList[0]);
                    }else{
                        SingleResponseList.addAll(responseList);
                    }
                    System.debug('SingleResponseList size: '+SingleResponseList.size());
                    s = JSON.serialize(SingleResponseList);
                    System.debug('s1: '+s);
                    s = s.unescapeEcmaScript();
                    System.debug('s2: '+s);
                    
                }
            }else{
                s = 'Parameters Missing in the endpoint';
            }
            return s;
        }catch(Exception ex){
            return ex.getMessage();
        }  
        
    }
}