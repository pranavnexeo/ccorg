@isTest
    Private Class Update_PriceSuppforSuppProf_batch_test{ 
  
        Public static testmethod void TestUpdate_PriceSuppforSuppProf_batch(){
            Map<String, SObject> testData = NexeoTestUtils_Test.initData();
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            List<user> ulist = new List<user>(); 
            User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             ulist.add(u);
             insert ulist;
             Account acct = new Account
           (name='TestAccount',
           AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
           insert acct;
            //Price_Support__c  ps = new Price_Support__c(Name ='test',Support_Type__c = 'Rebate',Supplier_Profile_ID__c = );
             string sc;
             List<Supplier_Profile__c> splist = new List<Supplier_Profile__c>(); 
             Supplier_Profile__c sf = new Supplier_Profile__c(Supplier_Name__c = acct.id,Purchasing_Organization__c = '1000',Vendor_PI__c = 'test',Supplier_Currency__c = 'USD',X1st_Discount__c = 12,X2nd_Discount__c =12,X1st_Discount_Type__c= '$',X2nd_Discount_Type__c = '$');
             splist.add(sf);
             insert splist;
             Price_Support__c  ps = new Price_Support__c(Support_Type__c = 'Rebate',Supplier_Profile_ID__c = sf.id,Supplier_Name__c = 'test',Customer_soldto__c = acct.id,status__c = 'Approved',Customer_Type__c ='PY-Payer',Supplier_PI_Number__c = 'test');
             insert ps;
        Test.startTest();
         //string bc;
        Update_PriceSuppforSuppProf_batch psfs = new Update_PriceSuppforSuppProf_batch(sc);
            ID idBatch = Database.executeBatch(psfs);
           
            psfs.execute(null,splist); 
            //psfs.finish();
       Test.stoptest();
        
        
       }
               Public static testmethod void TestUpdate_PriceSuppforSuppProf_batch1(){
               Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            List<user> ulist = new List<user>(); 
            User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             ulist.add(u);
             insert ulist;
             Account acct = new Account
           (name='TestAccount',
           AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
           insert acct;
            //Price_Support__c  ps = new Price_Support__c(Name ='test',Support_Type__c = 'Rebate',Supplier_Profile_ID__c = );
             string sc;
             List<Supplier_Profile__c> splist = new List<Supplier_Profile__c>(); 
             Supplier_Profile__c sf = new Supplier_Profile__c(Supplier_Name__c = acct.id,Purchasing_Organization__c = '1000',Vendor_PI__c = 'test',Supplier_Currency__c = 'USD',X1st_Discount__c = 12,X2nd_Discount__c =12,X1st_Discount_Type__c= '$',X2nd_Discount_Type__c = '$');
             splist.add(sf);
             insert splist;
             Price_Support__c  ps = new Price_Support__c(Support_Type__c = 'Upfront',Supplier_Profile_ID__c = sf.id,Supplier_Name__c = 'test',status__c = 'Approved',Customer_Type__c ='PY-Payer',Supplier_PI_Number__c = 'test');
             insert ps;
        Test.startTest();
         string bc;
        Update_PriceSuppforSuppProf_batch psfs = new Update_PriceSuppforSuppProf_batch(sc);
            //ID idBatch = Database.executeBatch(usnb );
           
            psfs.execute(null,splist); 
            //psfs.finish();
       Test.stoptest();
        
        
       }
       Public static testmethod void TestUpdate_PriceSuppforSuppProf_batch2(){
            Map<String, SObject> testData = NexeoTestUtils_Test.initData();
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            List<user> ulist = new List<user>(); 
            User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             ulist.add(u);
             insert ulist;
             Account acct = new Account
           (name='TestAccount',
           AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
           insert acct;
            //Price_Support__c  ps = new Price_Support__c(Name ='test',Support_Type__c = 'Rebate',Supplier_Profile_ID__c = );
             string sc;
             List<Supplier_Profile__c> splist = new List<Supplier_Profile__c>(); 
             Supplier_Profile__c sf = new Supplier_Profile__c(Supplier_Name__c = acct.id,Purchasing_Organization__c = '1000',Vendor_PI__c = 'test',Supplier_Currency__c = 'USD',X1st_Discount__c = 12,X2nd_Discount__c =12,X1st_Discount_Type__c= '$',X2nd_Discount_Type__c = '$');
             splist.add(sf);
             insert splist;
             Price_Support__c  ps = new Price_Support__c(Support_Type__c = 'Rebate',Supplier_Profile_ID__c = sf.id,Supplier_Name__c = 'test',status__c = 'Approved',Customer_Type__c ='BP-Bill To',Supplier_PI_Number__c = 'test');
             insert ps;
        Test.startTest();
         //string bc;
         Database.BatchableContext bc;
         //AsyncApexJob aaj = new AsyncApexJob(Status = 'open');
        Update_PriceSuppforSuppProf_batch psfs = new Update_PriceSuppforSuppProf_batch(sc);
            //ID idBatch = Database.executeBatch(usnb );
           
            psfs.execute(null,splist); 
            //psfs.finish(bc);
       Test.stoptest();
        
        
       }
   }