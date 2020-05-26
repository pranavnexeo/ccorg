@isTest
public class CdfDetailviewMsgController_Test {
    
    public static testMethod void CdfDetailviewMsgControllerTest() {
        List<Contract> cotlist = new List<Contract>();
        
        String plant = '0004';
        String matnum = '000000000123456789';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
        
              
        Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
        insert a;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;     
       
        SAP_Purchasing_Group__c spg = new SAP_Purchasing_Group__c (Purchasing_Group_Code__c = '123', Name = 'test', User__c = u.id);
        insert spg;
        
        Material_Plant2__c mp2 = new Material_Plant2__c(Record_Key__c = matnum+plant, Material_Number__c = matnum,Planned_Delivery_Time__c= '3', Plant_Code__c = plant, SalesOrg_Code__c = '1000', SAP_Purchasing_Analyst__c = spg.id);
        system.debug('mp2: ' + mp2);
        insert mp2;
        
        Material_Sales_Data2__c mm = new Material_Sales_Data2__c(Name = 'test material', Material_Number__c = matnum, Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1000',Record_Key__c = '123456789012345');
        system.debug('mm:' +mm);
        insert mm;
        
        Contract cot = new Contract(StartDate = system.today().addDays(2), status = 'Draft', Buyer_Comments__c = 'New contract creation',OwnerExpirationNotice = '120',AccountId = a.id, OwnerId = u.id,Forecasted_Quantity__c = 1234.123,Per__c = 'Month', Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', Stocking_Warehouse__c = '0004 - Edmonton', SAP_Material__c = mm.id  );
        cotlist.add(cot);
        insert cotlist;
  
        test.startTest();
        
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(cot);
        CdfDetailviewMsgController cc = new CdfDetailviewMsgController(sc);
        
        test.stopTest();
    }    
}