@isTest

public class Target_Calculator_Controller_test{
     public static testMethod void testtargetcalculator(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Target_Calculator_Controller tcc = new Target_Calculator_Controller();
              
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123',SAP_DivisionCode__c = 'test12',SAP_Sales_Org__c= 'abc');
       a.SAP_Sold_To_Account__c='';
         insert a;
      
        Account Accountb = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Prospect',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123',SAP_DivisionCode__c = 'test12',SAP_Sales_Org__c= 'abc');
        insert Accountb;
        
        Material__c mat=new Material__c();
    	mat.Company__c='Test';
    	insert mat;
         
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = mat.Id, Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_Base_Code__c = '12345');        
        insert matlist;
       
        Consumption__c con = new Consumption__c (Account_Name__c = a.id, SAP_Material__c = matlist.id);
        
        Opportunity opp = new Opportunity(AccountId = a.id, SAP_Material__c = matlist.id);
                
        Material_Base_Code__c mbc = new Material_Base_Code__c(Material_Base_Code_Description__c = 'test test 123', Material_Base_Code__c = '123456');
        
        Target_End_Market__c tem = new Target_End_Market__c(Name = 'end market1',Sales_org__c = '1000', division__c = '30');
        insert tem;
        
        SAP_Sales_Org__c sso = new SAP_Sales_Org__c(Sales_Org_Description__c = 'test',Sales_Org_Code__c = 'testdata');
        insert sso;
        
        SAP_Sales_Division__c ssd = new SAP_Sales_Division__c(Language_Code__c = 'lc',Sales_Division_Code__c = 'sd',Sales_Division_Description__c = 'abc');
        insert ssd;
        
        Profile profile = [select id from profile where name='System Administrator'];
        userrole role =[select id from userrole where name='ad sales'];
        
        User usr = new User(alias = 'standt', email='standarduser@testorg.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = profile.Id, userroleid=role.id, 
        username='supplierMain@testorg.com',timezonesidkey='America/Los_Angeles');
        try{        
        insert usr;
        }
       catch (exception e){}
             
        Target_Price_Request__c tpr = new Target_Price_Request__c(Sales_Org__c = 'test',Email_Owner__C = false,Material__c = matlist.id,Account__c = a.id, Notes__c = 'test',Region__c = 'test');
        insert tpr;
        
        Pricing_Region__c prc = new Pricing_Region__c(Division__c = '30', Sales_Org__c = '1000');
        insert prc;
        
       // List<CSP_JSON_Request_Item> cjr = new List<CSP_JSON_Request_Item>();
       // CSP_JSON_Request_Item csp = new CSP_JSON_Request_Item (matlist.Id);
         //csp.material=matlist.Id;
        //insert csp;
       // cjr.add(csp);
        Target_Calc_Request tcr = new Target_Calc_Request('1000','31','20','','','');
        tcr.MATERIAL=matlist.Id;
        tcr.SALES_ORG='testdata';
        //tcr.SUB_REGION='Test';
         ApexPages.standardController sc = new ApexPages.standardcontroller(tpr);
        Target_Calculator_Controller tc =new Target_Calculator_Controller(sc);
        try{
            string test='';
       CSP_JSON_Response resp = new CSP_JSON_Response(test,test,test,test,test,test,test,test,test,test,test,
                                               test,test,test,test,test,test,test,test,test,test,test,
                                               test,test,test,test, 
                                               new List<CSP_JSON_Response.tbl_sales_units>{new CSP_JSON_Response.tbl_sales_units( test, test, test, test, test)}, 
                                               new List<CSP_JSON_Response.tbl_csp_prices>{new CSP_JSON_Response.tbl_csp_prices(test,test,test,test,test,test,test,test,test,test,test)}, 
                                               new List<CSP_JSON_Response.tbl_target_prices>{new CSP_JSON_Response.tbl_target_prices(test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test, test,test,test,test,test,test, test)},  
                                               new List<CSP_JSON_Response.tbl_list_prices>{new CSP_JSON_Response.tbl_list_prices(test,test,test,test,test,test,test,test,test,test,test, test)},
                                               test,test);    
            List<CSP_JSON_Response> listresponses=new List<CSP_JSON_Response>();
            listresponses.add(resp);
        Target_Calculator_Controller.getTable(listresponses,'test');
        }catch(exception e){}
        Target_Calculator_Controller.getTestString();
        
        
        Target_Calculator_Controller.getMaterials('Test Material','material', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','base', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('Test Material','basematerial', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','consumption', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','Opportunity', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMarkets('1000','30');
        Target_Calculator_Controller.getRegions('1000','30');
        
        
        Target_Calculator_Controller.getContainers('12345',true,'31','COMMODITY');
        
        Target_Calculator_Controller.SendEmail(tpr.id, tpr.Notes__c);
        Target_Calculator_Controller.getRecent('');
        Target_Calculator_Controller.getRecent(a.id);
        Target_Calculator_Controller.getRecent('Default');
        Target_Calculator_Controller.getAccount(a.id);
        Try{
      
        Target_Calculator_Controller.getCustomerTiers(tcr, a.id, 'test');
            
        //Target_Calculator_Controller.getTable(responses );
       
       
        }
        catch(exception e){}
         try{     
		Target_Calculator_Controller.getProspectTiers(tcr, a.Id, 'test');
            }catch(Exception ex){
                
            }
         try{     
		Target_Calculator_Controller.getProspectTiers(tcr, accountB.Id, 'test');
            }catch(Exception ex){
                
            }

         try{
            //tcr.SALES_ORG=SSO.Id;
             //UPDATE tcr;
             //
             
          Target_Calculator_Controller.getTiers(tcr, 'test', 'test');
          }catch(Exception ex){
              
              System.debug('TEST FGG '+ex.getMessage());
          }
         
        CSP_JSON_Response.tbl_sales_units respuesta = new CSP_JSON_Response.tbl_sales_units('test','test','test','test','test');	
         //insert respuesta;
         List<CSP_JSON_Response.tbl_sales_units> units=new 
         List<CSP_JSON_Response.tbl_sales_units>();
         
         units.add(respuesta);
                try{
         
		 Target_Calculator_Controller.getConversionMap(units);
          }catch(Exception ex){
              
              System.debug('TEST FGG '+ex.getMessage());
          }

		         try{
                     Map<String, Double> conversionmap=new Map<String, Double>();
                     conversionmap.put('test', 123.0);
         Target_Calculator_Controller.ConvertUnits(conversionmap, 1230, 'test', 'test', true);
                     
         Target_Calculator_Controller.ConvertUnits(conversionmap, 1230, 'test', 'test', false);
          }catch(Exception ex){
              
              System.debug('TEST FGG '+ex.getMessage());
          }

         Double doublevar;
		 doublevar=Target_Calculator_Controller.stringtodouble('123-123,');
     }

public static testMethod void testtargetcalculator1(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Target_Calculator_Controller tcc = new Target_Calculator_Controller();
        
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        Material__c mat=new Material__c();
    	mat.Company__c='Test';
    	insert mat;
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = mat.Id, Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_Base_Code__c = '12345',Material_Group3_Desc__c = 'test');        
        insert matlist;
       
        Consumption__c con = new Consumption__c (Account_Name__c = a.id, SAP_Material__c = matlist.id);
        
        Opportunity opp = new Opportunity(AccountId = a.id, SAP_Material__c = matlist.id);
                
        Material_Base_Code__c mbc = new Material_Base_Code__c(Material_Base_Code_Description__c = 'test test 123', Material_Base_Code__c = '123456');
        
        Target_End_Market__c tem = new Target_End_Market__c(Name = 'end market1',Sales_org__c = '1000', division__c = '30');
        insert tem;
        
        Profile profile = [select id from profile where name='System Administrator'];
        try{
        UserRole ur = new UserRole(DeveloperName = 'Test', Name = 'Test');
        insert ur;
        
        User usr = new User(alias = 'standt', email='standarduser@testorg.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', //Role = ur.id,
        localesidkey='en_US', profileid = profile.Id, userroleid=ur.id, nexPrice_Disregard_Hierarchy__c = False,
        username='supplierMain@testorg.com',timezonesidkey='America/Los_Angeles');
        insert usr;
        
        string roleid = usr.id;
        Role_Data__c rd = new Role_Data__c(type__c = 'Account',role_id__c=roleid);
        Role_Data__c rd1 = new Role_Data__c(type__c = 'Account',role_id__c=usr.userroleid);
        }
        Catch(exception e){}
        Target_Price_Request__c tpr = new Target_Price_Request__c(Material__c = matlist.id,Account__c = a.id, Notes__c = 'test',Region__c = 'test');
        insert tpr;
        
        Pricing_Region__c prc = new Pricing_Region__c(Division__c = '30', Sales_Org__c = '1000');
        insert prc;
        
        Target_Calc_Request tcr = new Target_Calc_Request('1000','30','20',tem.name,'',matlist.name);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(tpr);
        Target_Calculator_Controller tc =new Target_Calculator_Controller(sc);
        
        
        Target_Calculator_Controller.getMaterials('Test Material','material', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','base', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('Test Material','basematerial', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','consumption', '1000', a.id, true, '34','COMMODITY');
        Target_Calculator_Controller.getMaterials('','Opportunity', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMarkets('1000','32');
        Target_Calculator_Controller.getRegions('1000','32');
        
        
        Target_Calculator_Controller.getContainers('12345',False,'31','COMMODITY');
        
        Target_Calculator_Controller.SendEmail(tpr.id, tpr.Notes__c);
        Target_Calculator_Controller.getRecent('');
        Target_Calculator_Controller.getRecent(a.id);
        Target_Calculator_Controller.getRecent('Default');
       try{
        
        Target_Calculator_Controller.getProspectTiers(tcr, a.id, 'test');
        Target_Calculator_Controller.getTiers(tcr,'test','test');
        }
        catch(exception e){}
        
     }
     public static testMethod void testtargetcalculator2(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Target_Calculator_Controller tcc = new Target_Calculator_Controller();
        
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_Base_Code__c = '12345',Material_Group3_Desc__c = 'test');        
        insert matlist;
       
        Consumption__c con = new Consumption__c (Account_Name__c = a.id, SAP_Material__c = matlist.id);
        
        Opportunity opp = new Opportunity(AccountId = a.id, SAP_Material__c = matlist.id);
                
        Material_Base_Code__c mbc = new Material_Base_Code__c(Material_Base_Code_Description__c = 'test test 123', Material_Base_Code__c = '123456');
        
        Target_End_Market__c tem = new Target_End_Market__c(Name = 'end market1',Sales_org__c = '1000', division__c = '30');
        insert tem;
        
        Profile profile = [select id from profile where name='System Administrator'];
        try{
        UserRole ur = new UserRole(DeveloperName = 'Test', Name = 'Test');
        insert ur;
        
        User usr = new User(alias = 'standt', email='standarduser@testorg.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', //Role = ur.id,
        localesidkey='en_US', profileid = profile.Id, nexPrice_Disregard_Hierarchy__c = False,
        username='supplierMain@testorg.com',timezonesidkey='America/Los_Angeles');
        insert usr;
        
        string rolename = 'AD Sales';
        Role_Data__c rd = new Role_Data__c(type__c = 'Account',role_name__c =rolename );
        }
        Catch(exception e){}
        Target_Price_Request__c tpr = new Target_Price_Request__c(Material__c = matlist.id,Account__c = a.id, Notes__c = 'test',Region__c = 'test');
        insert tpr;
        
        Pricing_Region__c prc = new Pricing_Region__c(Division__c = '30', Sales_Org__c = '1000');
        insert prc;
        
        List<CSP_JSON_Response.tbl_sales_units> units = new List<CSP_JSON_Response.tbl_sales_units>();
        Map<String, Double> conversionmap = new Map<String, Double>();
        
        
        Target_Calc_Request tcr = new Target_Calc_Request('1000','30','20',tem.name,'',matlist.name);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(tpr);
        Target_Calculator_Controller tc =new Target_Calculator_Controller(sc);
       // Target_Calculator_Controller.getTestString();
        
        
        Target_Calculator_Controller.getMaterials('Test Material','material', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','base', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('Test Material','basematerial', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMaterials('','consumption', '1000', a.id, true, '34','COMMODITY');
        Target_Calculator_Controller.getMaterials('','Opportunity', '1000', a.id, true, '31','COMMODITY');
        Target_Calculator_Controller.getMarkets('1000','32');
        Target_Calculator_Controller.getRegions('1000','32');
        Target_Calculator_Controller.getConversionMap(units);
        Target_Calculator_Controller.ConvertUnits(conversionmap ,1261992,'tes','test1', true);
        Target_Calculator_Controller.stringtodouble('3.14159');
        Target_Calculator_Controller.getContainers('12345',False,'31','COMMODITY');
        
        Target_Calculator_Controller.SendEmail(tpr.id, tpr.Notes__c);
        Target_Calculator_Controller.getRecent('');
        Target_Calculator_Controller.getRecent(a.id);
        Target_Calculator_Controller.getRecent('Default');
       try{
       
        
        //Target_Calculator_Controller.getProspectTiers(tcr, a.id);
        Target_Calculator_Controller.getTiers(tcr,'test','test');
        }
        catch(exception e){}
        
     }



}