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

public class StatusChange_Test {

    static testMethod void myUnitTest() {
    
    Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
    User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
           
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
       
    Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
    insert accplant;
       
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
    insert c;
    
    List<NCAR_Cases__c> NC = new List<NCAR_Cases__c>();
    NCAR_Cases__c cas = new NCAR_Cases__c();
        cas.Account__c = acc.id;
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
        NC.add(cas);
     insert NC;
     
     CAPA__c cp = new CAPA__c(Short_Description__c = 'testdata');
     insert cp;
        try {
        cp.Status__c = 'Closed';
        update cp;
        } catch(Exception ex){}
     
    }
}