@isTest
Public class SalesVarianceBatch_Test{
    Public static testMethod void testMe(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
          insert u;
           User u1 = new User(Alias = 'standt2', Email='ooo@tstorg.com',EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdec@gorg.com', IsActive = true);
          insert u1;
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
          Account a = new Account(Name = 'test',type = 'Customer',primary_seller__c = u.id,Parent = a1,SAP_DivisionCode__c='31',ZH_Partner__c = ss.id,YI_Partner__c = ST.id,YY_Partner__c = ST.id,YZ_Partner__c=ST.id,ZC_Partner__c = ss.id,ZU_Partner__c = ss.id);
          acclist.add(a);
          insert acclist;
          
          SalesChurn__c sc2=new SalesChurn__c(Account_Number__c=acclist[0].id);
          list<SalesChurn__c> scList = new List<SalesChurn__c>();
          scList.add(sc2);
          insert scList;
          scList[0].Ownerid = u1.id;
          update scList;
          
          accList[0].YZ_Partner__c=null;
          //accList[0].Specialty_Seller__c = u.id;
          update accList;
          
          SalesVarianceBatch sv = new SalesVarianceBatch();
          sv.Start(null);
          sv.execute(null,scList);
          Sv.finish(null);
          }Catch(exception e){}
    }
}