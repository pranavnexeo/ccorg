trigger Log_SAP_Sales_Org_Change on SAP_Sales_Org__c (after update) {

  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'SAP_Sales_Org__c' and completed__c = false])
  {  itc.completed__c = true; changes.add(itc); }
  integer size = changes.size();
 
  for(SAP_Sales_Org__c sg:trigger.new){
    string sorg = '';
    if(sg.Sales_Org_Code__c != null && sg.Sales_Org_Code__c != '')
    {
      //if(sg.sales_org_code__c.length() > 4 && sg.sales_org_code__c.right(2) == 'G2')
      //   sorg = sg.sales_org_code__c.left(sg.sales_org_code__c.length() - 2);
      //else
         sorg = sg.sales_org_code__c;
    }
    if(sg.Sales_Org_Description__c != trigger.oldmap.get(sg.id).Sales_Org_Description__c)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Sales_Org__c',
      Description_Field__c = 'SAP_Sales_Org_Desc__c',
      Config_Code_Field__c = 'Sales_Org_Code__c',
      Config_Desc_Field__c = 'Sales_Org_Description__c',
      Config_Table__c = 'SAP_Sales_Org__c',
      New_Description__c = sg.Sales_Org_Description__c,
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Org_Description__c,
      Code_value__c = sorg,
      Type__c = 'Account'
     );
     Integration_Table_Change__c c2 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Sales_Org__c',
      Description_Field__c = 'Prospect_Sales_Org__c',
      Config_Code_Field__c = 'Sales_Org_Code__c',
      Config_Desc_Field__c = 'Sales_Org_Description__c',
      Config_Table__c = 'SAP_Sales_Org__c',
      New_Description__c = sg.Sales_Org_Description__c + ' (' + sorg + ')',
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Org_Description__c + ' (' + sorg + ')',
      Code_value__c = sorg,
      Type__c = 'Account'
     );
     changes.add(c);
     changes.add(c2);
   }

}
 if(changes.size() > 0 && changes.size() > size)
    upsert changes;
}