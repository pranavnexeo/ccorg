/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         12/21/2016
*    Author:              Akansha Gupta
*   Last Modified:        12/21/2016
*   Last Modified By:     Akansha Gupta
*
*  **********************************************************************************************************************/


@istest
public class CheckCallReportOnSupplier_test{
    public static testMethod void testdata(){
    
    //User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
     Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    
    List<Nexeo_Competitor__c> ncl = new List<Nexeo_Competitor__c>();
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Call_Report__c = false,Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
    insert nc; 
    ncl.add(nc);
    
    List<Supplier_Contact__c> scl = new List<Supplier_Contact__c>();
    Supplier_Contact__c sc = new Supplier_Contact__c(Competitor_Supplier_or_OEM__c = nc.id,Call_Report_Contact__c = true);
    insert sc;
    scl.add(sc);
    
    sc.Call_Report_Contact__c = false;
    update sc;
    
    }
    
 
}