/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NCAR_Queue_Viewer_New_Tests {

    static testMethod void myUnitTest() {
        
        NCAR_Queue_Viewer_New QV = new NCAR_Queue_Viewer_New();
        QV.selectedoption = userinfo.getuserid();
        QV.queuechanged();
        
        QV.sort();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
        //Account a=new Account(name='abc');
        //insert a;
        
        Open_Orders__c Oor=new Open_Orders__c(ShipTo__c=a.id, Key__c='test', Line_Item_Number__c='test',Sales_Order_Number__c='testing');
        insert Oor;
        Test.startTest();
        
        NCAR_Cases__c NC=new NCAR_Cases__c();
        insert NC;
        
        List<NCAR_Line_Item__c> NLI=new List<NCAR_Line_Item__c>();
        NCAR_Line_Item__c cl=new NCAR_Line_Item__c(Open_Orders__c=Oor.id,NCAR_Cases__c=NC.id);
        insert cl;
        
        NCAR_Queue_Viewer_New.Wrapper wrap = new NCAR_Queue_Viewer_New.Wrapper(NC,NLI,'Test');
        
        Test.stopTest();
        
    }
    static testMethod void myUnitTest1() {
      
        NCAR_Queue_Viewer_New QV = new NCAR_Queue_Viewer_New();
        QV.selectedoption = userinfo.getuserid();
        QV.queuechanged();
        
        QV.sort();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
       // Account a=new Account(name='abc');
        //insert a;
        
        Open_Orders__c Oor=new Open_Orders__c(ShipTo__c=a.id, Key__c='test', Line_Item_Number__c='test',Sales_Order_Number__c='testing');
        insert Oor;
        
        Test.startTest();
        
        NCAR_Cases__c NC=new NCAR_Cases__c();
        insert NC;
        
        List<NCAR_Line_Item__c> NLI=new List<NCAR_Line_Item__c>();
        NCAR_Line_Item__c cl=new NCAR_Line_Item__c(Open_Orders__c=Oor.id,NCAR_Cases__c=NC.id);
        insert cl;
        
        NCAR_Queue_Viewer_New.Wrapper2 wrap2 = new NCAR_Queue_Viewer_New.Wrapper2(NC,cl,'Test');
        
        NCAR_Queue_Viewer_New.Wrapper2 wrapp2 = new NCAR_Queue_Viewer_New.Wrapper2(NC,'Test');
        
        Test.stopTest();
    }

}