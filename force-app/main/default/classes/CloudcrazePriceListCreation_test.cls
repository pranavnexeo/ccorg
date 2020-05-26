@isTest
public class CloudcrazePriceListCreation_test{

    public static testMethod void testmybatch(){
    List<Account> acclist = new List<Account>();  
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
    
      
     /*Account a = new Account(Name = 'test',type = 'Customer');
     insert a;*/
     
     List<Id> accId = new List<Id>();
     accId.add(a.id);
    
    Test.startTest();
    
    CloudcrazePriceListCreation cplist = new CloudcrazePriceListCreation(accId);
    Id batchId = Database.executeBatch(cplist);
    cplist.execute(null,acclist);
    
    Test.stopTest();
    
    
    }
    public static testMethod void testmybatch1(){
     List<Account> acclist = new List<Account>(); 
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
    
       
     /*Account a = new Account(Name = 'test',type = 'Customer',AccountNumber='12343');
     insert a;*/
     Material_Sales_Data2__c msd = new Material_Sales_Data2__c(Name='test',Material_Number__c='091234',Create_CC_Product__c=false,Dist_Channel_Code__c='30',Record_Key__c='09123410003031',Sales_Org_Code__c='1000');
     insert msd;
     Customer_Product_Info__c cpi = new Customer_Product_Info__c(SAP_Material__c=msd.id,CPI_Account__c=a.id,Deletion_Indicator__c='',CPI_Record_Type__c='1',Material_Number__c='091234',Customer_Number__c='12343',Distribution_Channel_Code__c='30',Record_Key__c='11234310003031091234',Sales_Org_Code__c='1000');
     insert cpi;
     Account_Material__c am = new Account_Material__c(Account__c=a.id,SAP_Material__c=msd.id,Created_From_CPI__c=cpi.id);
     insert am;
     
     List<Id> accId = new List<Id>();
     accId.add(a.id);
     accList.add(a);
    
    Test.startTest();
    
    CloudcrazePriceListCreation cplist = new CloudcrazePriceListCreation(accId);
    Id batchId = Database.executeBatch(cplist);
    cplist.execute(null,acclist);
    
    Test.stopTest();
    
    
    }

}