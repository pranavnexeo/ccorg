Public Class NCAR_PDF_Template{

Public List<NCAR_Line_Item__c> lines{get; set;}
Public NCAR_Cases__c mycase{get; set;}
Public String Full_Address{get; set;}
Public NCAR_PDF_Template(ApexPages.StandardController sc){
  String id = ((NCAR_Cases__c)sc.getrecord()).id;

 
  mycase = [select id, name, Contact__r.name, Account__r.Name, Account__r.Full_Address__c, Problem_Statement_Customer_Facing__c, 
            Immediate_Action_Customer_Facing__c, Root_Cause_Customer_Facing__C, Action_Taken_Customer_Facing__c, 
            Email_Comments__c, Account__r.SAP_CSR_Phone__c, Account__r.SAP_CSR_Email__c 
            from NCAR_Cases__c where id = :id limit 1];
            
if(mycase.Account__r.Full_Address__c!=null){
    For(String s:mycase.Account__r.Full_Address__c.split('\n'))
      {
        String s1 = s.trim();
        if(s1.length() > 0 && (s1 != null || s1 != ''))
          Full_Address += s1 + '\n' + '<br/>';
      }
    
  full_address = full_address.replace('null', '');     
}  

  lines = [select id, name, Open_Orders__r.Sales_Order_Number__c, 
                            Open_Orders__r.Customer_PO_Number__c, 
                            Open_Orders__r.Ordered_Qty_in_LB__c,
                            Open_Orders__r.Material_Desc__c
                            from NCAR_Line_Item__c where 
                            NCAR_Cases__c = :id limit 1000];
}

}