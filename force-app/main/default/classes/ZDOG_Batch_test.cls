@isTest

public class ZDOG_Batch_test{
    
    public static testMethod void testZDOG_Batch(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        User testUser1 = (User) testData.get('testUser3');
        System.runAs(testUser1) {
            List<Territory2Model> m2 = [select id from Territory2Model where state = 'Active' limit 1];
            if (m2.size() == 0) {
                Territory2Model model = new Territory2Model(   Name = 'TestTerritory2Model',   DeveloperName = 'TestTerritory2Model');
                insert model; 
            }    
                
            List<Territory2Type> ZDOG = [select id from Territory2Type where MasterLabel = 'ZDOG' limit 1];
            if (ZDOG.size() == 0) {
                List<sObject> listTerritoryType = Test.loadData(Territory2Type.sObjectType, 'Territory2TypeZDOG');               
            }
            List<Territory2Type> ZTER = [select id from Territory2Type where MasterLabel = 'ZTER' limit 1];    
            if (ZTER.size() == 0) {
                List<sObject> listTerritoryType = Test.loadData(Territory2Type.sObjectType, 'Territory2TypeZTER');               
            } 
        }
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             User u1 = new User(Alias = 'standt', Email='ooo1@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1@gorg.com', IsActive = false);
             insert u1;
             system.runas(u){
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
             insert s; 
             SAP_Seller__c s1 = new SAP_Seller__c(Name = 'test1', user__c = u1.id);
             insert s1;
             
             list<SAP_Sales_DOG__c> SDogsList = new List<SAP_Sales_DOG__c>();
             SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = s.id, Record_Key__c = 'test1234', YO_Partner__c = s.id,YV_Partner__c = s.id);
             SDogsList.add(ssd);
             SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = s1.id, Record_Key__c = 'test12345', YO_Partner__c = s1.id,YV_Partner__c = s1.id);
             SDogsList.add(ssd1);
             insert SDogsList;
             SAP_Territory__c st = new SAP_Territory__c(name = 'test',Record_Key__c = ssd1.id);
             insert st;
             Territory2Model m = new Territory2Model(Name = 'test123',DeveloperName = 'test123');
             insert m;
             List<Territory2Type> t2t = new List<Territory2Type>();
             t2t = [select id from Territory2Type limit1];
             // Territory2Type t2t = new Territory2Type(DeveloperName = 'test123');
             //insert t2t;
             Territory2 tt = new Territory2(Name = 'test123',DeveloperName = 'test12345',Territory2Model=m,Territory2ModelId = m.id,Parent_Id__c = m.id,Territory2Typeid = t2t[0].id);
             insert tt;
             List<Account> la = new List<Account>();
             Account acc = new Account(name = 'test',YI_Partner__c = st.id,YY_Partner__c = st.id,YZ_Partner__c = st.id);
             la.add(acc);
             insert la;
             ZDOG_Batch zb = new ZDOG_Batch('test',m,t2t[0],t2t[0]);
             ZDOG_Batch zb1 = new ZDOG_Batch(m,t2t[0],t2t[0]);
             zb.execute(null,SDogsList);
             
         } 
    } 
 }