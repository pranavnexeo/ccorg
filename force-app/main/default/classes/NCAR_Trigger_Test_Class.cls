@isTest
private class NCAR_Trigger_Test_Class  {

//******************
//Test Method 
//******************
  static testMethod void TestMe() {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
        //User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
        
        //Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
        //insert acc;
        Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
        insert accplant;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
        insert c;  
        
        SAP_Plant__c spPlant = new SAP_Plant__c();
        spPlant.plant_Code__c = 'W0065';
        insert spPlant;
                    
        Open_Orders__c order = new Open_Orders__c();
        order.Ordered_Qty_in_LB__c = 100;
        order.sales_Order_Number__c = '1234';
        order.key__c = 'NCARTEST';
        order.Line_Item_Number__c = '0010';
        //Updated the query for Removal of G2
        order.plant__c = spPlant.id;
        order.shipTo__c = acc.id;
        order.soldTo__C = acc.id;
        insert order;
              
        Map<String, Schema.RecordTypeInfo> RTMap = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();    
        NCAR_Cases__c cas = new NCAR_Cases__c();
        cas.Account__c = acc.id;
        cas.recordtypeid = RTMap.get('Nexeo Return').getrecordtypeid();
        cas.subject__c = 'test';
        cas.Origin__c = 'SAP';
        cas.Status__c = 'Submitted to Purchasing';
        cas.nexeo_plant__c = acc.id;
        cas.category__c = 'Date Requested Not Met';
        cas.subcategory__c = 'Material not in stock';
        cas.Import_Export__c = 'yes';
        cas.Acknowledgement_Format__c ='Fax';
        cas.subcategory_details__c ='Inventory Discrepancy'; 
        cas.customer_response_required__C = false;  
        cas.Contact__c= c.id;  
        cas.Type__c = 'Nexeo Physical Material Return';
        cas.Nexeo_Plant__c =accplant.id;
        cas.employee__c = u.id;
        cas.Restocking_Fee__c=2345.32;
        cas.Description__c='test';
        cas.Route_To__c = 'Plant';
        cas.Formal_Corrective_Action_Response_Req1__c = 'Yes';
        cas.Acknowledgement_Format__c = 'Print/Mail';
        cas.case_to_clear_DZ__c='No';
        cas.response_format__c = 'Phone';
        cas.actions_taken__c = '';
        cas.carrier__c='Alliance';
        cas.collectible__c = true;
        cas.reason_rejected__c ='Tiers Dispute';
        insert cas; 
        
       NCAR_Cases__c cas1 = new NCAR_Cases__c();
       cas1.id=cas.id;    
       cas1.response_format__c ='E-Mail';
       update cas1;
    

        delete cas1;
    
  }

//The End
}