@isTest
private class Open_Orders_Functions_Test1 {

    static testMethod void myUnitTest() {
    
      Material_General_Data2__c mgd2 = new Material_General_Data2__c(Material_Number__c = '000000000123456789');
      insert mgd2;
      
      Product_Hierarchy2__c PH = new Product_Hierarchy2__c (Product_Hierarchy__c = 'test');
      insert PH;
      
      Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_General_Data__c = mgd2.id,Product_Hierarchy__c = PH.id);        
      insert matlist;
      
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
      //Account a=new Account(name='abc');
      //insert a;
      
      Open_Orders__c Oor=new Open_Orders__c(ShipTo__c=a.id, Key__c='test', Line_Item_Number__c='test',Sales_Order_Number__c='testing',Material__c = matlist.id,Sales_UOM__c = 'test3');
      insert Oor;
      
      Material_UOM2__c MUOM = new Material_UOM2__c (Alternative_UOM__c = 'tst',Material_Number__c = '123456',Record_Key__c = '76543');
      insert MUOM;
            
      }
 }