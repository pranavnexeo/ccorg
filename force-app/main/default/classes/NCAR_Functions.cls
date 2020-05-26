Public Class NCAR_Functions{

public static string determineRouteTo(String Stage, String Tier1, String Tier2, String Tier3){
 if(Stage == 'Approver'){ 
 // Added by Annes on 06/19/2012
    if(Tier1 == 'ES - Pricing' && Tier2 == 'ES - Not Communicated' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Tax Charged' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Tax Not charged' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Tax Charged' && Tier3 == 'ES - Master Data' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Tax Not charged' && Tier3 == 'ES - Master Data' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Wrong Ship to' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Incorrect Instructions Entered' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Invoice' && Tier2 == 'ES- Invoiced by Manifest' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Invoice' && Tier2 == 'ES - Overcharge' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Invoice' && Tier2 == 'ES - Undercharge' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Invoice' && Tier2 == 'ES - Not Communicated' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Invoice' && Tier2 == 'ES - Customer Disputed' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES - Invoice' && Tier2 == 'ES - Data Entry Error' && Tier3 == 'ES - CSR' ||
      Tier1 == 'ES AP'||
      Tier1 == 'ES - Invoice' && Tier2 == 'Portal' && Tier3 == 'CSR'|| 
      Tier1 == 'ES - Invoice' && Tier2 == 'Portal' && Tier3 == 'Billing'|| 
      Tier1 == 'ES - Invoice' && Tier2 == 'Incorrect Information' && Tier3 == 'CSR'||
      Tier1 == 'ES - Invoice' && Tier2 == 'Incorrect Information' && Tier3 == 'Billing'||
      Tier1 == 'ES - Invoice'&& Tier2 == 'Incorrect Container Type' && Tier3 == 'CSR'||
      Tier1 == 'ES - Pricing' && Tier2 == 'Tier Pricing' && Tier3 == 'CSR'||
      Tier1 == 'ES - Pricing' && Tier2 == 'Incorrect PH' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Label not provided' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'LDRs not provided' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incorrect Manifest printed' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incomplete Manifest (missing material)' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'No Manifest provided' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Order Not Placed' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Pricing Not Entered' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Late Order' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'PH Not Updated' && Tier3 == 'CSR'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Recertification Not Completed' && Tier3 == 'CSR'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Tax Charged' && Tier3 == 'Master Data'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Tax Charged' && Tier3 == 'CSR'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Tax Not charged' && Tier3 == 'Master Data'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Tax Not charged' && Tier3 == 'CSR'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Wrong Ship to' && Tier3 == 'CSR'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Incorrect instructions entered' && Tier3 == 'CSR'||
      Tier1 == 'Incorrect Quality' && Tier2 == 'Over' && Tier3 == 'Vendor'||
      Tier1 == 'Incorrect Quality' && Tier2 == 'Over' && Tier3 == 'Billing'||
      Tier1 == 'Incorrect Quality' && Tier2 == 'Under' && Tier3 == 'Vendor'||
      Tier1 == 'Incorrect Quality' && Tier2 == 'Under' && Tier3 == 'Billing'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Early' && Tier3 == 'CSR'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Late' && Tier3 == 'CSR'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Equipment Not Available' && Tier3 == 'CSR'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Wrong Container Shipped' && Tier3 == 'CSR'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Empty Containers Not Delivered' && Tier3 == 'CSR'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Not Advised of Cancellation/Date Change' && Tier3 == 'CSR'||
      Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Order Entry Error' && Tier3 == 'CSR'||
      Tier1 == 'Product Quality' && Tier2 == 'Damaged Container' && Tier3 == 'Customer'||
      Tier1 == 'Invoice' && Tier2 == 'Partially Billed' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'PGI Entry Error' && Tier3 == 'Billing'||
      Tier1 == 'Pricing' && Tier2 == 'Pricing Not Communicated to biller' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'Overcharge - Vendor' && Tier3 == 'Vendor'||
      Tier1 == 'Pricing' && Tier2 == 'Overcharge - Vendor' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'Overcharge - Vendor' && Tier3 == 'Billing'||
      Tier1 == 'Pricing' && Tier2 == 'Undercharge - Vendor' && Tier3 == 'Vendor'||
      Tier1 == 'Pricing' && Tier2 == 'Undercharge - Vendor' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'Undercharge - Vendor' && Tier3 == 'Billing'||
      Tier1 == 'Pricing' && Tier2 == 'Not communicated to sale' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'Not communicated to sale' && Tier3 == 'Billing'||
      Tier1 == 'Pricing' && Tier2 == 'Customer Disputed' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'Customer Disputed' && Tier3 == 'Billing'||
      Tier1 == 'Pricing' && Tier2 == 'Data Entry Error' && Tier3 == 'CSR'||
      Tier1 == 'Pricing' && Tier2 == 'Data Entry Error' && Tier3 == 'Billing'||
      Tier1 == 'Invoice'

      )
  { return 'Customer Service Lead';}
  
  else if(Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Label not provided' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'LDRs not provided' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incorrect Manifest printed' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incomplete Manifest (missing material)' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'No Manifest provided' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Order Not Placed ' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Pricing Not Entered' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Late Order' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'PH Not Updated' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'PH Not Updated' && Tier3 == 'Customer'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Recertification Not Completed' && Tier3 == 'Customer'||
        Tier1 == 'ES - Product/Container Quality' && Tier2 == 'Damaged Container' && Tier3 == 'Customer'||
        Tier1 == 'ES - Product/Container Quality' && Tier2 == 'Dirty Containers' && Tier3 == 'Customer'||
        Tier1 == 'ES - Product/Container Quality' && Tier2 == 'Containers Not Sealed Correctly' && Tier3 =='Customer'||
        Tier1 == 'ES - Product/Container Quality' && Tier2 == 'Bulging Containers' && Tier3 == 'Customer'||
        Tier1 == 'ES - Product/Container Quality' && Tier2 == 'Leaking Containers' && Tier3 == 'Customer'||
        Tier1 == 'ES - Product/Container Quality' && Tier2 == 'Improperly Labeled Containers' && Tier3 == 'Customer'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Early' && Tier3 == 'Customer'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Late' && Tier3 == 'Customer'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Equipment Not Available' && Tier3 == 'Customer'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Wrong Container Shipped' && Tier3 == 'Customer'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Empty Containers Not Delivered' && Tier3 == 'Customer'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Not Advised of Cancellation/Date Change Customer Product Quality Damaged Container' && Tier3 == 'Customer'
         )
       {return 'CSM'; }
       
     else if(Tier1 == 'ES - Invoice' && Tier2 == 'Incorrect Information' && Tier3 == 'Vendor'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'PH Not Updated' && Tier3 == 'PLMT'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'PH Not Updated' && Tier3 == 'PLMT'||
        Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Recertification Not Completed' && Tier3 == 'PLMT'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Early' && Tier3 ==  'Vendor'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Late' && Tier3 ==  'Vendor'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Equipment Not Available' && Tier3 == 'Vendor'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Wrong Container Shipped' && Tier3 == 'Vendor'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Empty Containers Not Delivered' && Tier3 == 'Vendor'||
        Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Not Advised of Cancellation/Date Change' && Tier3 == 'Vendor'

         )
      
        {return 'Dan Black';}
        
      else if( Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Early' && Tier3 == 'Carrier'||
         Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Late' && Tier3 == 'Carrier'||
         Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Equipment Not Available' && Tier3 == 'Carrier'||
         Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Wrong Container Shipped' && Tier3 == 'Carrier'||
         Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Empty Containers Not Delivered'  && Tier3 == 'Carrier'||
         Tier1 == 'ES - Date/Time Not Met' && Tier2 == 'Not Advised of Cancellation/Date Change' && Tier3 == 'Carrier'
         )
       
       {return 'Mark Cramer';}
         
  
  else if(Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Wrong Ship To' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Product Quality' && Tier2 == 'ES - Damaged Container' && Tier3 == 'ES - Customer' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Wrong Ship To' && Tier3 == 'ES - Customer' ||
      Tier1 == 'ES - Incorrect Order / Account Information' && Tier2 == 'ES - Incorrect Instructions Entered' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Pricing' && Tier2 == 'ES - Not Communicated' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Pricing' && Tier2 == 'ES - Data Entry Error' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Pricing' && Tier2 == 'ES - Overcharge' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Pricing' && Tier2 == 'ES - Undercharge' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Pricing' && Tier2 == 'ES - Not Communicated' && Tier3 == 'ES - Sales' ||
      Tier1 == 'ES - Pricing' && Tier2 == 'ES - Customer Disputed' && Tier3 == 'ES - Sales'||
      Tier1 == 'Pricing' && Tier2 == 'Pricing Not Communicated to biller' && Tier3 == 'Sales'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Wrong Ship to' && Tier3 == 'Sales'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Wrong Ship to' && Tier3 == 'Customer'||
      Tier1 == 'Incorrect Order Information' && Tier2 == 'Incorrect instructions entered' && Tier3 == 'Sales'||
      Tier1 == 'Pricing' && Tier2 == 'Overcharge - Vendor' && Tier3 == 'Sales'||
      Tier1 == 'Pricing' && Tier2 == 'Undercharge - Vendor' && Tier3 == 'Sales'||
      Tier1 == 'Pricing' && Tier2 == 'Not communicated to sale' && Tier3 == 'Sales'||
      Tier1 == 'Pricing' && Tier2 == 'Customer Disputed' && Tier3 == 'Sales'||
      Tier1 == 'Pricing' && Tier2 == 'Data Entry Error' && Tier3 == 'Sales' ||
      
      
      // 8/13/2014 Added by Sneha
         
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incomplete Manifest (missing material)' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incorrect Manifest printed' && Tier3 == 'Sales'|| 
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Label not provided' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Late Order' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'LDRs not provided' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'No Manifest provided' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Order Not Placed' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'PH Not Updated' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Profile Not Created' && Tier3 == 'Sales'||
      Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Recertification Not Completed' && Tier3 == 'Sales'
      )
  { return 'Sales District Manager';}
 //end added by Annes on 06/19/2012 
   else if(Tier3 == 'Batch / Supplier not noted' ||
      Tier3 == 'CSR' ||
      Tier3 == 'Customer' ||
      Tier3 == 'Incorrect documentation' ||
      Tier3 == 'Material/ Package Type (Incorrect Material Code)' ||
      Tier3 == 'Missing documentation' ||
      Tier3 == 'Regulatory delay' ||
      Tier3 == 'Request not noted in order'
      )
  { return 'Manager';}
  else if(Tier3 == 'Nexeo Solutions Fleet' ||
          Tier3 == 'Plant (Through Plant)' ||
          Tier3 == 'Plant' ||
          Tier3 == 'ES - Plant' ||
          Tier3 == 'Nexeo Solutions Incorrect Blend/Slit' ||
          Tier3 == 'Request not processed (Plant/Logistics/Carrier)' ||
         (Tier3 == 'Inbound Material not received into SAP' && Tier2 == 'Material not in stock' ) ||
         (Tier3 == 'Inventory Discrepancy' && Tier2 == 'Material not in stock' )||
         
         // 8/13/2014 Added by Sneha
         
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incomplete Manifest (missing material)' && Tier3 == 'Plant') ||
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Incorrect Manifest printed' && Tier3 == 'Plant') || 
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Label not provided' && Tier3 == 'Plant') ||
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Late Order' && Tier3 == 'Plant') ||
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'LDRs not provided' && Tier3 == 'Plant') ||
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'No Manifest provided' && Tier3 == 'Plant') ||
         (Tier1 == 'ES Documents (not including invoices)' && Tier2 == 'Order Not Placed' && Tier3 == 'Plant')
        )
       {return 'Plant'; }
//added by annes  of 06/18/2012
  else if(Tier3 == 'ES - Billing' ||
         (Tier3 == 'ES - Vendor' ))
       {return 'Billing Lead'; }
 //End added by annes  of 06/18/2012                   
  else if(Tier3 == 'External Carrier' ||
          Tier3 == 'Nexeo Solutions Arranged Carrier')
       {return 'Logistics';}
  else if(Tier3 == 'Sales' ||
          Tier3 == 'ES - Sales')
       {return 'Sales';}
  else if(Tier3 == 'Freight Forwarder')
       {return 'International Queue';}
  else if(Tier3 == 'Supplier' ||
          Tier3 == 'Supplier Carrier (3rd party delivery)' ||
          Tier3 == 'Not a stocked item' ||
          Tier3 == 'Material Late (Supplier)' ||
          Tier3 == 'Material Late (Nexeo Solutions)' ||
          Tier3 == 'Request not noted in PO to Supplier (3rd party)' ||
          Tier3 == 'Request not processed by Supplier (3rd party)' ||
          Tier3 == 'Purchasing' || 
          Tier3 == 'Supplier Arranged Carrier' ||
          Tier3 == 'Buy To Order Material' ||
          Tier3 == 'Stocked Material'||  
          Tier3 == 'Supplier (3rd party Delivery)'  
          
         )
       {return 'Purchasing'; }
       
  else{ return 'No Route Found'; }
} else if(Stage == 'Evaluator') {
   if(Tier3 == 'Batch / Supplier not noted' ||
      Tier3 == 'CSR' ||
      Tier3 == 'Customer' ||
      Tier3 == 'Incorrect documentation' ||
      Tier3 == 'Lost Opp -Full Line Item Not Entered/Rejected' ||
      Tier3 == 'Material/ Package Type (Incorrect Material Code)' ||
      Tier3 == 'Missing documentation' ||
      Tier3 == 'Regulatory delay' ||
      Tier3 == 'Request not noted in order'
      )
  { return 'CSM';}
  else{ return 'Manager';}
}
else{ return 'No Route Found'; }
}
      
}