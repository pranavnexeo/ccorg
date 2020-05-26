//Test methods for Nexprice CPI Securtiy enhancement
//Author Rajeev

@isTest

private class nexpriceCPI_security{
    
    //Test method for "Nexprice_Account_Team_Functions" class
    
    static testmethod void nexpriceCPI_security_method1(){
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account acc = new Account(Name = 'Nexeo');
        Test.startTest();
        insert acc;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='h123aas3dbvsbbbc@gorg.com', IsActive = true);
        insert user;
        
        List<Nexeo_Account_Team__c> nats = new List<Nexeo_Account_Team__c>();
        Nexeo_Account_Team__c nat = new Nexeo_Account_Team__c(Account__c = acc.Id,
                                                             Expiration_Date__c = System.today()+10,
                                                             Nexprice_Access__c = 'Read/Write',
                                                             Opportunity_Access__c = 'Edit',
                                                             User__c = user.Id);
        
        nats.add(nat);
        
        Account_Material__c accm = new Account_Material__c(Account__c = acc.Id);
        insert accm;
        
        Nexprice_Account_Team_Functions.createSharingRecords(nats,false);
        Nexprice_Account_Team_Functions.deleteSharingRecords(nats);
        Test.stopTest();
    }

    //Test method for Nexeo_Account_Team class
    static testmethod void nexpriceCPI_security_method2(){
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account acc = new Account(Name = 'Nexeo');
        Test.startTest();
        insert acc;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='h123aas3dbvsbbbc@gorg.com', IsActive = true);
        insert user;
        
        List<Nexeo_Account_Team__c> nats = new List<Nexeo_Account_Team__c>();
        
        Nexeo_Account_Team__c nat1 = new Nexeo_Account_Team__c(Account__c = acc.Id,
                                                             Nexprice_Access__c = 'Read/Write',
                                                             Opportunity_Access__c = 'Edit',
                                                             User__c = user.Id); 
        
        nats.add(nat1);
        insert nats;
        Test.stopTest();                                                  
        ApexPages.standardcontroller sc1 = new ApexPages.standardcontroller(nats[0]);
        Nexeo_Account_Team RD1 = new Nexeo_Account_Team(sc1);
        RD1.saveonly();
        RD1.saveandmore();
        
                                                            
    }
    
    //Test method for Nexprice_Account_Team_batch class
    static testmethod void nexpriceCPI_security_method3(){
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account acc = new Account(Name = 'TestAcc');
        Test.startTest();
        insert acc;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='haas3dbvsbbbc@gorg.com', IsActive = true);
        insert user;
        List<Nexeo_Account_Team__c> nats = new List<Nexeo_Account_Team__c>();
        
        nats.add(new Nexeo_Account_Team__c(Account__c = acc.Id,
                                                             Expiration_Date__c = System.today()-10,
                                                             Nexprice_Access__c = 'Read/Write',
                                                             Opportunity_Access__c = 'Edit',
                                                             User__c = user.Id)
                                                             ); 
        
        insert nats;
        
        Nexprice_Account_Team_batch b = new Nexprice_Account_Team_batch('test');
        Id IdBatch = Database.executeBatch(b,1);
        b.execute(null,nats);
        Test.stopTest();

     }                                                         
    
    //Test method for NexpriceCPI_Owner_Update_batch class
    static testmethod void NexpriceCPI_Owner_Update_batch_method4(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Test.startTest();
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='habdfsscvsc@gorg.com', IsActive = true);
        insert u;
        
        User u1 = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='haas3dbvsc@gorg.com', IsActive = true);
        insert u1;
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account acc  = new Account(OwnerId = u.Id,Name = 'Account1');
        insert acc;
        List<Account_Material__c> amList = new List<Account_Material__c>();
        Account_Material__c am = new Account_Material__c(Account__c = acc.Id, OwnerId = u1.Id);
        amList.add(am);
        
        insert amList;
        
        NexpriceCPI_Owner_Update_batch b = new NexpriceCPI_Owner_Update_batch('Test');
        Id IdBatch = Database.executeBatch(b,1);
        b.execute(null,amList);
        
        Test.stopTest();
    }
    
    static testmethod void Material_SAP_Values_Sync_Batch_method5(){
        Test.startTest();
        Integration_Table_Change__c integration = new Integration_Table_Change__c(
                                          Completed__c = false,
                                          Code_Field__c = 'Material_Base_Code__c',
                                          code_value__c = '01_699892G2',
                                          Description_Field__c = 'Material_Base_Code_Desc__c',
                                          Config_Table__c = 'Material_Base_Code__c',
                                          Config_Code_Field__c = 'Material_Base_Code__c',
                                          Config_Desc_Field__c = 'Material_Base_Code_Description__c',
                                          type__c = 'Material',
                                          new_description__c = 'PC 141R 1325T GY LEXAN',
                                          old_description__c  = 'PC 141R GY1325T GY LEXAN');
        
        insert integration;
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key',
                                                                      Material_Base_Code__c = '01_699892G2',Material_Base_Code_Desc__c = 'PC 141R GY1325T GY LEXAN');        
        
        List<Material_Sales_Data2__c > mats = new List<Material_Sales_Data2__c >();
        mats.add(matlist);
        insert mats;
        
        Material_SAP_Values_Sync_Batch b = new Material_SAP_Values_Sync_Batch('test');
        Id IdBatch = Database.executeBatch(b,1);
        b.execute(null,mats);
        Test.stopTest();
    }
}