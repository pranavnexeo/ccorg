trigger UpdateTierInfo on Price_Request_Transaction__c (before update) {

    List<String> PRTId = new List<String>();
    Map<String, List<SAP_Price_Tier__c>> PRTSAPTierMap= new MAP<String, List<SAP_Price_Tier__c>>();
    Map<String, List<SAP_Price_Tier__c>> PRTSAPTierMapAlt= new MAP<String, List<SAP_Price_Tier__c>>();
    List<String> AMId = new List<String>();
    Map<Id, String> amMatMap = new Map<Id, String>();
     

    for(Integer i=0; i< Trigger.new.size(); i++)
    { 
        PRTId.add(Trigger.new[i].id);
        AMId.add(Trigger.new[i].Account_Material__c);
    }

    for(Account_Material__c ams:[Select id, Material_Group_3__c from Account_Material__c where id IN :AMId])
    {
      amMatMap.put(ams.id, ams.Material_Group_3__c);   
    }
    
    //Retrieve the associated SAP Price Tier records where SAP Price Tier Type='Requested'
    for(SAP_Price_Tier__c spt:[select id, price__c, volume__c, Effective_Date__c, Expiration_Date__c,price_uom__c, volume_uom__c, SAP_Price__c, tpi__c, SAP_Price__r.estimated_order_qty_uom__c,SAP_Price__r.quantity__c,sap_price__r.price_request_transaction__c, req_price__c from SAP_Price_Tier__c 
                               where sap_price__r.type__c = 'Requested' and SAP_Price__r.price_request_Transaction__c IN :PRTId])
        {
          if(PRTSAPTierMap.containskey(spt.sap_price__r.price_request_Transaction__c))
            PRTSAPTierMap.get(spt.sap_price__r.price_request_Transaction__c).add(spt);
          else
            PRTSAPTierMap.put(spt.sap_price__r.price_request_Transaction__c, new List<SAP_Price_Tier__c>{spt});  
       }    
                           
   //Retrieve the associated SAP Price Tier records where SAP Price Tier Type='Alernate'
    for(SAP_Price_Tier__c spt:[select id, price__c, volume__c, Effective_Date__c, Expiration_Date__c,price_uom__c, volume_uom__c, SAP_Price__c, tpi__c, SAP_Price__r.estimated_order_qty_uom__c,SAP_Price__r.quantity__c,sap_price__r.price_request_transaction__c, req_price__c from SAP_Price_Tier__c 
                               where sap_price__r.type__c = 'Alternate' and SAP_Price__r.price_request_Transaction__c IN :PRTId])
        {
          if(PRTSAPTierMapAlt.containskey(spt.sap_price__r.price_request_Transaction__c))
            PRTSAPTierMapAlt.get(spt.sap_price__r.price_request_Transaction__c).add(spt);
          else
            PRTSAPTierMapAlt.put(spt.sap_price__r.price_request_Transaction__c, new List<SAP_Price_Tier__c>{spt});  
       }  
       
       
    for(Price_Request_Transaction__c p:Trigger.new)
    {
     String window = '';
     String windowforseller = '';
     SAP_Price_Tier__c lowesttier;
     
      window += '<table><tr><td style="vertical-align:top;padding-right:1px;">';
      window += '<table class="innerTable" style="width:475px;" id="' + p.id + '"><thead><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>TPI</th></tr></thead>';
      window += '<tbody>';
      
      
      windowforseller += '<table><tr><td style="vertical-align:top;padding-right:1px;">';
      windowforseller += '<table class="innerTable" style="width:475px;" id="' + p.id + '"><thead><tr><th colspan="4">Requested Tiers</th></tr><tr><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>TPI</th><th>Estimated Order Qty</th></tr></thead>';
      windowforseller += '<tbody>';
      
      
      
     if(PRTSAPTierMap.size()>0){
     if(PRTSAPTierMap.containskey(p.id))
     for(SAP_Price_Tier__c t:PRTSAPTierMap.get(p.id))
      {
        
         if(lowesttier== null)
           lowesttier= t;
         else
         {
           if(t.volume__c < lowesttier.volume__c)
             lowesttier= t;
         }  
         
         //InnerTable creation
         window += '<tr>';
          if(t.effective_date__c != null)
            window += '<td>' + t.effective_date__c.format() + '</td><td>'; //formatDate
          else
            window += '<td></td><td>';
          
          if(t.expiration_date__c != null)
            window += t.expiration_date__c.format() + '</td>'; //formatDate
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
          
          
          
         //InnerTable creation for pending seller tab
          windowforseller += '<tr>';
              
          if(t.Effective_Date__c != null)
            windowforseller += '<td>' + t.Effective_Date__c.format() + '</td><td>'; //formatDate
          else
            windowforseller += '<td></td><td>';
          
          if(t.Expiration_Date__c != null)
            windowforseller += t.Expiration_Date__c.format() + '</td>'; //formatDate
          else
            windowforseller += '</td>';
            
          windowforseller += '<td>' + t.volume__c + '</td><td>';
          
          string tpis = '';
          if(t.tpi__c != null)
            tpis = (t.tpi__c ).setScale(2) + '%';
          windowforseller += t.Volume_UoM__c + '</td><td>';
          if(t.req_price__c != null)
          windowforseller += t.req_price__c;
          //windowforseller += t.price__c.setscale(4);
          windowforseller += '</td><td>' + t.price_uom__c + '</td><td>' + tpis+ '</td>'; 
          if(t.SAP_Price__r.quantity__c != null && t.SAP_Price__r.estimated_order_qty_uom__c != null)
            windowforseller += '<td>' + t.SAP_Price__r.quantity__c.intvalue() + ' ' + t.SAP_Price__r.estimated_order_qty_uom__c + '</td></tr>'; 
          else
            windowforseller += '<td></td></tr>';
      }
      
      //lowest tier population
      if(lowesttier != null)
      {
      p.Volume__c = lowesttier.Volume__c;
      p.Requested_UoM__c = lowesttier.Volume_UoM__c;
      p.Price__c = lowesttier.Price__c;
      p.Requested_Price_UoM__c = lowesttier.Price_UoM__c;
      p.TPI__c = lowesttier.TPI__c;
      }
      
      
      //InnerTable creation
      window += '</tbody></table></td><td style="vertical-align:top;padding-right:1px;">';
      window += '<table class="innerTable" style="width:475px;" id="' + p.id + '"><thead>';
      window += '<th>Avg Order Qty</th><th>Estimated Order Qty</th>';
      
      window += '</thead><tbody><td>';
      
      if(p.average_order_qty__c != null)
      window += p.average_order_qty__c.intvalue();
      window += ' ' + p.Average_Order_Qty_UoM__c + '</td>';
      window += '<td>';
      if(p.quantity__c != null)
      window += p.quantity__c.intvalue();
      window += ' ' + p.estimated_order_qty_uom__c + '</td></tbody>';
      window += '</table></td><td style="vertical-align:top;padding-right:1px;">';
      window += '<table class="innerTable"><thead><tr><th>Comments</th><th>Approval Comments</th></tr></thead><tbody><tr><td style="width:300px;vertical-align:top;padding-right:1px;">';
      if(p.comments__c != '' && p.comments__c != null)
      window += p.comments__c;
      window += '</td><td style="vertical-align:top;padding-right:1px;width:300px;">';
      if(p.approval_rejection_comments__c != '' && p.approval_rejection_comments__c != null)
      window += p.approval_rejection_comments__c.replaceall('\n', '<br/>');
      //window += '</td></tr></tbody></table></td></table>';
      window += '</td></tr></tbody>';
      
      if(p.CM_Flag__c){
          if(amMatMap.size()>0)
          if(amMatMap.containskey(p.Account_Material__c))
          if(amMatMap.get(p.Account_Material__c) == 'SPECIALTY')   
          {
          window += '<tr><table class="innerTable"><thead><tr><th colspan=3 align="center">CM Data</th></tr><tr><th>Material Cost</th><th>Variable Cost</th><th>Variable Delivery</th></tr></thead><tbody>';
          window += '<tr><td>' + p.Material_Cost__c + '</td><td>' + p.Variable_Warehouse__c + '</td><td>' + p.Variable_Delivery__c + '</td></tr></tbody></table>';
          window += '<table class="innerTable"><thead><tr><th>Unit Material Cost</th><th>Unit Variable Warehouse</th><th>Unit Variable Delivery</th></tr></thead><tbody>';
          window += '<tr><td>' + p.Unit_Material_Cost__c + '</td><td>' + p.Unit_Warehouse_Charge__c + '</td><td>' + p.Unit_Freight_Charge__c + '</td></tr></tbody></table></tr>';
  
          }
      }//end of CM Flag
      
      window += '</table></td></table>';
      
      // Added code for Alternate Tiers - Manish
      windowforseller += '</tbody></table></td><td style="vertical-align:top;padding-right:1px;">';
      windowforseller += '<table class="innerTable" style="width:475px;" id="' + p.id + '"><thead>';
      windowforseller += '<tr><th colspan="4">Alternate Tiers</th></tr><tr><th>Start Date</th><th>Expiration Date</th><th>Volume</th><th>UoM</th><th>Price</th><th>UoM</th><th>TPI</th><th>Estimated Order Qty</th></tr></thead>';
      windowforseller += '<tbody>';
      
      
      if(PRTSAPTierMapAlt.size()>0){
      if(PRTSAPTierMapAlt.containskey(p.id))
      for(SAP_Price_Tier__c t:PRTSAPTierMapAlt.get(p.id))
      {
          windowforseller += '<tr>';
              
          if(t.Effective_Date__c != null)
            windowforseller += '<td>' + t.Effective_Date__c.format() + '</td><td>'; //formatDate
          else
            windowforseller += '<td></td><td>';
          
          if(t.Expiration_Date__c != null)
            windowforseller += t.Expiration_Date__c.format() + '</td>'; //formatDate
          else
            windowforseller += '</td>';
            
          windowforseller += '<td>' + t.volume__c + '</td><td>';
          
          string tpi = '';
          if(t.tpi__c != null)
            tpi = (t.tpi__c ).setScale(2) + '%';
          windowforseller += t.Volume_UoM__c + '</td><td>';
          if(t.req_price__c != null)
          windowforseller += t.req_price__c;
          //windowforseller += t.price__c.setscale(4);
          windowforseller += '</td><td>' + t.price_uom__c + '</td><td>' + tpi+ '</td>';
          if(t.SAP_Price__r.quantity__c != null && t.SAP_Price__r.estimated_order_qty_uom__c != null)
            windowforseller += '<td>' + t.SAP_Price__r.quantity__c.intvalue() + ' ' + t.SAP_Price__r.estimated_order_qty_uom__c + '</td></tr>'; 
          else
            windowforseller += '<td></td></tr>';
        }
      }
     
        
      //InnerTable creation for pending seller
      windowforseller += '</tbody></table></td><td style="vertical-align:top;padding-right:1px;">';
      windowforseller += '<table class="innerTable"><thead><tr><th>Approval Comments</th></tr></thead><tbody><tr>';
      windowforseller += '<td style="vertical-align:top;padding-right:1px;width:300px;">';
      if(p.approval_rejection_comments__c != '' && p.approval_rejection_comments__c != null)
      windowforseller += p.approval_rejection_comments__c.replaceall('\n', '<br/>');
      windowforseller += '</td></tr></tbody></table></td></table>';
     }
      //Assign Window to 'InnerTable' on Price Request Trasaction
      p.Inner_Table__c = window;
      p.inner_table_for_seller__c = windowforseller;
    }
    
}