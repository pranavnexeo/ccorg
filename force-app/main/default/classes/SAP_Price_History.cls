public class SAP_Price_History {
 
 Public Static List<SAPHistoryWrapper> display_list = new List<SAPHistoryWrapper>();
 Public Static String ids {get; set;} 
 
 Public SAP_Price_History(){
  
 }
 
   @RemoteAction
   Public Static List<SAPHistoryWrapper> getRecordsToDisplay(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
        List<CSP_History_JSON_Request_Item> SAP_Requests = new List<CSP_HIstory_JSON_Request_Item>();
        display_list = new List<SAPHistoryWrapper>(); //set the display_list object to a new SAPHistory Wrapper List
        Integer counter = 1; //row counter variable
        system.debug('paramid is:'+paramid);
        String AccountMaterialId;
        Account_Material__c ams;
        List<String> AMids = new List<String>();
        String AccountId = '';
        String MaterialId = '';
        String FromDate = '';
        String ToDate = '';
        
        String csp_price;
        String csp_scale_uom;
        String csp_volume;
        String csp_price_unit;
        String csp_uom;
        String csp_currency;
        String csp_effective_date;
        String csp_expiration_date;
        String csp_price_protection_code;
        String csp_price_protection_desc;
        String csp_drum_deposit_code;
        String csp_condition_nbr;
        String csp_sfdc_pricereq_nbr;
        List<CSP_JSON_Response.tbl_csp_prices> csps2 = new List <CSP_JSON_Response.tbl_csp_prices>();
        
        System.debug('SAP History Account Materials Ids:'+AMids);
        
        
        
        for (Account_Material__c amrec : [select id , Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,
         Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c, Material__c, CSP_Expiration_Date__c,
         Account__r.SAP_Sold_To_Account__c, Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c, Account__r.SAP_Corporate_Account__c, Account__r.SAP_State__c,
         CSP__c, CSP_Effective_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c, Target__c, Target_Unit__c, Target_UoM__c, Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Prospect_Material__c, SAP_Material__r.material_number__c, Account__r.accountnumber, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c
         from Account_material__c where Id =:paramid]) { //query for the details of the records you want to display
         ams = amrec;
         system.debug('@#@#'+ams);
         AccountId = ams.Account__c;
         MaterialId = ams.SAP_Material__c;
         
         account a = [select id, accountnumber, SAP_Sold_To_Account_Id__c, SAP_Sales_Org__c, SAP_DistChannel__c from Account where id = :accountid limit 1];
             String SoldToNumber = '';
             
             if(a.SAP_Sold_To_Account_Id__c != '' && a.SAP_Sold_To_Account_Id__c != null)
             {  
                List<Account> accts = [select id, accountnumber from Account where id = :a.SAP_Sold_To_Account_Id__c limit 1];
                if(accts.size() > 0)
                   SoldToNumber = accts.get(0).accountnumber;
             } 
             
             Material_Sales_Data2__c m = [select id, Material_Number__c, Material_number_w_o_g2__c from Material_Sales_Data2__c where id = :materialid limit 1];
           CSP_History_JSON_Request_Item c = new CSP_History_JSON_Request_Item(a.accountnumber, 
                                                   SoldToNumber,
                                                   '',
                                                   m.material_number_w_o_G2__c,
                                                   '',
                                                   '1',
                                                   '',
                                                   FromDate,
                                                   ToDate,
                                                   a.id, 
                                                   '');
             if(a.SAP_DistChannel__c != null && a.SAP_DistChannel__c != '')
               c.DISTR_CHAN = a.SAP_DistChannel__c;
             
             if(a.SAP_Sales_Org__c != null && a.SAP_Sales_Org__c != '')
               c.SALES_ORG = a.SAP_Sales_Org__c;
               
             SAP_Requests.add(c);
             
                  
         } //end of for 
         
         List<CSP_JSON_Response> SAP_Responses = CSP_JSON_Request.submit_History_Request(SAP_Requests);
         system.debug('SAP Response is:'+SAP_Responses);
      
     for(CSP_JSON_Response csps:SAP_Responses)
     {  
      //CSP_JSON_Response.tbl_csp_prices csp = null;
      AccountMaterialId = csps.SFDC_Account_Id;
      csps2 = csps.tbl_csp_prices;
      //system.debug('CSP Size is:'+csps2.size());
      system.debug('CSP2 is:'+csps2);  
      if(csps2 != null){    
      if(csps.tbl_csp_prices.size() > 0)
      {
          for(CSP_JSON_Response.tbl_csp_prices csp :csps2)
          {
           //csp = csps.tbl_csp_prices.get(0);
           if(csp.csp_effective_date != '') // && !csp.csp_effective_date.contains('9999')
            csp_effective_date = formatDate(stringtodate(csp.csp_effective_date)); //stringtodate
           else
             csp_effective_date = null;
           if(csp.csp_Expiration_date != '') // && !csp.csp_Expiration_date.contains('9999')
             csp_expiration_date = formatDate(stringtodate(csp.csp_expiration_date)); //stringtodate
           else
             csp_expiration_date = null;
      
           if(csp.csp_currency != null && csp.csp_currency != '')
           {
            if(csp.csp_currency.length() > 3)
                csp_currency = csp.csp_currency.substring(0,3);
            else
                csp_currency = csp.csp_currency; 
           }else{ csp_currency = UserInfo.getDefaultCurrency(); }
          
              if(csp.csp_price != '')
                csp_price = (csp.csp_price); //stringtodouble
              if(csp.csp_price_unit != '')
                csp_price_unit = (csp.csp_price_unit);   //stringtodouble       
              if(csp.csp_uom != '')
                csp_uom = csp.csp_uom; 
              if(csp.csp_scale_uom != '' )
                csp_scale_uom = csp.csp_scale_uom;
              if(csp.csp_volume != '')
                csp_volume = (csp.csp_volume); //stringtodouble
                
              system.debug('Price Protection: ' + csp.csp_price_protection_code);
              if(csp.csp_price_protection_code != '' )
                csp_price_protection_code =  csp.csp_price_protection_code + ' - ' + csp.csp_price_protection_desc;
              else
                csp_price_protection_code = '';
              
              csp_drum_deposit_code = csp.csp_drum_deposit_code;
               
              system.debug('Price Protection After: ' + csp_price_protection_code);
              csp_condition_nbr = null;
              csp_sfdc_pricereq_nbr = null;
            SAPHistoryWrapper shw = new SAPHistoryWrapper(ams, counter, csp_price, csp_scale_uom, csp_volume, csp_price_unit, csp_uom, csp_currency, csp_effective_date, csp_expiration_date, csp_price_protection_code, csp_price_protection_desc, csp_drum_deposit_code, csp_condition_nbr, csp_sfdc_pricereq_nbr, csps2);
            system.debug('shw: ' + shw);
            display_list.add(shw); //add the account and counter to our list
            counter++; //increment the counter
            
            }
          } }
          system.debug('display_list:'+display_list);
          system.debug('Counter is:'+counter);
      }
        return display_list; //return the list of full records plus their row counter
    }
     
    Public class SAPHistoryWrapper{
        public Account_Material__c ams {get; set;} //Account Material object
        public Integer numberOfRow {get; set;} //row counter variable
        Public String csp_price{get; set;}
        Public String csp_scale_uom{get; set;}
        Public String csp_volume{get; set;}
        Public String csp_price_unit{get; set;}
        Public String csp_uom{get; set;}
        Public String csp_currency{get; set;}
        Public String csp_effective_date{get; set;}
        Public String csp_expiration_date{get; set;}
        Public String csp_price_protection_code{get; set;}
        Public String csp_price_protection_desc{get; set;}
        Public String csp_drum_deposit_code{get; set;}
        Public String csp_condition_nbr{get; set;}
        Public String csp_sfdc_pricereq_nbr{get; set;}
        Public List<CSP_JSON_Response.tbl_csp_prices> csps{get; set;}
        
       public SAPHistoryWrapper(Account_Material__c ams, Integer rowCounter, String csp_price, string csp_scale_uom, string csp_volume, string csp_price_unit, string csp_uom, string csp_currency, string csp_effective_date, string csp_expiration_date, string csp_price_protection_code, string csp_price_protection_desc, string csp_drum_deposit_code, string csp_condition_nbr, string csp_sfdc_pricereq_nb, List<CSP_JSON_Response.tbl_csp_prices> csp) {
            this.ams = ams; //assign account material
            this.numberOfRow = rowCounter; //assign row counter
            this.csp_scale_uom = csp_scale_uom;
            this.csp_price = csp_price;
            this.csp_volume =  csp_volume;
            this.csp_price_unit =  csp_price_unit;
            this.csp_uom =  csp_uom;
            this.csp_currency =  csp_currency;
            this.csp_effective_date =  csp_effective_date;
            this.csp_expiration_date =  csp_expiration_date;
            this.csp_price_protection_code =  csp_price_protection_code;
            this.csp_price_protection_desc =  csp_price_protection_desc;
            this.csp_drum_deposit_code =  csp_drum_deposit_code;
            this.csp_condition_nbr =  csp_condition_nbr;
            this.csp_sfdc_pricereq_nbr = csp_sfdc_pricereq_nbr;
            this.csps = csp;
        }
    }
    
    Public static Date stringtodate(string s){
  
      date d = null;
      try{
        d = Date.valueof(s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6)); 
      }catch(exception e){system.debug('***DATE CONVERT ERROR***: ' + s + ' ERROR: ' + e.getmessage());} 
      return d;
    }
    
    Public static String formatDate(date d){
      if(d != null)
        return d.format();
      else
        return '';
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

}