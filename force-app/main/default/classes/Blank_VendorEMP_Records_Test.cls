@isTest
    public Class Blank_VendorEMP_Records_Test{ 
  
        Public static testmethod void Blank_VendorEMP_Records_Test(){
            List<Account> ac = new List<Account>();
            
             Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
             User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
             insert s; 
             SAP_Seller__c s1 = new SAP_Seller__c(Name = 'test1', user__c = u.id);
             insert s1;
             SAP_Seller__c s2 = new SAP_Seller__c(Name = 'test2');
             insert s2;
             
             list<SAP_Sales_DOG__c> SDogsList = new List<SAP_Sales_DOG__c>();
             SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = s.id, Record_Key__c = '1234', YO_Partner__c = s.id,YV_Partner__c = s.id);
             SDogsList.add(ssd);
             SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = s1.id, Record_Key__c = '12345', YO_Partner__c = s1.id,YV_Partner__c = s1.id);
             SDogsList.add(ssd1);
             insert SDogsList;
             
             SAP_Territory__c st = new SAP_Territory__c(name = 'test',ZS_Partner__c=s.id,YS_Partner__c=s.id,Record_Key__c = ssd.id);
             insert st;
             SAP_Territory__c st1 = new SAP_Territory__c(name = 'test',ZS_Partner__c=s1.id,YS_Partner__c=s1.id,Record_Key__c = ssd1.id);
             insert st1;
             
             /*Account acc = new Account(SAP_Accounting_Group__c = 'ZEMP', type = 'Vendor',BillingCity = '',name = 'test',YI_Partner__c = st.id,SAP_Customer_Group_2__c = 'COM',ZH_Partner__c=s.id,YY_Partner__c = st.id,YZ_Partner__c = st.id);
             Account acc1 = new Account(SAP_Accounting_Group__c = 'ZEMP', type = 'Vendor',BillingCity = '',name = 'test1',YI_Partner__c = st1.id,SAP_Customer_Group_2__c = 'SPC',ZH_Partner__c=s1.id);
             Account acc2 = new Account(SAP_Accounting_Group__c = 'ZEMP', type = 'Vendor',BillingCity = '',name = 'tes21',YI_Partner__c = st.id,SAP_Customer_Group_2__c = 'SPC',ZH_Partner__c=s2.id);

             ac.add(acc);
             ac.add(acc1);
             ac.add(acc2);
             insert ac;*/
             Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User ur = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pr.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert ur;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test',SAP_Accounting_Group__c = 'ZEMP');
   insert a;
             
            
            }
            
         }