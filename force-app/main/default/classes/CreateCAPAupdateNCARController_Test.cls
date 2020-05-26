/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        16/08/2016
*    Author:             Akanksha Gupta
*   Last Modified:        04/01/2017
*   Last Modified By:    Akanksha Gupta
***********************************************************************************************************************/   

@isTest(seeAllData=false)

public class CreateCAPAupdateNCARController_Test { 

    static testMethod void myUnitTest() {
    
    User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1 = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u1;       
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
       
    Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
    insert accplant;
       
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
    insert c;
    
    CAPA__c cp = new CAPA__c(Short_Description__c = 'testdata', Tier_1__c = 'Documents', Tier_2__c='C of C, requested not processed');
    insert cp;
    
    List <NCAR_Cases__c> ncl = new List <NCAR_Cases__c>();
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
        cas.CAPA__c = cp.id;
     insert cas;
     ncl.add(cas);
     
     apexpages.currentpage().getparameters().put('ncarid', cp.id);
     
     ApexPages.standardController sc = new ApexPages.standardcontroller(cp);
     CreateCAPAupdateNCARController CCNC = new CreateCAPAupdateNCARController(sc);
     CCNC.customsave();
     CCNC.ncar = cas;
     
    }
    
        static testMethod void myUnitTest2() {
    
    User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1 = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u1;       
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
       
    Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
    insert accplant;
       
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
    insert c;
    
    CAPA__c cp = new CAPA__c(Short_Description__c = 'testdata', Tier_1__c = 'Documents', Tier_2__c='C of C, requested not processed');
    insert cp;
    
    List <NCAR_Cases__c> ncl = new List <NCAR_Cases__c>();
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
        cas.CAPA__c = cp.id;
     insert cas;
     ncl.add(cas);
     
       /* Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(cas.Id);

        Approval.ProcessResult result = Approval.process(req);
        System.assert(result.isSuccess()); */
     
     
   //  User u = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

    System.runAs(u) {
    Approval.ProcessSubmitRequest r = new Approval.ProcessSubmitRequest();

    r.setObjectId(cas.Id);

    Approval.process(r);
        }
        
     apexpages.currentpage().getparameters().put('ncarid', cp.id);
     
     ApexPages.standardController sc = new ApexPages.standardcontroller(cp);
     CreateCAPAupdateNCARController CCNC = new CreateCAPAupdateNCARController(sc);
     CCNC.customsave();
     
    }
}