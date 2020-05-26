@isTest
public class nexPrice_test{
     public static testMethod void testMyController() {
        
        
        Date myDate = Date.Today();
        String today = '12/27/2009'; 
        try{       
        Account a = new Account(name = 'Test Account', sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        string acct = a.Id;
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=a.id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist.id;
        List<String> materialList = new List<String>();
        Integer ai = 1;
        List<Integer> aiList = new List<Integer>();
        List<String> ownerid = new List<String>();
        List<String> RequestIds=new List<String>();
        List<String> RequestIdRfq=new List<String>();
        List<String> AccountMatId= new List<String>();
        AccountMatId.add(acmt.Id);
        String owner = acmt.ownerid;
        String mat = matlist.id;
        
        Account_Material__c accmat = new account_material__c(Account__c = a.id, SAP_Material__c = mat);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id);
        List<String> pTrans = new List<String>();
        Price_Request_Transaction__c p = new Price_Request_Transaction__c(Approval_Rejection_Comments__c = 'Comments',Account_Material__c = accmat.id);
        insert p;
        
        pTrans.add(p.Id);
        
        String pId = (String)p.Id;
        Map<String, Price_Request_Transaction__c> amap = new Map<String, Price_Request_Transaction__c>();
        amap.put(pid,p);
        
        Map<String, Price_Request_Transaction> objmap = new Map<String, Price_Request_Transaction>();
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist.id, sap_material__r = matlist,ship_to__r = a,ship_to__c = a.id,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;
 
        RequestIds.add(transrecord.Id);
       
        Map<String, Price_Request_Transaction__c> amap1 = new Map<String, Price_Request_Transaction__c>();
        amap1.put(transrecord.Id,transrecord);
        
       
        Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
        nexPrice.FetchMyAccounts(Userinfo.getuserid(),'','','');
        nexPrice.FromAccount(a.id);
        nexPrice.getDateFormat();
        List<String> ids = new List<String>();
        ids.add(accmat.id);
        nexPrice.FetchPH7('24');

        List<String> soldtoList = new List<String>();
        String soldto = '0000094713 - CORAL CHEMICAL';
        soldtoList.add(soldto);
        List<String> soldtoList1 = new List<String>(); 
        List<String> shiptoList = new List<String>();
        String shipto = '0000590933 - CORAL CHEMICAL';
        shiptoList.add(shipto);
        List<String> shiptoList1 = new List<String>(); 
        List<String> corpList = new List<String>();
        String corp = '0000590933 - CORAL CHEMICAL';
        corpList.add(corp);
        

        List<String> requestid = new List<string>();
        String reqid = transrecord.Name;
       
        Test.startTest(); 
       
        accList.add(a.id);
        
        ownerid.add(owner);
        List<Integer> aiDisplay = new List<Integer>();
        List<String> aids = new List<String>();
              
        nexPrice.CheckDuplicateAM(accList,ids);
       nexPrice.saveaccountwomaterial(accList,'test','test','test');
       
       materialList.add(mat1); 
       nexPrice.saveaccountmaterial(accList ,materialList);
       
       PageReference pageRef = Page.nexprice_12;
       Test.setCurrentPage(pageRef);
       
       apexpages.currentpage().getparameters().put('returl','nexprice12');
       Nexprice nex = new Nexprice();
       
       nexPrice.getProspectMaterial(accList,accList);
       nexPrice.getPricing(accList,accList);
       nexPrice.getQuotes(ownerid); 
       nexPrice.getAuditnew(ownerid);
       nexPrice.fetchPendingWithSeller(1,ownerid);
       nexPrice.getAccountDetails(corpList,soldtoList1,shiptoList);
       nexPrice.getsuppliers();     
       requestid.add(reqid);
       //nexPrice.approveRejectChange('data','test','testapp');
       nexPrice.SubmitFormrfq(RequestIds,formdataList,'savesubmit');
       nexPrice.SubmitFormrfq(RequestIds,formdataList,'simulate');
       nexPrice.getpsrsuppliers('test');

nex.OrgOptions = 'test';
       nex.DivOptions= 'test';
       nex.IndOptions= 'test';
       nex.PH6s= 'test';
       nex.PH7s= 'test';
       
       nexPrice.getRequests(aiDisplay,aids);
       nexPrice.getAudit(aids);
       nexPrice.FetchAccount(acct);
       nexPrice.FetchAccountFromAccountMaterial(accmat.id);
       nexPrice.FetchAccountSelect(ids);
       nexPrice.FetchAccountOptions(ids); 
       nexPrice.getSingleOptions2('test','test1','test2','test3','test4','test5','test6');
       nexPrice.getPermission();
       nexPrice.getsapplant('test');

      Test.stopTest();
      }
      catch(exception e){}
       
    }
    public static testMethod void testMyController4() {
        
        
        Date myDate = Date.Today();
        String today = '12/27/2009'; 
        try{       
        Account a = new Account(name = 'Test Account', sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=a.id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist.id;
        List<String> materialList = new List<String>();
        Integer ai = 1;
        List<Integer> aiList = new List<Integer>();
        List<String> ownerid = new List<String>();
        List<String> RequestIds=new List<String>();
        List<String> RequestIdRfq=new List<String>();
        List<String> AccountMatId= new List<String>();
        AccountMatId.add(acmt.Id);
        String owner = acmt.ownerid;
        String mat = matlist.id;
        
        Account_Material__c accmat = new account_material__c(Account__c = a.id, SAP_Material__c = mat);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id);
        List<String> pTrans = new List<String>();
        Price_Request_Transaction__c p = new Price_Request_Transaction__c(Approval_Rejection_Comments__c = 'Comments',Account_Material__c = accmat.id);
        insert p;
        
        pTrans.add(p.Id);
        
        List<String> existingids = new List<String>();
        List<formData> data = new List<formData>();
        
        String pId = (String)p.Id;
        Map<String, Price_Request_Transaction__c> amap = new Map<String, Price_Request_Transaction__c>();
        amap.put(pid,p);
        
        Map<String, Price_Request_Transaction> objmap = new Map<String, Price_Request_Transaction>();
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist.id, sap_material__r = matlist,ship_to__r = a,ship_to__c = a.id,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;
 Test.startTest();
        
       nexPrice.getAccount(a.id);
       nexPrice.approveRejectChange(null,null,null);
       Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
       nexPrice.getDataCount(formdataList);
       List<String> DIVS = new List<String>();
       DIVS.add('31');
       DIVS.add('32');
       List<String> BlankList = new List<String>();
       //try{
       //nexPrice.getSingleOptions('Account',BlankList,'coral','Account','Name, AccountNumber, SAP_Sales_Org__c, SAP_DivisionCode__c','',ownerid,BlankList,DIVS,'Name','1');
       nexPrice.getSingleOptions('SAP Material',BlankList,'coral','Material_Sales_Data2__c','Name, Material_Number__c,  Sales_Org_Code__c, Division_Code__c','',ownerid,BlankList,DIVS,'Name','1');
       nexPrice.getSelectOptions(BlankList,'coral','Account','Name, AccountNumber, SAP_Sales_Org__c, SAP_DivisionCode__c, SAP_City__c','','Name','1');
       nexPrice.SubmitForm12(true,'test',AccountMatId, formdataList,'simulate',false);
       nexPrice.SubmitForm12(false,'test', AccountMatId, formdataList,'savesubmit',false); 
       //}
       //catch(exception e){}
       nexPrice.getPermission();
       nexPrice.getsapplant('test');
       nexPrice.getData(existingids,data,'test','test1');

      Test.stopTest();
      }
      catch(exception e){} 
    }

    public static testMethod void testMyController3() {
        
        
        Date myDate = Date.Today();
        String today = '12/27/2009';  
        try{      
        Account a = new Account(name = 'Test Account', sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=a.id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist.id;
        List<String> materialList = new List<String>();
        Integer ai = 1;
        List<Integer> aiList = new List<Integer>();
        List<String> ownerid = new List<String>();
        List<String> RequestIds=new List<String>();
        List<String> RequestIdRfq=new List<String>();
        List<String> AccountMatId= new List<String>();
        AccountMatId.add(acmt.Id);
        String owner = acmt.ownerid;
                       
        
        String mat = matlist.id;
        
        Account_Material__c accmat = new account_material__c(Account__c = a.id, SAP_Material__c = mat);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id);
        List<String> pTrans = new List<String>();
        Price_Request_Transaction__c p = new Price_Request_Transaction__c(Approval_Rejection_Comments__c = 'Comments',Account_Material__c = accmat.id);
        insert p;
        system.debug('$$$$$$$ p'+p.id);
        pTrans.add(p.Id);
        
        String pId = (String)p.Id;
        Map<String, Price_Request_Transaction__c> amap = new Map<String, Price_Request_Transaction__c>();
        amap.put(pid,p);
        
        Map<String, Price_Request_Transaction> objmap = new Map<String, Price_Request_Transaction>();
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist.id, sap_material__r = matlist,ship_to__r = a,ship_to__c = a.id,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;      
             
        RequestIds.add(transrecord.Id);       
        Map<String, Price_Request_Transaction__c> amap1 = new Map<String, Price_Request_Transaction__c>();
        amap1.put(transrecord.Id,transrecord);
        
       
        Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
        nexPrice.FetchMyAccounts(Userinfo.getuserid(),'','','');
        nexPrice.FromAccount(a.id);
        nexPrice.getDateFormat();
        List<String> ids = new List<String>();
        ids.add(accmat.id);


        List<String> soldtoList = new List<String>();
        String soldto = '0000094713 - CORAL CHEMICAL';
        soldtoList.add(soldto);
        List<String> soldtoList1 = new List<String>(); 
        List<String> shiptoList = new List<String>();
        String shipto = '0000590933 - CORAL CHEMICAL';
        shiptoList.add(shipto);
        List<String> shiptoList1 = new List<String>(); 
        List<String> corpList = new List<String>();
        String corp = '0000590933 - CORAL CHEMICAL';
        corpList.add(corp);
       
        List<String> requestid = new List<string>();
        String reqid = transrecord.Name;
       
        Test.startTest(); 
       
        accList.add(a.id);
        
        ownerid.add(owner);
              
        nexPrice.CheckDuplicateAM(accList,ids);
       nexPrice.saveaccountwomaterial(accList,'test','test','test');
       
       materialList.add(mat1); 
       nexPrice.saveaccountmaterial(accList ,materialList);
       PageReference pageRef = Page.nexprice_12;
       Test.setCurrentPage(pageRef);
       
       apexpages.currentpage().getparameters().put('returl','nexprice12');
       Nexprice nex = new Nexprice();
       
       nexPrice.getProspectMaterial(accList,accList);
       
       nexPrice.getQuotes(ownerid); 
       
       nexPrice.getAuditnew(ownerid);
       
       nexPrice.fetchPendingWithSeller(2,ownerid);
       nexPrice.fetchPendingWithSeller(1,ownerid);
             
       nexPrice.getAccountDetails(corpList,soldtoList1,shiptoList);
       nexPrice.getAccountDetails(corpList,soldtoList,null);
       nexPrice.getAccountDetails(corpList,null,null);
       nexPrice.getsuppliers();
       
       requestid.add(reqid);
       //try{
       /*nexPrice.SimulateForm(RequestIds,formdataList,'simulate','modify',materialList,false);
       nexPrice.getForms(RequestIds,'test');
       nexPrice.SubmitForm(RequestIds,formdataList,'savesubmit');
       nexPrice.SubmitForm(RequestIds,formdataList,'simulate');
       nexPrice.ValidateStartDate(RequestIds,formdataList,'simulate');
       nexPrice.ValidateStartDate(RequestIds,formdataList,'savesubmit');
       nexPrice.ReleaseQuote(pTrans);
       nexPrice.getPermission();
       nexPrice.getsapplant('test');
       nexPrice.getRowCount('testdata');
       nexPrice.getRows('test','test1');
       nexPrice.getComboGridData('test','test1','test2','test3','test4','test5','test6');*/
       
       //nexPrice.SubmitFormrfq(RequestIdRfq,formdataList,'simulate');
      // nexPrice.SubmitFormrfq(RequestIdRfq,formdataList,'savesubmit');
     // }
      //catch(exception e){}
       
       Test.stopTest();
       }
      catch(exception e){}
    }
    public static testMethod void testMyController5() {
        
        
        Date myDate = Date.Today();
        String today = '12/27/2009';  
        try{      
        Account a = new Account(name = 'Test Account', sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=a.id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist.id;
        List<String> materialList = new List<String>();
        Integer ai = 1;
        List<Integer> aiList = new List<Integer>();
        List<String> ownerid = new List<String>();
        List<String> RequestIds=new List<String>();
        List<String> RequestIdRfq=new List<String>();
        List<String> AccountMatId= new List<String>();
        AccountMatId.add(acmt.Id);
        String owner = acmt.ownerid;
                       
        
        String mat = matlist.id;
        
        Account_Material__c accmat = new account_material__c(Account__c = a.id, SAP_Material__c = mat);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id);
        List<String> pTrans = new List<String>();
        Price_Request_Transaction__c p = new Price_Request_Transaction__c(Approval_Rejection_Comments__c = 'Comments',Account_Material__c = accmat.id);
        insert p;
        system.debug('$$$$$$$ p'+p.id);
        pTrans.add(p.Id);
        
        String pId = (String)p.Id;
        Map<String, Price_Request_Transaction__c> amap = new Map<String, Price_Request_Transaction__c>();
        amap.put(pid,p);
        
        Map<String, Price_Request_Transaction> objmap = new Map<String, Price_Request_Transaction>();
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist.id, sap_material__r = matlist,ship_to__r = a,ship_to__c = a.id,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;      
             
        RequestIds.add(transrecord.Id);       
        Map<String, Price_Request_Transaction__c> amap1 = new Map<String, Price_Request_Transaction__c>();
        amap1.put(transrecord.Id,transrecord);
        
       
        Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
        nexPrice.FetchMyAccounts(Userinfo.getuserid(),'','','');
        nexPrice.FromAccount(a.id);
        nexPrice.getDateFormat();
        List<String> ids = new List<String>();
        ids.add(accmat.id);


        List<String> soldtoList = new List<String>();
        String soldto = '0000094713 - CORAL CHEMICAL';
        soldtoList.add(soldto);
        List<String> soldtoList1 = new List<String>(); 
        List<String> shiptoList = new List<String>();
        String shipto = '0000590933 - CORAL CHEMICAL';
        shiptoList.add(shipto);
        List<String> shiptoList1 = new List<String>(); 
        List<String> corpList = new List<String>();
        String corp = '0000590933 - CORAL CHEMICAL';
        corpList.add(corp);
       
        List<String> requestid = new List<string>();
        String reqid = transrecord.Name;
       
        Test.startTest(); 
       
        accList.add(a.id);
        
        ownerid.add(owner);
              
        nexPrice.CheckDuplicateAM(accList,ids);
       nexPrice.saveaccountwomaterial(accList,'test','test','test');
       
       materialList.add(mat1); 
       nexPrice.saveaccountmaterial(accList ,materialList);
       PageReference pageRef = Page.nexprice_12;
       Test.setCurrentPage(pageRef);
       
       apexpages.currentpage().getparameters().put('returl','nexprice12');
       Nexprice nex = new Nexprice();
       
       /*nexPrice.getProspectMaterial(accList,accList);
       
       nexPrice.getQuotes(ownerid); 
       
       nexPrice.getAuditnew(ownerid);
       
       nexPrice.fetchPendingWithSeller(2,ownerid);
       nexPrice.fetchPendingWithSeller(1,ownerid);
             
       nexPrice.getAccountDetails(corpList,soldtoList1,shiptoList);
       nexPrice.getAccountDetails(corpList,soldtoList,null);
       nexPrice.getAccountDetails(corpList,null,null);
       nexPrice.getsuppliers();*/
       
       requestid.add(reqid);
       //try{
       nexPrice.SimulateForm(RequestIds,formdataList,'simulate','modify',materialList,false);
       nexPrice.getForms(RequestIds,'test');
       nexPrice.SubmitForm(RequestIds,formdataList,'savesubmit');
       nexPrice.SubmitForm(RequestIds,formdataList,'simulate');
       nexPrice.ValidateStartDate(RequestIds,formdataList,'simulate');
       nexPrice.ValidateStartDate(RequestIds,formdataList,'savesubmit');
       nexPrice.ReleaseQuote(pTrans);
       nexPrice.getPermission();
       nexPrice.getsapplant('test');
       nexPrice.getRowCount('testdata');
       nexPrice.getRows('test','test1');
       nexPrice.getComboGridData('test','test1','test2','test3','test4','test5','test6');
       
       //nexPrice.SubmitFormrfq(RequestIdRfq,formdataList,'simulate');
      // nexPrice.SubmitFormrfq(RequestIdRfq,formdataList,'savesubmit');
     // }
      //catch(exception e){}
       
       Test.stopTest();
       }
      catch(exception e){}
    }
    
 /*public static testMethod void testMyController2(){
         
        Date myDate = Date.Today();
        String today = '12/27/2009';  
        try{      
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork');
        insert a;
        string acct = a.Id;
        //List<Material_Sales_Data2__c> matlist = [select id,Name,Material_Group2_Desc__c,PH1_Division__c,PH2_Line__c,PH3_group__c,PH4_supplier__c,PH5_family__c,PH6_segment__c,PH7_subsegment__c,Material_Base_Code__c,material_Base_Code_Desc__c,Material_Group2_Code__c,material_group4_code__c from Material_Sales_Data2__c limit 1];
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new account_material__c();
        acmt.account__c = acct;
        acmt.sap_material__c = matlist.id; 
        //acmt.sap_data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.9271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.6807","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.8271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.5857","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.7271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.4907","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.6271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.3957","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"202 ","material_nbr":"000000000000725073","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"3878 ","material_nbr":"000000000000725073","denominator":"1000 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000725073","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000725073","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"3.4000 ","csp_expiration_date":"20140321","csp_effective_date":"20130321","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0036659213"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000097093","ship_to":"0000097093","sfdc_material_id":"","sfdc_account_id":"a56E0000000ZPW3IAO","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000725073","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"5.000 "}';
        acmt.ownerid = '005E0000000Yxil';
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist.id;
        
        List<String> materialList = new List<String>();
        Integer ai = 1;
        List<Integer> aiList = new List<Integer>();
        List<String> ownerid = new List<String>();
        List<String> RequestIds=new List<String>();
        String owner = acmt.ownerid;
                       
        String acc = createAccountprice_Requests(); 
        String mat = createMaterial();
        
        Account_Material__c accmat = new account_material__c(Account__c = acc, SAP_Material__c = mat);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id); 
       
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist.id, sap_material__r = matlist,ship_to__r = a,ship_to__c = a.id,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;
        
        Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
        nexPrice.FetchMyAccounts(Userinfo.getuserid(),'','','');
        //try{
       // nexPrice.FromAccount(a.id);
        nexPrice.getDateFormat();
        //}catch(exception e){}
        List<String> ids = new List<String>();
        ids.add(accmat.id);    
        List<String> list0 = new List<String>(); 
        List<String> list1 = new List<String>(); 

        List<String> existingids = new List<String>();
        List<formData> data = new List<formData>();
        List<Integer> aiDisplay = new List<Integer>();
       Test.startTest(); 
       nexPrice.FetchAccount(acct);
       nexPrice.FetchAccountFromAccountMaterial(accmat.id);
       nexPrice.FetchAccountSelect(ids);
       nexPrice.FetchAccountOptions(ids);  
              
      // try{
       nexPrice.getData(existingids,data,'test','test1');
      // }
      // catch(Exception e){}
      // try{
       nexPrice.getRequests(aiDisplay,list0);
      // }
      // catch(Exception e){}
      // try{
       nexPrice.getAudit(list1);
      // }
      // catch(Exception e){}
      // try{
        nexPrice.getSingleOptions2('test','test1','test2','test3','test4','test5','test6');
        //}
       //catch(Exception e){}
       Test.stopTest(); 
       }
      catch(exception e){}
     } 
      public static testMethod void testMyController5(){
         
        Date myDate = Date.Today();
        String today = '12/27/2009';  
        try{      
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork');
        insert a;
        string acct = a.Id;
        //List<Material_Sales_Data2__c> matlist = [select id,Name,Material_Group2_Desc__c,PH1_Division__c,PH2_Line__c,PH3_group__c,PH4_supplier__c,PH5_family__c,PH6_segment__c,PH7_subsegment__c,Material_Base_Code__c,material_Base_Code_Desc__c,Material_Group2_Code__c,material_group4_code__c from Material_Sales_Data2__c limit 1];
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new account_material__c();
        acmt.account__c = acct;
        acmt.sap_material__c = matlist.id; 
        //acmt.sap_data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.9271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.6807","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.8271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.5857","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.7271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.4907","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.6271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.3957","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"202 ","material_nbr":"000000000000725073","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"3878 ","material_nbr":"000000000000725073","denominator":"1000 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000725073","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000725073","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"3.4000 ","csp_expiration_date":"20140321","csp_effective_date":"20130321","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0036659213"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000097093","ship_to":"0000097093","sfdc_material_id":"","sfdc_account_id":"a56E0000000ZPW3IAO","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000725073","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"5.000 "}';
        acmt.ownerid = '005E0000000Yxil';
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist.id;
        
        List<String> materialList = new List<String>();
        Integer ai = 1;
        List<Integer> aiList = new List<Integer>();
        List<String> ownerid = new List<String>();
        List<String> RequestIds=new List<String>();
        String owner = acmt.ownerid;
                       
        String acc = createAccountprice_Requests(); 
        String mat = createMaterial();
        
        Account_Material__c accmat = new account_material__c(Account__c = acc, SAP_Material__c = mat);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id); 
       
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist.id, sap_material__r = matlist,ship_to__r = a,ship_to__c = a.id,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;
        
        Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
        nexPrice.FetchMyAccounts(Userinfo.getuserid(),'','','');
        //try{
       // nexPrice.FromAccount(a.id);
        nexPrice.getDateFormat();
        //}catch(exception e){}
        List<String> ids = new List<String>();
        ids.add(accmat.id);    
        List<String> list0 = new List<String>(); 
        List<String> list1 = new List<String>(); 
        List<String> list2 = new List<String>();
        List<String> list3 = new List<String>();  
        List<String> list4 = new List<String>(); 
        List<String> list5 = new List<String>();
        List<String> list6 = new List<String>();  
        List<String> list7 = new List<String>(); 
        List<String> list8 = new List<String>(); 
        List<String> list9 = new List<String>(); 
        List<String> list10 = new List<String>(); 
        List<String> list11 = new List<String>(); 
        List<String> list12 = new List<String>(); 
        List<String> list13 = new List<String>(); 
        List<String> list14 = new List<String>(); 
        List<String> list15 = new List<String>(); 
        List<String> list16 = new List<String>(); 
        List<String> list17 = new List<String>(); 
        List<String> existingids = new List<String>();
        List<formData> data = new List<formData>();
        List<Integer> aiDisplay = new List<Integer>();
       Test.startTest(); 
       
       nexPrice.SubmitFormrfq(RequestIds,formdataList,'savesubmit');
       nexPrice.SubmitFormrfq(RequestIds,formdataList,'simulate');
       nexPrice.getpsrsuppliers('test');
       try{
       nexPrice.getCPIs(list0,list1,list2,list3,list4,list5,list6,list7,list8,list9,list10,list11,list12,list13,list14,list15,list16,list17);
       }
       catch(Exception e){}
       try{
       nexPrice.getComboGridData('test','test1','test2','test3','test4','test5','test6');
       }
       catch(Exception e){}
       try{
       nexPrice.getRowCount('test');
       }
       catch(Exception e){}
       try{
       nexPrice.getRows('test','test1');
       }catch(Exception e){}
       try{
       nexPrice.getData(existingids,data,'test','test1');
       }
       catch(Exception e){}
       
       Test.stopTest(); 
       }
      catch(exception e){}
    }  */
          
    public static String createAccountprice_Requests(){
        Account a = new Account(name = 'Test Account');
        try{
        insert a;
        }
      catch(exception e){}
        return a.Id;
    }
    
    public static String createMaterial(){
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test');
        insert m;
        return m.Id;

    }
    
     

}