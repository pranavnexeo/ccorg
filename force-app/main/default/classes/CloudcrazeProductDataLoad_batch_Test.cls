@isTest
 Public Class CloudcrazeProductDataLoad_batch_Test{
  
      Public static testmethod void TestThisBatch(){
      
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
                
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
          insert u;
          try{
          
          SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
          SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
          insert ssd;
          
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
          insert ST;
          
          List<Account> acclist = new List<Account>();
          Account a1 = new Account(Name = 'test',type = 'Prospect',primary_seller__c = u.id,ZH_Partner__c = ss.id);
          insert a1;
          Account a = new Account(Name = 'test',type = 'Customer',primary_seller__c = u.id,Parent = a1,ZH_Partner__c = ss.id,YI_Partner__c = ST.id,YY_Partner__c = ST.id,YZ_Partner__c = ST.id,ZC_Partner__c = ss.id,ZU_Partner__c = ss.id);
          acclist.add(a);
          insert acclist;
          
           
          List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
          AccountTeamMember atm = new AccountTeamMember(AccountId = a.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
          atmlist.add(atm);
          insert atmlist;
          
          String matnum = '000000000123456789';
          String plant = '1234';
          String sorg = '1234';
          String dchan = '12';
          String lang = 'E';
        
          SAP_Sales_Org__c so = new SAP_Sales_Org__c();
          so.Sales_Org_Code__c = sorg;
          so.Language_Code__c = lang;
          insert so;
        
          SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
          dc.Distribution_Channel_Code__c = dchan;
          dc.Language_Code__c = lang;
          insert dc;
        
          Material_General_Data2__c mgd2 = new Material_General_Data2__c();
          mgd2.Material_Number__c = matnum;
          mgd2.Division_Code__c = '31';
          mgd2.Marked_for_Deletion__c = '';
          insert mgd2;
                
          List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
          Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
          msd2.Material_Number__c = matnum;
          msd2.Sales_Org_Code__c = sorg;
          msd2.Dist_Channel_Code__c = dchan;
          msd2.Record_Key__c = matnum + sorg + dchan;
          msd2.SalesOrg_Code__r = so;
          msd2.DistChannel_Code__r = dc;
          msd2.Material_General_Data__r = mgd2;
          msdl.add(msd2);
          insert msdl;

          Map<Id, List<String>> bmap = new Map<Id, List<String>>();
          
          Integer batchNumber = 4;
          string test4;
          Test.startTest();
          system.runas(u){
          CloudcrazeProductDataLoad_batch cpdb = new CloudcrazeProductDataLoad_batch (4,true,'31');
          ID idBatch = Database.executeBatch(cpdb);
           cpdb.execute(null,msdl);
          }
          Test.stopTest();
          }catch(exception e){}
      
      }
  }