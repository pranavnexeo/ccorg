Global Class Account_Material_Functions{

public static nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
public static integer targetScale = (ns.Target_Price_Decimals__c == null) ? 2 : ns.Target_Price_Decimals__c.intValue();

Public Static String getForms(List<String> idlist, String Type){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getForms', 4);
  List<Account_Material__c> ams = [select id, PRT_Form__c, Adjust_Form__c from Account_Material__c where id IN :idlist];
  String toReturn = '';
  if(Type == 'multiple')
    for(integer i=0; i<ams.size(); i++)
    {
      Account_material__c am = ams.get(i);
      String step = am.PRT_Form__c;
      step = step.replace('[stepnum]', string.valueof(i+1));
      step = step.replace('[steptot]', string.valueof(ams.size()));
      toReturn += step;
    }
  if(Type == 'single')
    if(ams.size() > 0)
    {
       toReturn = ams.get(0).PRT_Form__c;
       toreturn = toReturn.replace('[stepnum]','1');
       toreturn = toReturn.replace('[steptot]', '1');
    }
  if(Type == 'adjust')
    if(ams.size() > 0)
    {
       toReturn = ams.get(0).Adjust_Form__c;
       toreturn = toReturn.replace('[stepnum]','1');
       toreturn = toReturn.replace('[steptot]', '1');
    }
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getForms', 30);
  return toReturn;
}


Public Static List<Price_Request_Transaction__c> upsertTransactions(List<Price_Request_Transaction__c> trans, Map<String, String> amap, String reqType)
{
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'upsertTransactions', 37);
  Boolean CMflag = false;
  List<Approval.ProcessSubmitRequest> reqs = new list<Approval.ProcessSubmitRequest>();
  List<Price_Request_Transaction__c> transactions = getTransactions(trans, amap);
  Set<String> types = new Set<String>();
  if(reqType == 'Approver')
      types = new set<String>{'CSP', 'Target'};
  else
      types = new set<String>{'Requested','CSP','Target'};
      
  List<SAP_Price__c> sapprices = [select id, type__c,SAP_currency__c from SAP_Price__c where Price_Request_Transaction__c IN :trans and type__c IN :types];
   List<PRT_Movement_Settings__c> PRTMovmntSett = PRT_Movement_Settings__c.getall().values();
  Map<String,Boolean> customSettMap = new Map<String,Boolean>();
  Map<String,Boolean> CustGrpSettMap = new Map<String,Boolean>();
    
             for(PRT_Movement_Settings__c PRTsett : PRTMovmntSett){
                customSettMap.put(PRTsett.Name,PRTsett.Switch__c);
                CustGrpSettMap.put(PRTsett.Name,PRTsett.CG5__c);
   }
   
  for(Sap_Price__c pr:sapprices){ pr.type__c = pr.type__c + ' History';}
  
  Map<Id, Price_Request_Transaction__c> tmap = new map<Id, Price_Request_Transaction__c>();
  String divCode;
  
  for(Price_Request_Transaction__c t:transactions)
  {  
    if(t.Ship_To__r.SAP_DivisionCode__c != null)
        divCode = t.Ship_To__r.SAP_DivisionCode__c;
    else if (t.Sold_To__r.SAP_DivisionCode__c != null)
        divCode = t.Sold_To__r.SAP_DivisionCode__c;
        
     tmap.put(t.id, t); 
     
     sap_price__c csp = new SAP_Price__c();
     csp.Price_Request_Transaction__c = t.id;
     csp.Quantity__c = t.Quantity__c;
     csp.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     csp.type__c = 'CSP';
     csp.PRT_Type__c = t.Type__c;
     csp.SAP_Currency__c = t.CSP_Currency__c;
     sapprices.add(csp);
          
     sap_price__c tar = new SAP_Price__c();
     tar.Price_Request_Transaction__c = t.id;
     tar.Quantity__c = t.Quantity__c;
     tar.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     tar.type__c = 'Target';
     tar.PRT_Type__c = t.Type__c;
     csp.SAP_Currency__c = t.CSP_Currency__c;
     sapprices.add(tar);
     System.debug('upsertTransactions::Corodinator Check is->'+t.Coordinator_Check__c);
     if(reqType == 'Coordinator'){
        if(t.Coordinator_Check__c)   
            t.Approval_Status__c = 'Submitted';
        else{
            if(customSettMap.get(divCode) == true){
                
                if(CustGrpSettMap.get(divCode) == true){
                    t.approval_Status__c = 'SAP Transfer Open';
                }
                else{
                    if(t.Ship_To__r.SAP_Customer_Group_5__c == '11' || t.Ship_To__r.SAP_Customer_Group_5__c == '12' || t.Ship_To__r.SAP_Customer_Group_5__c == '13'){
                        t.approval_Status__c = 'Pending Entry';
                    }
                    else{
                        t.approval_Status__c = 'SAP Transfer Open';
                    }
                }
            }
            else t.Approval_Status__c = 'Pending Entry';
        }
        sap_price__c req = new SAP_Price__c();
        req.Price_Request_Transaction__c = t.id;
        req.Quantity__c = t.Quantity__c;
        req.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
        req.type__c = 'Requested';
        req.PRT_Type__c = t.Type__c;
        csp.SAP_Currency__c = t.CSP_Currency__c;
        sapprices.add(req);
        
     }else{
         if(t.Approver_Match__c){
         sap_price__c alt = new SAP_Price__c();
         alt.Price_Request_Transaction__c = t.id;
         alt.Quantity__c = t.Quantity__c;
         alt.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
         alt.type__c = 'Alternate';
         alt.PRT_Type__c = t.Type__c;
         csp.SAP_Currency__c = t.CSP_Currency__c;
         sapprices.add(alt);
         
         //Manish - 13th April 2013 - Submitting Request to Seller through Standard Approval Process
         //t.Approval_Status__c = 'Rejected-Alternate';
         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
         req1.setObjectId(t.id);
         reqs.add(req1);
         system.debug('reqs is:'+reqs);
         }
         else
            t.Approval_Status__c = 'Submitted';
     }
  }
  
          
  if(sapprices.size() > 0)
    upsert sapprices;
  
  List<SAP_Price_Tier__c> alltiers = new List<SAP_Price_Tier__c>();
  for(SAP_Price__c pr:sapprices)
  {
    List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
    if(pr.type__c == 'Requested')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'CSP')
       if(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Target')
       if(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Alternate')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    
    for(SAP_Price_Tier__c t:tiers)
       t.SAP_Price__c = pr.id;
    alltiers.addall(tiers);
  }
  if(alltiers.size() > 0)
  insert alltiers;
  
  if(amap.get('psr') == 'psr'){
    system.debug('inside psr');
        Price_Support_Request__c ps = new Price_Support_Request__c();
        if(amap.containskey('CUPS')){ ps.CUPS__c = amap.get('CUPS');}
        if(amap.containskey('psrsupplier')){ ps.Supplier_Name__c = amap.get('psrsupplier');}
        if(amap.containskey('aggrnum')){ ps.Agreement_Number__c = amap.get('aggrnum');}
        if(amap.containskey('sapplant')){ if(amap.get('sapplant') != null && amap.get('sapplant') != '') ps.SAP_Plant__c = amap.get('sapplant');}
        if(amap.containskey('psreffdate')){ ps.Effective_Date__c = datetime.newinstance(long.valueof(amap.get('psreffdate'))).dategmt();}
        if(amap.containskey('psrexpdate')){ ps.Expiration_Date__c = datetime.newinstance(long.valueof(amap.get('psrexpdate'))).dategmt();}
        if(amap.containskey('region')){ ps.Region_Code__c = amap.get('region');}
        if(amap.containskey('psrfreight')){ ps.Freight_Terms_Buying__c = amap.get('psrfreight');}
        if(amap.containskey('psrSuppPrice')){ ps.Supplier_Supported_Price__c = Account_Material_Functions.stringtodouble(amap.get('psrSuppPrice'));}
        if(amap.containskey('psruom')){ ps.UOM__c = amap.get('psruom');}
        if(amap.containskey('psrdisc1')){ ps.Support_Disc_1__c = stringtodouble(amap.get('psrdisc1'));}
        if(amap.containskey('psrdisc2')){ ps.Support_Disc_2__c = stringtodouble(amap.get('psrdisc2'));}
        if(amap.containskey('disc1type')){ ps.Disc1type__c = amap.get('disc1type');}
        if(amap.containskey('disc2type')){ ps.Disc2type__c = amap.get('disc2type');}
        if(amap.containskey('suppcomments')){ ps.Additional_Comments__c = amap.get('suppcomments');}
        
        if(amap.containskey('upfront')){ ps.Upfront__c = True;}
        ps.Material_Buying__c = transactions[0].SAP_Material__c;
        ps.Customer_Name__c = transactions[0].ship_to__c;
        ps.Status__c = 'Open';
        RecordType rt = [select Id from RecordType where Name = 'PSR' and SobjectType = 'Price_Support_Request__c' limit 1];
        ps.RecordTypeId = rt.Id;
        ps.Price_Request_Transaction__c = transactions[0].id;
        Insert ps;
        transactions[0].Price_Support_Request__c = ps.id;
  }
  
  if(transactions.size() > 0)
  upsert transactions;
  System.debug('upsert transactions'+transactions);
  if(reqs.size() > 0)
    List<Approval.ProcessResult> results = Approval.process(reqs); 
    
      //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'upsertTransactions', 126);
  return transactions; 
}


Public Static List<Price_Request_Transaction__c> insertTransactions(List<Account_Material__c> ams, Map<String, String> amap, Boolean CMflag){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'insertTransactions', 132);
  List<Price_Request_Transaction__c> transactions = getTransactions(ams, amap, CMflag);
  Map<Id, Price_Request_Transaction__c> tmap = new map<Id, Price_Request_Transaction__c>();
  List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
  if(transactions.size() > 0)
  Insert transactions;
  
   
  
  for(Price_Request_Transaction__c t:transactions)
  {  
     tmap.put(t.id, t); 
     sap_price__c req = new SAP_Price__c();
     sap_price__c csp = new SAP_Price__c();
     sap_price__c tar = new SAP_Price__c();
     req.Price_Request_Transaction__c = t.id;
     csp.Price_Request_Transaction__c = t.id;
     tar.Price_Request_Transaction__c = t.id;
     req.type__c = 'Requested';
     csp.type__c = 'CSP';
     tar.type__c = 'Target';
     req.Quantity__c = t.Quantity__c;
     csp.Quantity__c = t.Quantity__c;
     tar.Quantity__c = t.Quantity__c;
     req.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     csp.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     tar.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     req.PRT_Type__c = t.Type__c;
     csp.PRT_Type__c = t.Type__c;
     tar.PRT_Type__c = t.Type__c;
     csp.SAP_Currency__c = t.CSP_Currency__c;
     tar.SAP_Currency__c = t.CSP_Currency__c;
     req.SAP_Currency__c = t.CSP_Currency__c;
     sapprices.add(req);
     sapprices.add(csp);
     sapprices.add(tar);
  }
  if(sapprices.size() > 0)
  insert sapprices;
  List<SAP_Price_Tier__c> alltiers = new List<SAP_Price_Tier__c>();
  for(SAP_Price__c pr:sapprices)
  {
    List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
    if(pr.type__c == 'Requested')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'CSP')
       if(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Target')
       if(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c, List<SAP_Price_Tier__c>.class);
    
    for(SAP_Price_Tier__c t:tiers)
       t.SAP_Price__c = pr.id;
    alltiers.addall(tiers);
  }
  if(alltiers.size() > 0)
  insert alltiers;
  
  if(amap.get('psr') == 'psr'){
    system.debug('inside psr');
        Price_Support_Request__c ps = new Price_Support_Request__c();
        if(amap.containskey('CUPS')){ ps.CUPS__c = amap.get('CUPS');}
        if(amap.containskey('psrsupplier')){ ps.Supplier_Name__c = amap.get('psrsupplier');}
        if(amap.containskey('aggrnum')){ ps.Agreement_Number__c = amap.get('aggrnum');}
        if(amap.containskey('sapplant')){ if(amap.get('sapplant') != null && amap.get('sapplant') != '') ps.SAP_Plant__c = amap.get('sapplant');}
        if(amap.containskey('psreffdate')){ ps.Effective_Date__c = datetime.newinstance(long.valueof(amap.get('psreffdate'))).dategmt();}
        if(amap.containskey('psrexpdate')){ ps.Expiration_Date__c = datetime.newinstance(long.valueof(amap.get('psrexpdate'))).dategmt();}
        if(amap.containskey('region')){ ps.Region_Code__c = amap.get('region');}
        if(amap.containskey('psrfreight')){ ps.Freight_Terms_Buying__c = amap.get('psrfreight');}
        if(amap.containskey('psrSuppPrice')){ ps.Supplier_Supported_Price__c = Account_Material_Functions.stringtodouble(amap.get('psrSuppPrice'));}
        if(amap.containskey('psruom')){ ps.UOM__c = amap.get('psruom');}
        if(amap.containskey('psrdisc1')){ ps.Support_Disc_1__c = stringtodouble(amap.get('psrdisc1'));}
        if(amap.containskey('psrdisc2')){ ps.Support_Disc_2__c = stringtodouble(amap.get('psrdisc2'));}
        if(amap.containskey('disc1type')){ ps.Disc1type__c = amap.get('disc1type');}
        if(amap.containskey('disc2type')){ ps.Disc2type__c = amap.get('disc2type');}
        if(amap.containskey('suppcomments')){ ps.Additional_Comments__c = amap.get('suppcomments');}
        if(amap.containskey('upfront')){ ps.Upfront__c = True;}
        ps.Material_Buying__c = transactions[0].SAP_Material__c;
        ps.Customer_Name__c = transactions[0].ship_to__c;
        ps.Status__c = 'Open';
        ps.Price_Request_Transaction__c = transactions[0].id;
        RecordType rt = [select Id from RecordType where Name = 'PSR' and SobjectType = 'Price_Support_Request__c' limit 1];
        ps.RecordTypeId = rt.Id;
        Insert ps;
        transactions[0].Price_Support_Request__c = ps.id;
  }
  
  if(transactions.size() > 0)
  upsert transactions;
  
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'insertTransactions', 187);
  return transactions;
}

Public Static String AlternatePrice_InnerTable(Price_Request_Transaction__c prt, String comments, String appComments)
{
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'AlternatePrice_InnerTable', 193);
 List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
 String tarVolUOM = '';
 String tarPriceUOM = '';
 
 if(prt.Requested_Tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(prt.Requested_Tiers__c, List<SAP_Price_Tier__c>.class);
          
          
 String window = '';
 
     window += '<table><tr><td style="vertical-align:top;padding-right:1px;">';
     window += '<table class="innerTable" style="width:475px;" id="' + prt.id + '"><thead><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>TPI</th></tr></thead>';
     window += '<tbody>';
     
     for(SAP_Price_Tier__c t:tiers)
      {
      tarVolUOM = t.Volume_UoM__c;
      tarPriceUOM = t.price_uom__c;
      
      //InnerTable creation for Requested Tier info
         window += '<tr>';
          if(prt.requested_effective_date__c != null)
            window += '<td>' + t.Effective_Date__c.format() + '</td><td>'; //formatDate
          else
            window += '<td></td><td>';
          
          if(prt.Requested_expiration_date__c != null)
            window += t.Expiration_Date__c.format() + '</td>'; //formatDate
            else
            window += '</td>';
            
          window += '<td>' + t.volume__c + '</td><td>';
          
          string tpi = '';
          if(t.tpi__c != null)
            tpi = (t.tpi__c ).setScale(2) + '%';
          window += t.Volume_UoM__c + '</td><td>';
          if(t.req_price__c != null)
          window += t.req_price__c;
          //window += t.price__c.setscale(4);
          window += '</td><td>' + t.price_uom__c + '</td><td>' + tpi+ '</td></tr>';  
 
        } //end of for SAP_Price_Tier__c
        
         window += '</tbody></table></td><td style="vertical-align:top;padding-right:1px;">';
    
    if(PRT.Account_Material__r.prospect_material__c != true){ 
    
    //InnerTable creation for Target Tier
     boolean uomFlag = True;
     String sAccMat = prt.Account_Material__c;
            
     Account_Material__c am = [Select id, SAP_Data__c from Account_Material__c where id = :sAccMat];
     CSP_JSON_Response response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
     Map<String, Double> conversionmap = getconversionmap(PRT, response.tbl_sales_units);
          
     window  +=  '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable" style="width:475px;" id="' + prt.id + '"><thead><tr><th colspan="5">Target Tiers</th></tr><tr><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>Approver Floor</th></tr></thead><tbody>';
              
     List<SAP_Price_Tier__c> targets = new List<SAP_Price_Tier__c>();
     String curr = '';
     Map<String, Double> CurrencyMap = new Map<String, Double>();
        for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
        {
             if(c.isocode != '' && c.isocode != null)
               CurrencyMap.put(c.IsoCode, C.ConversionRate);
        } 
      if(PRT.Target_Tiers__c != null)
       targets = (List<SAP_Price_Tier__c>)JSON.deserialize(PRT.Target_Tiers__c, List<SAP_Price_Tier__c>.class);
       
     
         
       for(SAP_Price_Tier__c t:targets)
       {
           Double tarPrice;
           Double excep2Price;
           
           string tuom = t.price_uom__c;
           if(!conversionmap.containskey(tuom))
                uomFlag = False;
           
           if(t.currencyisocode != prt.currencyisocode){
               tarPrice = convertcurrency(stringtodouble(t.Price__c), t.currencyisocode, prt.currencyisocode, currencymap);
               
           if(t.exception_2_Price__c != null)
               excep2Price = convertcurrency(stringtodouble(t.exception_2_Price__c), t.currencyisocode, prt.currencyisocode, currencymap);
           
           }
           else{
               tarPrice = stringtodouble(t.Price__c);
               excep2Price = stringtodouble(t.exception_2_Price__c);
         }
                    
           Double vol = t.volume__c;
           Double price = t.Price__c;
           
           Double  tvol  = convertunits(conversionmap, vol,t.Volume_UoM__c, tarVolUOM, false );
           Double  tprice = convertUnits(conversionmap, tarPrice,t.Price_UoM__c,tarPriceUOM, true );
            if(uomFlag)
               window += '<tr><td>' + Decimal.valueof(tvol).setscale(1)   + '</td><td>'+ tarVolUOM  +'</td><td>' + Decimal.valueof(tprice).setscale(2)  + '</td><td>' + tarPriceUOM  + '</td>';
           else
               window += '<tr><td>' + Decimal.valueof(vol).setscale(1)   + '</td><td>'+ t.Volume_UoM__c  +'</td><td>' + Decimal.valueof(tarPrice).setscale(2)  + '</td><td>' + t.Price_UoM__c  + '</td>';
           
           if(excep2Price  != null)
               window += '<td>' + Decimal.valueof(excep2Price).setscale(2)  + '</td></tr>';
           else
               window += '<td></td></tr>';
        }
     
     window += '</tbody></table></td><td style="vertical-align:top;padding-right:1px;">'; 
         //End of Target Tier
     }  
     
     //InnerTable creation for Transaction details
          
          window += '<table class="innerTable" style="width:475px;" id="' + prt.id + '"><thead>';
          window += '<th>Avg Order Qty</th><th>Estimated Order Qty</th>';
         // system.debug('String is:'+avgqty);
          if(prt.average_order_qty__c == null)
              window += '</thead><tbody><td>' + '' + '</td>';
          else
              window += '</thead><tbody><td>' + prt.average_order_qty__c.intvalue() + ' ' + prt.average_order_qty_uom__c + '</td>';
          if(prt.quantity__c == null)
              window += '</thead><tbody><td>' + '' + '</td>';
          else
              window += '<td>' + prt.quantity__c.intvalue() + ' ' + prt.estimated_order_qty_uom__c + '</td></tbody>';
            window += '</table></td><td style="vertical-align:top;padding-right:1px;">';
          
          window += '<table class="innerTable"><thead><tr><th>Comments</th><th>Approval Comments</th></tr></thead><tbody><tr><td style="width:300px;vertical-align:top;padding-right:1px;">';
          if(comments != '' && comments != null)
            window += comments.replaceall('\n', '<br/>');
          window += '</td><td style="vertical-align:top;padding-right:1px;width:300px;">';
          if(appComments != '' && appComments != null)
          window += appComments.replaceall('\n', '<br/>');
          window += '</td></tr></tbody>';
          
          system.debug('outside CM window'+prt.CM_Flag__c);
           system.debug('outside CM window'+prt.Type__c);
           system.debug('outside CM window'+prt.Date_Approved__c);
           system.debug('outside CM window'+prt.Account_Material__r.Material_Group_3__c);
          if(prt.CM_Flag__c == true)// && prt.Type__c == 'Quote')
          if(prt.Account_Material__r.Material_Group_3__c == 'SPECIALTY')
          { system.debug('inside CM window');
              window += '<tr><table class="innerTable"><thead><tr><th colspan=3 align="center">CM Data</th></tr><tr><th>Material Cost</th><th>Variable Warehouse</th><th>Variable Delivery</th></tr></thead><tbody>';
              window += '<tr><td>' + prt.Material_Cost__c + '</td><td>' + prt.Variable_Warehouse__c + '</td><td>' + prt.Variable_Delivery__c + '</td></tr></tbody></table>';
              window += '<table class="innerTable"><thead><tr><th>Unit Material Cost</th><th>Unit Variable Warehouse</th><th>Unit Variable Delivery</th></tr></thead><tbody>';
              window += '<tr><td>' + prt.Unit_Material_Cost__c + '</td><td>' + prt.Unit_Warehouse_Charge__c + '</td><td>' + prt.Unit_Freight_Charge__c + '</td></tr></tbody></table></tr>';
          } 
          
          window += '</table></td></table>';
          system.debug('window:'+window);
  
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'AlternatePrice_InnerTable', 255);
 return window;
 
 }//end of function


Public Static List<Price_Request_Transaction__c> getTransactions(List<Price_Request_Transaction__c> transactions_in, Map<String, String> amap){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getTransactions', 262);
  List<String> amids = new List<String>();
  String appComments = '';
 // Map<String, Decimal> avgqty = new Map<String, Decimal>();
  Map<String, String> comments = new Map<String, String>();
  Map<String, String> approverLevel = new Map<String, String>();
  Map<String, Decimal> tpiMap = new Map<String, Decimal>();
  Map<String, Decimal> priceMap = new Map<String, Decimal>();
  Map<String, Price_Request_Transaction__c> prtmap = new Map<String, Price_Request_Transaction__c>();
  for(Price_Request_Transaction__c prt:transactions_in)
  {  amids.add(prt.account_material__c);
     prtmap.put(prt.account_material__c, prt);
     
     comments.put(prt.account_material__c, prt.comments__c);
  //   avguom.put(prt.account_material__c, prt.Average_Order_Qty_UoM__c);
     approverLevel.put(prt.account_material__c, prt.Approval_Level__c);
     tpiMap.put(prt.account_material__c, prt.TPI__c);
     priceMap.put(prt.account_material__c, prt.Price__c);
     
  }
  List<Account_Material__c> ams = getaccountmaterials(amids);
  Boolean CMflag = false;
  List<Price_Request_Transaction__c> transactions_out = getTransactions(ams, amap, CMflag);
  
  for(Price_request_transaction__c prt:transactions_out)
  {
    prtmap.get(prt.account_material__c).Requested_Effective_Date__c = prt.Requested_Effective_Date__c;
    prtmap.get(prt.account_material__c).Requested_Expiration_Date__c = prt.Requested_Expiration_Date__c;
    prtmap.get(prt.account_material__c).Requested_Effective_Datenext__c = prt.Requested_Effective_Datenext__c;
    prtmap.get(prt.account_material__c).Requested_Expiration_Datenext__c = prt.Requested_Expiration_Datenext__c;
    prtmap.get(prt.account_material__c).quantity__c = prt.quantity__c;
    prtmap.get(prt.account_material__c).Estimated_Order_Qty_UoM__c = prt.Estimated_Order_Qty_UoM__c;
    prtmap.get(prt.account_material__c).volume__c = prt.volume__c;
    prtmap.get(prt.account_material__c).Requested_UoM__c = prt.Requested_UoM__c;
    prtmap.get(prt.account_material__c).price__c = prt.price__c;
    prtmap.get(prt.account_material__c).Requested_Price_UoM__c = prt.Requested_Price_UoM__c;
    prtmap.get(prt.account_material__c).currencyisocode = prt.currencyisocode;
    prtmap.get(prt.account_material__c).CSP_Currency__c = prt.CSP_Currency__c;
    prtmap.get(prt.account_material__c).TPI__c = prt.TPI__c;
    prtmap.get(prt.account_material__c).SAP_Data__c = prt.SAP_Data__c;
    prtmap.get(prt.account_material__c).Requested_Tiers__c = prt.Requested_Tiers__c;
    prtmap.get(prt.account_material__c).CSP_Tiers__c = prt.CSP_Tiers__c;
    prtmap.get(prt.account_material__c).Target_Tiers__c = prt.Target_Tiers__c;
    
    prtmap.get(prt.account_material__c).Application__c = prt.Application__c;
    prtmap.get(prt.account_material__c).PAC_Code__c = prt.PAC_Code__c;
    prtmap.get(prt.account_material__c).OEM__c = prt.OEM__c;
    prtmap.get(prt.account_material__c).Specified_Material__c = prt.Specified_Material__c;
    prtmap.get(prt.account_material__c).Existing_Business_for_Customer__c = prt.Existing_Business_for_Customer__c;
    prtmap.get(prt.account_material__c).Competitive_Producer__c = prt.Competitive_Producer__c;
    prtmap.get(prt.account_material__c).Competitive_Grade__c = prt.Competitive_Grade__c;
    prtmap.get(prt.account_material__c).Estimated_Annual_Volume__c = prt.Estimated_Annual_Volume__c;
    prtmap.get(prt.account_material__c).Freight_Terms__c = prt.Freight_Terms__c;

    
    if(prt.Approval_Rejection_Comments__c != null && prt.Approval_Rejection_Comments__c != '')
    {prtmap.get(prt.account_material__c).Approval_Rejection_Comments__c = prt.Approval_Rejection_Comments__c;}
    
    
    if(prtmap.get(prt.account_material__c).Approval_Status__c == 'Pending Entry')
        appComments = prtmap.get(prt.account_material__c).Approval_Rejection_Comments__c;
    else 
        appComments = prt.Approval_Rejection_Comments__c;
    prtmap.get(prt.account_material__c).Coordinator_Comments__c = prt.Coordinator_Comments__c;
  //  prtmap.get(prt.account_material__c).Inner_Table__c = AlternatePrice_InnerTable(prt,avgqty.get(prt.account_material__c), avguom.get(prt.account_material__c));
    prtmap.get(prt.account_material__c).Inner_Table__c = AlternatePrice_InnerTable(prt,comments.get(prt.account_material__c),appComments);   
    system.debug('getTransaction BEFORE::'+prtmap.get(prt.account_material__c).Approver_Match__c);
    if(prt.Approver__r.Name !=null){
        
        if(prt.Approver__c != userinfo.getuserid() && approverLevel.get(prt.account_material__c) == 'Exception 1' && prt.Approval_Level__c == 'Exception 2'){
            prtmap.get(prt.account_material__c).Approver_Match__c = False;
        }else{
            prtmap.get(prt.account_material__c).Approver_Match__c = True;
        }
        
    }else{
        prtmap.get(prt.account_material__c).Approver_Match__c = True;
    }
    system.debug('getTransaction AFTER::'+prtmap.get(prt.account_material__c).Approver_Match__c);
    system.debug('getTransaction BEFORE::'+prtmap.get(prt.account_material__c).Coordinator_Check__c);
    if((tpiMap.get(prt.account_material__c) == prt.TPI__c && priceMap.get(prt.account_material__c) == prt.Price__c) ||
    (tpiMap.get(prt.account_material__c) == prt.TPI__c && priceMap.get(prt.account_material__c) < prt.Price__c) ||
    (tpiMap.get(prt.account_material__c) < prt.TPI__c && priceMap.get(prt.account_material__c) < prt.Price__c) ||
    (tpiMap.get(prt.account_material__c) < prt.TPI__c && priceMap.get(prt.account_material__c) == prt.Price__c))
        prtmap.get(prt.account_material__c).Coordinator_Check__c =  False;
    else
        prtmap.get(prt.account_material__c).Coordinator_Check__c = True;
    system.debug('getTransaction AFTER::'+prtmap.get(prt.account_material__c).Coordinator_Check__c);  
    if(prtmap.get(prt.account_material__c).Approval_Status__c != 'Pending Entry' && prt.Approval_Level__c != 'Auto-Approved'){   
     
        prtmap.get(prt.account_material__c).Approver__c = prt.Approver__c;
        prtmap.get(prt.account_material__c).Approver__r = prt.Approver__r;
        prtmap.get(prt.account_material__c).Approval_Backup__c = prt.Approval_Backup__c;
    }
    prtmap.get(prt.account_material__c).Approval_Level__c = prt.Approval_Level__c;
    prtmap.get(prt.account_material__c).Reason_Code__c = prt.Reason_Code__c;
    prtmap.get(prt.account_material__c).Requested_Price_Protection__c = prt.Requested_Price_Protection__c;

  }
 // update prtmap.values();
 //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getTransactions', 318);
  return prtmap.values();
}

Public Static List<Price_Request_Transaction__c> getTransactions(List<Account_Material__c> ams, Map<String, String> amap, Boolean CMflag){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getTransactions', 322);
  
  boolean cspFlag = False;
  boolean uomFlag = True;
  Map<String, Double> CurrencyMap = new Map<String, Double>();
  for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
  {
       if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, C.ConversionRate);
  }
  Integer tiercount = 0;
  Integer tiercountnext = 0;
  for(string s:amap.keyset()){
    if(s.contains('bracketvolume_'))
    {  tiercount = tiercount + 1;
       system.debug('!!!! tiercount:'+tiercount);  
    }
    if(s.contains('bracketvolumenext_'))
    {
        tiercountnext = tiercountnext + 1;
       system.debug('!!!! tiercountcsp:'+tiercountnext);  
    } 
  }
  List<Price_Request_Transaction__c> transactions = new list<Price_Request_Transaction__c>();
  List<String> aids = new List<String>();
  system.debug('amssize:'+ams.size());
  for(Account_material__c am:ams)
  {
    Price_Request_Transaction__c PRT = new Price_Request_Transaction__c();
    PRT.SAP_Data__c = am.SAP_Data__c;
    CSP_JSON_Response response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
    system.debug(response);
    Map<String, Double> conversionmap = getconversionmap(PRT, response.tbl_sales_units);
    PRT.Approval_Status__c = 'Submitted';
    PRT.Account_Material__c = am.id;
    PRT.Account_Material__r = am;
    PRT.SAP_Material__c = am.SAP_Material__c;
    PRT.SAP_Material__r = am.SAP_Material__r;
    PRT.ship_to__c = am.Account__c;
    PRT.CSP_Currency__c = am.CSP_Currency__c;
    PRT.Ship_to_dm__c = am.Account__r.owner.managerid;
    system.debug('am.Account__r is : ' +am.Account__r);
    system.debug('am.Account__c is : ' + am.Account__c);
    
    PRT.ship_to__r = am.Account__r;
    if(am.Account_Sold_To_Id__c != null)
      aids.add(am.Account_Sold_To_Id__c);
    if(am.Account_Corp_Account_Id__c != null)
      aids.add(am.Account_Corp_Account_Id__c);
    //PRT.sold_to__c = am.Account_Sold_To_Id__c;
    //PRT.Corporate_account__c = am.Account_Corp_Account_Id__c;
    PRT.average_order_qty__c = am.Avg_Order_Qty__c;
    PRT.average_Order_Qty_UoM__c = am.Avg_Order_Qty_Uom__c;
     
    String DefaultPriceProt = '';
    String DefaultFreight = '';
    if(amap.containskey('effdate')){ PRT.Requested_Effective_Date__c = datetime.newinstance(long.valueof(amap.get('effdate'))).dategmt(); }
    if(amap.containskey('exdate')){ PRT.Requested_Expiration_Date__c = datetime.newinstance(long.valueof(amap.get('exdate'))).dategmt(); }
    if(amap.containskey('currency')){ 
      if((amap.get('currency')).length() > 3)
         PRT.currencyisocode = (amap.get('currency')).substring(0,3);
      else
         PRT.currencyisocode = amap.get('currency'); 
     PRT.CSP_Currency__c = amap.get('currency'); }
    if(amap.containskey('pricetype')){ PRT.type__c = amap.get('pricetype'); }
    
    if(amap.containskey('currency')){ PRT.CSP_Currency__c = amap.get('currency'); }
    if(amap.containskey('drdep')){ PRT.Requested_Drum_Deposit__c = amap.get('drdep'); }
    if(amap.containskey('bracketprice_0')){ PRT.Price__c = stringtodouble(amap.get('bracketprice_0')); }
    //if(amap.containskey('bracketprice')){ PRT.Price__c = stringtodouble(amap.get('bracketprice')); }
    if(amap.containskey('brpriceuom')){ PRT.Requested_Price_UoM__c = amap.get('brpriceuom'); }
    if(amap.containskey('bracketvolume_0')){ PRT.Volume__c = stringtodouble(amap.get('bracketvolume_0')); }
    if(amap.containskey('brvoluom')){ PRT.Requested_UoM__c = amap.get('brvoluom'); }
    if(amap.containskey('ordervol')){ system.debug('qty 1:'+amap.get('ordervol')); PRT.Quantity__c = stringtodouble(amap.get('ordervol'));}
    if(amap.containskey('ordervoluom')){ PRT.Estimated_Order_Qty_UoM__c = amap.get('ordervoluom'); }
    if(amap.containskey('competitorid')){ PRT.Competitor__c = amap.get('competitorid'); }
    if(amap.containskey('obtainedfrom')){ PRT.Competitor_Obtained_From__c = amap.get('obtainedfrom'); }
    if(amap.containskey('compprice')){ system.debug('***************************'+stringtodouble(amap.get('compprice')));PRT.Competitive_Price__c = stringtodouble(amap.get('compprice')); }
    if(amap.containskey('compuom')){ PRT.Competitive_UoM__c = amap.get('compuom'); }
    if(amap.containskey('obtainedfrom')){ PRT.Competitor_obtained_From__c = amap.get('obtainedfrom');  }    
    if(amap.containskey('priceprot')){ PRT.Requested_Price_Protection__c = amap.get('priceprot'); }
    if(amap.containskey('ReasonCode')){ PRT.Reason_Code__c = amap.get('ReasonCode'); }
    if(amap.containskey('comments')){ PRT.comments__c = amap.get('comments'); }
    if(amap.containskey('pricetype')){ PRT.type__c = amap.get('pricetype'); }
    if(amap.containskey('freightval'))
    { system.debug('freight is:'+amap.get('freightval'));PRT.Freight_Terms__c = amap.get('freightval'); }
    system.debug('appcomments key:'+amap.containskey('appcomments'));
    system.debug('get appcomments:'+amap.get('appcomments'));
    if(amap.containskey('appcomments')){ 
    system.debug('inside appcomments');
    PRT.Approval_Rejection_Comments__c = amap.get('appcomments'); }
    if(amap.containskey('coordcomments')){ PRT.Coordinator_Comments__c = amap.get('coordcomments'); }
    
   if(amap.containskey('freightval')){
        DefaultFreight = PRT.Freight_Terms__c;
        if(DefaultFreight.contains('No Change') || DefaultFreight == null)
           PRT.Freight_Terms__c = am.Freight_Terms__c;
    }
    system.debug('PriceType is:'+amap.get('pricetype'));
    if(amap.get('pricetype') == 'RFQ'){
    if(amap.containskey('application')){ PRT.Application__c = amap.get('application'); }
    if(amap.containskey('pacCode')){ PRT.PAC_Code__c = amap.get('pacCode'); }
    if(amap.containskey('oem')){ PRT.OEM__c = amap.get('oem'); }
    if(amap.containskey('SpecifiedMaterial')){ PRT.Specified_Material__c = amap.get('SpecifiedMaterial'); }
    if(amap.containskey('ExistingBusiness')){ PRT.Existing_Business_for_Customer__c = amap.get('ExistingBusiness'); }
    if(amap.containskey('CompetitiveProducer')){ PRT.Competitive_Producer__c = amap.get('CompetitiveProducer'); }
    if(amap.containskey('competitivegrade')){ PRT.Competitive_Grade__c = amap.get('competitivegrade'); }
    if(amap.containskey('estanualVol')){ PRT.Estimated_Annual_Volume__c = stringtodouble(amap.get('estanualVol')); }
    if(amap.containskey('estanualUom')){ PRT.Estimated_Annual_Volume_UOM__c = amap.get('estanualUom'); }    
}
    
    if(amap.containskey('edatenext')){System.debug('!@Contains edatenext');}
    if(amap.containskey('effdatenext')){System.debug('!@Contains effdatenext'+datetime.newinstance(long.valueof(amap.get('effdatenext'))).dategmt());}
    if(amap.containskey('exdatenext')){System.debug('###########################');}
    
    /*Check if other date fields are available in form*/
    if(amap.containskey('effdatenext') && amap.containskey('exdatenext') )
    
    {
        System.debug(' enters if condition!!!!!!!!!!!');
        cspFlag = True;
        System.debug('!!!!effdatenext'+amap.get('effdatenext'));
        //System.debug('!!!!effdatenext'+long.valueof(amap.get('effdatenext'))); 
        PRT.additional_dates__c = 'Yes';
        if(amap.containskey('effdatenext')){ 
        PRT.Requested_Effective_Datenext__c = datetime.newinstance(long.valueof(amap.get('effdatenext'))).dategmt();
        system.debug('testing requested next: '+PRT.Requested_Effective_Datenext__c);
        system.debug('testing requested date: '+PRT.Requested_Effective_Date__c);
        }
        if(amap.containskey('exdatenext')){ PRT.Requested_Expiration_Datenext__c = datetime.newinstance(long.valueof(amap.get('exdatenext'))).dategmt(); system.debug('testing2 : '+PRT.Requested_Expiration_Datenext__c);}
        if(amap.containskey('bracketvolumenext_0')){ PRT.Requested_Volumenext__c = stringtodouble(amap.get('bracketvolumenext_0')); }
        //if(amap.containskey('brvoluomnext')){ PRT.Requested_UoM__c = amap.get('brvoluomnext'); }
        if(amap.containskey('bracketpricenext_0')){ PRT.Requested_Pricenext__c = stringtodouble(amap.get('bracketpricenext_0')); }
          
    }else{
        PRT.additional_dates__c = 'No';
    }
    
    List<SAP_Price_Tier__c> Requested = new List<SAP_Price_Tier__c>();
    List<SAP_Price_Tier__c> CSPs = new List<SAP_Price_Tier__c>();
    List<SAP_Price_Tier__c> targets = new List<SAP_Price_Tier__c>();
    
    //If there are no CSP Tier present for Account Material
    if(response.tbl_CSP_prices.size() == 0)
    {   string priceprot = '';
        priceprot = PRT.Requested_Price_Protection__c;
        string drumdepo = '';
        drumdepo = PRT.Requested_Drum_Deposit__c ;
        if(priceprot != null)
          if(priceprot.contains('Default'))
             PRT.Requested_Price_Protection__c = 'Z0 - No Protection';
          
        if(drumdepo != null) 
          if(drumdepo.contains('Default'))
             PRT.Requested_Drum_Deposit__c = 'No';
    }
             
    for(integer i=0; i<response.tbl_CSP_prices.size(); i++)       
          {
             CSP_JSON_Response.tbl_CSP_prices CSP = response.tbl_CSP_prices.get(i);
             SAP_Price_Tier__c t = new SAP_Price_Tier__c();
             if(csp.csp_price != '')
               t.Price__c = stringtodouble(CSP.csp_price);
             if(csp.csp_volume != '')
               t.Volume__c = stringtodouble(csp.csp_volume);
             if(csp.csp_currency != null){
               if(csp.csp_currency.length() > 3)
                   t.CurrencyIsoCode = csp.csp_currency.substring(0,3);
               else
                   t.currencyIsoCode = csp.csp_currency;
             t.SAP_Currency__c = csp.csp_currency;}
                
             if(csp.csp_price_unit != '')
               t.Price_Unit__c = stringtodouble(csp.csp_price_unit);
             if(csp.csp_uom != '')
                t.price_uom__c = csp.csp_uom; 
             if(csp.csp_scale_uom != '')
                t.volume_uom__c = csp.csp_scale_uom;             
                  
             if(csp.csp_expiration_date != '' && !csp.csp_expiration_date.contains('9999'))
             { t.Expiration_Date__c = stringtodate(csp.csp_expiration_date);
             }
             if(csp.csp_effective_date != '' && !csp.csp_effective_date.contains('9999'))
             { t.Effective_Date__c = stringtodate(csp.csp_effective_date);      
             }

             t.price_protection_code__c = csp.csp_price_protection_code;
             t.price_protection_desc__c = csp.csp_price_protection_desc;
             
             string priceprot = '';
             priceprot = PRT.Requested_Price_Protection__c;
             string drumdepo = '';
             drumdepo = PRT.Requested_Drum_Deposit__c ;
        
             if((t.price_protection_code__c != null || t.price_protection_desc__c != '') && i == 0)
               if(PRT.Requested_Price_Protection__c != null)
                 if(priceprot.contains('Default'))
                    PRT.Requested_Price_Protection__c= t.price_protection_code__c + ' - ' + t.price_protection_desc__c;
             
             if((t.price_protection_code__c == null || t.price_protection_desc__c == '') && i == 0)
              if(PRT.Requested_Price_Protection__c != null)
                 if(priceprot.contains('Default'))
                    PRT.Requested_Price_Protection__c='Z0 - No Protection';
              
             t.drum_deposit_code__c = csp.csp_drum_deposit_code;
             
             if((t.drum_deposit_code__c!= null || t.drum_deposit_code__c!= '') && i == 0)
               if(PRT.Requested_Drum_Deposit__c!= null)
                 if(drumdepo.contains('Default'))
                    PRT.Requested_Drum_Deposit__c= 'Yes';
             
             if((t.drum_deposit_code__c== null || t.drum_deposit_code__c== '') && i == 0)
              if(PRT.Requested_Drum_Deposit__c!= null)
                 if(drumdepo.contains('Default'))
                    PRT.Requested_Drum_Deposit__c ='No';
                    
                    
             t.Condition_Number__c = csp.csp_condition_nbr;
             if(t.effective_date__c != null || t.expiration_date__c != null || t.volume__c != null || t.price__c != null)
             CSPs.add(t);
          }
    PRT.CSP_Tiers__c = JSON.serialize(CSPs);
    for(CSP_JSON_Response.tbl_target_prices target:response.tbl_target_prices) 
          {         
             SAP_Price_Tier__c t = new SAP_Price_Tier__c();
             if(target.target_price != null && target.target_price != '')
             t.Price__c = stringtodouble(target.target_price);
             if(target.tier_volume != null && target.tier_volume != '')
             t.Volume__c = stringtodouble(target.tier_volume);
             if(target.target_price_currency != null){
               if(target.target_price_currency.length() > 3)
                 t.CurrencyIsoCode = target.target_price_currency.substring(0,3);
               else
                 t.currencyisocode = target.target_price_currency;
               t.SAP_Currency__c = target.target_price_currency;}
             t.Price_UoM__c =  target.target_price_uom;
             if(target.target_price_unit != null && target.target_price_unit != '')
             t.price_unit__c = stringtodouble(target.target_price_unit);
             t.volume_uom__c = target.target_scale_uom;
             if(target.exception1_price != null && target.exception1_price != '')
                t.exception_1_Price__c = stringtodouble(target.exception1_price);
             if(target.exception2_price != null && target.exception2_price != ''){
                t.exception_2_Price__c = stringtodouble(target.exception2_price);
                System.debug('@@exception_2_Price__c'+t.exception_2_Price__c);
                
             }
             if(target.total_target_price != null && target.total_target_price != '')
                t.total_target_price__c = stringtodouble(target.total_target_price);
             String dpl_currency = '';
             if(target.dpl_price_currency != null)
             if(target.dpl_price_currency.length() > 3)
                 dpl_currency = target.dpl_price_currency.substring(0,3);
               else
                 dpl_currency = target.dpl_price_currency;
             if(target.dpl_price != null && target.dpl_price != '' && dpl_currency != '' )
               t.dpl_price__c = convertcurrency(stringtodouble(target.dpl_price), dpl_currency , t.currencyisocode, currencymap);
               
             if(target.dpl_price_unit != null && target.dpl_price_unit != '')
                t.dpl_Price_unit__c = stringtodouble(target.dpl_price_unit);
             if(target.dpl_price_uom != null && target.dpl_price_uom != '')
                t.dpl_Price_uom__c = target.dpl_price_uom;
             
             if(t.price__c != null && t.price_Uom__c != null)
             targets.add(t);          
           }
    PRT.target_tiers__c = JSON.serialize(targets);
    
    if(amap.containskey('formtype'))
    { system.debug('formtype: ' + amap.get('formtype'));
    if(amap.get('formtype') == 'create' || amap.get('formtype') == 'simulate' || amap.get('formtype') == 'savesubmit' )
    {
       
       for(integer i=0; i<tiercount; i++)  {
            SAP_Price_Tier__c t = new SAP_Price_Tier__c();
            t.effective_date__c = PRT.Requested_Effective_Date__c;
            t.expiration_date__c = PRT.Requested_Expiration_Date__c;
            t.Volume__c = stringtodouble(amap.get('bracketvolume_' + i));
            if(amap.containskey('currency'))     
            if(amap.get('currency') != '' && amap.get('currency') != null){
                if((amap.get('currency')).length()>3)
                    t.currencyisocode = (amap.get('currency')).substring(0,3);
                else
                  t.currencyisocode = amap.get('currency');
            t.SAP_Currency__c = amap.get('currency');}
            if(amap.containskey('brvoluom'))     
               if(amap.get('brvoluom') != '' && amap.get('brvoluom') != null)
                  t.Volume_UoM__c = amap.get('brvoluom');
            if(amap.containskey('brpriceuom'))     
               if(amap.get('brpriceuom') != '' && amap.get('brpriceuom') != null)
                  t.Price_UoM__c = amap.get('brpriceuom');
            if(amap.get('bracketprice_' + i) != '' && amap.get('bracketprice_' + i) != null){
                  t.Price__c = stringtodouble(amap.get('bracketprice_' + i));
                  t.Req_Price__c = amap.get('bracketprice_' + i);
                  System.debug('!! t.Price__c 1st:'+t.Price__c); 
            }              
            requested.add(t);
           
       }
       
       for(integer i=0; i<tiercountnext; i++)  
       {  
            SAP_Price_Tier__c t = new SAP_Price_Tier__c();
          
            t.effective_date__c = PRT.Requested_Effective_Datenext__c;
            t.expiration_date__c = PRT.Requested_Expiration_Datenext__c;
            t.Volume__c = stringtodouble(amap.get('bracketvolumenext_' + i));
            if(amap.containskey('currency'))     
               if(amap.get('currency') != '' && amap.get('currency') != null){
                   if((amap.get('currency')).length() > 3)
                      t.currencyisocode = (amap.get('currency')).substring(0,3);
                   else
                      t.currencyisocode = amap.get('currency');
               t.SAP_Currency__c = amap.get('currency');}
            System.debug('t.effective_date__c'+t.effective_date__c);
            System.debug('t.expiration_date__c'+t.expiration_date__c);
            if(amap.containskey('brvoluom'))     
               if(amap.get('brvoluom') != '' && amap.get('brvoluom') != null)
                  t.Volume_UoM__c = amap.get('brvoluom');
            if(amap.containskey('brpriceuom'))     
               if(amap.get('brpriceuom') != '' && amap.get('brpriceuom') != null)
                  t.Price_UoM__c = amap.get('brpriceuom');
            System.debug('!!bracket price new:'+amap.get('bracketpricenext_' + i));
            if(amap.get('bracketpricenext_' + i) != '' && amap.get('bracketpricenext_' + i) != null){
               t.Price__c = stringtodouble(amap.get('bracketpricenext_' + i));
               t.Req_Price__c = amap.get('bracketpricenext_' + i);
               System.debug('!! t.Price__c new:'+t.Price__c);     
            }
            requested.add(t);
        }
            
        
       system.debug('Requested: ' + requested);
     }
     else if(amap.get('formtype') == 'adjust')
     {
        date preveffdate = null;
        system.debug('csp size: ' + csps.size());
        for(integer i=0; i< CSPs.size(); i++)
        {
            SAP_Price_Tier__c spt = CSPs.get(i);
            system.debug('PRT Requestted Eff Date: ' + PRT.Requested_Effective_Date__c);
            system.debug('SPT Effective Date: ' + spt.effective_Date__c);
            system.debug(PRT.Requested_Effective_Date__c);
            system.debug('SPT Exp Date: ' + spt.expiration_date__c);
            system.debug('prefeffdate: ' + preveffdate);
            system.debug(PRT.Requested_Effective_Date__c >= spt.effective_date__c);
            system.debug(PRT.Requested_Effective_Date__c <= spt.expiration_date__c || spt.expiration_date__c == null);
            system.debug(spt.effective_date__c == preveffdate || preveffdate == null);
            //if(PRT.Requested_Effective_Date__c >= spt.effective_date__c &&
              // (spt.effective_date__c == preveffdate || preveffdate == null))
            if(PRT.Requested_Effective_Date__c >= spt.effective_date__c && 
                (PRT.Requested_Effective_Date__c <= spt.expiration_date__c || spt.expiration_date__c == null ))
            {
            preveffdate = spt.effective_date__c;
            
            SAP_Price_Tier__c t = new SAP_Price_Tier__c(); 
            t.effective_date__c = PRT.Requested_Effective_Date__c;
            t.expiration_date__c = PRT.Requested_Expiration_Date__c;        
            if(amap.containskey('currency'))     
               if(amap.get('currency') != '' && amap.get('currency') != null){
                if((amap.get('currency')).length() > 3)  
                  t.currencyisocode = (amap.get('currency')).substring(0,3);
                else
                  t.currencyisocode = amap.get('currency');
               t.SAP_Currency__c = amap.get('currency');}
            if(amap.containskey('brpriceuom'))     
               if(amap.get('brpriceuom') != '' && amap.get('brpriceuom') != null)
                  t.Price_UoM__c = amap.get('brpriceuom');
               
            if(amap.get('upordown') == 'Increase' && amap.get('bracketprice') != null)
                  t.Price__c = stringtodouble(amap.get('bracketprice')) + convertunits(conversionmap, stringtodouble(spt.price__c), spt.price_uom__c,  t.price_uom__c, true);
            if(amap.get('upordown') == 'Decrease' && amap.get('bracketprice') != null)
                  t.Price__c = convertunits(conversionmap, stringtodouble(spt.price__c), spt.price_uom__c,  t.price_uom__c, true) - stringtodouble(amap.get('bracketprice'));
            if(PRT.price__c == null){
                  PRT.price__c = t.price__c;
                  //t.Req_Price__c = String.valueOf(t.price__c);
                  }
            if((t.SAP_Currency__c).contains('4'))
               t.Req_Price__c = String.valueOf(t.Price__c.setscale(4));
            else
              t.Req_Price__c = String.valueOf(t.Price__c.setscale(2));
            t.volume__c = spt.volume__c;
            t.volume_uom__c = spt.volume_uom__c;
            requested.add(t);
            } 
        system.debug('Requested: ' + requested);
        }
      }   
     }
     

     
     boolean isfirst = true;
     for(SAP_Price_Tier__c r: requested)
 {
      if(PRT.id == null)
        PRT.Approval_Status__c = 'Submitted';
        
      boolean AutoApprove = true;
      boolean exception1 = false;
      boolean exception2 = false;

           double mytargetprice = 0;
           double mytargetvol = 0;
           string mytargetvoluom = '';
           double mytargetunit = 0;
           double myexception1 = 0;
           double myexception2 = 0;

           integer ind = 0;
           double nexttvolconverted = 0;
           
           if(requested.size() == 1 && ams.size() > 1 &&
             (PRT.quantity__c!= null || PRT.average_order_qty__c != null))
             { 
               if(PRT.quantity__c != null)
               { mytargetvoluom = PRT.Estimated_Order_Qty_UoM__c;
                 mytargetvol = PRT.quantity__c;
               }
               else if(PRT.average_order_qty__c != null)
               { mytargetvoluom = PRT.average_Order_Qty_UoM__c;
                 mytargetvol = PRT.average_order_qty__c;
               }
               if(conversionmap.containskey(mytargetvoluom) && conversionmap.containskey(r.volume_uom__c))
               {
                double denom = conversionmap.get(mytargetvoluom);
                Double baseunit = 0;
                if(denom != 0)
                  baseunit = mytargetvol * conversionmap.get(mytargetvoluom);
                mytargetvol = (baseunit / conversionmap.get(r.volume_uom__c));
                mytargetvoluom = r.volume_uom__c;
                 //system.debug('One Tier1: mytargetvol: ' + mytargetvol + 'mytargetvoluom: ' + mytargetvoluom);
               }
             } 
           else if(requested.size() == 1 && ams.size() == 1)
             { mytargetvoluom = PRT.Estimated_Order_Qty_UoM__c;
               mytargetvol = PRT.quantity__c;
               //system.debug('One Tier2-1: mytargetvol: ' + mytargetvol + 'mytargetvoluom: ' + mytargetvoluom);
               if(conversionmap.containskey(mytargetvoluom) && conversionmap.containskey(r.volume_uom__c))
               {
                double denom = conversionmap.get(mytargetvoluom);
                Double baseunit = 0;
                if(denom != 0)
                  baseunit = mytargetvol * conversionmap.get(mytargetvoluom);
                mytargetvol = (baseunit / conversionmap.get(r.volume_uom__c));
                mytargetvoluom = r.volume_uom__c;
                 //system.debug('One Tier2: mytargetvol: ' + mytargetvol + 'mytargetvoluom: ' + mytargetvoluom);
               }
             }            
             else
             { 
                //system.debug('Multiple Tiers: mytargetvol: ' + mytargetvol + 'mytargetvoluom: ' + mytargetvoluom);
               mytargetvoluom = r.volume_uom__c;
               mytargetvol = r.volume__c;
             }
       
       double tconverted = 0;
       double tvolconverted = 0;
       decimal TPI = 0;
for(integer i=0; i<targets.size(); i++)
     {
        SAP_Price_Tier__c t = targets.get(i);
             
        string tuom = t.price_uom__c;
        if(!conversionmap.containskey(tuom)){
            uomFlag = False;
        }
        string tcurr = t.currencyisocode;
        double tprice = t.price__c;
               
       double tvol = t.volume__c;
       string tvoluom = t.volume_uom__c;
       string ccurr = r.currencyisocode;
                    
       if(ccurr != '' && ccurr != null)
           tconverted = ConvertCurrency(stringtodouble(tprice), tcurr, ccurr, currencymap);
             
             if(conversionmap.containskey(tvoluom) && conversionmap.containskey(r.price_uom__c))
             {
                
                Double baseunit = tvol * conversionmap.get(tvoluom);
                tvolconverted = (baseunit / conversionmap.get(r.volume_uom__c));
                // system.debug('convert: ' + tvol + ' ' + tvoluom + ' TO ' + tvolconverted + ' ' + r.volume_uom__c); 
                if(i < targets.size()-1)
                {
                  baseunit = stringtodouble(targets.get(i+1).volume__c)* conversionmap.get(tvoluom);
                  nexttvolconverted = (baseunit / conversionmap.get(r.volume_uom__c));
                }
             }
             system.debug('tuom : '+tuom);
             system.debug('conversionmap : '+conversionmap);
             system.debug('conversionmap.containskey(tuom) : '+conversionmap.containskey(tuom));
             system.debug('conversionmap.containskey(tuom) : '+conversionmap.containskey(tuom.trim()));
             system.debug('conversionmap.containskey(r.price_uom__c) : '+conversionmap.containskey(r.price_uom__c));
             system.debug('Mytargetvol: ' + MyTargetVol + ' tvolconverted: ' + Math.roundtolong(tvolconverted) + 'nexttvolconverted: '+Math.roundtolong(nexttvolconverted) + 'targets.size() : '+targets.size());
             if(conversionmap.containskey(tuom) && conversionmap.containskey(r.price_uom__c) &&
                (
                (mytargetvol >= Math.roundtolong(tvolconverted) && mytargetvol < Math.roundtolong(nexttvolconverted)) || 
                (i == 0 && mytargetvol <= Math.roundtolong(tvolconverted)) || 
                (i == targets.size()-1 && mytargetvol >= Math.roundtolong(tvolconverted) )
                )
               )
              {
                 system.debug('MyTargetVol inside: ' + mytargetvol + ' ' + mytargetvoluom + ' tvolconverted: ' + tvolconverted+ ' ' + tvoluom);
                double h = tconverted;
                Double baseunit = tconverted / conversionmap.get(tuom);
                tconverted = (baseunit * conversionmap.get(r.price_uom__c));
                 
                mytargetprice = tconverted;
                mytargetvol = tvolconverted;
                mytargetunit = t.price_unit__c;
                r.dpl_price__c = t.dpl_price__c;
                r.dpl_price_uom__c = t.dpl_price_uom__c;
                
                // system.debug('****got here****' + t.price_unit__c);
               
                if(t.Exception_1_price__c != null)
                { 
                  myexception1 = convertcurrency(stringtodouble(t.Exception_1_Price__c), t.currencyisocode, r.currencyisocode, currencymap);
                  
                  if(t.price_uom__c != r.price_uom__c){
                  baseunit = stringtodouble(t.Exception_1_Price__c) / conversionmap.get(t.price_uom__c);
                  myexception1 = (baseunit * conversionmap.get(r.price_uom__c)); }
                }
                if(t.exception_2_price__c != null)
                {
                  myexception2 = convertcurrency(stringtodouble(t.Exception_2_Price__c), r.currencyisocode, t.currencyisocode, currencymap); 
                  
                  if(t.price_uom__c != r.price_uom__c){
                  baseunit = stringtodouble(t.Exception_2_Price__c) / conversionmap.get(t.price_uom__c);
                  myexception2 = (baseunit * conversionmap.get(r.price_uom__c)); }            
                }
                
                system.debug('Price:'+stringtodouble(r.price__c));
                
                if(tconverted != 0 && r.price__c!= null)
                  tpi = decimal.valueof((stringtodouble(r.price__c) / tconverted)*100).setscale(2);
              }
           }
          
           if(r.dpl_price__c != null && r.dpl_price_uom__c != '' && r.dpl_price_uom__C != null)
           {
                  double baseunit = stringtodouble(r.dpl_Price__c) / conversionmap.get(r.dpl_price_uom__c);
                  r.dpl_price__c = (baseunit * conversionmap.get(r.price_uom__c));
                  r.dpl_price_uom__c = r.price_uom__c;            
           }  
           r.target_tier_price__c = mytargetprice;
           r.target_tier_price_unit__c = mytargetunit;
           r.target_Tier_Price_uom__c = r.price_uom__c;
           r.exception_1_price__c = myexception1;
           r.exception_2_price__C = myexception2;
           r.tpi__c = tpi;
           
           
           if((tpi > 0 && tpi <= 10) || (tpi > 200))
               PRT.TPI_below_threshold__c = true;
           
               
           if(isfirst)
           PRT.TPI__c = tpi; 
           isfirst = false;
    }
     PRT.Requested_Tiers__c = JSON.serialize(requested);
     
     if(CMflag == true){
     List<SAP_Price_Tier__c> CM_spt = new List<SAP_Price_Tier__c>();
     Date dtoday = system.today();
     for(SAP_Price_Tier__c r: requested)
     {
         //if(dtoday >= r.effective_date__c && dtoday <= r.expiration_date__c)
          if(PRT.Requested_Effective_Date__c == r.effective_date__c && PRT.Requested_Expiration_Date__c == r.expiration_date__c)
             CM_spt.add(r); 
     }
     PRT.CM_Flag__c = true;
     List<CM_JSON_Request_Item> CM_Requests = new List<CM_JSON_Request_Item>();
         string materialnumber = am.SAP_Material__r.material_number__c;
           if(materialnumber != '' && materialnumber != null)
              materialnumber = materialnumber.replace('G2', '');
         String SoldToNumber = '';
           if(am.Account__r.SAP_Sold_To_Account__c != null && am.Account__r.SAP_Sold_To_Account__c != '')
              SoldToNumber = am.Account__r.SAP_Sold_To_Account__c.substringBefore(' - ');
         Double Quantity=0;
         string Sales_unit;
         system.debug('formtype is:'+amap.get('formtype'));
         if(amap.get('formtype') == 'adjust'){
             quantity = stringtodouble(PRT.Average_Order_Qty__c);
             Sales_unit = am.Avg_Order_Qty_Uom__c; }
         else{
             quantity = stringtodouble(PRT.Quantity__c);
             Sales_unit = PRT.Estimated_Order_Qty_UoM__c; }
         system.debug('CM Quantity is:'+CM_spt.size()+'::'+quantity);
         
         
         string priceUoM = CM_spt.get(0).price_uom__c;
         Double price=0;
         if(CM_spt.size() == 1)
            price = CM_spt.get(0).price__c;
         else{
                for(integer i=1; i<=CM_spt.size(); i++){
                if(price == 0){
                if(i==CM_spt.size() && quantity >= CM_spt.get(i-1).volume__c)
                    price = CM_spt.get(i-1).price__c;
                if(i<CM_spt.size() && quantity >= CM_spt.get(i-1).volume__c && quantity < CM_spt.get(i).volume__c)
                    price = CM_spt.get(i-1).price__c;
                 }
                }
         }
         system.debug('CM Price is:'+price);    
         
         string sfdc_account_Id; 
         string sfdc_material_Id;
         CM_JSON_Request_Item cm = new CM_JSON_Request_Item(am.Account__r.accountnumber, SoldToNumber, materialnumber, quantity, Sales_unit, price, priceUoM, PRT.currencyisocode, am.SAP_Plant_Code__c, am.id, sfdc_material_Id, am.Account_Sales_Org_Code__c, am.Account__r.SAP_DistChannel__c,am.Account_Division_Code__c, (PRT.freight_terms__c).substring(0,3));
         //CM_JSON_Request_Item cm = new CM_JSON_Request_Item(am.Account__r.accountnumber, SoldToNumber, materialnumber, quantity, Sales_unit, price, priceUoM, PRT.CSP_Currency__c, am.SAP_Plant_Code__c, am.id, sfdc_material_Id, am.Account_Sales_Org_Code__c, am.Account__r.SAP_DistChannel__c,am.Account_Division_Code__c, (PRT.freight_terms__c).substring(0,3));
         string serializedCM = JSON.serialize(cm);
         system.debug('CM request is:'+serializedCM);
         CM_Requests.add(cm);
         List<CM_JSON_Response> CM_Responses = CSP_JSON_Request.submit_Request_cm(CM_Requests);
         
          for(CM_JSON_Response c:CM_Responses)
          {
              if(c.price_support != null && c.price_support != '')
                  PRT.Price_Support_Rebate__c = stringtodouble(c.price_support);
              else
                  PRT.Price_Support_Rebate__c = 0;
              if(c.ic_charge != null && c.ic_charge != '')
                  PRT.IC_Charge__c = stringtodouble(c.ic_charge);
              else 
                  PRT.IC_Charge__c = 0;
              if(c.add_charge != null && c.add_charge != '')
                  PRT.Additional_Charges__c = stringtodouble(c.add_charge);
              else 
                  PRT.Additional_Charges__c = 0;
              if(c.mat_cost != null && c.mat_cost != '')
                  PRT.Material_Cost__c = stringtodouble(c.mat_cost);
              else
                  PRT.Material_Cost__c = 0;
              if(c.warehouse_charge != null && c.warehouse_charge != '')
                  PRT.Variable_Warehouse__c = stringtodouble(c.warehouse_charge);
              else
                  PRT.Variable_Warehouse__c = 0;
              if(c.freight_charge != null && c.freight_charge != '')
                  PRT.Variable_Delivery__c = stringtodouble(c.freight_charge);
              else 
                  PRT.Variable_Delivery__c = 0;
              if(c.revenue != null && c.revenue != '')
                  PRT.CM_Revenue__c = stringtodouble(c.revenue);
              else 
                  PRT.CM_Revenue__c = 0;
              if(c.contrib_margin != null && c.contrib_margin != '')
                  PRT.Contribution_Margin__c = stringtodouble(c.contrib_margin);
              else 
                  PRT.Contribution_Margin__c = 0;
              if(c.unit_cm != null && c.unit_cm != '')
                  PRT.Unit_Contribution_Margin__c = stringtodouble(c.unit_cm);
              else 
                  PRT.Unit_Contribution_Margin__c = 0;
              if(c.unit_mat_cost != null && c.unit_mat_cost != '')
                  PRT.Unit_Material_Cost__c = stringtodouble(c.unit_mat_cost);
              else 
                  PRT.Unit_Material_Cost__c = 0;
              if(c.unit_warehouse_chg != null && c.unit_warehouse_chg != '')
                  PRT.Unit_Warehouse_Charge__c = stringtodouble(c.unit_warehouse_chg);
              else 
                  PRT.Unit_Warehouse_Charge__c = 0;
              if(c.unit_freight_chg != null && c.unit_freight_chg != '')
                  PRT.Unit_Freight_Charge__c = stringtodouble(c.unit_freight_chg);
              else 
                  PRT.Unit_Freight_Charge__c = 0;
              if(c.cm_percent != null && c.cm_percent != '')
                  PRT.CM_Percent__c = stringtodouble(c.cm_percent);
              else 
                  PRT.CM_Percent__c = 0;
                  
              PRT.CM_Message__c = c.message;
              PRT.CM_Status__c = c.status;
              PRT.CM_Quantity_Sent__c = stringtodouble(c.quantity);
              PRT.CM_Price_Sent__c = stringtodouble(c.price);
              
              double revenue;
              double CM_Percent;
              double CM_Val;    
              //if(c.price_support != '' && c.ic_charge != '' && c.add_charge != '' && c.mat_cost != '' && c.warehouse_charge != '' && c.freight_charge != '')
              /*if(c.price != '')
              {    revenue = PRT.CM_Price_Sent__c + PRT.Price_Support_Rebate__c + PRT.IC_Charge__c + PRT.Additional_Charges__c;
                   CM_Val = revenue - (PRT.Material_Cost__c + PRT.Variable_Warehouse__c + PRT.Variable_Delivery__c);
                   CM_Percent = (CM_Val / revenue) * 100;
                   PRT.CM_Percent__c = Decimal.valueof(CM_Percent).setscale(2);
              }
              else
                  PRT.CM_Percent__c = 0;*/
               
          }
           
     }     
     else 
         PRT.CM_Flag__c = false;
              
     if(amap.get('pricetype') != null && amap.get('pricetype') != '')
         fetchsimulatewindow(PRT,uomFlag,CMflag);
     transactions.add(PRT);
     system.debug('PRT Record is:'+transactions);
   }
   Map<String, String> approver_map = new Map<String, String>();
   if(amap.get('psr') == 'psr')
       approver_map.put(transactions[0].account_material__c, 'Auto-Approved;' + userinfo.getuserid()) ;
   else
       approver_map = Price_Request_Approval_Functions.FetchApproverMap(transactions);
   Map<Id, Account> accmap = new Map<id, Account>([select id from Account where id IN :aids]);
   Map<Id, User> User_map = new map<Id, User>([select id, name from user where isactive = true limit 10000]);
   for(Price_Request_Transaction__c prt:transactions)
    {
      String s = Approver_Map.get(prt.Account_material__c);
      if(accmap.containskey(prt.Account_Material__r.Account_Sold_To_Id__c))
        prt.Sold_To__c = accmap.get(prt.Account_Material__r.Account_Sold_To_Id__c).id;
      if(accmap.containskey(prt.Account_material__r.Account_Corp_Account_Id__c))
        prt.Corporate_Account__c = accmap.get(prt.Account_Material__r.Account_Corp_Account_Id__c).id;
      List<String> sl = s.split(';');
      if(sl.get(0) == 'Catch All')
      { 
        prt.Approval_Level__c = sl.get(0);
        prt.Approver__c = null;
        prt.Approval_Backup__c = null;  
      }
      else if(sl.get(0) == 'Auto-Approved')
      { 
        prt.Approval_Level__c = sl.get(0);
        prt.Approver__c = userinfo.getuserid();
        system.debug('user_map.get(userinfo.getuserid()'+user_map.get(userinfo.getuserid()));
        prt.Approver__r = user_map.get(userinfo.getuserid());
        prt.Approval_Backup__c = null;  
      }
      else
      {
        prt.Approval_Level__c = sl.get(0);
        if(user_map.containskey(sl.get(1)))
        {
          prt.Approver__c = sl.get(1);
          prt.approver__r = user_map.get(sl.get(1));
        }
        else
        {
          prt.Approval_Level__c = 'Catch All';
          prt.Approver__c = null;
          prt.Approval_Backup__c = null;        
        }
        if(sl.get(2) != prt.approver__c && user_map.containskey(sl.get(2)))
        {
          prt.approval_backup__r = user_map.get(sl.get(2));
          prt.Approval_Backup__c = sl.get(2);
        }
        else
          prt.Approval_Backup__c = null;
      }
    }
system.debug(transactions);
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getTransactions', 757);
return transactions;
}
Public Static List<Account_Material__c> getAccountMaterialsFromAccounts(List<String> aids){
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getAccountMaterialsFromAccounts', 761);
    List<Account> sh = [select id from Account where id IN :aids];
    List<Account> so = [select id from Account where SAP_Sold_To_Account_Id__c IN :aids];
    List<Account> corp = [select id from Account where SAP_Corporate_Account_Id__c IN :aids];
    String q = 'select id, Material__c,Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Competitor__c,  Competitor__r.name, Material_Supplier_Name__c, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account__r.Owner_Name__c, Account__r.owner.managerid, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Account__r.accountnumber, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Account__r.SAP_Sold_To_Account__c, SAP_Material__r.Material_Number__c, Material_Segment__c, Material_SubSegment__c, SAP_Material__r.name, Material_Base_Code__c,Account__r.sap_salesgroup__c, Account__r.SAP_DivisionCode__c,';
         q += 'Account__r.Name, Account__c, Target_Tier_UoM__c,Target_UoM__c,PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Sold_To__c, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,SAP_Material__r.Material_Group2_Code__c, SAP_Material__r.material_group4_code__c, ';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  SAP_Data__c, SAP_Data_Refreshed_Text__c, CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Supplier__c, Container_for_new_material__c,Material_Description__c, Prospect_Material__c, Plant_Name__c, Account_Sap_Plant__c, Plant_Code__c, SAP_Plant_Code__c, Material_Group_3__c ';
         q += 'from Account_Material__c where (Account__c IN :sh OR (Account_Sold_To_Id__c IN :aids and Account__c IN :so) or (Account_Corp_Account_Id__c IN :aids and Account__c IN :corp)) order by Account__r.name, SAP_Material__r.name ';
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getAccountMaterialsFromAccounts', 770);
         return database.query(q);

}
Public Static List<Account_Material__c> getAccountMaterials(List<String> amids){
    
    String q = 'select id, Material__c,Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Competitor__c,  Competitor__r.name, Material_Supplier_Name__c, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account__r.Owner_Name__c, Account__r.owner.managerid, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Account__r.accountnumber, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Account__r.SAP_Sold_To_Account__c, SAP_Material__r.Material_Number__c, Material_Segment__c, Material_SubSegment__c, SAP_Material__r.name, Material_Base_Code__c,Account__r.sap_salesgroup__c, Account__r.SAP_DivisionCode__c,';
         q += 'Account__r.Name, Account__r.SAP_Customer_Group_5__c, Account__r.SAP_DistChannel__c,Account__r.SAP_Business_Partner_Customer_Number__c, Account__r.Owner.SAP_Cust_Num__c, Account__c, Target_Tier_UoM__c,Target_UoM__c,PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Sold_To__c, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,SAP_Material__r.Material_Group2_Code__c, SAP_Material__r.material_group4_code__c, ';
         q += ' CSP__c, Division_Desc__c, CSP_Currency__c, CSP_Effective_Date__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  SAP_Data__c, SAP_Data_Refreshed_Text__c, CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c ,Supplier__c,Container_for_new_material__c,Material_Description__c, Prospect_Material__c, created_from_Cpi__r.sap_plant__r.Plant_Name__c, Plant_Name__c, Account_Sap_Plant__c, Plant_Code__c, SAP_Plant_Code__c, Material_Group_3__c, Freight_Terms__c ';
         q += 'from Account_Material__c where id in :amids order by Account__r.name, SAP_Material__r.name ';

         return database.query(q);

}
Public static List<Account_Material__c> getCPIs(List<String> list0, List<String> list1, List<String> list2, List<String> List3, List<String> List4, List<String> list5, List<String> list6,
                                                List<String> list7, List<String> list8, List<String> list9, List<String> List10, List<String> List11, list<string> list12, list<string> list13,
                                                List<String> List14, List<String> List15, List<String> List16, List<String> List17){
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getCPIs', 788);
    List<List<String>> values = new List<List<String>>();
    values.add(list0);
    values.add(list1);
    values.add(list2);
    values.add(list3);
    values.add(list4);
    values.add(list5);
    values.add(list6);
    values.add(list7);
    values.add(list8);
    values.add(list9);
    values.add(list10);
    values.add(list11);
    values.add(list12);
    values.add(list13);
    values.add(list14);
    values.add(list15);
    values.add(list16);
    values.add(list17);

    system.debug('values: ' + values);

    string q = 'select id, Material__c,Material_Division__c,UoMs__c, Account_Number__c, Account_City__c, CSP_UoM__c, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c,Account_Sales_Org_Code__c, Inner_table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account__r.Owner_Name__c, Account__r.Owner.managerid, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c, ';
    q += 'Material_Container_Code__c, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Account__r.accountnumber, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Account__r.SAP_Sold_To_Account__c, SAP_Material__r.Material_Number__c, Material_Segment__c, Material_SubSegment__c, SAP_Material__r.name, Material_Base_Code__c, ';
    q += 'Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Sold_To__c, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c, ';
    q += 'CSP__c, CSP_Effective_Date__c, CSP_Currency__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  SAP_Data__c, SAP_Data_Refreshed_Text__c, CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c ';
    q += 'from Account_Material__c where id != null';

  for(integer i=0; i<values.size(); i++)
  {  system.debug(values.get(i));
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_Owner_Id__c' )
       q += ' and Account__r.ownerid IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_Sales_Org__c' )
       q += ' and Account__r.SAP_Sales_Org__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_Division__c' )
       q += ' and Account__r.SAP_DivisionCode__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_Industry_Code__c' )
       q += ' and Account__r.SAP_Industry_Key__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_HQ_Sales_Office__c' )
       q += ' and Account__r.HQ_Sales_Office_Desc__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_SAP_Sales_Group__c' )
       q += ' and Account__r.SAP_SalesGroup_Desc__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_Sold_To_Owner_Id__c' )
       q += ' and Account_Sold_To_Owner_Id__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Material_Container_Code__c' )
       q += ' and Material_Container_Code__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Material_Group_1__c' )
       q += ' and Material_Group_1__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'PH4__c' )
       q += ' and PH4__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'PH5__c' )
       q += ' and PH5__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'PH6__c' )
       q += ' and PH6__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'PH7__c' )
       q += ' and PH7__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'SAP_Material__c' )
       q += ' and SAP_Material__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Material_Base__c' )
       q += ' and Material_Base__c IN :list' + i;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account_Sold_To_Id__c' )
       q += ' and (Account_Sold_To_Id__c IN :list' + i + ' and Account__c IN (select id from Account where Account_Sold_To_Id__c IN :list' + i + ') ' ;
     if(values.get(i).size() > 1 && values.get(i).get(0) == 'Account__c' )
       q += ' and Account__c IN :list' + i;
     
     if(values.get(i).get(0) == 'Id')
     {  
        if(values.get(i).size() > 1)
          q += ' and (NOT Id IN :list' + i + ')';    
     }
  }

  q += ' limit 600';
  system.debug(q);
  System.debug('Script Statements: ' + Limits.getLimitScriptStatements());
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getCPIs', 864);
  return database.query(q);
}

Public static List<CSP_JSON_Request_Item> getRequests(List<Integer> aiDisplayMaster, List<String> aids){
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getRequests', 869);
    List<CSP_JSON_Request_Item> SAP_Requests = new List<CSP_JSON_Request_Item>();
    List<Account_Material__c> toupdate = new List<Account_Material__c>();
    Map<String, Account_Material__c> amap = new Map<String, Account_Material__c>();
    
    String q = 'select id, Material__c,Material_Division__c,UoMs__c, Account_Number__c, Account_City__c, CSP_UoM__c, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account__r.Owner_Name__c, Account__r.owner.managerid, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Account__r.accountnumber, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Account__r.SAP_Sold_To_Account__c, SAP_Material__r.Material_Number__c, Material_Segment__c, Material_SubSegment__c, SAP_Material__r.name, Material_Base_Code__c,';
         q += 'Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Sold_To__c, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c, ';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  SAP_Data__c, SAP_Data_Refreshed_Text__c, CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c ';
         q += 'from Account_Material__c where id in :aids ';

    Map<Id, Account_material__c> ammap = new Map<Id, Account_Material__c>([select id, Material__c,Material_Division__c,Account_Number__c, Account_City__c, Account_Name__c, Account__r.Owner_Name__c, Account__r.owner.managerid, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,
         Material_Container_Code__c, Material_Product_Class__c, Account__r.accountnumber, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Account__r.SAP_Sold_To_Account__c, SAP_Material__r.Material_Number__c, Material_Segment__c, Material_SubSegment__c, SAP_Material__r.name, Material_Base_Code__c,
         Account__r.Name, iDisplayindex__c, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, Account_Sold_To__c, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c, 
         CSP__c, CSP_Effective_Date__c, CSP_Currency__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  SAP_Data__c, SAP_Data_Refreshed_Text__c, CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Account__r.SAP_Sales_Org__c, Account__r.SAP_DistChannel__c 
         from Account_Material__c where id in :aids]);
         
    for(integer i=0; i<aiDisplayMaster.size(); i++)      
    {
       Account_material__c m = ammap.get(aids.get(i));

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
       amap.put(m.id, m);
       }
       upsert ammap.values();

   //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getRequests', 915);
   Return SAP_Requests;

}



public static List<Account_material__c> getPricingRFQ(String materiaId, String acctMatId){

    system.debug('***************** '+materiaId);
    List<CSP_JSON_Request_Item> SAP_Requests = new List<CSP_JSON_Request_Item>();
    List<Account_Material__c> toupdate = new List<Account_Material__c>();
    Map<id, Account_Material__c> amap = new Map<id, Account_Material__c>();
    
String q = 'select id , Material__c,Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c,';
         q += ' Account__r.Name, Account__c,Competitor__c, Competitor__r.name, Material_Supplier_Name__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Unit__c, Target_UoM__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Supplier__c, Container_for_new_material__c,Material_Description__c, Prospect_Material__c ';
         q += 'from Account_Material__c where id = :acctMatId';

    Map<Id, Account_material__c> ammap = new Map<Id, Account_Material__c>([select id, iDisplayIndex__c, SAP_Data_Refreshed__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Material__r.material_number__c,
                                                 Account__r.SAP_Sold_To_Account__c, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, created_from_cpi__C, Account__r.accountnumber, 
                                                 SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account__r.SAP_Sales_Org__c, Account__r.SAP_DistChannel__c from Account_Material__c where id  = :acctMatId]);
    List<Material_Sales_Data2__c> maList = [select material_number__c,Sales_UOM__r.Alternative_UOM__c from Material_Sales_Data2__c where id = : materiaId];   
    for(account_material__c m:ammap.values())      
    {
       string materialnumber = maList[0].material_number__c;
       if(materialnumber != '' && materialnumber != null)
          materialnumber = materialnumber.replace('G2', '');
       String altUOM = maList[0].Sales_UOM__r.Alternative_UOM__c;
       
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
                                                   altUOM ,
                                                   m.id, 
                                                   '',
                                                   m.Account__r.SAP_Sales_Org__c,
                                                   m.Account__r.SAP_DistChannel__c);
       SAP_Requests.add(c);
       amap.put(m.id, m);
     }
     system.debug(SAP_Requests.size());
    //List<CSP_JSON_Response> SAP_Responses = new List<CSP_JSON_Response>();
    List<CSP_JSON_Response> SAP_Responses = CSP_JSON_Request.submit_Request_m(SAP_Requests);
    for(CSP_JSON_Response csp:SAP_Responses)
    {
      system.debug('Id: ' + csp.SFDC_Account_Id);
      if(amap.containskey(csp.SFDC_Account_Id))
      {
      Account_material__c a = amap.get(csp.SFDC_Account_Id); //Actually the Account_Material_Id
      a.SAP_Data_Refreshed__c = system.now();
      a.SAP_Material__c = materiaId;
      a.SAP_Data__c = JSON.serialize(csp);
      toupdate.add(a);
      system.debug('statement count: ' + Limits.getScriptStatements());
      }
      
    }
    update toUpdate;
      
      List<Account_material__c> ams = database.query(q);
      //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getPricing', 989);
      return ams;
}




Public Static Account_Material__c getPricing(string amid){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getPricing', 920);
  List<Account_Material__c> amlist = getPricing(new List<String>{'0'}, new List<String>{amid});
  
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getPricing', 923);
  if(amlist.size() > 0)
    return amlist.get(0);
  else
    return null;
}

public static List<Account_material__c> getPricing(List<String> aiDisplayMaster, List<String> aids){

   
    List<CSP_JSON_Request_Item> SAP_Requests = new List<CSP_JSON_Request_Item>();
    List<Account_Material__c> toupdate = new List<Account_Material__c>();
    Map<id, Account_Material__c> amap = new Map<id, Account_Material__c>();
    
String q = 'select id , Material__c,Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c,';
         q += ' Account__r.Name, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c, Freight_Terms__c,';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Unit__c, Target_UoM__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Supplier__c, Container_for_new_material__c,Material_Description__c, Prospect_Material__c, Account_with_SalesOrg__c, Price_Support_Indicator__c, Customer_Material_Number__c, Plant_Code__c, SAP_Plant_Code__c, Plant_Name__c, Account_SAP_Plant__c, Material_Group_3__c, Seller_Name__c   ';
         q += 'from Account_Material__c where id in :aids';

    Map<Id, Account_material__c> ammap = new Map<Id, Account_Material__c>([select id, iDisplayIndex__c, SAP_Data_Refreshed__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Material__r.material_number__c,
                                                 Account__r.SAP_Sold_To_Account__c, Competitor__c, Competitor__r.name, Material_Supplier_Name__c, created_from_cpi__C, Account__r.accountnumber, Account__r.id,Freight_Terms__c,
                                                 SAP_Material__r.Sales_UOM__r.Alternative_UOM__c, Account__r.SAP_Sales_Org__c, Account__r.SAP_DistChannel__c from Account_Material__c where id in :aids and Account__r.id!=null]);
         
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
       system.debug('Account Id: ' + m.Account__r.id);
       system.debug('Ship to Id: ' + m.id + ': ' + m.Account__r.accountnumber);
       system.debug('Sold to Id: ' + m.id + ': ' + m.Account__r.SAP_Sold_To_Account__c);
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
       amap.put(m.id, m);
     }
     system.debug('@@@@'+SAP_Requests.size());
    //List<CSP_JSON_Response> SAP_Responses = new List<CSP_JSON_Response>();
    if(SAP_Requests.size() != null){
        List<CSP_JSON_Response> SAP_Responses = CSP_JSON_Request.submit_Request_m(SAP_Requests);
        
        System.debug('@@@@ SAP_Responses'+SAP_Responses.size());
        for(CSP_JSON_Response csp:SAP_Responses)
        {
          system.debug('Id: ' + csp.SFDC_Account_Id);
          if(amap.containskey(csp.SFDC_Account_Id))
          {
          Account_material__c a = amap.get(csp.SFDC_Account_Id); //Actually the Account_Material_Id
          a.SAP_Data_Refreshed__c = system.now();
          a.SAP_Data__c = JSON.serialize(csp);
          toupdate.add(a);
          system.debug('statement count: ' + Limits.getScriptStatements());
          }
        }
        
    }    
    update toUpdate;
      
      List<Account_material__c> ams = database.query(q);
      //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getPricing', 989);
      return ams;
}

Public static void BeforeUpdate(List<Account_material__c> ams){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'BeforeUpdate', 994);
  System.debug('Inside before update!!!');
  set<string> aids = new set<string>();
  set<string> mids = new set<string>();

  Map<String, Double> CurrencyMap = new Map<String, Double>();
  for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
  {
       if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, C.ConversionRate);
  }
    FetchMyInnerTable(ams, CurrencyMap);
  for(Account_Material__c am:ams)
  {
      
    System.debug('Flag is'+am.Has_Open_PRT__c);  
    if(am.Account__c != null)
      aids.add(am.Account__c);
    if(am.SAP_Material__c != null)
      mids.add(am.SAP_Material__c);
    if(am.SAP_Data__c != null && am.SAP_Data__c != '')
    {
      
      CSP_JSON_Response csps = (csp_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);

      if(csps.avg_order_qty != '')
         am.avg_order_qty__c = stringtodouble(csps.avg_order_qty);
        if(csps.avg_order_unit != '' && csps.avg_order_unit != null)
          am.avg_order_qty_uom__c = csps.avg_order_unit;
     
      CSP_JSON_Response.tbl_csp_prices csp = null;
      CSP_JSON_Response.tbl_target_prices tarTier = null;
      Double volTocompare=0;
      Date cspeffdate = null;
      Date cspexdate = null;
      
      if(csps.tbl_csp_prices.size() > 0)
      {
       
       csp = csps.tbl_csp_prices.get(0);
       if(csp.csp_effective_date != '' && !csp.csp_effective_date.contains('9999'))
         am.CSP_Effective_Date__c = stringtodate(csp.csp_effective_date);
       else
         am.CSP_Effective_Date__c = null;
       if(csp.csp_Expiration_date != '' && !csp.csp_Expiration_date.contains('9999'))
         am.CSP_Expiration_Date__c = stringtodate(csp.csp_expiration_date);
       else
         am.CSP_Expiration_Date__c = null;
       if(csp.csp_currency != null && csp.csp_currency != '')
       {
        if(csp.csp_currency.length() > 3)
            am.CurrencyIsoCode = csp.csp_currency.substring(0,3);
        else
            am.currencyIsoCode = csp.csp_currency; 
         am.CSP_Currency__c = csp.csp_currency;
       }else{ am.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
              am.CSP_Currency__c = UserInfo.getDefaultCurrency(); }
      
      if(csp.csp_price != '')
        am.CSP_Price__c = stringtodouble(csp.csp_price); 
      if(csp.csp_price_unit != '')
        am.CSP_Unit__c = stringtodouble(csp.csp_price_unit);          
      if(csp.csp_uom != '')
        am.csp_uom__c = csp.csp_uom; 
      if(csp.csp_scale_uom != '' )
        am.CSP_Tier_UoM__c = csp.csp_scale_uom;
      if(csp.csp_volume != '')
        am.CSP_tier_Unit__c = stringtodouble(csp.csp_volume);
      if(csp.csp_price_protection_code != '' && csp.csp_price_protection_desc != '')
        am.price_Protection__c =  csp.csp_price_protection_code + ' - ' + csp.csp_price_protection_desc;
      else
        am.price_protection__c = '';
      
      am.drum_deposit__c = csp.csp_drum_deposit_code;
      volTocompare = stringtodouble(csp.csp_volume);
      }
      else{
        am.CSP_Effective_Date__c = null;
        am.CSP_Expiration_Date__c = null;
        am.CSP_Price__c = null;
        am.CSP_Unit__c = null;
        am.CSP_UoM__c = '';
        am.CSP_Tier_UoM__c = '';
        am.CSP_Tier_Unit__c = null;
        am.Price_Protection__C = '';
        
      }
               
      if(csps.tbl_target_prices.size() > 0)
      {
      system.debug('@@@@tarTier'+tarTier);  
      if(csps.tbl_CSP_prices.size() > 0){
      for(integer i=0; i< csps.tbl_target_prices.size(); i++)
      {   
           system.debug('@@@@volTocompare'+volTocompare);
           system.debug('@@@@csps.tbl_target_prices.get(i).tier_volume'+csps.tbl_target_prices.get(i).tier_volume);
           if(tarTier == null && volTocompare != 0 && stringtodouble(csps.tbl_target_prices.get(i).tier_volume) != null){
               if(volTocompare == stringtodouble(csps.tbl_target_prices.get(i).tier_volume)) 
               {
                  tarTier = csps.tbl_target_prices.get(i);
                  break;
                }
               else if(i+1 != csps.tbl_target_prices.size()){
                   if((volTocompare > stringtodouble(csps.tbl_target_prices.get(i).tier_volume)) && (volTocompare < stringtodouble(csps.tbl_target_prices.get(i+1).tier_volume)))
                   {
                       tarTier = csps.tbl_target_prices.get(i);
                       break;}
               }else if(i+1 == csps.tbl_target_prices.size() )
               {
                   tarTier = csps.tbl_target_prices.get(i);
                   break;
               }
           }
              
                   
       }}
       if(tarTier == null)
           tarTier= csps.tbl_target_prices.get(0);
       system.debug('tarTier:'+tarTier);
       String curr = '';
       if(tarTier != null){
       if(tarTier.target_price_currency != null)
        if(tarTier.target_price_currency.length() > 3)
            curr = tarTier.target_price_currency.substring(0,3);
        else
            curr = tarTier.target_price_currency;  
      
      if(tarTier.target_price != '')
        am.target_Price__c = stringtodouble(tarTier.target_price);      
      
      if(tarTier.target_price_unit != '')
        if(curr != am.currencyisocode)
            am.Target_Price__c = convertcurrency(stringtodouble(tarTier.target_price), curr, am.currencyisocode, currencymap);
        else
           am.Target_Price__c = stringtodouble(tarTier.target_price);
                     
      if(tarTier.target_price_unit != '')
        am.Target_Unit__c = stringtodouble(tarTier.target_price_unit);
      if(tarTier.target_price_uom != '')
        am.Target_uom__c = tarTier.target_price_uom; 
      if(tarTier.target_scale_uom != '' )
        am.Target_Tier_UoM__c = tarTier.target_scale_uom;
      if(tarTier.tier_volume != '')
        am.Target_tier_Unit__c = stringtodouble(tarTier.tier_volume);
       
      } 
      }  
      else 
      { am.Target_Price__C = null;
        am.target_unit__c = null;
        am.target_uom__c = '';
        am.Target_tier_Uom__c = '';
        am.target_tier_unit__c = null; 
      }
       Map<String, Double> conversionmap = getConversionMap(csps.tbl_sales_units);
      List<String> uoms = new list<String>();
      uoms.addall(conversionmap.keyset());
      uoms.sort();
      am.uoms__c = String.join(uoms, ';');
      am.Has_Unit_Options__c = (uoms.size() > 0);
      
      if(am.target_Price__c != null && am.CSP_Price__c != null && am.Target_Tier_UoM__c != null && am.csp_uom__c != null)
      {
        Double denom = convertunits(getConversionMap(csps.tbl_sales_units), double.valueof(am.Target_Price__c), am.Target_UoM__c, am.csp_uom__c, true);
        if(denom != null && denom != 0)
          am.tpi__c = (am.CSP_Price__c / denom).setscale(2) * 100;
        else
            am.tpi__c = 0;
         
      }else
        am.tpi__c = 0;
    }
  }

  map<id, Account> acctmap = new map<id, Account>([select id, parentid, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c, SAP_DivisionCode__c,
                                                   SAP_Corporate_Account_Manager__c, SAP_Sold_To_Account_Owner__c, ownerid, HQ_Sales_Office__c,
                                                   SAP_Industry_Key__c, SAP_Sales_Org__c, SAP_SalesGroup__c
                                                   from Account where id IN :aids]);
  map<id, Material_Sales_Data2__c> mmap = new map<id, Material_Sales_Data2__c>([select id, Material_General_Data__r.Material_Base_Code__c, Product_Hierarchy__r.PH4__c, Product_Hierarchy__r.PH5__c, 
                                                   Product_Hierarchy__r.PH6__c, Product_Hierarchy__r.PH7__c,
                                                   Material_Group1_Code__c, Material_General_Data__r.Material_Container_Code__c, Material_General_Data__r.Division_Id__c
                                                   from Material_Sales_Data2__c where id IN :mids]);
                                                   
 Map<String, String> offices = new map<String,String>();
 for(SAP_Sales_Office__c so:[select Sales_Office_Code__c, Sales_Office_Name__c, id from SAP_Sales_Office__c where name != 'MASKED'])
   offices.put(so.sales_office_code__c, so.id);
   
  Map<String, String> mpg1s = new map<String,String>();
 for(Material_Pricing_Group1__c mpg1:[select id, Material_Pricing_Group1_Code__c from Material_Pricing_Group1__c where name != 'MASKED'])
   mpg1s.put(mpg1.Material_Pricing_Group1_Code__c, mpg1.id);
   

for(Account_material__c am:ams)
{
  if(acctmap.containskey(am.Account__c))
  {
    //am.ownerid = acctmap.get(am.Account__c).ownerid;
    am.Account_Sold_To_Id_Ext__c = acctmap.get(am.Account__c).SAP_Sold_To_Account_Id__c;
    if(acctmap.get(am.Account__c).SAP_Corporate_Account_Id__c != null)
    am.Account_Corp_Account_Id_Ext__c = acctmap.get(am.Account__c).SAP_Corporate_Account_Id__c;
    else
    am.Account_Corp_Account_Id_Ext__c = acctmap.get(am.Account__c).parentid;
    
    //am.Account_Owner_Id_Ext__c = acctmap.get(am.Account__c).ownerid;
    //am.Account_SAP_Sales_Group_Ext__c = acctmap.get(am.Account__c).SAP_SalesGroup__c;
    //am.Account_Sold_To_Owner_Id_Ext__c = acctmap.get(am.Account__c).SAP_Sold_To_Account_Owner__c;
    
    //if(offices.containskey(acctmap.get(am.Account__c).HQ_Sales_Office__c))
    //  am.Account_HQ_Sales_Office_Ext__c = offices.get(acctmap.get(am.Account__c).HQ_Sales_Office__c);
    //else
    //  am.Account_HQ_Sales_Office_Ext__c = null;
      
    //am.Account_Sales_Org_Code_Ext__c = acctmap.get(am.Account__c).SAP_Sales_Org__c;  
    //am.Account_Division_Code_Ext__c = acctmap.get(am.Account__c).SAP_DivisionCode__c;
     

    //am.Account_Industry_Code_Ext__c = acctmap.get(am.Account__c).SAP_Industry_Key__c;
    //am.Account_Corp_Account_Owner_Id_Ext__c = acctmap.get(am.Account__c).SAP_Corporate_Account_Manager__c;
    
  }
  /*
  if(mmap.containskey(am.SAP_Material__c))
  {
    am.Material_Base_Code_Ext__c = mmap.get(am.SAP_Material__c).Material_General_Data__r.Material_Base_Code__c;
    am.PH4_Ext__c =  mmap.get(am.SAP_Material__c).Product_Hierarchy__r.PH4__c;
    am.PH5_Ext__c =  mmap.get(am.SAP_Material__c).Product_Hierarchy__r.PH5__c;
    am.PH6_Ext__c =  mmap.get(am.SAP_Material__c).Product_Hierarchy__r.PH6__c;
    am.PH7_Ext__c =  mmap.get(am.SAP_Material__c).Product_Hierarchy__r.PH7__c;
    am.Material_Container_Code_Ext__c = mmap.get(am.SAP_Material__c).Material_General_Data__r.Material_Container_Code__c;
    am.Material_Division_Ext__c = mmap.get(am.SAP_Material__c).Material_General_Data__r.Division_Id__c;
    
    if(MPG1s.containskey(mmap.get(am.SAP_Material__c).Material_Group1_Code__c))
       am.Material_Group_1_Ext__c =  MPG1s.get(mmap.get(am.SAP_Material__c).Material_Group1_Code__c);
    else
       am.Material_Group_1_Ext__c = null;
    
  }
  */
}
}
Public static void Accountmaterialsharing(List<Account_material__c> ams, Map<Id, Account_Material__c> newMap, boolean isUpdate){
    /*Initalizing variables*/
    List<Account_material__share> acctMatShareList  = new List<Account_material__share>();
    Account_material__share SoldToOwner;
    Account_material__share CorporateOwner;
    set<Id> AccountIds = new set<Id>();
    if(isUpdate){
    List<Account_Material__share> deleteshares = [Select Id, RowCause from Account_Material__share where ParentID IN :ams and RowCause != 'Owner' and RowCause != 'Rule' and RowCause != 'Nexprice_Team_Member__c'];
        
        if(deleteshares.size()>0)
          delete deleteshares;
    }
    for(Account_material__c accMat :ams){
      AccountIds.add(accMat.Account__c);
    }
    
    Map<Id, Account> amap = new map<Id, Account>([select id, SAP_Sold_To_Account_Owner__c, SAP_Corporate_Account_Manager__c,SAP_Corporate_Account_Manager__r.IsActive,SAP_Sold_To_Account_Owner__r.IsActive from Account where id IN :accountids]);
    /*Modify all the records for sharing after the records are inserted*/
    for(Account_material__c accMat : ams){
          SoldToOwner = new Account_material__share();
          SoldToOwner.ParentId = accMat.Id;
          SoldToOwner.AccessLevel = 'Edit';
          SoldToOwner.RowCause = Schema.Account_material__share.RowCause.SoldToOwner__c;
        
      if(amap.containskey(accMat.Account__c))
      {
       Account accountRecord = amap.get(accMat.Account__c);    
        if((accountRecord.SAP_Sold_To_Account_Owner__c != null) && (accountRecord.SAP_Sold_To_Account_Owner__r.IsActive == true)){
          SoldToOwner.UserOrGroupId = amap.get(accMat.Account__c).SAP_Sold_To_Account_Owner__c;
          acctMatShareList.add(SoldToOwner);
        }
        
          CorporateOwner = new Account_material__share();
          CorporateOwner.ParentId = accMat.Id;
          CorporateOwner.AccessLevel = 'Edit';
          CorporateOwner.RowCause = Schema.Account_material__share.RowCause.CorporateOwner__c;
        
        if((accountRecord.SAP_Corporate_Account_Manager__c!= null) && (accountRecord.SAP_Corporate_Account_Manager__r.IsActive == true)){
         
          CorporateOwner.UserOrGroupId = amap.get(accMat.Account__c).SAP_Corporate_Account_Manager__c;
          acctMatShareList.add(CorporateOwner);
        }
      }
         
    }
    system.debug('share list size:' + acctMatShareList.size());

    /*insert the sharing objects into the database*/
    Database.SaveResult[] lsr = Database.insert(acctMatShareList,false); 
        Integer i=0;
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                 if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                      &&  err.getMessage().contains('AccessLevel'))){
                        newMap.get(acctMatShareList[i].ParentId).addError('Unable to grant sharing access due to following exception: ' +err.getMessage());                          
                }
            }
            i++;
        }


}

Public static SFDC_Maps GeneratePendingMaps(List<Account_Material__c> ams)
{for(Account_Material__c am :ams)
    system.debug('amid is:'+ am.id);
 //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'GeneratePendingMaps', 1114);
 Map<Id, List<Price_Request_Transaction__c>> Pending_Price_Request_Transactions_Map = new map<Id, List<Price_Request_Transaction__c>>();
 Map<Id, List<SAP_Price_Tier__c>> Pending_Request_Tiers_map = new Map<Id, List<SAP_Price_Tier__c>>();
 Set<String> prtids = new Set<String>();
 Date YEAR_AGO = system.today() - 365;
 
 
 for(Price_Request_Transaction__c prt:[select id, Material__c,SAP_ShipTo_Account__c, SAP_SoldTo_Account__c, account_material__c, approval_status__c, createddate, sold_to__r.name, ship_to__r.name, ship_to__c, sold_to__c, corporate_account__c, approver__c,
     Base_Code__c, Competitive_Price__c, Competitive_uoM__c, Competitor__c, Competitor__r.name, Distribution_Channel__c, Division__c,
     Estimated_order_Qty_uom__c, Quantity__c, Lbs_Unit__c, PLM__c, Product_Cluster__c, Quote__c, Quote_Converted__c,
     Requested_drum_deposit__c, Requested_Effective_date__c,Requested_expiration_date__c, Requested_Price_Protection__c,
     Requested_Price_Uom__c, Requested_uom__c, Retrieved_from_sap__c, Return_Message__c, Return_Type__c, Sales_Org__c,
     Sales_Unit__c, SAP_Material__c, SAP_Material__r.name, SAP_Material__r.Material_Base_Code_Desc__c, Special_Product__c,
     Specialty__c, Supplier__c, Type__c, Unit_Conversion_Data__c, approver__r.name, approval_level__c, Comments__c,Approval_Rejection_Comments__c,
     average_order_qty__c,average_order_qty_uom__c, name, Ship_to__r.SAP_Sales_Group_Desc__c, Ship_to__r.AccountNumber, Requested_Effective_Date_Text__c,
     Ship_to__r.SAP_Sales_Org__c, CSP_Currency__c, Ship_to__r.SAP_Sales_Org_desc__c, corporate_Account__r.owner.name, 
     corporate_Account__r.name FROM Price_Request_Transaction__c where                                           
         Open_Or_Closed__c = 'Open'
         and Account_Material__c = :ams
         order by requested_effective_date__c desc])
         {
           prtids.add(prt.id);
           if(pending_price_request_transactions_map.containskey(prt.account_material__c ))
              pending_price_request_transactions_map.get(prt.account_material__c).add(prt);
           else
              pending_price_request_transactions_map.put(prt.account_material__c, new List<Price_Request_Transaction__c>{prt});  
         }

for(SAP_Price_Tier__c spt:[select id, price__c, SAP_Currency__c, volume__c, price_uom__c, volume_uom__c, SAP_Price__c, tpi__c, Effective_Date__c, Expiration_Date__c, sap_price__r.price_request_transaction__c, currencyisocode, req_price__c from SAP_Price_Tier__c 
                           where sap_price__r.type__c = 'Requested' and SAP_Price__r.price_request_Transaction__c IN :prtids])
   {
      System.debug('$$ spt'+spt); 
      if(Pending_Request_tiers_map.containskey(spt.sap_price__r.price_request_Transaction__c)){
        pending_request_tiers_map.get(spt.sap_price__r.price_request_Transaction__c).add(spt);
        }
      else
        pending_request_tiers_map.put(spt.sap_price__r.price_request_Transaction__c, new List<SAP_Price_Tier__c>{spt});  
   }                                          
   //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'GeneratePendingMaps', 1151);
return new SFDC_Maps(pending_price_request_transactions_map, pending_request_Tiers_map);
}

Public static void FetchMyInnerTable(List<Account_Material__c> ams, Map<String, Double> CurrencyMap){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'FetchMyInnerTable', 1156);
  SFDC_Maps maps = generatependingmaps(ams);
  Map<Id, List<Price_Request_Transaction__c>> Price_Request_Transactions_map = maps.PRT_map;
  Map<Id, List<SAP_Price_Tier__c>> SAP_request_tiers_map = maps.Price_request_tiers_map;
  Map<String, String> toreturn = new Map<String, String>();
  
  for(Account_Material__c am:ams)
  {
  String sReturn = '';
  system.debug('AccountCurrency:'+am.Account_Currency__c);
  am.CSP_Currency__c = am.Account_Currency__c;
  
  if((am.SAP_Data__c != null && am.SAP_Data__c != '') || am.Prospect_Material__c == true)
  {
    CSP_JSON_Response j = null;

    if(am.SAP_Data__c != null)
      j = (csp_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
    
    if(j != null)
    {
    
      sReturn = '<table>';
      sReturn += '<tr>';
 
     //CSP TABLE
     boolean displayContactPLM = false;
     boolean isCSPTableBlank = false;
     boolean isTargetTableBlank = false;
 
     if((j.tbl_csp_prices == null || j.tbl_csp_prices.size() == 0) &&( j.tbl_target_prices == null || j.tbl_target_prices.size() == 0))
       displayContactPLM = true;
     for(CSP_JSON_Response.tbl_csp_Prices t:j.tbl_csp_Prices){
      if(t.csp_expiration_date== '' && t.CSP_effective_date == '' && 
         t.CSP_volume == '' && t.csp_scale_uom == '' &&
         t.CSP_price == '' && t.CSP_UoM == '')
          isCSPTableBlank = true;
     }
     for(CSP_JSON_Response.tbl_target_Prices t:j.tbl_target_Prices)
      if(t.target_price == '')
        isTargetTableBlank = true;
 
     if((isCSPTableBlank || j.tbl_csp_prices.size() == 0 ) && (isTargetTableBlank || j.tbl_target_prices.size() == 0)) 
       displayContactPLM = true;

     am.Has_CSP__c = !(isCSPTableBlank || j.tbl_csp_prices.size() == 0 );
     if(displaycontactPLM == true)
     {
      sReturn += '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th colspan="7">CSP Tiers - <span style="color:red;" >Contact PLM for Pricing</span></th></tr><tr><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th></tr></thead><tbody>';
      sReturn += '</tbody></table></td>';
      sReturn +=  '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th colspan="4">Target Tiers - <span style="color:red;">Contact PLM for Pricing</span></th></tr><tr><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th></tr></thead><tbody>';
     }
     else
     {
      sReturn += '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th colspan="7">CSP Tiers</th></tr><tr><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>Currency Type</th><th>UoM</th></tr></thead><tbody>';
 

     for(CSP_JSON_Response.tbl_csp_prices t:j.tbl_csp_prices)
     {
       if(!(t.csp_expiration_date== '' && t.CSP_effective_date == '' && 
        t.CSP_volume == '' && t.csp_scale_uom == '' &&
        t.CSP_price == '' && t.CSP_UoM == ''))
      {
       sReturn += '<tr id="csphasval"><td>';
       if(t.csp_effective_date != null && t.csp_effective_date != ''){
           sreturn += formatDate(stringtodate(t.csp_effective_date));
       }
       else
           sreturn += '</td>';
       sreturn += '<td>' ;
   
       if(t.csp_expiration_date != null && t.csp_expiration_date != '')
       {  date d = stringtodate(t.csp_expiration_date);
          if(d != null)
            sReturn += formatDate(d);
       }
       else
       sreturn += '</td>';  
       sreturn += '<td>' + t.csp_volume + '</td><td>'+ t.csp_scale_uom +'</td><td>';
       if(t.csp_price != null && t.CSP_Price != '')
           sreturn += (t.CSP_Price);
       am.CSP_Currency__c = t.csp_currency;
       sreturn += '</td><td>' + t.csp_currency + '</td><td>' + t.CSP_UoM + '</td></tr>';
      }
     }
 
     sReturn += '</tbody></table></td>';
     //TARGET TABLE
     sReturn +=  '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th colspan="5">Target Tiers</th></tr><tr><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>Seller Floor</th></tr></thead><tbody>';

     /*Map<String, Double> CurrencyMap = new Map<String, Double>();
      for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
      {
           if(c.isocode != '' && c.isocode != null)
             CurrencyMap.put(c.IsoCode, C.ConversionRate);
      }*/
      
     for(CSP_JSON_Response.tbl_target_prices t:j.tbl_target_prices)
     {
       if(t.target_price != '')
       {
         String curr = '';
         Double tarPrice;
         Double excep1Price;
         if(t.target_price_currency != null)
            if(t.target_price_currency.length() > 3)
                curr = t.target_price_currency.substring(0,3);
         else
            curr = t.target_price_currency;              
      
         if(t.target_price_unit != '')
            if(curr != am.currencyisocode){
                tarPrice = convertcurrency(stringtodouble(t.target_price), curr, am.currencyisocode, CurrencyMap);
                excep1Price = convertcurrency(stringtodouble(t.exception1_price), curr, am.currencyisocode, CurrencyMap);
              
             }
         else{
                tarPrice = stringtodouble(t.target_price);
                excep1Price = stringtodouble(t.exception1_price);
              }
        
           
           sReturn += '<tr><td>' + t.tier_volume + '</td><td>'+ t.target_scale_uom +'</td><td>';
           if(t.target_price != null && t.target_Price != '')
             sreturn += Decimal.valueof(tarPrice).setscale(targetScale);
             //decimal.valueof(stringtodouble(t.target_Price)).setscale(targetScale);
           sreturn += '</td><td>' + t.target_price_UoM + '</td>';
           if(t.exception1_price != null && t.exception1_price != '')
           sreturn += '<td>' + Decimal.valueof(excep1Price).setscale(targetScale) + '</td></tr>';
           
       }
     }
 
  }
    sReturn += '</tbody></table></td>';
    //EXISTING REQUESTS TABLE
    system.debug('PRT Map: ' + price_request_transactions_map);
    if(price_request_transactions_map.containskey(am.id))
    {
         am.Has_Open_PRT__c = true;
         sReturn += '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th colspan="10">Existing Requests</th></tr><tr><th>Status</th><th>Type</th><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Currency</th><th>Price</th><th>UoM</th><th>TPI</th></tr></thead><tbody>';
      
       
         for(Price_Request_Transaction__c ra: Price_Request_Transactions_map.get(am.id))
         {
           if(ra != null )
           {
               if(SAP_Request_Tiers_map.containskey(ra.id))
                       for(SAP_Price_Tier__c prt:SAP_Request_Tiers_map.get(ra.id))
                   {   
                        
                        sReturn += '<tr><td>' + ra.approval_Status__c + '</td><td>' + ra.type__c + '</td><td>' + formatDate(prt.Effective_Date__c) + '</td><td>';
                        sReturn += formatDate(prt.Expiration_Date__c) + '</td><td>' + prt.volume__c + '</td><td>';
                        string tpi = '';
                        if(prt.tpi__c != null)
                         tpi = (prt.tpi__c ).setScale(2) + '%';
                       // sReturn += prt.Volume_UoM__c + '</td><td>' + prt.currencyisocode + '</td><td>';
                       sReturn += prt.Volume_UoM__c + '</td><td>' + prt.SAP_Currency__c + '</td><td>';
                        if(prt.price__c != null)
                            sReturn += prt.req_price__c;
                            //sReturn += prt.price__c.setscale(4);
                        sReturn += '</td><td>' + prt.price_uom__c + '</td><td>' + tpi+ '</td></tr>';   
                   }
           }
         }
         sreturn += '</tbody></table></td></tr>';
    }
    else{ am.has_open_prt__c = false; }
    
    //END INNER TABLES
     
     sReturn += '</table>';
     sReturn += '<div class="graphcontainer"></div>';
    }
  }
am.inner_table__c = sReturn;
}
//Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'FetchMyInnerTable', 1293);
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
Public static Map<String, Double> getConversionMap(List<CSP_JSON_Response.tbl_sales_units> units)
{
   Map<String, Double> conversionmap = new Map<String, Double>();
   for(CSP_JSON_Response.tbl_sales_units u:units)
   {
     if(u.numerator != '' && u.denominator != '')
     {  if(Double.valueof(u.denominator) != 0)
        {  
           conversionmap.put(u.sales_unit, (Double.valueof(u.numerator) / Double.valueof(u.denominator)));
        }
     }
   }
   return conversionmap;
}
Public static Map<String, Double> getConversionMap(Price_Request_Transaction__c PRT, List<CSP_JSON_Response.tbl_sales_units> units)
{
   Map<String, Double> conversionmap = new map<String, Double>();
   String conversiondata = '';
   for(CSP_JSON_Response.tbl_sales_units u:units)
   {
     if(u.numerator != '' && u.denominator != '')
     conversiondata += u.Sales_unit + '>' + (Double.valueof(u.numerator) / Double.valueof(u.denominator)) + ';';
     if(u.numerator != '' && u.denominator != '')
     conversionmap.put(u.sales_unit, (Double.valueof(u.numerator) / Double.valueof(u.denominator)));
   }
   PRT.unit_conversion_data__c = ConversionData;
   return conversionmap;
}
Public static Double ConvertUnits(Map<String, Double> conversionmap, Double iValue, String sUnitFrom, String sUnitTo, boolean invert){

  if(conversionmap.containskey(sUnitFrom) && conversionmap.containskey(sUnitTo))
  {
    if(conversionmap.get(sUnitTo) > 0)
    {
     if(invert == true)
     {
     Double baseunit = iValue / conversionmap.get(sUnitFrom);
     return (baseunit * conversionmap.get(sUnitTo));
     }
     else
     {
     Double baseunit = iValue * conversionmap.get(sUnitFrom);
     return (baseunit / conversionmap.get(sUnitTo));
     }
    }
    else return iValue;
  }
  else
  { return iValue; }
}
public static void FetchSimulateWindow(Price_Request_Transaction__c PRT, boolean uomFlag, boolean CMflag){
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'FetchSimulateWindow', 1387);
  CSP_JSON_Response CSPs = null;
  if(PRT.SAP_Data__c != null)
    CSPs = (CSP_JSON_Response)JSON.deserialize(PRT.SAP_Data__c, CSP_JSON_Response.class);
  
  Map<String, Double> conversionmap = new Map<String, Double>();
  if(CSPs != null)
    conversionmap = getConversionMap(csps.tbl_sales_units);
    
  String window = '';
  String window1 = '';
  //adding separate window for target tier
  String window2 = '';
  
  String tarVolUOM = '';
  String tarPriceUOM = '';
  if(PRT.return_type__c == 'E'){
    window +=  '<span style="color:red;font-weight:bold;">SAP Error: ' + PRT.return_message__c + '</span>';
 
    window1 +=  '<span style="color:red;font-weight:bold;">SAP Error: ' + PRT.return_message__c + '</span>';
    window2 +=  '<span style="color:red;font-weight:bold;">SAP Error: ' + PRT.return_message__c + '</span>';
    }
  window += '<table><tr><td style="vertical-align:top;padding-right:1px;">';
  window += '<table class="innerTable" style="width:475px;"><thead><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>TPI</th></tr></thead>';
  window += '<tbody>';
    
  window1 += '<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%"><thead><tr>';
  window1 += '<th>Volume/UoM</th><th>Price/UoM</th><th>TPI</th></tr></thead>';
  window1 += '<tbody>';
  
  
  /*window2 += '<table><tr><td style="vertical-align:top;padding-right:1px;">';
  window2 += '<table class="innerTable" style="width:475px;"><thead><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>TPI</th></tr></thead>';
  window2 += '<tbody>';*/
  
  List<SAP_Price_Tier__c> Requested = new List<SAP_Price_Tier__c>();
  if(PRT.Requested_Tiers__c != null)
    Requested = (List<SAP_Price_Tier__c>)JSON.deserialize(PRT.Requested_Tiers__c, List<SAP_Price_Tier__c>.class);
  system.debug('Requested:'+Requested);
  system.debug('PRT.Requested_Tiers__c:'+PRT.Requested_Tiers__c);   
     for(SAP_Price_Tier__c PRTier:Requested)
     {  
       
      tarVolUOM = PRTier.Volume_UoM__c;
      tarPriceUOM = PRTier.price_uom__c;
       
       window += '<tr>';
       window1 += '<tr>';
      //window += '<td>' + formatDate(PRT.requested_effective_date__c) + '</td><td>';
      //window += formatDate(PRT.Requested_expiration_date__c) + '</td><td>' + PRTier.volume__c + '</td><td>';
      
      /*commented two lines above as correct dates are obtained from PRTier*/
      System.debug('$ : eff date'+PRTier.Effective_Date__c); 
      window += '<td>' + formatDate(PRTier.Effective_Date__c) + '</td><td>';
      window += formatDate(PRTier.Expiration_Date__c) + '</td><td>' + PRTier.volume__c + '</td><td>';
      
      window1 += '<td>' + PRTier.volume__c + '/' + PRTier.Volume_UoM__c + '</td><td>';
      System.debug('$ : after format eff date'+PRTier.Effective_Date__c); 
      
      if(PRTier.req_price__c != null)
         window1 += PRTier.req_price__c + '/' + PRTier.price_uom__c + '</td><td>';
       //window1 += PRTier.price__c.setscale(4) + '/' + PRTier.price_uom__c + '</td><td>';
      
      string tpi = '';
      if(PRTier.tpi__c != null)
        tpi = (PRTier.tpi__c ).setScale(2) + '%';
      window1 += tpi+ '</td></tr>';
      window += PRTier.Volume_UoM__c + '</td><td>';
      if(PRTier.req_price__c != null)
          window += PRTier.req_price__c;
          //window += PRTier.price__c.setscale(4);
      window += '</td><td>' + PRTier.price_uom__c + '</td><td>' + tpi+ '</td></tr>';   
     
         
     }
   
  window += '</tbody></table></td>';
  window1 += '</tbody></table>';
   //TARGET TABLE
  window+=  '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th>Target Vol</th><th>UoM</th><th>Target Price</th><th>UoM</th><th>Seller Floor</th></tr></thead><tbody>';

  window2+=  '<td style="vertical-align:top;padding-right:1px;"><table class="table table-striped table-bordered"><thead><tr><th>Target Vol/UoM</th><th>Target Price/UoM</th></tr></thead><tbody>';

 Map<String, Double> CurrencyMap = new Map<String, Double>();
    for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
    {
         if(c.isocode != '' && c.isocode != null)
           CurrencyMap.put(c.IsoCode, C.ConversionRate);
    }
 List<SAP_Price_Tier__c> targets = new List<SAP_Price_Tier__c>();
 String curr = '';
  if(PRT.Target_Tiers__c != null){
    targets = (List<SAP_Price_Tier__c>)JSON.deserialize(PRT.Target_Tiers__c, List<SAP_Price_Tier__c>.class);
    system.debug('Target Tier info is:'+targets);
  }
 for(SAP_Price_Tier__c t:targets)
 {
   Double vol = t.volume__c;
   Double price = t.Price__c;
   Double tarPrice;
   Double excep1Price;
         
         if(t.currencyisocode != prt.currencyisocode){
               tarPrice = convertcurrency(stringtodouble(t.Price__c), t.currencyisocode, prt.currencyisocode, currencymap);
               if(t.exception_1_Price__c != null)
               excep1Price = convertcurrency(stringtodouble(t.exception_1_Price__c), t.currencyisocode, prt.currencyisocode, currencymap);
         }else{
               tarPrice = stringtodouble(t.Price__c);
               excep1Price = stringtodouble(t.exception_1_Price__c);
         }
   
   Double  tvol  = convertunits(conversionmap, vol,t.Volume_UoM__c, tarVolUOM, false );
   Double  tprice = convertUnits(conversionmap, tarPrice,t.Price_UoM__c,tarPriceUOM, true );
   if(t.exception_1_Price__c != null)
       excep1Price = convertUnits(conversionmap, excep1Price,t.Price_UoM__c,tarPriceUOM, true );
   if(uomFlag){
       window += '<tr><td>' + Decimal.valueof(tvol).setscale(1)   + '</td><td>'+ tarVolUOM  +'</td><td>' + Decimal.valueof(tprice).setscale(2)  + '</td><td>' + tarPriceUOM  + '</td><td>' + Decimal.valueof(excep1Price).setscale(2)  + '</td></tr>';
       window2 += '<tr><td>' + Decimal.valueof(tvol).setscale(1)   + '/'+ tarVolUOM  +'</td><td>' + Decimal.valueof(tprice).setscale(2)  + '/' + tarPriceUOM  + '</td></tr>';
   }else{
       window += '<tr><td>' + Decimal.valueof(vol).setscale(1)   + '</td><td>'+ t.Volume_UoM__c  +'</td><td>' + Decimal.valueof(tarPrice).setscale(2)  + '</td><td>' + t.Price_UoM__c  + '</td><td>' + Decimal.valueof(excep1Price).setscale(2)  + '</td></tr>';
       window2 += '<tr><td>' + Decimal.valueof(vol).setscale(1)   + '/'+ t.Volume_UoM__c  +'</td><td>' + Decimal.valueof(tarPrice).setscale(2)  + '/' + t.Price_UoM__c  + '</td></tr>';
   }    
 }
  window += '</tbody></table></td>';
  window2 += '</tbody></table></td>';
  window +=  '<td style="vertical-align:top;padding-right:1px;"><table class="innerTable"><thead><tr><th>Avg Order Qty</th><th>Estimated Order Qty</th></tr></thead><tbody>';
  string avgord = '';
  if(PRT.average_order_qty__c != null && PRT.average_order_qty_uom__c != null && PRT.average_order_qty_uom__c != '')
    avgord = PRT.average_order_qty__c + ' ' + PRT.average_order_qty_uom__c;
  string estord = '';
  if( PRT.quantity__c != null && PRT.estimated_order_qty_uom__c != null && PRT.estimated_order_qty_uom__c != '')
    estord =  PRT.quantity__c + ' ' + PRT.estimated_order_qty_uom__c; 
  
  if(avgord != '' || estord != '')
    window += '<tr><td>' + avgord + '</td><td>' + estord + '</td></tr>';
  //window += '</tbody></table></td></tr></table>';
  window += '</tbody>';
  
  system.debug('Fetchsimulatewindow CMflag:'+CMflag);
  if(CMflag == true)
  if(PRT.Account_Material__r.Material_Group_3__c == 'SPECIALTY')
  {
      window += '<tr><table class="innerTable"><thead><tr><th colspan=3 align="center">CM Data</th></tr><tr><th>Material Cost</th><th>Variable Warehouse</th><th>Variable Delivery</th></tr></thead><tbody>';
      window += '<tr><td>' + PRT.Material_Cost__c + '</td><td>' + PRT.Variable_Warehouse__c + '</td><td>' + PRT.Variable_Delivery__c + '</td></tr></tbody></table>';
      window += '<table class="innerTable"><thead><tr><th>Unit Material Cost</th><th>Unit Variable Warehouse</th><th>Unit Variable Delivery</th></tr></thead><tbody>';
      window += '<tr><td>' + PRT.Unit_Material_Cost__c + '</td><td>' + PRT.Unit_Warehouse_Charge__c + '</td><td>' + PRT.Unit_Freight_Charge__c + '</td></tr></tbody></table></tr>';
  }
  window += '</table></td></tr></table>';
  PRT.Simulate_Table__c = window;
  PRT.SimulateTable_TarTiers__c= window2;
  PRT.SimulateTable_ReqTiers__c = window1;
  
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'FetchSimulateWindow', 1460);
}
public static SFDC_Maps generateAuditMap(string ownerid, List<String> types, List<string> statuses){
  return generateAuditMap(new List<String>{ownerid}, types, statuses);
}


public static List<Price_Request_Transaction__c> generateAuditMapnew(List<String> ownerids, List<String> types, List<string> statuses){
    List<String> EmployeeIds = new List<String>();
    system.debug('ownerids:'+ownerids);
    List<User> users = [Select id, Ashland_Employee_Number__c from User where Ashland_Employee_Number__c LIKE : ownerids];
    for(User u:users)
        EmployeeIds.add(u.id);
    system.debug('EmployeeIds:'+EmployeeIds);
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'generateAuditMap', 1466);
    Date YEAR_AGO = system.today()-365;
    List<Price_Request_Transaction__c> prtlist = [select id, Material__c,plant__c,ship_to__r.owner.name,approval_status__c, createddate, sold_to__r.name, ship_to__r.name, ship_to__c, sold_to__c, corporate_account__c, approver__c,
    Base_Code__c,
    Competitive_Price__c,
    Competitive_uoM__c,
    Competitor__c,
    Competitor__r.name,
    Distribution_Channel__c,
    Division__c,
    Estimated_order_Qty_uom__c,
    Quantity__c,
    Lbs_Unit__c,
    PLM__c,
    Product_Cluster__c,
    Quote__c,
    Quote_Converted__c,
    Requested_drum_deposit__c,
    Requested_Effective_date__c,
    Requested_expiration_date__c,
    Requested_Price_Protection__c,
    Requested_Price_Uom__c,
    Requested_uom__c,
    Retrieved_from_sap__c,
    Return_Message__c,
    Return_Type__c,
    Sales_Org__c,
    Sales_Unit__c,
    SAP_Material__c,
    SAP_Material__r.name,
    SAP_Material__r.Material_Base_Code_Desc__c,
    Special_Product__c,
    Specialty__c,
    Supplier__c,
    Type__c,
    approver__r.name,
    approval_level__c,
    Comments__c,
    Price_Protection_Changed__c,
    Price_Protection_Changed_Value__c,
    Approval_Rejection_Comments__c,
    average_order_qty__c,
    average_order_qty_uom__c,
    Ship_to__r.SAP_Sales_Group_Desc__c,
    Unit_Conversion_Data__c, 
    name, 
    Ship_to__r.AccountNumber,
    Ship_to__r.SAP_Sales_Org__c,
    Ship_to__r.SAP_Sales_Org_desc__c,
    corporate_Account__r.owner.name,
    corporate_Account__r.name,
    SAP_ShipTo_Account__c,
    SAP_SoldTo_Account__c,
    Requested_Effective_Date_Text__c,
    Inner_table__c,
    Requested_Expiration_Date_Text__c,
    Volume__c,
    Price__c,
    TPI__c,
    CSP_Currency__c,
    Prospect_Material__c,
    Account_Material__r.Account__c
  
     from Price_Request_Transaction__c where                                           
                                                ((createdbyid IN :EmployeeIds) OR
                                                 (ship_to__r.Team_Employee_Ids__c LIKE :ownerids  and ship_to__c != null) OR
                                                 (sold_to__r.Team_Employee_Ids__c LIKE :ownerids  and sold_to__c != null) OR
                                                 (corporate_Account__r.Team_Employee_Ids__c LIKE :ownerids  and corporate_account__c != null)) AND
                                                 CreatedDate >= :YEAR_AGO AND  Type__c IN :types 
                                                 AND Approval_Status__c IN :statuses                 
                                                 order by requested_effective_date__c desc];
    
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'generateAuditMap', 1560);
    return prtlist;
}


public static SFDC_Maps generateAuditMap(List<String> ownerids, List<String> types, List<string> statuses){
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'generateAuditMap', 1466);
Date YEAR_AGO = system.today()-365;
List<Price_Request_Transaction__c> reqaccts = [select id, Material__c,plant__c,ship_to__r.owner.name,approval_status__c, createddate, sold_to__r.name, ship_to__r.name, ship_to__c, sold_to__c, corporate_account__c, approver__c,
Base_Code__c,
Competitive_Price__c,
Competitive_uoM__c,
Competitor__c,
Competitor__r.name,
Distribution_Channel__c,
Division__c,
Estimated_order_Qty_uom__c,
Quantity__c,
Lbs_Unit__c,
PLM__c,
Product_Cluster__c,
Quote__c,
Quote_Converted__c,
Requested_drum_deposit__c,
Requested_Effective_date__c,
Requested_expiration_date__c,
Requested_Price_Protection__c,
Requested_Price_Uom__c,
Requested_uom__c,
Retrieved_from_sap__c,
Return_Message__c,
Return_Type__c,
Sales_Org__c,
Sales_Unit__c,
SAP_Material__c,
SAP_Material__r.name,
SAP_Material__r.Material_Base_Code_Desc__c,
Special_Product__c,
Specialty__c,
Supplier__c,
Type__c,
approver__r.name,
approval_level__c,
Comments__c,
Price_Protection_Changed__c,
Price_Protection_Changed_Value__c,
Approval_Rejection_Comments__c,
average_order_qty__c,
average_order_qty_uom__c,
Ship_to__r.SAP_Sales_Group_Desc__c,
Unit_Conversion_Data__c, 
name, 
Ship_to__r.AccountNumber,
Ship_to__r.SAP_Sales_Org__c,
Ship_to__r.SAP_Sales_Org_desc__c,
corporate_Account__r.owner.name,
corporate_Account__r.name,
SAP_ShipTo_Account__c,
SAP_SoldTo_Account__c,
Requested_Effective_Date_Text__c,
Inner_table__c,
Requested_Expiration_Date_Text__c,
Volume__c,
Price__c,
TPI__c
 from Price_Request_Transaction__c where                                           
                                            ((createdbyid IN :ownerids) OR
                                             (ship_to__r.ownerid IN :ownerids  and ship_to__c != null) OR
                                             (sold_to__r.ownerid IN :ownerids  and sold_to__c != null) OR
                                             (corporate_Account__r.ownerid IN :ownerids  and corporate_account__c != null)) AND
                                             CreatedDate >= :YEAR_AGO AND  Type__c IN :types 
                                             AND Approval_Status__c IN :statuses                 
                                             order by requested_effective_date__c desc];

    set<string> accmat = new set<string>();
    Map<String, Price_Request_Transaction__c> Audit_Price_Request_Transactions_Map = new Map<String, Price_Request_Transaction__c>();
    Map<String, List<SAP_Price_Tier__c>> Audit_request_Tiers_Map = new map<String, List<SAP_Price_Tier__c>>();
    
    for(Price_Request_Transaction__c ra:reqaccts)
    {  
         audit_Price_Request_Transactions_Map.put(ra.id, ra);
    }     
                                         
    List<SAP_Price_Tier__c> reqtiers = [select id, price__c, SAP_Currency__c, volume__c, price_uom__c, volume_uom__c, SAP_Price__c, tpi__c, currencyisocode, sap_price__r.price_request_transaction__c, req_price__c from SAP_Price_Tier__c where sap_price__r.type__c = 'Requested'];                                          
   
    
    for(SAP_Price_Tier__c prt:reqtiers)
    {
         
         if(audit_request_tiers_map.containskey( prt.SAP_Price__r.price_request_transaction__c ))
             audit_request_tiers_map.get(prt.SAP_Price__r.price_request_transaction__c).add(prt);
         else
         { List<SAP_Price_Tier__c> tl = new List<SAP_Price_Tier__c>();
           tl.add(prt);             
           audit_request_tiers_map.put(prt.SAP_Price__r.price_request_transaction__c, tl);
         }
         if(audit_price_request_transactions_map.containskey(prt.SAP_Price__r.price_request_transaction__c))
         audit_price_request_transactions_map.get(prt.SAP_Price__r.price_request_transaction__c).Requested_Tiers__c = 
           JSON.serialize(audit_request_tiers_map.get(prt.SAP_Price__r.price_request_transaction__c));
      
    }
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'generateAuditMap', 1560);
  return new SFDC_Maps(Audit_Price_Request_Transactions_Map, Audit_Request_Tiers_Map);
}
Public Static void getPRTForm(List<Account_Material__c> ams){
//Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getPRTForm', 1564);
/*
set<id> materialids = new set<id>();
set<id> accountids = new set<id>();
for(Account_Material__c am:ams)
{
  materialids.add(am.SAP_Material__c);
  accountids.add(am.Account__c);
}

Map<Id, Material_Sales_Data2__c> matmap = new map<Id, Material_Sales_Data2__c>([select id, name from Material_Sales_Data2__c where id IN :materialids]);
Map<Id, account> amap = new map<Id, Account>([select id, name from account where id IN :accountids]);
for(Account_Material__c am:ams)
{
String unitoptions = '';
String CompUoM_Options = '';
String EstUoM_Options = '';
String PriceUoM_Options = '';
String VolUoM_Options = '';
String curroptions = '';

if(am.currencyisocode == 'CAD')
  curroptions += '<option value="CAD" selected="selected">CAD</option>';
else
  curroptions += '<option value="CAD">CAD</option>';
if(am.currencyisocode == 'USD')
  curroptions += '<option value="USD" selected="selected">USD</option>';
else
  curroptions += '<option value="USD">USD</option>';

if(am.SAP_Data__c != null && am.SAP_Data__c != '')
{
   CSP_JSON_Response response = (csp_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
   for(CSP_JSON_Response.tbl_sales_units su:response.tbl_sales_units)
   {  unitoptions += '<option value="' + su.sales_unit + '">' + su.sales_unit + '</option>';
      if(am.Competitive_UoM__c == su.sales_unit)
        CompUoM_options += '<option value="' + su.sales_unit + '" selected="selected">' + su.sales_unit + '</option>';
      else
        CompUoM_options += '<option value="' + su.sales_unit + '">' + su.sales_unit + '</option>';
      if(am.Estimated_Order_Qty_UoM__c == su.sales_unit)
        EstUoM_options += '<option value="' + su.sales_unit + '" selected="selected">' + su.sales_unit + '</option>';
      else
        EstUoM_options += '<option value="' + su.sales_unit + '">' + su.sales_unit + '</option>';
      if(am.CSP_UoM__c == su.sales_unit)
        PriceUoM_options += '<option value="' + su.sales_unit + '" selected="selected">' + su.sales_unit + '</option>';
      else
        PriceUoM_options += '<option value="' + su.sales_unit + '">' + su.sales_unit + '</option>';
      if(am.CSP_Tier_UoM__c == su.sales_unit)
        VolUoM_options += '<option value="' + su.sales_unit + '" selected="selected">' + su.sales_unit + '</option>';
      else
        VolUoM_options += '<option value="' + su.sales_unit + '">' + su.sales_unit + '</option>';
   }

}

String PRT_Form_A = '<span class="step" id="step_' + am.id + '">';
PRT_Form_A += '<div class="input">';
PRT_Form_A += '<table>';
PRT_Form_A += '<thead><tr><th>';
if(matmap.containskey(am.sap_material__c))
  PRT_Form_A += matmap.get(am.SAP_Material__c).name;
PRT_Form_A += '</th><th>';
if(amap.containskey(am.Account__c))
  PRT_Form_A += amap.get(am.Account__c).name;
PRT_Form_A += '<span class="font_normal_07em_black">Step [stepnum] of [steptot]</span>';
PRT_Form_A += '</th></tr></thead>';
PRT_Form_A += '<tr><td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<table class="gridtable">';
PRT_Form_A += '<thead><tr><th>Date Range</th><th>Competitor Information</th></tr></thead>';
PRT_Form_A += '<tr style="height:10px;"/>';
PRT_Form_A += '<tr>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<label for="FromDate_' + am.id + '">Effective Date</label><br />';
PRT_Form_A += '<input name="FromDate_' + am.id + '" class="FromDate" data-record="' + am.id + '"/><br />';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<label for="Competitor_' + am.id + '">Competitor</label><br />';
PRT_Form_A += '<select name="Competitor_' + am.id + '" id="Competitor_' + am.id + '" class="Competitor" style="height:24px;width:290px;">';
PRT_Form_A += '</select>';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '</tr>';
PRT_Form_A += '<tr>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<label for="ToDate_' + am.id + '">Expiration Date</label><br />';
PRT_Form_A += '<input name="ToDate_' + am.id + '" id = "ToDate_' + am.id + '" class="ToDate" data-record="' + am.id + '"/><br />';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<label for="ObtainedFrom_' + am.id + '">Obtained From</label><br />';
PRT_Form_A += '<select style="height:24px;width:290px;" class="formSel" name="ObtainedFrom_' + am.id + '" id="ObtainedFrom_' + am.id + '">';
PRT_Form_A += '<option value="Customer - Verbal">Customer - Verbal</option>';
PRT_Form_A += '<option value="Customer - Written">Customer - Written</option>';
PRT_Form_A += '<option value="General Market Knowledge">General Market Knowledge</option>';
PRT_Form_A += '</select><br/>';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '</tr>';
PRT_Form_A += '<tr>';
PRT_Form_A += '<td/>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<label for="CompPrice_' + am.id + '">Competitive Price</label><br />';
PRT_Form_A += '<table><tr><td style="vertical-align:top;">';
PRT_Form_A += '<input name="CompPrice_' + am.id + '" id="CompPrice_' + am.id + '" class="CompPrice" />';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</td><td style="vertical-align:top;">';
PRT_Form_A += '<select name="CompUoM_' + am.id + '" id="CompUoM_' + am.id + '" class="formSelUoM" style="width:120px;">';
PRT_Form_A += CompUoM_Options + '</select>';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</td></tr></table>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '</tr>';
PRT_Form_A += '</table>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td><td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<table class="gridtable">';
PRT_Form_A += '<thead><th colspan="2">Other Information</th></thead>';
PRT_Form_A += '<tr style="height:10px;"/>';
PRT_Form_A += '<tr><td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<label for="type_' + am.id + '">Type</label><br />';
PRT_Form_A += '<div class="component-demo-wrapper">';
PRT_Form_A += '<div class="onoffswitch">';
PRT_Form_A += '<input type="checkbox" name="type_' + am.id + '" id="type_' + am.id + '" class="onoffswitch-checkbox" checked="checked"/>';
PRT_Form_A += '<label class="onoffswitch-label" for="type_' + am.id + '">';
PRT_Form_A += '<div class="onoffswitch-inner" data-on="CSP" data-off="Quote"></div>';
PRT_Form_A += '<div class="onoffswitch-switch"></div>';
PRT_Form_A += '</label>';
PRT_Form_A += '</div></div>';
PRT_Form_A += '</td>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<div>';
PRT_Form_A += '<label for="EstOrderQty_' + am.id + '">Estimated Order Quantity</label><br />';
PRT_Form_A += '<table><tr><td style="vertical-align:top;">';
PRT_Form_A += '<input name="EstOrderQty_' + am.id + '" id="EstOrderQty_' + am.id + '" />';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</td><td style="vertical-align:top;">';
PRT_Form_A += '<select name="EstUoM_' + am.id + '" id="EstUoM_' + am.id + '" class="formSelUoM" style="width:120px;">';
PRT_Form_A += EstUoM_Options + '</select>';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</td></tr></table>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '</tr>';
PRT_Form_A += '<tr><td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<label>Drum Deposit</label><br/>';
PRT_Form_A += '<div class="component-demo-wrapper">'; 
PRT_Form_A += '<div class="onoffswitch">';
PRT_Form_A += '<input type="checkbox" name="DrumDep_' + am.id + '" id="DrumDep_' + am.id + '" class="onoffswitch-checkbox" checked="checked"/>';
PRT_Form_A += '<label class="onoffswitch-label" for="DrumDep_' + am.id + '">';
PRT_Form_A += '<div class="onoffswitch-inner" data-on="No" data-off="Yes"></div>';
PRT_Form_A += '<div class="onoffswitch-switch"></div>';
PRT_Form_A += '</label>';
PRT_Form_A += '</div></div>';
PRT_Form_A += '</td><td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<label for="PriceProt_' + am.id + '">Price Protection</label><br />';
PRT_Form_A += '<div>';
PRT_Form_A += '<select name="PriceProt_' + am.id + '" id="PriceProt_' + am.id + '" style="width:240px;">';
PRT_Form_A += '<apex:outputtext value="{!PriceProtections}" escape="false"/>';
PRT_Form_A += '</select>';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td>';
PRT_Form_A += '</tr>';
PRT_Form_A += '<tr>';
PRT_Form_A += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_A += '<label for="Curr_' + am.id + '">Currency</label><br />';
PRT_Form_A += '<div>';
PRT_Form_A += '<select name="Curr_' + am.id + '" id="Curr_' + am.id + '" class="formSel" style="width:120px;">' + curroptions;
PRT_Form_A += '</select>';
PRT_Form_A += '<div class="error_container"/>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td><td/></tr>';
PRT_Form_A += '</table>';
PRT_Form_A += '</div>';
PRT_Form_A += '</td></tr>';

String PRT_Form_B = '<tr><td style="vertical-align:top;padding-right:10px;" colspan="2">';
PRT_Form_B += '<div>';
PRT_Form_B += '<span class="font_normal_07em_black">Pricing Information</span><br />';
PRT_Form_B += '<table class="gridtable">';
PRT_Form_B += '<thead>';
PRT_Form_B += '<th>Volume</th>';
PRT_Form_B += '<th>UoM</th>';
PRT_Form_B += '<th>Price</th>';
PRT_Form_B += '<th>UoM</th>';
PRT_Form_B += '<th></th>';
PRT_Form_B += '</thead>';
PRT_Form_B += '<tr style="height:10px;"/>';
PRT_Form_B += '<tr>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_0_' + am.id + '" id="Volume_0_' + am.id + '"/><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><select name="VolUoM_' + am.id + '" id="VolUoM_' + am.id + '"class="formSelUoM" style="width:120px;">' + voluom_options + '</select><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_0_' + am.id + '" id="Price_0_' + am.id + '"/><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><select name="PriceUoM_' + am.id + '" id="PriceUoM_' + am.id + '" class="formSelUoM" style="width:120px;">' + priceuom_options + '</select><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';
PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_1_' + am.id + '" id="Volume_1_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_1_' + am.id + '" id="Price_1_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';

PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_2_' + am.id + '" id="Volume_2_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_2_' + am.id + '" id="Price_2_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';

PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_3_' + am.id + '" id="Volume_3_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_3_' + am.id + '" id="Price_3_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';

PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_4_' + am.id + '" id="Volume_4_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_4_' + am.id + '" id="Price_4_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';

PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_5_' + am.id + '" id="Volume_5_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_5_' + am.id + '" id="Price_5_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';

PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_6_' + am.id + '" id="Volume_6_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_6_' + am.id + '" id="Price_6_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';

PRT_Form_B += '<tr class="formrow">';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Volume_7_' + am.id + '" id="Volume_7_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>'; 
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;">';
PRT_Form_B += '<div><input name="Price_' + am.id + '" id="Price_' + am.id + '" /><br />';
PRT_Form_B += '<div class="error_container"/></div></td>';
PRT_Form_B += '<td style="vertical-align:top;padding-right:10px;"/>';
PRT_Form_B += '<td><table><tr>';
PRT_Form_B += '<td class="imgopen"></td>';
PRT_Form_B += '<td class="imgclosed"></td>';
PRT_Form_B += '</tr></table>';
PRT_Form_B += '</td>';
PRT_Form_B += '</tr>';
PRT_Form_B += '</table>';
PRT_Form_B += '</div>';
PRT_Form_B += '</td></tr>';

String PRT_Form_C = '<tr><td style="vertical-align:top;padding-right:10px;" colspan="2">';
PRT_Form_C += '<div>';
PRT_Form_C += '<span class="font_normal_07em_black">Step 3 - Pricing Information</span><br />';
PRT_Form_C += '<table class="gridtable">';
PRT_Form_C += '<thead>';
PRT_Form_C += '<th>Price</th>';
PRT_Form_C += '<th>UoM</th>';
PRT_Form_C += '</thead>';
PRT_Form_C += '<tr style="height:10px;"/><tr class="formrow"><td>';
PRT_Form_C += '<input name="Price_' + am.id + '" id="Price_' + am.id + '" ></input></td><td>';
PRT_Form_C += '<input name="PriceUOM_' + am.id + '" id="PriceUOM_' + am.id + '" disabled="disabled">'+ am.CSP_UoM__c +'</input></td></tr>';
PRT_Form_C += '</table></div></td></tr>';

String PRT_Form_D = '</table>';
PRT_Form_D += '</div>';
PRT_Form_D += '</span>';

//am.PRT_Form__c = PRT_Form_A + PRT_Form_B + PRT_Form_D;
//am.Adjust_Form__c = PRT_Form_A + PRT_Form_C + PRT_Form_D;
}
*/
//Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'getPRTForm', 1919);
}
Public class SFDC_maps{

Public Map<Id, List<Price_Request_Transaction__c>> PRT_Map{get; set;}
Public Map<String, Price_Request_Transaction__c> Price_Request_Map{get; set;}
Public Map<Id, List<SAP_Price_Tier__c>> Price_request_tiers_map{Get; set;}
Public Map<String, List<SAP_Price_Tier__c>> Price_request_tier_map{Get; set;}

Public SFDC_Maps(Map<Id, List<Price_Request_Transaction__c>> PRT_Map, Map<Id, List<SAP_Price_Tier__c>> Tiers_Map)
{  this.prt_map = PRT_Map; Price_Request_Tiers_Map = tiers_Map; price_request_map = new Map<String, Price_Request_Transaction__c>(); price_Request_Tier_Map = new Map<string, List<SAP_Price_Tier__c>>();}
Public SFDC_Maps(Map<String, Price_Request_Transaction__c> Price_Request_Map, Map<String, List<SAP_Price_Tier__c>> Tiers_Map)
{  this.prt_map = new Map<Id, List<Price_Request_Transaction__c>>(); Price_Request_Tier_Map = tiers_Map; Price_Request_Tiers_Map = new Map<Id, List<SAP_Price_Tier__c>>(); this.price_Request_map = Price_request_Map;}

}

/*added for rfq form*/

Public Static List<Price_Request_Transaction__c> insertTransactionsrfq(List<Account_Material__c> ams, Map<String, String> amap){
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'insertTransactions', 132);
  System.debug('inside insertTransactionsrfq');
  List<Price_Request_Transaction__c> transactions = getTransactionsrfq(ams, amap);
  Map<Id, Price_Request_Transaction__c> tmap = new map<Id, Price_Request_Transaction__c>();
  List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
  if(transactions.size() > 0)
  Insert transactions;
  
  for(Price_Request_Transaction__c t:transactions)
  {  
     tmap.put(t.id, t); 
     sap_price__c req = new SAP_Price__c();

     req.Price_Request_Transaction__c = t.id;

     req.type__c = 'Requested';
     
     req.PRT_Type__c = t.Type__c;
 
     req.Quantity__c = t.Quantity__c;

     req.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;

     sapprices.add(req);
  }
  if(sapprices.size() > 0)
  insert sapprices;
  List<SAP_Price_Tier__c> alltiers = new List<SAP_Price_Tier__c>();
  for(SAP_Price__c pr:sapprices)
  {
    List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
    if(pr.type__c == 'Requested')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'CSP')
       if(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Target')
       if(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c, List<SAP_Price_Tier__c>.class);
    
    for(SAP_Price_Tier__c t:tiers)
       t.SAP_Price__c = pr.id;
    alltiers.addall(tiers);
  }
  if(alltiers.size() > 0)
  insert alltiers;
  
  if(transactions.size() > 0)
  upsert transactions;
  
  Map<String, Double> CurrencyMap = new Map<String, Double>();
  for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
  {
       if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, C.ConversionRate);
  }
    FetchMyInnerTable(ams, CurrencyMap);
   upsert ams;
  //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'insertTransactions', 187);
  return transactions;
}


Public static List<Price_Request_Transaction__c> getTransactionsrfq(List<Account_Material__c> ams, Map<String, String> amap){
    System.debug('inside getTransactionsrfq');
    boolean uomFlag = True;
    Map<String, Double> CurrencyMap = new Map<String, Double>();

    for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
    {
        if(c.isocode != '' && c.isocode != null)
        CurrencyMap.put(c.IsoCode, C.ConversionRate);
    }
    Integer tiercount = 0;
    String suppliername;
    for(string s:amap.keyset())
    if(s.contains('bracketvolume_'))
       tiercount = tiercount + 1;
        
    System.debug('tier count is'+tiercount );
      
    List<Price_Request_Transaction__c> transactions = new list<Price_Request_Transaction__c>();
    List<String> aids = new List<String>();
    
    for(Account_material__c am:ams)
    {
        Price_Request_Transaction__c PRT = new Price_Request_Transaction__c();
        //PRT.SAP_Data__c = am.SAP_Data__c;
        //CSP_JSON_Response response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
        //system.debug(response);
        //Map<String, Double> conversionmap = getconversionmap(PRT, response.tbl_sales_units);
        PRT.Approval_Status__c = 'Submitted';
        PRT.Account_Material__c = am.id;
        PRT.Account_Material__r = am;
        //PRT.SAP_Material__c = am.SAP_Material__c;
        //PRT.SAP_Material__r = am.SAP_Material__r;
        PRT.ship_to__c = am.Account__c;
        PRT.Ship_to_dm__c = am.Account__r.owner.managerid;
        system.debug('am.Account__r is : ' +am.Account__r);
        system.debug('am.Account__c is : ' + am.Account__c);
        
        PRT.ship_to__r = am.Account__r;
        if(am.Account_Sold_To_Id__c != null)
          aids.add(am.Account_Sold_To_Id__c);
        if(am.Account_Corp_Account_Id__c != null)
          aids.add(am.Account_Corp_Account_Id__c);
        //PRT.sold_to__c = am.Account_Sold_To_Id__c;
        //PRT.Corporate_account__c = am.Account_Corp_Account_Id__c;
        PRT.average_order_qty__c = am.Avg_Order_Qty__c;
        PRT.average_Order_Qty_UoM__c = am.Avg_Order_Qty_Uom__c;
           
        String DefaultPriceProt = '';
        if(amap.containskey('effdate')){ PRT.Requested_Effective_Date__c = datetime.newinstance(long.valueof(amap.get('effdate'))).dategmt(); }
        if(amap.containskey('exdate')){ PRT.Requested_Expiration_Date__c = datetime.newinstance(long.valueof(amap.get('exdate'))).dategmt(); }
        if(amap.containskey('currency')){ 
        if((amap.get('currency')).length() > 3)
            PRT.currencyisocode = (amap.get('currency')).substring(0,3);
        else
            PRT.currencyisocode = amap.get('currency'); 
        PRT.CSP_Currency__c = amap.get('currency'); }
        if(amap.containskey('pricetype')){ PRT.type__c = amap.get('pricetype'); }
        
        if(amap.containskey('drdep')){ PRT.Requested_Drum_Deposit__c = amap.get('drdep'); }
        if(amap.containskey('bracketprice_0')){ PRT.Price__c = stringtodouble(amap.get('bracketprice_0')); }
        //if(amap.containskey('bracketprice')){ PRT.Price__c = stringtodouble(amap.get('bracketprice')); }
        if(amap.containskey('brpriceuom')){ PRT.Requested_Price_UoM__c = amap.get('brpriceuom'); }
        if(amap.containskey('bracketvolume_0')){ PRT.Volume__c = stringtodouble(amap.get('bracketvolume_0')); }
        if(amap.containskey('brvoluom')){ PRT.Requested_UoM__c = amap.get('brvoluom'); }
        if(amap.containskey('ordervol')){ PRT.Quantity__c = stringtodouble(amap.get('ordervol')); }
        if(amap.containskey('ordervoluom')){ PRT.Estimated_Order_Qty_UoM__c = amap.get('ordervoluom'); }
        if(amap.containskey('competitorid')){ PRT.Competitor__c = amap.get('competitorid'); }
        if(amap.containskey('obtainedfrom')){ PRT.Competitor_Obtained_From__c = amap.get('obtainedfrom'); }
        if(amap.containskey('compprice')){ system.debug('***************************'+stringtodouble(amap.get('compprice')));PRT.Competitive_Price__c = stringtodouble(amap.get('compprice')); }
        if(amap.containskey('compuom')){ PRT.Competitive_UoM__c = amap.get('compuom'); }
        if(amap.containskey('obtainedfrom')){ PRT.Competitor_obtained_From__c = amap.get('obtainedfrom');  }    
        if(amap.containskey('priceprot')){ PRT.Requested_Price_Protection__c = amap.get('priceprot'); }
        if(amap.containskey('ReasonCode')){ PRT.Reason_Code__c = amap.get('ReasonCode'); }
        if(amap.containskey('comments')){ PRT.comments__c = amap.get('comments'); }
                
        if(amap.containskey('application')){ PRT.Application__c = amap.get('application'); }
        if(amap.containskey('pacCode')){ PRT.PAC_Code__c = amap.get('pacCode'); }
        if(amap.containskey('oem')){ PRT.OEM__c = amap.get('oem'); }
        if(amap.containskey('SpecifiedMaterial')){ PRT.Specified_Material__c = amap.get('SpecifiedMaterial'); }
        if(amap.containskey('ExistingBusiness')){ PRT.Existing_Business_for_Customer__c = amap.get('ExistingBusiness'); }
        if(amap.containskey('CompetitiveProducer')){ PRT.Competitive_Producer__c = amap.get('CompetitiveProducer'); }
        if(amap.containskey('competitivegrade')){ PRT.Competitive_Grade__c = amap.get('competitivegrade'); }
        if(amap.containskey('estanualVol')){ PRT.Estimated_Annual_Volume__c = stringtodouble(amap.get('estanualVol')); }
        if(amap.containskey('estanualUom')){ PRT.Estimated_Annual_Volume_UOM__c = amap.get('estanualUom'); }
        if(amap.containskey('supplier')){ am.supplier__c = amap.get('supplier'); PRT.Prospect_Material_Supplier__c = amap.get('supplier');}
        if(amap.containskey('description')){ am.Material_Description__c = amap.get('description');PRT.Prospect_Material_Description__c = amap.get('description'); }
        if(amap.containskey('ContainerForNewMaterial')){ am.Container_for_new_material__c = amap.get('ContainerForNewMaterial'); PRT.Prospect_Material_Container__c = amap.get('ContainerForNewMaterial');}
        
        suppliername = am.Supplier__c;
        List<Price_Request_Approver__c> pra =[Select id, Supplier_Name__c,  Approver__c from Price_Request_Approver__c where Supplier_Name__c =: suppliername limit 1];
        
        if(pra.size()>0){  
            PRT.Approver__c =pra[0].Approver__c;
            System.debug('PRT Approver is '+PRT.Approver__c);       
        }
        else
        {
            
            List<Price_Request_Approver__c> pradefault =[Select id, Approval_Level__c, Is_Active__c, Supplier_Name__c, Approver__c,Division_Code__c, Division_Desc__c from Price_Request_Approver__c where Division_Code__c = '32' and Division_Desc__c = 'Plastics' and Supplier_Name__c ='' and Approval_Level__c = 'Exception 2' and Is_Active__c = true and sap_sales_group_code__c = '' and plm__c = '' and material_group_4__c = '' limit 1]; 
            if(pradefault.size() > 0){
                PRT.Approver__c = pradefault[0].Approver__c;
                system.debug('default app:'+PRT.Approver__c);
            }
        }
        
        if(am.Supplier__c != '' && am.Supplier__c != null){
            prt.Approval_Level__c = 'Exception 2';
        }
            
        system.debug('appcomments key:'+amap.containskey('appcomments'));
        system.debug('get appcomments:'+amap.get('appcomments'));
        if(amap.containskey('appcomments')){ 
        system.debug('inside appcomments');
        PRT.Approval_Rejection_Comments__c = amap.get('appcomments'); }
        if(amap.containskey('coordcomments')){ PRT.Coordinator_Comments__c = amap.get('coordcomments'); }
      
        List<SAP_Price_Tier__c> Requested = new List<SAP_Price_Tier__c>();
        
        for(integer i=0; i<tiercount; i++)  
        {  
                SAP_Price_Tier__c t = new SAP_Price_Tier__c();
                t.effective_date__c = PRT.Requested_Effective_Date__c;
                t.expiration_date__c = PRT.Requested_Expiration_Date__c;
                system.debug('Requested Date: ' + t.effective_date__c);
                if(amap.containskey('currency'))     
                   if(amap.get('currency') != '' && amap.get('currency') != null){
                    if((amap.get('currency')).length() > 3)
                        t.currencyisocode = (amap.get('currency')).substring(0,3);
                    else
                        t.currencyisocode = amap.get('currency');
                     t.SAP_Currency__c = amap.get('currency');}
                t.Volume__c = stringtodouble(amap.get('bracketvolume_' + i));
                if(amap.containskey('brvoluom'))     
                   if(amap.get('brvoluom') != '' && amap.get('brvoluom') != null)
                      t.Volume_UoM__c = amap.get('brvoluom');
                if(amap.containskey('brpriceuom'))     
                   if(amap.get('brpriceuom') != '' && amap.get('brpriceuom') != null)
                      t.Price_UoM__c = amap.get('brpriceuom');
                if(amap.get('bracketprice_' + i) != '' && amap.get('bracketprice_' + i) != null){
                      t.Price__c = stringtodouble(amap.get('bracketprice_' + i));
                      t.req_price__c = amap.get('bracketprice_' + i);}
    
               requested.add(t);
         }
         system.debug('Requested: ' + requested);      
      
         PRT.Requested_Tiers__c = JSON.serialize(requested);

         transactions.add(PRT);
         system.debug('PRT Record is:'+transactions);
      
         System.debug('OPEN OR NOT'+am.Has_Open_PRT__c);
         am.Has_Open_PRT__c = true;
         System.debug('after setting!!!'+am.Has_Open_PRT__c); 
     
  }
  update ams;
  
  Map<String, String> approver_map = Price_Request_Approval_Functions.FetchApproverMap(transactions);
  Map<Id, User> alluser = new Map<Id, User>([select id, name, backup__c,Out_of_office__c  from user where isactive = true limit 50000]);
  Map<Id, Account> accmap = new Map<id, Account>([select id from Account where id IN :aids]);
  Map<Id, User> User_map = new map<Id, User>([select id, name from user where isactive = true limit 10000]);
  
  for(Price_Request_Transaction__c prt:transactions)
  {
      String s = Approver_Map.get(prt.Account_material__c);
      if(accmap.containskey(prt.Account_Material__r.Account_Sold_To_Id__c))
        prt.Sold_To__c = accmap.get(prt.Account_Material__r.Account_Sold_To_Id__c).id;
      if(accmap.containskey(prt.Account_material__r.Account_Corp_Account_Id__c))
        prt.Corporate_Account__c = accmap.get(prt.Account_Material__r.Account_Corp_Account_Id__c).id;
      List<String> sl = s.split(';');
      if(sl.get(0) == 'Catch All')
      { 
        //prt.Approval_Level__c = sl.get(0);
        //prt.Approver__c = null;
        prt.Approval_Backup__c = null;  
      }
      else if(sl.get(0) == 'Auto-Approved')
      { 
        //prt.Approval_Level__c = sl.get(0);
        //prt.Approver__c = userinfo.getuserid();
       // system.debug('user_map.get(userinfo.getuserid()'+user_map.get(userinfo.getuserid()));
        //prt.Approver__r = user_map.get(userinfo.getuserid());
        prt.Approval_Backup__c = null;  
      }
      else
      {
        prt.Approval_Level__c = sl.get(0);
        if(user_map.containskey(sl.get(1)))
        {
          //prt.Approver__c = sl.get(1);
          //prt.approver__r = user_map.get(sl.get(1));
        }
        else
        {
          //prt.Approval_Level__c = 'Catch All';
          //prt.Approver__c = null;
          prt.Approval_Backup__c = null;        
        }
        if(sl.get(2) != prt.approver__c && user_map.containskey(sl.get(2)))
        {
          prt.approval_backup__r = user_map.get(sl.get(2));
          prt.Approval_Backup__c = sl.get(2);
        }
        else
          prt.Approval_Backup__c = null;
      }
  }
    
  System.debug('returning from getTransactionsrfq'+transactions );
  return transactions ;
}

Public Static List<Price_Request_Transaction__c> getTransactionsrfq(List<Price_Request_Transaction__c> transactions_in, Map<String, String> amap, String opt, Boolean CMflag){
    List<String> amids = new List<String>();
    String appComments = '';
    Map<String, String> comments = new Map<String, String>();
    Map<String, String> approverLevel = new Map<String, String>();
    Map<String, Decimal> tpiMap = new Map<String, Decimal>();
    Map<String, Decimal> priceMap = new Map<String, Decimal>();
    Map<String, Price_Request_Transaction__c> prtmap = new Map<String, Price_Request_Transaction__c>();
    //Boolean CMflag = false;

    for(Price_Request_Transaction__c prt:transactions_in)
    {   amids.add(prt.account_material__c);
        prtmap.put(prt.account_material__c, prt);
     
        comments.put(prt.account_material__c, prt.comments__c);
        
  
        approverLevel.put(prt.account_material__c, prt.Approval_Level__c);
        tpiMap.put(prt.account_material__c, prt.TPI__c);
        priceMap.put(prt.account_material__c, prt.Price__c);
    }
    
    
    List<Account_Material__c> ams = getaccountmaterials(amids);
    List<Price_Request_Transaction__c> transactions_out = new List<Price_Request_Transaction__c>();
    if(opt != 'convert' && transactions_in.get(0).prospect_material__c)    
        transactions_out = getTransactionsrfq(ams, amap);
    else
        transactions_out = getTransactions(ams, amap, CMflag);
  
  
  
    for(Price_request_transaction__c prt:transactions_out)
    {
        prtmap.get(prt.account_material__c).Requested_Effective_Date__c = prt.Requested_Effective_Date__c;
        prtmap.get(prt.account_material__c).Requested_Expiration_Date__c = prt.Requested_Expiration_Date__c;
        prtmap.get(prt.account_material__c).quantity__c = prt.quantity__c;
        prtmap.get(prt.account_material__c).Estimated_Order_Qty_UoM__c = prt.Estimated_Order_Qty_UoM__c;
        prtmap.get(prt.account_material__c).volume__c = prt.volume__c;
        prtmap.get(prt.account_material__c).Requested_UoM__c = prt.Requested_UoM__c;
        prtmap.get(prt.account_material__c).price__c = prt.price__c;
        prtmap.get(prt.account_material__c).Requested_Price_UoM__c = prt.Requested_Price_UoM__c;
        prtmap.get(prt.account_material__c).currencyisocode = prt.currencyisocode;
        prtmap.get(prt.account_material__c).CSP_Currency__c = prt.CSP_Currency__c;
        prtmap.get(prt.account_material__c).TPI__c = prt.TPI__c;
        prtmap.get(prt.account_material__c).SAP_Data__c = prt.SAP_Data__c;
        prtmap.get(prt.account_material__c).Requested_Tiers__c = prt.Requested_Tiers__c;
        system.debug('prt.prospect_material__c flag is:'+prt.prospect_material__c);
        if(prt.prospect_material__c != true){
        prtmap.get(prt.account_material__c).CSP_Tiers__c = prt.CSP_Tiers__c;
        prtmap.get(prt.account_material__c).Target_Tiers__c = prt.Target_Tiers__c;
        }
        if(prt.Approval_Rejection_Comments__c != null && prt.Approval_Rejection_Comments__c != '')
        {prtmap.get(prt.account_material__c).Approval_Rejection_Comments__c = prt.Approval_Rejection_Comments__c;}
        if(prtmap.get(prt.account_material__c).Approval_Status__c == 'Pending Entry')
            appComments = prtmap.get(prt.account_material__c).Approval_Rejection_Comments__c;
        else 
            appComments = prt.Approval_Rejection_Comments__c;
        prtmap.get(prt.account_material__c).Coordinator_Comments__c = prt.Coordinator_Comments__c;
        prtmap.get(prt.account_material__c).Price_Support_Rebate__c = prt.Price_Support_Rebate__c;
        prtmap.get(prt.account_material__c).IC_Charge__c = prt.IC_Charge__c;
        prtmap.get(prt.account_material__c).Additional_Charges__c = prt.Additional_Charges__c;
        prtmap.get(prt.account_material__c).Material_Cost__c = prt.Material_Cost__c;
        prtmap.get(prt.account_material__c).Variable_Warehouse__c = prt.Variable_Warehouse__c;
        prtmap.get(prt.account_material__c).CM_Revenue__c = prt.CM_Revenue__c;
        prtmap.get(prt.account_material__c).Contribution_Margin__c = prt.Contribution_Margin__c;
        prtmap.get(prt.account_material__c).Unit_Contribution_Margin__c = prt.Unit_Contribution_Margin__c;
        prtmap.get(prt.account_material__c).Unit_Material_Cost__c = prt.Unit_Material_Cost__c;
        prtmap.get(prt.account_material__c).Unit_Warehouse_Charge__c = prt.Unit_Warehouse_Charge__c;
        prtmap.get(prt.account_material__c).Unit_Freight_Charge__c = prt.Unit_Freight_Charge__c;
        prtmap.get(prt.account_material__c).CM_Percent__c = prt.CM_Percent__c;
        prtmap.get(prt.account_material__c).CM_Message__c = prt.CM_Message__c;
        prtmap.get(prt.account_material__c).CM_Status__c = prt.CM_Status__c;
        prtmap.get(prt.account_material__c).CM_Quantity_Sent__c = prt.CM_Quantity_Sent__c;
        prtmap.get(prt.account_material__c).CM_Price_Sent__c = prt.CM_Price_Sent__c;
        prtmap.get(prt.account_material__c).CM_Flag__c = CMflag;
        prtmap.get(prt.account_material__c).Freight_Terms__c = prt.Freight_Terms__c;
      //  prtmap.get(prt.account_material__c).Inner_Table__c = AlternatePrice_InnerTable(prt,avgqty.get(prt.account_material__c), avguom.get(prt.account_material__c));
        prtmap.get(prt.account_material__c).Inner_Table__c = AlternatePrice_InnerTable(prt,comments.get(prt.account_material__c),appComments);   
       system.debug('prtmap.get(prt.account_material__c).CM_Percent__c:'+prtmap.get(prt.account_material__c).CM_Percent__c);
       if(opt == 'rejectAlt'){
        system.debug('getTransaction BEFORE::'+prtmap.get(prt.account_material__c).Approver_Match__c);
        if(prt.Approver__r.Name !=null){
            
            if(prt.Approver__c != userinfo.getuserid() && approverLevel.get(prt.account_material__c) == 'Exception 1' && prt.Approval_Level__c == 'Exception 2'){
                prtmap.get(prt.account_material__c).Approver_Match__c = False;
            }else{
                prtmap.get(prt.account_material__c).Approver_Match__c = True;
            }
            
        }else{
            prtmap.get(prt.account_material__c).Approver_Match__c = True;
        }
        system.debug('getTransaction AFTER::'+prtmap.get(prt.account_material__c).Approver_Match__c);
        }
       /* system.debug('getTransaction BEFORE::'+prtmap.get(prt.account_material__c).Coordinator_Check__c);
        if((tpiMap.get(prt.account_material__c) == prt.TPI__c && priceMap.get(prt.account_material__c) == prt.Price__c) ||
        (tpiMap.get(prt.account_material__c) == prt.TPI__c && priceMap.get(prt.account_material__c) < prt.Price__c) ||
        (tpiMap.get(prt.account_material__c) < prt.TPI__c && priceMap.get(prt.account_material__c) < prt.Price__c) ||
        (tpiMap.get(prt.account_material__c) < prt.TPI__c && priceMap.get(prt.account_material__c) == prt.Price__c))
            prtmap.get(prt.account_material__c).Coordinator_Check__c =  False;
        else
            prtmap.get(prt.account_material__c).Coordinator_Check__c = True;
        system.debug('getTransaction AFTER::'+prtmap.get(prt.account_material__c).Coordinator_Check__c);  
        */ 
        prtmap.get(prt.account_material__c).Approver__c = prt.Approver__c;
        prtmap.get(prt.account_material__c).Approver__r = prt.Approver__r;
        prtmap.get(prt.account_material__c).Approval_Backup__c = prt.Approval_Backup__c;
        prtmap.get(prt.account_material__c).Approval_Level__c = prt.Approval_Level__c;
        prtmap.get(prt.account_material__c).Reason_Code__c = prt.Reason_Code__c;
        prtmap.get(prt.account_material__c).Requested_Price_Protection__c = prt.Requested_Price_Protection__c;
        prtmap.get(prt.account_material__c).Type__c = prt.Type__c;
        
        if(opt != 'convert'){
        prtmap.get(prt.account_material__c).Application__c = prt.Application__c;
        prtmap.get(prt.account_material__c).PAC_Code__c = prt.PAC_Code__c;
        prtmap.get(prt.account_material__c).OEM__c = prt.OEM__c;
        prtmap.get(prt.account_material__c).Specified_Material__c = prt.Specified_Material__c;
        prtmap.get(prt.account_material__c).Existing_Business_for_Customer__c = prt.Existing_Business_for_Customer__c;
        prtmap.get(prt.account_material__c).Competitive_Producer__c = prt.Competitive_Producer__c;
        prtmap.get(prt.account_material__c).Estimated_Annual_Volume__c = prt.Estimated_Annual_Volume__c;
        prtmap.get(prt.account_material__c).Competitive_Grade__c = prt.Competitive_Grade__c;
        prtmap.get(prt.account_material__c).supplier__c = prt.supplier__c;
        prtmap.get(prt.account_material__c).Prospect_Material_Container__c = prt.Prospect_Material_Container__c;
        prtmap.get(prt.account_material__c).Prospect_Material_Description__c= prt.Prospect_Material_Description__c;
        prtmap.get(prt.account_material__c).Prospect_Material_Supplier__c= prt.Prospect_Material_Supplier__c;
        
        }
                                             
  }
 
  return prtmap.values();
    
}

Public Static List<Price_Request_Transaction__c> upsertTransactionsrfq2(List<Price_Request_Transaction__c> trans, Map<String, String> amap, String reqType, List<String> mat, Boolean CMflag)
{
    //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'upsertTransactions', 37);
  List<Approval.ProcessSubmitRequest> reqs = new list<Approval.ProcessSubmitRequest>();
  List<Price_Request_Transaction__c> transactions = getTransactionsrfq(trans, amap, reqType,CMflag);
  Set<String> types = new Set<String>();
  List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
  List<Account_Material__c> ams = new List<Account_Material__c>();
  Map<Id, Price_Request_Transaction__c> tmap = new map<Id, Price_Request_Transaction__c>();
  for(Price_Request_Transaction__c t:transactions)
  {
      system.debug('t.type__c:'+t.type__c);
      system.debug('t.Account_Material__c:'+t.Account_Material__c);
      system.debug('reqType:'+reqType);
      if(reqType != 'rejectAlt'){
      if(t.Prospect_Material__c == true)
          types = new set<String>{'Requested'};
      else
          types = new set<String>{'Requested','CSP','Target'};
         
      system.debug('Type:'+types);
      sapprices = [select id, type__c from SAP_Price__c where Price_Request_Transaction__c =: t.id and type__c IN :types];
      for(Sap_Price__c pr:sapprices){ pr.type__c = pr.type__c + ' History';}
      }
      //Change Prospect Material Flag value to 'false' on convert rfq
      if(reqType == 'convert' && t.Prospect_Material__c == true){
          ams = [select id, SAP_Material__c,Prospect_Material__c from Account_Material__c where id=:t.Account_Material__c];
          for(Account_Material__c am:ams)
          { am.Prospect_Material__c = false; am.SAP_Material__c = mat[0];}
          t.SAP_Material__c = mat[0];
      }
      
     tmap.put(t.id, t); 
     
     if(reqType == 'convert' || (t.Prospect_Material__c == false && reqType == 'modify')){
         sap_price__c csp = new SAP_Price__c();
         csp.Price_Request_Transaction__c = t.id;
         csp.Quantity__c = t.Quantity__c;
         csp.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
         csp.type__c = 'CSP';
         csp.PRT_Type__c = t.Type__c;
         sapprices.add(csp);
              
         sap_price__c tar = new SAP_Price__c();
         tar.Price_Request_Transaction__c = t.id;
         tar.Quantity__c = t.Quantity__c;
         tar.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
         tar.type__c = 'Target';
         tar.PRT_Type__c = t.Type__c;
         sapprices.add(tar);
     }  
    if(reqType != 'rejectAlt'){    
    sap_price__c req = new SAP_Price__c();
    req.Price_Request_Transaction__c = t.id;
    req.Quantity__c = t.Quantity__c;
    req.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
    req.type__c = 'Requested';
    req.PRT_Type__c = t.Type__c;
    sapprices.add(req);}
    
    if(reqType == 'rejectAlt' && t.Approver_Match__c){
         sap_price__c alt = new SAP_Price__c();
         alt.Price_Request_Transaction__c = t.id;
         alt.Quantity__c = t.Quantity__c;
         alt.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
         alt.type__c = 'Alternate';
         alt.PRT_Type__c = t.Type__c;
         sapprices.add(alt);
         
         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
         req1.setObjectId(t.id);
         reqs.add(req1);}
    else
        t.Approval_Status__c = 'Submitted';
  }
   system.debug('sapprices:'+sapprices);       
  if(sapprices.size() > 0)
    upsert sapprices;
  
  List<SAP_Price_Tier__c> alltiers = new List<SAP_Price_Tier__c>();
  for(SAP_Price__c pr:sapprices)
  {
    List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
    if(pr.type__c == 'Requested')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'CSP')
       if(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Target')
       if(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Alternate')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    
    for(SAP_Price_Tier__c t:tiers)
       t.SAP_Price__c = pr.id;
    alltiers.addall(tiers);
  }
  if(alltiers.size() > 0)
  insert alltiers;
  if(transactions.size() > 0)
  upsert transactions;
  upsert ams;
  
  if(reqType == 'rejectAlt'){
    if(reqs.size() > 0)
    List<Approval.ProcessResult> results = Approval.process(reqs);}
      //Limits_functions.Record_Limits(apexpages.currentpage(), 'Account_Material_Functions', 'upsertTransactions', 126);
  return transactions; 
}

}