/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        16/08/2016
*    Author:             Akanksha Gupta
*   Last Modified:        16/08/2016
*   Last Modified By:    Akanksha Gupta
***********************************************************************************************************************/   

@isTest

public class CAPAwrapperClassController_Test {

    static testMethod void myUnitTest() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
    //User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
           
    //Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    //insert acc;
       
    Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
    insert accplant;
       
    contact c = new contact(Accountid = a.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
    insert c;
    
    List<NCAR_Cases__c> NC = new List<NCAR_Cases__c>();
    NCAR_Cases__c cas = new NCAR_Cases__c();
        cas.Account__c = a.id;
        cas.subject__c = 'test';
        cas.Origin__c = 'SAP';
        cas.Status__c = 'Submitted to Purchasing';
        cas.nexeo_plant__c = a.id;
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
        NC.add(cas);
     insert NC;
     
     CAPA__c cp = new CAPA__c(Short_Description__c = 'testdata');
     insert cp;
     
     ApexPages.standardController sc = new ApexPages.standardcontroller(cp);
     CAPAwrapperClassController CCNC = new CAPAwrapperClassController(sc);
     CCNC.getNcars();
     CCNC.processSelected();
    }
}