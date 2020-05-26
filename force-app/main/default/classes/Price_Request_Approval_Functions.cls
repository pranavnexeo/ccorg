public with Sharing class Price_Request_Approval_Functions{

    @TestVisible private static string FindInOfficeUser(id uid, Map<Id, User> alluser){
        
        string s;
        User u = alluser.get(uid);
        
        if(u.Out_of_office__c == null ||(u.Out_of_office__c != null && u.backup__c == null))   
            return uid;        
        else if(u.backup__c != null )    
        {
         s = checkuser(u.backup__c, alluser, 0);
          return s;
        }   
        
        return uid; 
    }
    
    @TestVisible private static string checkuser(id userid, Map<Id, User> alluser, integer index)
    {
      
      for(user u:alluser.values())
      {
         if(userid == u.id)
         {
             if(u.out_of_office__c!= null)
             {
                 if(u.backup__c!=null && index < 5)
                 {
                      checkuser(u.backup__c, alluser, (index + 1));
                 }
                 else
                 {
                    return userid;
                 }
             } 
             else
             {
              return u.id;
             }           
         }
       }
       return userid;
    }

   public static Map<String, String> FetchApproverMap(List<Price_Request_Transaction> prts)
   {
      Map<String, Decimal> Price_Protection_Map = new Map<String, Decimal>();
      for(Price_Protection_Codes__c p:Price_Protection_Codes__c.getall().values())
       if(p.Level__c == null)
          price_protection_map.put(p.code__c + ' - ' + p.name, 0);
       else
          price_protection_map.put(p.code__c + ' - ' + p.name, p.level__c);
      
      Map<Id, User> alluser = new Map<Id, User>([select id, name, backup__c,Out_of_office__c  from user where isactive = true limit 50000]);
      
      List<Price_Request_approver__c> approvers = new list<Price_Request_Approver__c>([select id, is_active__c, division_code__c, sap_sales_group_code__c, Material_Group_4__c,plm__c, sap_sales_group__c, approval_level__c, approver__r.IsActive, approver__c from price_request_approver__c where is_active__c = true order by process_order__c limit 50000]);
      Map<String, String> returnmap = new map<string, string>();

      for(Price_Request_Transaction prt:prts)
      {
          String materialid = prt.trans.sap_material__c;
          system.debug('materialid  is: '+materialid );
          material_sales_data2__c m = prt.trans.sap_material__r;
          boolean exception1 = false;
          boolean exception2 = false;
          boolean error = false;
          boolean autoapprove = false;
          Account a = prt.trans.ship_to__r;

          String accountid = prt.trans.ship_to__c;
          Price_Request_Transaction__c trans = prt.trans;
          String rowkey = prt.trans.account_material__c;
          system.debug('rowkey: ' + rowkey);
          for(SAP_Price_Tier__c spt:prt.Requested_Tiers.SAP_Tiers)
          {
              Double ReqPrice;
              if(spt.price_unit__c != null)
                ReqPrice = spt.price__c / spt.price_unit__c;
              else
                ReqPrice = spt.price__c;
              
              Double TarPrice;
              if(spt.target_tier_price_unit__c != null && spt.target_tier_price_unit__c != 0)
                TarPrice = spt.target_tier_price__c / spt.target_tier_price_unit__c;
                
              else
                tarPrice = spt.Target_Tier_Price__c;
                
              Double exception1price = spt.Exception_1_price__c;
              Double exception2price = spt.Exception_2_price__c;
              Double dplprice = spt.dpl_price__c;
              
              if((exception1price == 0 || exception1price == null) &&
                 (exception2price == 0 || exception1price == null))
                 exception2 = true;                 
              if(reqPrice < dplprice && a.sap_divisioncode__c == '33' )
                 exception2 = true;
              system.debug('sales group: ' + a.sap_divisioncode__c);
              if(reqPrice >= exception1price)
                 autoapprove = true;
              if(ReqPrice < exception1price)
                 exception1 = true;
              if(ReqPrice < exception2price)
                 exception2 = true;
              if(exception1price < 0 || exception2price < 0)
                 exception2 = true;
                
              String Existing_Protection = prt.getTopPriceProtectionDesc();
              if(Existing_Protection == null)
                  Existing_Protection = 'Z0 - No Protection';
              if(Existing_Protection == '')
                  Existing_Protection = 'Z0 - No Protection';
              
              system.debug('Auto-Approve: ' + autoapprove + ' Exception 1: ' + exception1 + ' exception2: ' + exception2 + ' Existing Protection: ' + Existing_Protection);
              if(!prt.trans.Requested_Price_Protection__c.contains(Existing_Protection))
              {
                   system.debug('Protection Changed');
                   exception2 = true; 
                   autoapprove = false;
              }
          }
          
        for(Price_Request_Approver__c approver:approvers)
        {
         if(returnmap.containskey(rowkey))
            break;
         else
         {

         String Exception_Level = '';
         if(exception1)
           Exception_Level = 'Exception 1';
         if(exception2)
           Exception_Level = 'Exception 2';
         
         boolean ismatch = (!returnmap.containskey(rowkey) && 
                            issame(a.sap_salesgroup__c, approver.sap_sales_group_code__c) && 
                            issame(m.Material_Group2_Code__c, approver.plm__c) && 
                            issame(m.material_group4_code__c, approver.material_group_4__c) && 
                            issame(a.SAP_DivisionCode__c, approver.division_code__c) &&
                            approver.approval_level__c == Exception_Level);
                             
         system.debug('ismatch: ' + ismatch);
         if(ismatch)
         {
          if(exception2){
            
            returnmap.put(rowkey, 'Exception 2;' +approver.approver__c + ';' + FindInOfficeUser(approver.approver__c, alluser));
              
          }else if(exception1){
            
            returnmap.put(rowkey, 'Exception 1;' + approver.approver__c + ';' + FindInOfficeUser(approver.approver__c, alluser));
          }
         }
        } 
       }
       if(autoapprove && !exception1 && !exception2)
            returnmap.put(rowkey, 'Auto-Approved;' + userinfo.getuserid()) ;
       if(!returnmap.containskey(rowkey)){ returnmap.put(rowkey, 'Catch All;'); } 
      } 
      system.debug('returnmap: ' + returnmap);
      return returnmap;   
   }
   public static Map<String, String> FetchApproverMap(List<Price_Request_Transaction__c> prts)
   {
      Map<String, Decimal> Price_Protection_Map = new Map<String, Decimal>();
      String priceprot='';
      for(Price_Protection_Codes__c p:Price_Protection_Codes__c.getall().values())
       if(p.Level__c == null)
          price_protection_map.put(p.code__c + ' - ' + p.name, 0);
       else
          price_protection_map.put(p.code__c + ' - ' + p.name, p.level__c);
      
      Map<Id, User> alluser = new Map<Id, User>([select id, name, backup__c,Out_of_office__c  from user where isactive = true limit 50000]);
      
      List<Price_Request_approver__c> approvers = new list<Price_Request_Approver__c>([select id, sap_seller__c,sap_seller__r.Name, is_active__c, division_code__c, sap_sales_group_code__c, Material_Group_4__c,plm__c, sap_sales_group__c, approval_level__c, approver__c from price_request_approver__c where is_active__c = true order by process_order__c limit 50000]);
      Map<String, String> returnmap = new map<string, string>();
      
      //for GTM
      List<Id> AcctId = New List<Id>();
      
      for(Price_Request_Transaction__c p : prts)
          AcctId.Add(p.ship_to__r.id);
      
        
      Map<Id, Account> allAccounts = new Map<Id, Account>([select YY_Partner__r.SAP_Sales_DOG__r.SAP_Sales_Group__r.Sales_Group_Code__c,YZ_Partner__r.SAP_Sales_DOG__r.SAP_Sales_Group__r.Sales_Group_Code__c,YY_Partner__r.SAP_Sales_DOG__r.SAP_Sales_Division__r.Sales_Division_Code__c,YZ_Partner__r.SAP_Sales_DOG__r.SAP_Sales_Division__r.Sales_Division_Code__c, YY_Partner__r.ZS_Partner__r.Name, YZ_Partner__r.ZS_Partner__r.Name, SAP_DivisionCode__c from account where Id IN :AcctId]);      
    
      for(Price_Request_Transaction__c prt:prts)
      {
          String materialid = prt.sap_material__c;
          material_sales_data2__c m = prt.sap_material__r;
          boolean exception1 = false;
          boolean exception2 = false;
          boolean error = false;
          boolean autoapprove = false;
          boolean cspFlag;    
          //Account a = prt.ship_to__r;
          Account a = allAccounts.get(prt.ship_to__c);
          
          List<string> calculateexception = new List<string>();
          
          String accountid = prt.ship_to__c;

          String rowkey = prt.account_material__c;
          List<SAP_Price_Tier__c> Requested_Tiers = new List<SAP_Price_Tier__c>();
          CSP_JSON_Response response = null;
          
          if(PRT.Requested_Tiers__c != null)
            Requested_Tiers = (List<SAP_Price_Tier__c>)JSON.deserialize(PRT.Requested_Tiers__c, List<SAP_Price_Tier__c>.class);
          if(PRT.SAP_Data__c != null)
            Response = (CSP_JSON_Response)JSON.deserialize(PRT.SAP_Data__c, CSP_JSON_Response.class);
          
          String Existing_Protection = 'Z0 - No Protection';
          
          if(Response != null)
            if(Response.tbl_csp_Prices.size() > 0)
              Existing_Protection = Response.tbl_csp_Prices.get(0).csp_price_protection_code+ ' - ' + Response.tbl_csp_Prices.get(0).csp_price_protection_desc;
              
          for(SAP_Price_Tier__c spt:Requested_Tiers)
          {
              Double ReqPrice;
              if(spt.price_unit__c != null)
                ReqPrice = spt.price__c / spt.price_unit__c;
              else
                ReqPrice = spt.price__c;
              
              Double TarPrice;
              if(spt.target_tier_price_unit__c != null && spt.target_tier_price_unit__c != 0)
                TarPrice = spt.target_tier_price__c / spt.target_tier_price_unit__c;
                
              else
                tarPrice = spt.Target_Tier_Price__c;
                
              Double exception1price = spt.Exception_1_price__c;
              Double exception2price = spt.Exception_2_price__c;
              System.debug('@@ exception1price'+exception1price);
              System.debug('@@ exception2price'+exception2price);
          Double dplprice = spt.dpl_price__c;
              
          
          if((exception1price == 0 || exception1price == null) &&
                 (exception2price == 0 || exception1price == null)){
                 exception2 = true;
              }                 
              if(reqPrice < dplprice && a.sap_divisioncode__c == '33' ){
                 exception2 = true; 
              }
              if(reqPrice >= exception1price){
                 autoapprove = true;
                  
              }
              if(ReqPrice < exception1price){
                 exception1 = true;
                 
              }
              if(ReqPrice < exception2price){
                 exception2 = true;
                     
              }
              if(exception1price < 0 || exception2price < 0){
                 exception2 = true;
              }
               
              priceprot = PRT.Requested_Price_Protection__c;  
              if(Existing_Protection == null || Existing_Protection == '' || Existing_Protection == ' - ')
                  Existing_Protection = 'Z0 - No Protection';
              system.debug(PRT.Requested_Price_Protection__c + ' = ' + existing_Protection);
              
              if(priceprot != null && priceprot != ' - ' && priceprot != '' && !priceprot.contains(Existing_Protection))
              {
              
              if(priceprot.contains('Default'))
                  priceprot = 'Z0 - No Protection';
              
              system.debug('Auto-Approve: ' + autoapprove + ' Exception 1: ' + exception1 + ' exception2: ' + exception2 + ' Existing Protection: ' + Existing_Protection + ' Price Prot: ' + prt.Requested_Price_Protection__c);
              
             
                   system.debug('Protection Changed');
                   exception2 = true; 
                   autoapprove = false;
              }             
              
          if(exception2 == true){
                  calculateexception.add('exception2');}
              else if(exception1 == true){
                  calculateexception.add('exception1');
              }
              else
                  calculateexception.add('autoapprove');    
          }
         
         if(prt.additional_dates__c == 'Yes')
         {
             if(calculateexception.size() > 1){  
                for(integer i = 0; i<calculateexception.size();i++){
                    if(i+1 < calculateexception.size()){
                    if(calculateexception[i] == 'excpetion1'){
                        
                        if(calculateexception[i+1] == 'exception2' )    
                            exception2 = true;
                        else 
                            exception1 = true;
                                      
                    }
                    else if(calculateexception[i] == 'exception2'){
                            
                            exception2 = true;
                        
                    }
                    else{
                        if(calculateexception[i+1] == 'excpetion1')
                        {
                            exception1 = true;    
                        }
                        else if(calculateexception[i+1] == 'exception2')
                        {
                            exception2 = true;    
                        }        
                        else
                            autoapprove = true;
                    }
                  }   
                }
               
            } 
            
         }
        for(Price_Request_Approver__c approver:approvers)
        {
         if(returnmap.containskey(rowkey))
            break;
         else
         {
         String Exception_Level = '';
         if(exception1)
           Exception_Level = 'Exception 1';
         if(exception2)
           Exception_Level = 'Exception 2';
            system.debug('exception1price is: '+exception1 );
            system.debug('exception2price is: '+exception2 );
            system.debug('Exception_Level is: '+Exception_Level);
         system.debug(returnmap);
         system.debug(rowkey);
         system.debug(a);
         system.debug(approver);
         system.debug(m);
         system.debug('AMId of PRT:'+prt.Account_Material__r.id);
         boolean ismatch=false;
         String YYOwnerSellerNum='';
         String YZOwnerSellerNum='';
         //String OwnerSellerNum = a.Owner.SAP_Cust_Num__c;
         YYOwnerSellerNum = a.YY_Partner__r.ZS_Partner__r.Name;
         YZOwnerSellerNum = a.YZ_Partner__r.ZS_Partner__r.Name;
         String SAPSellerNum = approver.sap_seller__r.name;
         
         system.debug('Approver SAP Seller Number:'+approver.sap_seller__r.name);

         if(m != null)
         ismatch = (!returnmap.containskey(rowkey) && 
                            (issame(a.YY_Partner__r.SAP_Sales_DOG__r.SAP_Sales_Group__r.Sales_Group_Code__c, approver.sap_sales_group_code__c) || 
                            issame(a.YZ_Partner__r.SAP_Sales_DOG__r.SAP_Sales_Group__r.Sales_Group_Code__c, approver.sap_sales_group_code__c)) && 
                            issame(m.Material_Group2_Code__c, approver.plm__c) && 
                            issame(m.material_group4_code__c, approver.material_group_4__c) && 
                            issame(a.SAP_DivisionCode__c, approver.division_code__c) &&
                            (sellercheck(YYOwnerSellerNum, SAPSellerNum) || sellercheck(YZOwnerSellerNum , SAPSellerNum)) &&
                            approver.approval_level__c == Exception_Level);
         if(ismatch)
         {
         
          if(exception2){
            
            returnmap.put(rowkey, 'Exception 2;' + approver.approver__c + ';' + FindInOfficeUser(approver.approver__c, alluser));
            
          }
          else if(exception1){
            returnmap.put(rowkey, 'Exception 1;' + approver.approver__c + ';' + FindInOfficeUser(approver.approver__c, alluser));
           } 
         }
         
        } 
       }
       if(autoapprove && !exception1 && !exception2)
            returnmap.put(rowkey, 'Auto-Approved;' + userinfo.getuserid()) ;
       if(!returnmap.containskey(rowkey)){ returnmap.put(rowkey, 'Catch All;'); } 
      } 
      
      system.debug('returnmap: ' + returnmap);
      return returnmap;   
   }
  @TestVisible private static boolean issame(string StringToTest, string StandardString)
   {
     if(standardstring == '' || standardstring == null || standardstring == StringToTest)
       return true;
     else
       return false;
   
   }
   
  @TestVisible private static boolean sellercheck(string OwnerSellerNum, string SAPSellerNum)
   {
     
     if((SAPSellerNum != '' && SAPSellerNum != null) && (OwnerSellerNum != '' && OwnerSellerNum != null))
        return OwnerSellerNum.contains(SAPSellerNum);
     else if(SAPSellerNum == '' || SAPSellerNum == null)
        return true;
     else
       return false;
   
   }
   
  /* 
public static double CalculateTPI(CSP_JSON_Response j, account_material__c am, map<string, double> currencymap){
        
        Material_Sales_Data2__c m;
        double Estimated_order_qty = 0;
        String Estimated_order_qty_uom = '';
        double Avg_order_qty = 0;
        String Avg_Order_Qty_Uom = '';
        
        if(j.avg_order_qty != '')
          avg_order_qty = stringtodouble(j.avg_order_qty);
        if(j.avg_order_unit != '' && j.avg_order_unit != null)
          avg_order_qty_uom = j.avg_order_unit;
        
          m = am.SAP_Material__r;
          estimated_order_qty = am.Estimated_Order_Quantity__c;
          estimated_order_qty_uom = am.Estimated_Order_Qty_UoM__c;

        if(estimated_order_qty == null)
          estimated_order_qty = 0;
        if(estimated_order_qty_uom == null)
          estimated_order_qty_uom = '';
 
        //Get Top TPI
        double TPI = 0;
        string TPIString = '';
        Map<String, Double> conversionmap = new map<String, Double>();
        for(CSP_JSON_Response.tbl_sales_units u:j.tbl_Sales_units)
        {
           if(u.numerator != '' && u.denominator != '')
             conversionmap.put(u.sales_unit, (stringtodouble(u.numerator) / stringtodouble(u.denominator)));
        }
        
        if(j.tbl_csp_prices.size() == 1 && j.tbl_target_prices.size() > 0 && estimated_order_qty > 0 && estimated_order_qty_uom != '' )
        {
           double mytargetprice = 0;
           if(j.tbl_csp_prices.get(0).CSP_price != '' && j.tbl_csp_prices.get(0).CSP_price != null)
             mytargetprice = stringtodouble(j.tbl_csp_prices.get(0).CSP_price);
           double mytargetvol = estimated_order_qty;
           string mytargetvoluom = estimated_order_qty_uom;
           
           if(conversionmap.containskey(mytargetvoluom) && conversionmap.containskey(j.tbl_csp_prices.get(0).CSP_scale_uom))
            {
                Double baseunit = mytargetvol / conversionmap.get(mytargetvoluom);
                mytargetvol = (baseunit * conversionmap.get(j.tbl_csp_prices.get(0).CSP_scale_uom));
                mytargetvoluom = j.tbl_csp_prices.get(0).CSP_scale_uom;
            }
           
           integer ind = 0;
           double tvolconverted = 0;
           double nexttvolconverted = 0;
           double tconverted = 0;
                     
           for(CSP_JSON_Response.tbl_target_prices t:j.tbl_target_prices)
           {
             
             string tuom = t.target_price_uom;
             string tcurr = t.target_price_currency;
             string tprice = t.target_price;
             string tvol = t.tier_volume;
             string tvoluom = t.target_scale_uom;
             string ccurr = j.tbl_csp_prices.get(0).csp_currency;
             if(ccurr != '' && ccurr != null)
               ccurr = ccurr.substring(0,3);
             
             if(ccurr != '' && ccurr != null && tprice != '')
              tconverted = ConvertCurrency(stringtodouble(tprice), tcurr, ccurr, currencymap);
             
             
             if(conversionmap.containskey(tvoluom) && conversionmap.containskey(mytargetvoluom))
             {
                Double baseunit = stringtodouble(tvol) / conversionmap.get(tvoluom);
                tvolconverted = (baseunit * conversionmap.get(mytargetvoluom));
                if(ind < j.tbl_target_prices.size()-1)
                {
                  baseunit = stringtodouble(j.tbl_target_prices.get(ind + 1).tier_volume)/ conversionmap.get(tvoluom);
                  nexttvolconverted = (baseunit * conversionmap.get(mytargetvoluom));
                }
             }
             
             if(conversionmap.containskey(tuom) && conversionmap.containskey(j.tbl_csp_prices.get(0).csp_uom) &&
                (
                (mytargetvol >= tvolconverted && mytargetvol < nexttvolconverted) || 
                (ind == 0 && mytargetvol <= tvolconverted) || 
                (ind ==j.tbl_target_prices.size()-1 && mytargetvol >= tvolconverted )
                )
               )
              {
                Double baseunit = stringtodouble(tconverted) / conversionmap.get(tuom);
                tconverted = (baseunit * conversionmap.get(j.tbl_csp_prices.get(0).csp_uom));
              
              if(tconverted != 0)
                tpi = decimal.valueof((stringtodouble(j.tbl_csp_prices.get(0).csp_price) / tconverted)*100).setscale(2);  
                TPIString = 'mytarvol: ' + mytargetvol + ' tvol: ' + tvolconverted;
              }
                ind = ind + 1;
           }
        }
        else if(j.tbl_csp_prices.size() == 1 && j.tbl_target_prices.size() > 0 && avg_order_qty > 0 && avg_order_qty_uom != '' && estimated_order_qty == 0)
        {
           double mytargetprice = 0;
           double mytargetvol = avg_order_qty;
           string mytargetvoluom = avg_order_qty_uom;
           
           if(conversionmap.containskey(mytargetvoluom) && conversionmap.containskey(j.tbl_csp_prices.get(0).CSP_scale_uom))
            {
                Double baseunit = mytargetvol / conversionmap.get(mytargetvoluom);
                mytargetvol = (baseunit * conversionmap.get(j.tbl_csp_prices.get(0).CSP_scale_uom));
                mytargetvoluom = j.tbl_csp_prices.get(0).CSP_scale_uom;
            }
           integer ind = 0;
           double nexttvolconverted = 0;
           Double tconverted = 0;
           Double tvolconverted = 0;
           for(CSP_JSON_Response.tbl_target_prices t:j.tbl_target_prices)
           {
             
             string tuom = t.target_price_uom;
             string tcurr = t.target_price_currency;
             string tprice = t.target_price;
             string tvol = t.tier_volume;
             string tvoluom = t.target_scale_uom;
             string ccurr = j.tbl_csp_prices.get(0).csp_currency;
             if(ccurr != '' && ccurr != null)
               ccurr = ccurr.substring(0,3);
             
             if(ccurr != '' && ccurr != null && tprice != '')
              tconverted = ConvertCurrency(stringtodouble(tprice), tcurr, ccurr, currencymap);
             
             if(conversionmap.containskey(tvoluom) && conversionmap.containskey(mytargetvoluom))
             {
                Double baseunit = stringtodouble(tvol) / conversionmap.get(tvoluom);
                tvolconverted = (baseunit * conversionmap.get(mytargetvoluom));
                
                if(ind < j.tbl_target_prices.size()-1)
                {
                  baseunit = stringtodouble(j.tbl_target_prices.get(ind + 1).tier_volume) / conversionmap.get(tvoluom);
                  nexttvolconverted = (baseunit * conversionmap.get(mytargetvoluom));
                }

             }
             if(conversionmap.containskey(tuom) && conversionmap.containskey(j.tbl_csp_prices.get(0).csp_uom) &&
                (
                (mytargetvol >= tvolconverted && mytargetvol < nexttvolconverted) || 
                (ind == 0 && mytargetvol <= tvolconverted) || 
                (ind ==j.tbl_target_prices.size()-1 && mytargetvol >= tvolconverted )
                )
               )
              {
                Double baseunit = stringtodouble(tconverted) / conversionmap.get(tuom);
                tconverted = (baseunit * conversionmap.get(j.tbl_csp_prices.get(0).csp_uom));
                mytargetprice = tconverted;
                mytargetvol = tvolconverted;
                
                if(tconverted != 0)
                 tpi = decimal.valueof((stringtodouble(j.tbl_csp_prices.get(0).csp_price) / tconverted)*100).setscale(2);  
           
              }
                ind = ind + 1;
           }
           
        }
        else if(j.tbl_csp_prices.size() > 0 && j.tbl_target_prices.size() > 0)
          if(j.tbl_csp_prices.get(0).csp_price != '' &&  j.tbl_target_prices.get(0).target_price != '')
          {
              string tuom = j.tbl_target_prices.get(0).target_price_uom;
              string tcurr = j.tbl_target_prices.get(0).target_price_currency;
              string tprice = j.tbl_target_prices.get(0).target_price;
              
              string cuom = j.tbl_csp_prices.get(0).csp_uom;
              string ccurr = j.tbl_csp_prices.get(0).csp_currency;
              string cprice = j.tbl_csp_prices.get(0).csp_price;
              double tconverted;
              
              if(ccurr != '' && ccurr != null && tprice != '')
                tconverted = ConvertCurrency(stringtodouble(tprice), tcurr, ccurr, currencymap);
              
              
              if(conversionmap.containskey(tuom) && conversionmap.containskey(cuom))
              {
                Double baseunit = stringtodouble(tconverted) / conversionmap.get(tuom);
                tconverted = (baseunit * conversionmap.get(cuom));
              }
              if(tconverted != 0)
              tpi = decimal.valueof((stringtodouble(j.tbl_csp_prices.get(0).csp_price) / tconverted)*100).setscale(2);    
          }
          return tpi;
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
    return double.valueof(temp);
  }
  else{ return null; }
}
private static Double ConvertCurrency(Double iValue, String sFrom, String sTo, Map<String, Double> conversionmap)
{
   if(conversionmap.containskey(sFrom) && conversionmap.containskey(sTo))
   {
   Double baseunit = iValue * conversionmap.get(sFrom);
   return (baseunit / conversionmap.get(sTo));
   }
   else
    return iValue;
}
*/
}