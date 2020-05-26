@isTest

public class ZTERR_Users_Batch_test{
    
    public static testMethod void testMe(){
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
    insert u;
    
    User u1 = new User(Alias = 'standt', Email='ooo1@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1@gorg.com', IsActive = false);
    insert u1;
    
    system.runas(u){
    
    SAP_Seller__c ss = new SAP_Seller__c(Name = 'test', user__c = u.id);
    insert ss;
    
    SAP_Seller__c ss1 = new SAP_Seller__c(Name = 'test1', user__c = u1.id);
    insert ss1;
    
    SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = ss.id, Record_Key__c = '1234', YO_Partner__c = ss.id,YV_Partner__c = ss.id);
    insert ssd;
    
    SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = ss1.id, Record_Key__c = '1234', YO_Partner__c = ss1.id,YV_Partner__c = ss1.id);
    insert ssd1;
    
    list<SAP_Territory__c> STList = new List<SAP_Territory__c>();
    SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
    STList.add(ST);
    
    SAP_Territory__c ST1 = new SAP_Territory__c(Name = 'test1', ZS_Partner__c = ss1.id, YS_Partner__c = ss1.id,SAP_Sales_DOG__c = ssd1.id);
    STList.add(ST1);
    insert STList;
    
    Territory2Model m = new Territory2Model(Name = 'test123',DeveloperName = 'test123');
    insert m;
    
    territory2 t1 = new territory2(name = 'testT1',DeveloperName = 'testterritory111',Territory2ModelId = m.id,Territory2TypeId= [select id from Territory2Type limit 1].id);
    insert t1;
             
    Territory2Type tt = [select id from Territory2Type limit 1];
    territory2 t2 = new territory2(name = 'testT2',DeveloperName = 'testterritory222',Territory2ModelId = m.id,ParentTerritory2 = t1,Territory2TypeId = tt.id);
    insert t2;
    
    UserTerritory2Association uta = new UserTerritory2Association(User = u1,Territory2Id = t2.id,RoleInTerritory2='');
    try{
    insert uta;
    }
    catch(exception e){}
    
    string test1;
    Test.startTest();
       
    ZTERR_Users_Batch ztb = new ZTERR_Users_Batch (m,'test1');
    ID idBatch = Database.executeBatch(ztb);
    ztb.execute(null,STList); 
    Test.stoptest();
    
      }
    
    }
    
 }