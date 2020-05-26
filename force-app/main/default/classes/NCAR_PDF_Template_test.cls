@isTest
private class NCAR_PDF_Template_test{
    
    static NCAR_Cases__c cas;
    static NCAR_Line_Item__c nitem;
 
    static testMethod void myTest(){
        Test.startTest();  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
      
        Account acc = new Account(Name = 'TestAccount',SAP_Sales_Org__c = '1000', SAP_Street__c = 'Blazer Parkway', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Dublin', SAP_State__c = 'OH',SAP_Zip_Code__c = '90210', SAP_Country__c = 'US',type= 'Customer', CurrencyIsoCode='USD',Full_Address__c= 'New Bazar Parkway,US');
         
        insert acc; 
                
        contact c = new contact(Accountid = acc.id, firstname = 'abc', lastname = 'xyz', phone = '999-999-9999', No_Email__c = True);
        insert c; 
        
        SAP_Plant__c sap = new SAP_Plant__c();
        sap.Plant_Code__c = '0078';
        insert sap;
          Id RecordTypeId = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Credit Debit Claim').getRecordTypeId();             
        Map<String, Schema.RecordTypeInfo> RTMap = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName(); 
        cas = new NCAR_Cases__c();
        cas.Account__c = acc.id;
        cas.Contact__c = c.id;
        cas.RecordTypeId =RecordTypeId;
        cas.subject__c = '';
        cas.Origin__c = 'SAPSAP';
        cas.Status__c = 'NewStatus';
        cas.category__c = 'Category';
        cas.subcategory__c = 'Subcategory';
        cas.subcategory_details__c = 'SubcategoryDetails'; 
        cas.Description__c = 'Description';
        cas.Acknowledgement_Format__c = 'Email';
        cas.customer_response_required__C = true;  
        cas.Customer_Initiated1__c = 'Yes';
        cas.Import_Export__c = 'Yes';
        cas.Problem_Statement_Customer_Facing__c = 'Problem Statement Customer facing';
        cas.Immediate_Action_Customer_Facing__c = 'Immediate Action Customer Facing';
        cas.Root_Cause_Customer_Facing__C = 'Root Cause Customer Facing';
        cas.Action_Taken_Customer_Facing__c = 'Action Taken Customer Facing';
        cas.Email_Comments__c = 'Email Comments';

        insert cas; 
        system.debug('--------cas.Account__c----'+cas.Account__c); 
        system.debug('--------cas.Account__r----'+cas.Account__r);      
        system.debug('--------before full address----'+acc.Full_Address__c);   
        system.debug('--------full address----'+cas.Account__r.Full_Address__c);        
        Open_Orders__c order = new Open_Orders__c();
        order.Ordered_Qty_in_LB__c = 100.00;
        order.Customer_PO_Number__c = '500';
        order.Sales_Order_Number__c = '9876';
        order.key__c = 'NCARTESTT';
        order.Line_Item_Number__c = '0010';
        order.plant__c = [select id from SAP_Plant__c where Plant_Code__c = '0078'limit 1].id;
        order.shipTo__c = acc.id;
        order.soldTo__C = acc.id;
        insert order;
        
        nitem = new NCAR_Line_Item__c();
       
        nitem.NCAR_Cases__c = cas.id;
        nitem.open_orders__c = order.id;
        insert nitem;
        
        apexpages.currentpage().getparameters().put('id', cas.id);  
        ApexPages.standardController sc = new ApexPages.standardcontroller(cas);
        NCAR_PDF_Template nc = new NCAR_PDF_Template(sc);
        nc.mycase=cas;
        
        Test.stopTest();
      
    }
}