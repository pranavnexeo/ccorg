/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/1/2016
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:   
*
*   Short Description:  Test Class for Stored tier pricing in cc objects. 
*   **********************************************************************************************************************/
@isTest(seeAllData=false)

public class TierPricingCustomerPortal_Test {

      public static testMethod void MyTest(){
        
        Map<String, SObject> testData = cc_imp_testUtils.initData();
        
        User portalUser = (User) testData.get('portalUser');   
          System.runAs(portalUser) {  
            Account acct=new Account();
            acct.name='TestAccount';
            acct.Account_Number__c='123456789';
            acct.Type='Customer';
            acct.Street_Address__c='x';
            acct.SAP_City__c='Houston';
            acct.SAP_Zip_Code__c='77380';
            acct.CurrencyIsoCode='USD';
            acct.SAP_Account_Name_2__c='';
            acct.AccountNumber='P2721278';
            acct.SAP_Corporate_Account__c='N/A';                       
            insert acct;     
            
            List<Account> listAccounts = new List<Account>();
            listAccounts.add(acct);
            
            ccrz__E_PriceList__c plist=new ccrz__E_PriceList__c();
            plist.ccrz__PricelistId__c='123456789';        
            insert plist;
            ccrz__E_Product__c product=new ccrz__E_Product__c();
            product.Name='ccrz__E_Product__c';
            product.ccrz__SKU__c='100000000000020157100030';
            insert product;
            ccrz__E_PriceListItem__c plistItem= new ccrz__E_PriceListItem__c();
            plistItem.ccrz__StartDate__c=Date.today();
            date myDate = date.newInstance(2083, 7, 15);
            plistItem.ccrz__EndDate__c=myDate;
            plistItem.ccrz__Pricelist__c=plist.Id;
            plistItem.ccrz__Product__c=product.Id;
            plistItem.CurrencyIsoCode='USD';
            insert plistItem;
              String test='test';
             CSP_JSON_Response.tbl_csp_prices tblcsp=new CSP_JSON_Response.tbl_csp_prices('1',test,'3',test,test,test,test,test,test,test,test);
             CSP_JSON_Response.tbl_sales_units tblSUcsp=new CSP_JSON_Response.tbl_sales_units('174.0','3.429','1.0','0.45359200011157447','696.0');
              
              List<CSP_JSON_Response.tbl_sales_units> litSU=new List<CSP_JSON_Response.tbl_sales_units>();
              List<CSP_JSON_Response.tbl_csp_prices> litcsp=new List<CSP_JSON_Response.tbl_csp_prices>();
              litcsp.add(tblcsp);
              litSU.add(tblSUcsp);
            Map<ID, List<CSP_JSON_Response.tbl_csp_prices>>  mapPLI= new Map<ID, List<CSP_JSON_Response.tbl_csp_prices>>(); 
            Map<ID, List<CSP_JSON_Response.tbl_sales_units>>  mapSalesUnits= new Map<ID, List<CSP_JSON_Response.tbl_sales_units>>();
                
              mapPLI.put(plistItem.Id,litcsp);
              mapSalesUnits.put(plistItem.Id, litSU);
              TierPricingCustomerPortal tpcp=new TierPricingCustomerPortal();          
              tpcp.createCCPriceModifierBulk(mapPLI,mapSalesUnits);
              
              tpcp.stringtodouble('100');
              tpcp.stringtodouble('100-');                
              tpcp.stringtodouble('100,');
              tpcp.stringtodouble('');       
              
              
            tpcp.stringtodecimal('100');
            tpcp.stringtodecimal('100-');                
            tpcp.stringtodecimal('100,');
            tpcp.stringtodecimal('');  
          }
      }
    
    public static testMethod void stringtodoubleTest(){
        TierPricingCustomerPortal tpcp = new TierPricingCustomerPortal();
        tpcp.stringtodouble('10-12');
        tpcp.stringtodouble('10,12');
    }
    
    public static testMethod void stringtodecimalTest(){
        TierPricingCustomerPortal tpcp = new TierPricingCustomerPortal();
        tpcp.stringtodecimal('10-12');
        tpcp.stringtodecimal('10,12');
    }
}