@isTest
private class ConsToOppConvert_Test {

static testMethod void myUnitTest() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    	User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;
        Account acc1 = new Account(Name='AD_Plastics',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Plastics');
        insert acc1;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        Id RecordTypeId = Schema.SObjectType.Consumption__c.getRecordTypeInfosByName().get('Distribution Chemicals').getRecordTypeId();
        Consumption__c con = new Consumption__c();
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Secondary_Volume__c = 12;
        con.Annual_Volume__c = 1000;
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        con.recordtypeid = RecordTypeId;
        insert con;
        
        RTK_Transfer__c t = new RTK_Transfer__c(Consumption__c = con.id);
        t.Hidden_EPA_ID_Source_Facility__c = '123';
        t.Reporting_year__c = '4';
        t.page_number__c = '5';
        insert t;
        
        epa_code__c e = new epa_code__c(Consumption__c = con.id);
        rtk_code__c r = new RTK_Code__c(Name = 'test', Description__c='Desc');
        insert r;
        e.EPA_ID__c = '123';
        e.Reporting_year__c = '4';
        e.page_number__c = '5';
        e.epa_code__c = r.id;
        insert e;
        
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert();
        c.processcancel();
        c.closePopup();
        c.showPopup();

     }
     
     static testMethod void myUnitTest1() {
        Test.startTest();
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    	User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;
        Account acc1 = new Account(Name='AD_Plastics',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Plastics');
        insert acc1;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        Id RecordTypeId = Schema.SObjectType.Consumption__c.getRecordTypeInfosByName().get('Distribution Chemicals').getRecordTypeId();
        
        Consumption__c con = new Consumption__c();
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Secondary_Volume__c = 12;
        con.Annual_Volume__c = 1000;
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        con.recordtypeid = RecordTypeId;
        insert con;
        
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert();
     }
     
     static testMethod void myUnitTest3() {
        Test.startTest();
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    	User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;
        Account acc1 = new Account(Name='AD_Plastics',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Plastics');
        insert acc1;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        Id RecordTypeId = Schema.SObjectType.Consumption__c.getRecordTypeInfosByName().get('Distribution Chemicals').getRecordTypeId();
        Consumption__c con = new Consumption__c();
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Secondary_Volume__c = 12;
        con.Annual_Volume__c = 1000;
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        con.recordtypeid = RecordTypeId;
        insert con;
        
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert();
        c.processcancel();
        c.closePopup();
        c.showPopup();

     }
     
     static testMethod void myUnitTest4() {
        Test.startTest();
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    	User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;
        Account acc1 = new Account(Name='AD_Plastics',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Plastics');
        insert acc1;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        Id RecordTypeId = Schema.SObjectType.Consumption__c.getRecordTypeInfosByName().get('Distribution Chemicals').getRecordTypeId();
        Consumption__c con = new Consumption__c();
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Secondary_Volume__c = 12;
        con.Annual_Volume__c = 1000;
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        con.recordtypeid = RecordTypeId;
        insert con;
 
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert();
     }
     
          static testMethod void myUnitTest5() {
        Test.startTest();
              Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    	User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;
        Account acc1 = new Account(Name='AD_Plastics',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Plastics');
        insert acc1;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        Id RecordTypeId = Schema.SObjectType.Consumption__c.getRecordTypeInfosByName().get('Distribution Plastics').getRecordTypeId();
        Consumption__c con = new Consumption__c();
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Secondary_Volume__c = 12;
        con.Annual_Volume__c = 1000;
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        con.recordtypeid = RecordTypeId;
        insert con;
        
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert();
     }
     
          static testMethod void myUnitTest6() {
        Test.startTest();
              Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    	User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Account acc = new Account(Name='AD_Chemicals',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Chemicals');
        insert acc;
        Account acc1 = new Account(Name='AD_Plastics',
                                  RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                  SAP_Division_Desc__c = 'Plastics');
        insert acc1;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Name='Nexeo Comp');
        insert nc;
        Id RecordTypeId = Schema.SObjectType.Consumption__c.getRecordTypeInfosByName().get('Distribution Composites').getRecordTypeId();
        Consumption__c con = new Consumption__c();
        con.Account_Name__c = acc.id;
        con.SAP_Material__c = mat.id;
        con.Nexeo_Competitor__c = nc.id;
        con.Distribution_Volume__c = 1000; 
        con.Secondary_Volume__c = 12;
        con.Annual_Volume__c = 1000;
        con.Direct_Volume__c = 1000;
        con.description__c = 'This is my description';    
        con.Unit_of_Measure__c = 'KG';
        con.RTKKey__c = '12345';
        con.recordtypeid = RecordTypeId;
        insert con;
        
        ApexPages.currentpage().getparameters().put('cid', con.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con); 
        ConsToOppConvert c = new ConsToOppConvert(sc);
        c.doconvert();
     }
}