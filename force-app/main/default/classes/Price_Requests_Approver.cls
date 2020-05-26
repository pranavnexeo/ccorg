Public Class Price_Requests_Approver{

Public list<selectoption> salesgroups{Get; set;}
Public List<selectoption> plms{Get; set;}
Public List<selectoption> mg4s{get; set;}
Public List<SelectOption> divisions{get; set;}
public String division{get; set;}
Public String salesgroup{Get; set;}
Public String plm{get; set;}
Public String mg4{get; set;}


Public String supplier{get; set;}
Public List<selectoption> suppliername{get; set;}
public price_request_approver__c approver{Get; set;}


Public Price_Requests_Approver(ApexPages.standardcontroller sc){
  plm = '--None--';
  //supplier = '--None--';
  salesgroup = '--None--';
  approver = (price_request_approver__c)sc.getrecord();
  if(approver.id != null)
  {approver = [select id, SAP_Seller__c, name, Supplier_Name__c, Approval_Level__c, PLM_Name__c, SAP_Sales_Group_Code__c, Material_Group_4_Desc__c, Division_Desc__c, Division_Code__c, is_active__c, process_order__c, Approver__c, PLM__c, SAP_Sales_Group__c, material_group_4__c from price_request_approver__c where id = :approver.id limit 1];
    if(Approver.plm__c != null && Approver.plm_name__c != null)
      plm = Approver.plm__c + ' - ' + approver.plm_name__c;
    if(Approver.sap_sales_group__c != null && Approver.SAP_Sales_group_code__c != null)
      salesgroup = approver.sap_sales_group__c + ' - ' + Approver.SAP_Sales_group_code__c;
    if(Approver.material_group_4__c != null && Approver.material_group_4_desc__c != null)
      mg4 = approver.material_group_4__c + ' - ' + Approver.material_group_4_desc__c;
    if(Approver.division_desc__c != null && Approver.division_code__c != null)
      division = approver.division_desc__c + ' - ' + approver.division_code__c;
  }
  if(ApexPages.currentpage().getparameters().containskey('clone') &&
     ApexPages.currentpage().getparameters().get('clone') == '1')
     approver = approver.clone(false);
     
  salesgroups = new list<selectoption>();
  List<SAP_Sales_Group_cs__c> sgs = SAP_Sales_Group_CS__c.getall().values();
  List<String> sgsstrings = new list<String>();
  
  for(SAP_Sales_Group_CS__c sg: sgs)
    sgsstrings.add(sg.name + ' - ' + sg.sales_group_code__c );
  sgsstrings.sort();
  
  salesgroups.add(new selectoption('--None--', '--None--'));
  for(string s:sgsstrings)
    salesgroups.add(new selectoption(s, s));

  plms = new list<SelectOption>();
  plms.add(new selectoption('--None--', '--None--'));
  for(material_pricing_group2__c mpg2:[select id, name, material_pricing_group2_code__c, material_pricing_group2_description__c from material_pricing_group2__c where material_pricing_group2_description__c != 'MASKED' order by material_pricing_group2_description__c])
    plms.add(new selectoption(mpg2.material_pricing_group2_code__c + ' - ' + mpg2.material_pricing_group2_description__c , mpg2.material_pricing_group2_code__c + ' - ' + mpg2.material_pricing_group2_description__c));
  
  suppliername = new list<SelectOption>();
  suppliername.add(new selectoption('--None--','--None--'));
  
  for(Nexeo_Competitor__c ncc:[Select Id, Name , Nexprice_flag__c from Nexeo_Competitor__c where Nexprice_flag__c = true])
      suppliername.add(new selectoption(ncc.Name,ncc.Name));
  
  if(approver.Supplier_Name__c != '' && approver.Supplier_Name__c != null){
      supplier = approver.Supplier_Name__c;
  }
  
  List<SAP_Divisions__c> divs = SAP_Divisions__c.getall().values();
  List<String> holder = new list<string>();
  for(SAP_Divisions__c d:divs){
    holder.add(d.division_desc__c + ' - ' + d.division_code__c);
  }
  holder.sort();
  divisions = new list<selectoption>();
  for(string s:holder)
    divisions.add(new selectoption(s, s)); 
  
  
  mg4s = new list<SelectOption>();
  mg4s.add(new selectoption('--None--', '--None--'));
  for(material_pricing_group4__c mpg4:[select id, name, material_pricing_group4_code__c, material_pricing_group4_description__c from material_pricing_group4__c where material_pricing_group4_description__c != 'MASKED' order by material_pricing_group4_description__c])
    mg4s.add(new selectoption(mpg4.material_pricing_group4_code__c + ' - ' + mpg4.material_pricing_group4_description__c , mpg4.material_pricing_group4_code__c + ' - ' + mpg4.material_pricing_group4_description__c));
  
}

Public pagereference save(){
  if(plm != '--None--')
  { approver.plm__c = plm.substring(0, plm.indexof(' - '));
    approver.plm_name__c = plm.substring(plm.indexof(' - ') + 3);
  }
  else{ 
    approver.plm__c = '';
    approver.plm_name__c = '';
  }
  if(salesgroup != '--None--')
  { approver.SAP_Sales_Group__c = salesgroup.substring(0, salesgroup.indexof(' - '));
    approver.SAP_Sales_Group_code__c = salesgroup.substring(salesgroup.indexof(' - ') + 3);
  
  }
  else{
    approver.SAP_Sales_Group__c = '';
    approver.SAP_Sales_Group_Code__c = '';
  }
  if(mg4 != '--None--' && mg4 != null)
  { approver.Material_Group_4__c = mg4.substring(0,  mg4.indexof(' - '));
    approver.Material_Group_4_desc__c =  mg4.substring( mg4.indexof(' - ') + 3); 
  }
  else{
    approver.material_group_4__C = '';
    approver.material_group_4_desc__c = '';
  }
  if(division != '' && division != null)
  { 
    approver.division_desc__c = division.substring(0, division.indexof(' - '));
    approver.division_code__c = division.substring(division.indexof(' - ') + 3);
  }
  else{
    approver.division_desc__c = '';
    approver.division_code__c = '';
  }
  if(supplier != '--None--'){
      approver.Supplier_Name__c = supplier;   
  }
  else{
      approver.Supplier_Name__c = '';    
  }
  upsert approver;
  return new pagereference('/' + approver.id);
}
}