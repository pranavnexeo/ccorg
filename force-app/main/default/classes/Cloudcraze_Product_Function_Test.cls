/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        9/23/2016
*    Author:             Sneha Likhar
*   Last Modified:       Akansha Gupta
*   Last Modified By:    10/19/2016
*
*   **********************************************************************************************************************/


@isTest(seeAllData=false)
private class Cloudcraze_Product_Function_Test {

    public static testMethod void testMe() {
    //try{
        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        //String s = 'Supplier';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        
        SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
        insert ss;
        
        SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
        insert ssd;
          
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
        insert ST;
          
        List<Account> acclist = new List<Account>(); 
        Account acct = new Account(Account_Number__c = '0013245',AccountNumber='012340',name='TestAccount',ccrz__UsedByCloudcraze__c = true, SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31',Site='chem');
        acclist.add(acct);
        insert acclist;       
        
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        insert va;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        insert so;
                
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Language_Code__c = lang;
        insert dc;

        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + plant;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = plant;
        insert mv;
        List<String> mvKeys = new List<String> {matnum + plant};

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;                
        
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(Ext_Material_Group_Code__c = '101',ccrz__ProductStatus__c = 'Not Orderable',NexeoMaterialId__c = 'test12',ccrz__SKU__c=matnum + sorg + dchan,DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC');
        ccpl.add(ccp);
        insert ccpl;
        
        List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c(Material_Number__c = matnum,Sales_Org_Code__c = sorg,Dist_Channel_Code__c = dchan,Record_Key__c = matnum + sorg + dchan,SalesOrg_Code__r = so,DistChannel_Code__r = dc,Material_General_Data__r = mgd2);
        msdl.add(msd2);
        insert msdl;  
        
        List<Customer_Product_Info__c> cpil = new List<Customer_Product_Info__c>();      
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(CPI_Account__c = acct.id,Es_Account__c = acct.id,Comp_Account__c = acct.id,Plastics_Account__c = acct.id,Chem_Account__c=acclist[0].id,SAP_Material__c=msdl[0].id,Plant_Code__c=plant,ShipTo_Number__c ='0012343' ,SAP_Plant__c=sp.id,CPI_Record_Type__c='1',Customer_Number__c='012340', Distribution_Channel_Code__c='30', Material_Number__c=matnum, Record_Key__c='0193939920', Sales_Org_Code__c='1000');
        cpil.add(cpi);
        insert cpil;
        
        List<ccrz__E_AccountGroup__c> ccagl = new List<ccrz__E_AccountGroup__c>();
        
        List<Database.Upsertresult> db = new List<Database.Upsertresult>();
        
        ccrz__E_AccountGroup__c ag = new ccrz__E_AccountGroup__c(ccrz__AccountGroupID__c='test',ccrz__Desc__c='test',SalesArea__c='30',ccrz__PriceListSelectionMethod__c='Best Price',ccrz__ThemeName__c='test');
        ccagl.add(ag);
        insert ccagl;
        
        ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c(ccrz__AccountGroup__c=ag.id,ccrz__AccountGroupPriceListID__c='test',ccrz__Enable__c=true,Type__c = 'SalesAreaPriceList');
        insert agpl;
        
        ccrz__E_ProductCategory__c pc = new ccrz__E_ProductCategory__c();
        List<String> MKey = new List<String>();
        
        List<ccrz__E_Category__c> Catl = new List<ccrz__E_Category__c>();
        ccrz__E_Category__c cat = new ccrz__E_Category__c(ccrz__CategoryID__c = 'test1',Name = 'catcloud');
        Catl.add(cat);
        insert Catl;
        
        List<ccrz__E_Spec__c> specl = new List<ccrz__E_Spec__c>();
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata1',Name = 'Supplier');
        specl.add(spec);
        ccrz__E_Spec__c spec1 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata2',Name = 'Segment');
        specl.add(spec1);
        ccrz__E_Spec__c spec2 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata3',Name = 'Color');
        specl.add(spec2);
        ccrz__E_Spec__c spec3 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata4',Name = 'Weight');
        specl.add(spec3);
        ccrz__E_Spec__c spec4 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata5',Name = 'Diameter');
        specl.add(spec4);
        ccrz__E_Spec__c spec5 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata6',Name = 'Size');
        specl.add(spec5);
        insert specl;
        
        List<ccrz__E_ProductSpec__c> prodSpecl = new List<ccrz__E_ProductSpec__c>();
        ccrz__E_ProductSpec__c pspec4 = new ccrz__E_ProductSpec__c(ccrz__Product__c = ccp.id,ProductSpecID__c = 'testdata5',ccrz__Spec__c = spec1.id,ccrz__SpecValue__c = 'General');
        prodSpecl.add(pspec4);
        ccrz__E_ProductSpec__c pspec5 = new ccrz__E_ProductSpec__c(ccrz__Product__c =ccp.id ,ProductSpecID__c = 'testdata6',ccrz__Spec__c = spec.id,ccrz__SpecValue__c = 'General');
        prodSpecl.add(pspec5);
        insert prodSpecl;
        
        Cloudcraze_Product_Function.upsert_cloudcraze_product(ccpl);
        Cloudcraze_Product_Function.getCategoryMap();
        Cloudcraze_Product_Function.getSpecMap();
        Cloudcraze_Product_Function.getPriceListMap();
        Cloudcraze_Product_Function.writeProductErrors(db);
        

      //}catch(exception e){}
    }
    
    public static testMethod void testMethod1() {
    try{

        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
        insert u;
        
        SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
        insert ss;
        
        SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
        insert ssd;
          
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
        insert ST;
          
        List<Account> acclist = new List<Account>(); 
        Account acct = new Account(AccountNumber='012340',name='TestAccount',ccrz__UsedByCloudcraze__c = true, SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31',Site='chem');
        acclist.add(acct);
        insert acclist;  
        
        List<id> accset = new List<id>();
        accset.add(acclist[0].id); 
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        insert va;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        insert so;
                
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Language_Code__c = lang;
        insert dc;

        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + plant;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = plant;
        insert mv;
        List<String> mvKeys = new List<String> {matnum + plant};

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;                
        
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(NexeoMaterialId__c = 'test12',ccrz__SKU__c=matnum + sorg + dchan,DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC', ProductSpec__c = 'Test');
        ccpl.add(ccp);
        insert ccpl;
        
        List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c(Material_Number__c = matnum,Sales_Org_Code__c = sorg,Dist_Channel_Code__c = dchan,Record_Key__c = matnum + sorg + dchan,SalesOrg_Code__r = so,DistChannel_Code__r = dc,Material_General_Data__r = mgd2);
        msdl.add(msd2);
        insert msdl;  
              
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(CPI_Account__c = acct.id,Es_Account__c = acct.id,Comp_Account__c = acct.id,Plastics_Account__c = acct.id,Chem_Account__c=acclist[0].id,SAP_Material__c=msdl[0].id,Plant_Code__c=plant,ShipTo_Number__c ='0012343' ,SAP_Plant__c=sp.id,CPI_Record_Type__c='1',Customer_Number__c='012340', Distribution_Channel_Code__c='30', Material_Number__c=matnum, Record_Key__c='0193939920', Sales_Org_Code__c='1000');
        insert cpi;
        Account_Material__c am = new Account_Material__c(Account__c=acct.id,SAP_Material__c=msd2.id,Created_From_CPI__c=cpi.id);
        insert am;
        Set<String> sKey = new Set<String>();
        String key = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+acct.SAP_DivisionCode__c;
        sKey.add(key);
        
        List<ccrz__E_AccountGroup__c> ccagl = new List<ccrz__E_AccountGroup__c>();
        List<Customer_Product_Info__c> cpil = new List<Customer_Product_Info__c>();
        List<Database.Upsertresult> db = new List<Database.Upsertresult>();
        
        ccrz__E_AccountGroup__c ag = new ccrz__E_AccountGroup__c(ccrz__AccountGroupID__c='test',ccrz__Desc__c='test',SalesArea__c='30',ccrz__PriceListSelectionMethod__c='Best Price',ccrz__ThemeName__c='test');
        ccagl.add(ag);
        insert ccagl;
        
        ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c(ccrz__AccountGroup__c=ag.id,ccrz__AccountGroupPriceListID__c='test',ccrz__Enable__c=true,Type__c = 'SalesAreaPriceList');
        insert agpl;
        
        ccrz__E_ProductCategory__c pc = new ccrz__E_ProductCategory__c();
        List<String> MKey = new List<String>();
        
        List<ccrz__E_Category__c> Catl = new List<ccrz__E_Category__c>();
        ccrz__E_Category__c cat = new ccrz__E_Category__c(ccrz__CategoryID__c = 'test1',Name = 'catcloud');
        Catl.add(cat);
        insert Catl;
        
        List<ccrz__E_Spec__c> specl = new List<ccrz__E_Spec__c>();
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata1',Name = 'Supplier');
        specl.add(spec);
        ccrz__E_Spec__c spec1 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata2',Name = 'Segment');
        specl.add(spec1);
        ccrz__E_Spec__c spec2 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata3',Name = 'Color');
        specl.add(spec2);
        ccrz__E_Spec__c spec3 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata4',Name = 'Weight');
        specl.add(spec3);
        ccrz__E_Spec__c spec4 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata5',Name = 'Diameter');
        specl.add(spec4);
        ccrz__E_Spec__c spec5 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata6',Name = 'Size');
        specl.add(spec5);
        ccrz__E_Spec__c spec6 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata7',Name = 'ProductSpec');
        specl.add(spec6);      
        insert specl;
                
        Cloudcraze_Product_Function.add_AccountGroupCreation(accset);
        //Cloudcraze_Product_Function.upsert_nexeo3D_product(ccpl);
        Cloudcraze_Product_Function.getMatToProdMap(MKey);
        Cloudcraze_Product_Function.getCPIPriceListMap(sKey);
        } catch(exception e){}

    }
    
        public static testMethod void testMethod2() {
        try{

        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
        insert u;
        
        SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
        insert ss;
        
        SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
        insert ssd;
          
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
        insert ST;
          
        List<Account> acclist = new List<Account>(); 
        Account acct = new Account(AccountNumber='012340',name='TestAccount',ccrz__UsedByCloudcraze__c = true, SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31',Site='chem');
        acclist.add(acct);
        insert acclist;       
        
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        insert va;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        insert so;
                
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Language_Code__c = lang;
        insert dc;

        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + plant;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = plant;
        insert mv;
        List<String> mvKeys = new List<String> {matnum + plant};

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;                
        
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(NexeoMaterialId__c = 'test12',ccrz__SKU__c=matnum + sorg + dchan,DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC');
        ccpl.add(ccp);
        insert ccpl;
        
        List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c(Material_Number__c = matnum,Sales_Org_Code__c = sorg,Dist_Channel_Code__c = dchan,Record_Key__c = matnum + sorg + dchan,SalesOrg_Code__r = so,DistChannel_Code__r = dc,Material_General_Data__r = mgd2);
        msdl.add(msd2);
        insert msdl;  
              
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(CPI_Account__c = acct.id,Es_Account__c = acct.id,Comp_Account__c = acct.id,Plastics_Account__c = acct.id,Chem_Account__c=acclist[0].id,SAP_Material__c=msdl[0].id,Plant_Code__c=plant,ShipTo_Number__c ='0012343' ,SAP_Plant__c=sp.id,CPI_Record_Type__c='1',Customer_Number__c='012340', Distribution_Channel_Code__c='30', Material_Number__c=matnum, Record_Key__c='0193939920', Sales_Org_Code__c='1000');
        insert cpi;
        Account_Material__c am = new Account_Material__c(Account__c=acct.id,SAP_Material__c=msd2.id,Created_From_CPI__c=cpi.id);
        insert am;
        
        List<ccrz__E_AccountGroup__c> ccagl = new List<ccrz__E_AccountGroup__c>();
        List<Account_Material__c> cpil = new List<Account_Material__c>();
        cpil.add(am);
        List<Database.Upsertresult> db = new List<Database.Upsertresult>();
        
        ccrz__E_AccountGroup__c ag = new ccrz__E_AccountGroup__c(ccrz__AccountGroupID__c='test',ccrz__Desc__c='test',SalesArea__c='30',ccrz__PriceListSelectionMethod__c='Best Price',ccrz__ThemeName__c='test');
        ccagl.add(ag);
        insert ccagl;
        
        ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c(ccrz__AccountGroup__c=ag.id,ccrz__AccountGroupPriceListID__c='test',ccrz__Enable__c=true,Type__c = 'SalesAreaPriceList');
        insert agpl;
        
        ccrz__E_ProductCategory__c pc = new ccrz__E_ProductCategory__c();
        List<String> MKey = new List<String>();
        
        List<ccrz__E_Category__c> Catl = new List<ccrz__E_Category__c>();
        ccrz__E_Category__c cat = new ccrz__E_Category__c(ccrz__CategoryID__c = 'test1',Name = 'catcloud');
        Catl.add(cat);
        insert Catl;
        
        List<ccrz__E_Spec__c> specl = new List<ccrz__E_Spec__c>();
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata1',Name = 'Supplier');
        specl.add(spec);
        ccrz__E_Spec__c spec1 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata2',Name = 'Segment');
        specl.add(spec1);
        ccrz__E_Spec__c spec2 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata3',Name = 'Color');
        specl.add(spec2);
        ccrz__E_Spec__c spec3 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata4',Name = 'Weight');
        specl.add(spec3);
        ccrz__E_Spec__c spec4 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata5',Name = 'Diameter');
        specl.add(spec4);
        ccrz__E_Spec__c spec5 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata6',Name = 'Size');
        specl.add(spec5);
        ccrz__E_Spec__c spec6 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata7',Name = 'ProductSpec');
        specl.add(spec6);             
        insert specl;
        
        List<ccrz__E_ProductSpec__c> prodSpecl = new List<ccrz__E_ProductSpec__c>();
        ccrz__E_ProductSpec__c pspec4 = new ccrz__E_ProductSpec__c(ccrz__Product__c = ccp.id,ProductSpecID__c = 'testdata5',ccrz__Spec__c = spec1.id,ccrz__SpecValue__c = 'General');
        prodSpecl.add(pspec4);
        ccrz__E_ProductSpec__c pspec5 = new ccrz__E_ProductSpec__c(ccrz__Product__c =ccp.id ,ProductSpecID__c = 'testdata6',ccrz__Spec__c = spec.id,ccrz__SpecValue__c = 'General');
        prodSpecl.add(pspec5);
        insert prodSpecl;
        
        Cloudcraze_Product_Function.create_CPI_PriceList(cpil);
        Cloudcraze_Product_Function.upsert_cloudcraze_product(msdl);
   }catch(exception e){}
    }
    
            public static testMethod void testMethod3() {
            try{

        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
        insert u;
        
        SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
        insert ss;
        
        SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
        insert ssd;
          
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
        insert ST;
          
        List<Account> acclist = new List<Account>(); 
        Account acct = new Account(AccountNumber='012340',name='TestAccount',ccrz__UsedByCloudcraze__c = true, SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31',Site='chem');
        acclist.add(acct);
        insert acclist;   
        List<id> accset = new List<id>();
        accset.add(acclist[0].id);    
        
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        insert va;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        insert so;
                
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Language_Code__c = lang;
        insert dc;

        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + plant;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = plant;
        insert mv;
        List<String> mvKeys = new List<String> {matnum + plant};

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;    
        
        List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c(Material_Number__c = matnum,Sales_Org_Code__c = sorg,Dist_Channel_Code__c = dchan,Record_Key__c = matnum + sorg + dchan,SalesOrg_Code__r = so,DistChannel_Code__r = dc,Material_General_Data__r = mgd2);
        msdl.add(msd2);
        insert msdl;           
        
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(ccrz__SKU__c = 'test12',SAP_Material__c = msdl[0].id,NexeoMaterialId__c = 'test12',DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC');
        ccpl.add(ccp);
        insert ccpl;
              
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(CPI_Account__c = acct.id,Es_Account__c = acct.id,Comp_Account__c = acct.id,Plastics_Account__c = acct.id,Chem_Account__c=acclist[0].id,SAP_Material__c=msdl[0].id,Plant_Code__c=plant,ShipTo_Number__c ='0012343' ,SAP_Plant__c=sp.id,CPI_Record_Type__c='1',Customer_Number__c='012340', Distribution_Channel_Code__c='30', Material_Number__c=matnum, Record_Key__c='0193939920', Sales_Org_Code__c='1000');
        insert cpi;
                
        Account_Material__c am = new Account_Material__c(Account__c=acct.id,SAP_Material__c=msd2.id,Created_From_CPI__c=cpi.id);
        insert am;
                
        
        List<ccrz__E_AccountGroup__c> ccagl = new List<ccrz__E_AccountGroup__c>();
        List<Customer_Product_Info__c> cpili = new List<Customer_Product_Info__c>();
        cpili.add(cpi);
        List<Account_Material__c> cpil = new List<Account_Material__c>();
        cpil.add(am);
        List<Database.Upsertresult> db = new List<Database.Upsertresult>();
        
        ccrz__E_AccountGroup__c ag = new ccrz__E_AccountGroup__c(ccrz__AccountGroupID__c='test',ccrz__Desc__c='test',SalesArea__c='30',ccrz__PriceListSelectionMethod__c='Best Price',ccrz__ThemeName__c='test');
        ccagl.add(ag);
        insert ccagl;
        
        ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c(ccrz__AccountGroup__c=ag.id,ccrz__AccountGroupPriceListID__c='test',ccrz__Enable__c=true,Type__c = 'SalesAreaPriceList');
        insert agpl;
        
        ccrz__E_ProductCategory__c pc = new ccrz__E_ProductCategory__c();
        List<String> MKey = new List<String>();
        
        List<ccrz__E_Category__c> Catl = new List<ccrz__E_Category__c>();
        ccrz__E_Category__c cat = new ccrz__E_Category__c(ccrz__CategoryID__c = 'test1',Name = 'catcloud');
        Catl.add(cat);
        insert Catl;
        
        List<ccrz__E_Spec__c> specl = new List<ccrz__E_Spec__c>();
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata1',Name = 'Supplier');
        specl.add(spec);
        ccrz__E_Spec__c spec1 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata2',Name = 'Segment');
        specl.add(spec1);
        ccrz__E_Spec__c spec2 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata3',Name = 'Color');
        specl.add(spec2);
        ccrz__E_Spec__c spec3 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata4',Name = 'Weight');
        specl.add(spec3);
        ccrz__E_Spec__c spec4 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata5',Name = 'Diameter');
        specl.add(spec4);
        ccrz__E_Spec__c spec5 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata6',Name = 'Size');
        specl.add(spec5);
        insert specl;
        
        List<ccrz__E_ProductSpec__c> prodSpecl = new List<ccrz__E_ProductSpec__c>();
        ccrz__E_ProductSpec__c pspec4 = new ccrz__E_ProductSpec__c(ccrz__Product__c = ccp.id,ProductSpecID__c = 'testdata5',ccrz__Spec__c = spec1.id,ccrz__SpecValue__c = 'General');
        prodSpecl.add(pspec4);
        ccrz__E_ProductSpec__c pspec5 = new ccrz__E_ProductSpec__c(ccrz__Product__c =ccp.id ,ProductSpecID__c = 'testdata6',ccrz__Spec__c = spec.id,ccrz__SpecValue__c = 'General');
        prodSpecl.add(pspec5);
        insert prodSpecl;
        
        List<ccrz__E_PriceList__c> listPriceList = new List<ccrz__E_PriceList__c>();
        ccrz__E_PriceList__c pl = new ccrz__E_PriceList__c(Name = 'test',Account__c = acct.id,ccrz__PricelistId__c = '00142',ccrz__Storefront__c = 'nexeo3d');
        listPriceList.add(pl);
        insert listPriceList;
        
        List<ccrz__E_PriceListItem__c> plItemL = new List<ccrz__E_PriceListItem__c>(); 
        ccrz__E_PriceListItem__c plitem = new ccrz__E_PriceListItem__c(ccrz__Pricelist__c = pl.id, ccrz__Product__c = ccp.id);
        plItemL.add(plitem);
        insert plItemL;
        Set<id> sid = new Set<id>();
        
        Cloudcraze_Product_Function.add_AccountGroupPriceListSetup(sid);
        Cloudcraze_Product_Function.update_CPI_PriceList(cpil);
        Cloudcraze_Product_Function.create_newCPI_CCProduct(cpili);
        
        }catch(exception e){}
    }
    
    public static testMethod void testMethod4() {
    try{

        List<ccrz__E_Category__c> Catl = new List<ccrz__E_Category__c>();
        ccrz__E_Category__c cat = new ccrz__E_Category__c(ccrz__CategoryID__c = 'test1',Name = 'Test_Category');
        Catl.add(cat);
        insert Catl;          
        
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(Name = 'Test_Product',ccrz__SKU__c='12345',Nexeo3D__c = True, ccrz__Storefront__c = 'nexeo3d', ccrz__ProductType__c='Product',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC', ProductSpec__c = 'Test_Product');
        ccpl.add(ccp);
        insert ccpl;
        

        List<Database.Upsertresult> db = new List<Database.Upsertresult>();
        
        List<ccrz__E_Spec__c> specl = new List<ccrz__E_Spec__c>();
        ccrz__E_Spec__c spec1 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata3',Name = 'Color');
        specl.add(spec1);
        ccrz__E_Spec__c spec2 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata4',Name = 'Weight');
        specl.add(spec2);
        ccrz__E_Spec__c spec3 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata5',Name = 'Diameter');
        specl.add(spec3);
        ccrz__E_Spec__c spec4 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata6',Name = 'Size');
        specl.add(spec4);
        ccrz__E_Spec__c spec5 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata7',Name = 'ProductSpec');
        specl.add(spec5);  
        ccrz__E_Spec__c spec6 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata8',Name = 'Color_german');
        specl.add(spec6);
        ccrz__E_Spec__c spec7 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata9',Name = 'Weight_german');
        specl.add(spec7);
        ccrz__E_Spec__c spec8 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata10',Name = 'Diameter_german');
        specl.add(spec8);
        ccrz__E_Spec__c spec9 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata6',Name = 'Size_german');
        specl.add(spec9);
        ccrz__E_Spec__c spec10 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata7',Name = 'ProductSpec_german');
        specl.add(spec10);       
        ccrz__E_Spec__c spec11 = new ccrz__E_Spec__c(ccrz__SpecID__c = 'testdata7',Name = 'shippingWeight');
        specl.add(spec11); 
        insert specl;
                
        Test.startTest();
        update ccpl;
        Test.stopTest();
        
        List<ccrz__E_ProductCategory__c> prod_categories = [Select Id from ccrz__E_ProductCategory__c];        
        List<ccrz__E_ProductSpec__c> specs = [Select Id from ccrz__E_ProductSpec__c];
        
        System.assertequals(1,prod_categories.size(),'Product Category did not get created properly');
        System.assertequals(10,specs.size(),'Product Specs did not get created properly');
        
        } catch(exception e){}

    }
    
    public static testMethod void testMethod5() {
        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(NexeoMaterialId__c = 'test12',ccrz__SKU__c=matnum + sorg + dchan,DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC', ProductSpec__c = 'Test');
        ccpl.add(ccp);
        insert ccpl;
        
        Cloudcraze_Product_Function.insert_product_media(ccpl);
    }
    
   
}