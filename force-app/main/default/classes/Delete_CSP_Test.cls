@isTest
private class Delete_CSP_Test {
static Account acct = new Account();
static Customer_Product_Info__c cpi = new Customer_Product_Info__c();
static Account_Material__c am = new Account_Material__c();
static Account_Material__c am2 = new Account_Material__c();
static Map<String, Account_Material__c> amMap = new Map<String, Account_Material__c>();
static List<String> data = new List<String>(); 
static List<account_material__c> a = new list<account_material__c>();
static Price_Letter__c pl = new Price_Letter__c();
static Price_Letter_Item__c plt = new Price_Letter_Item__c();
static Price_Request_Transaction__c PRT = new Price_Request_Transaction__c();

Public static testmethod void Delete_CSP_Test_Method(){

    try{
         acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
         insert acct; 
         }
         catch(exception e){}
         Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c(Material_Number__c = '8363833',Sales_Org_Code__c = '1000',
                                 Record_key__c = '8363833100030',Name = 'DIMETHYLETHANOLAMINEX',Dist_Channel_Code__c = '30');
         insert msd2;
          
         cpi = new Customer_Product_Info__c(CPI_Record_Type__c='t',Sales_Org_Code__c='te',Distribution_Channel_Code__c='tt',Customer_Number__c='123',Material_Number__c='test',CurrencyIsoCode='CAD',Record_Key__c='12345678');
         insert cpi;
         
         pl = new Price_Letter__c(Customers__c='test',Language__c='test',Sent_To__c='test');
         insert pl;
    
    try{
         am=new Account_Material__c(SAP_Material__c=msd2.id,Account__c=acct.id,inner_table__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD');
         insert am;
         }
         catch(exception e){}
         data.add(String.valueOf(am.Id)); 
         try{
         amMap.put(''+am.Account__c+am.SAP_material__c,am);  
         a.add(am);
         
         list<Price_Letter_Item__c> pltl= new list<Price_Letter_Item__c>();
         plt= new Price_Letter_Item__c(Price_Letter__c=pl.id,Account_Material__c=am.id,CurrencyIsoCode='CAD');
         insert plt;
         pltl.add(plt);
         }catch(exception e){}
         am2=new Account_Material__c(SAP_Material__c=msd2.id,Created_From_CPI__c=cpi.id,inner_table__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD');
         insert am2;
        
         data.add(String.valueOf(am2.Id));
         amMap.put(''+am2.created_from_cpi__c+am2.Account__c+am2.SAP_material__c,am2); 
         a.add(am2);
         try{
         PRT=new Price_Request_Transaction__c(Account_Material__c=am2.id,Inner_Table__c='Test',CurrencyIsoCode='CAD');
         insert PRT; 
        }
        catch(exception e){}
         Price_Support_Ids__c ids = new Price_Support_Ids__c(ids__c = am.Id);
         insert ids;  
 Test.startTest();              
Delete_CSP.getRecordsToDisplay(ids.id);
Delete_CSP.deleteCSP(data);
//try{
//Delete_CSP.updatePriceLetterItems(amMap,a);
//}catch(exception e){}

Test.stopTest();        
}
Public static testmethod void Delete_CSP_Test_Method1(){
Test.startTest();
    try{
         acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
         insert acct; 
         }
catch(exception e){
}
         Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c(Material_Number__c = '8363833',Sales_Org_Code__c = '1000',
                                 Record_key__c = '8363833100030',Name = 'DIMETHYLETHANOLAMINEX',Dist_Channel_Code__c = '30');
         insert msd2;
          
         cpi = new Customer_Product_Info__c(CPI_Record_Type__c='t',Sales_Org_Code__c='te',Distribution_Channel_Code__c='tt',Customer_Number__c='123',Material_Number__c='test',CurrencyIsoCode='CAD',Record_Key__c='12345678');
         insert cpi;
         
         pl = new Price_Letter__c(Customers__c='test',Language__c='test',Sent_To__c='test');
         insert pl;
    try{
         am=new Account_Material__c(SAP_Material__c=msd2.id,Account__c=acct.id,inner_table__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD');
         insert am;
         data.add(String.valueOf(am.Id)); 
         
         amMap.put(''+am.Account__c+am.SAP_material__c,am);  
         a.add(am);
         
         
         plt= new Price_Letter_Item__c(Price_Letter__c=pl.id,Account_Material__c=am.id,CurrencyIsoCode='CAD');
         insert plt;
         }catch(exception e){}
         am2=new Account_Material__c(SAP_Material__c=msd2.id,Created_From_CPI__c=cpi.id,inner_table__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD');
         insert am2;
        
         data.add(String.valueOf(am2.Id));
         amMap.put(''+am2.created_from_cpi__c+am2.Account__c+am2.SAP_material__c,am2); 
         a.add(am2);
         
         PRT=new Price_Request_Transaction__c(Account_Material__c=am2.id,Inner_Table__c='Test',CurrencyIsoCode='CAD');
         insert PRT; 
        
         Price_Support_Ids__c ids = new Price_Support_Ids__c(ids__c = am.Id);
         insert ids;  
               
      Delete_CSP dcsp = new Delete_CSP();
      //dcsp.Delete_CSP();        
       
Delete_CSP.updatePRTs(amMap,a);
Delete_CSP.getDateFormat();
Delete_CSP.deleteProspectCPIs(a);

Test.stopTest();        
}
}