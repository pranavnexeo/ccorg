@isTest

public class ZDOG_Users_Batch_test{
    
    public static testMethod void testMe(){
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Basic Access'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             system.runAS(u){
             User u1 = new User(Alias = 'standt', Email='ooo1@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1@gorg.com', IsActive = false);
             insert u1;
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
             insert s; 
             SAP_Seller__c s1 = new SAP_Seller__c(Name = 'test1', user__c = u1.id);
             insert s1;
             list<SAP_Sales_DOG__c> SDogsList = new List<SAP_Sales_DOG__c>();
             SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = s.id, Record_Key__c = '1234', YO_Partner__c = s.id,YV_Partner__c = s.id);
             SDogsList.add(ssd);
             SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = s1.id, Record_Key__c = '12345', YO_Partner__c = s1.id,YV_Partner__c = s1.id);
             SDogsList.add(ssd1);
             insert SDogsList;
             Territory2Model m = new Territory2Model(Name = 'test123',DeveloperName = 'test123');
             insert m;
             
             territory2 t1 = new territory2(name = 'testTerritory1',DeveloperName = 'testTerritory1',Territory2ModelId = m.id,Territory2TypeId= [select id from Territory2Type limit 1].id);
             insert t1;
             Territory2Type tt = [select id from Territory2Type limit 1];
             territory2 t2 = new territory2(name = 'testTerritory2',DeveloperName = 'testTerritory2',parent_id__c = ssd.id,Territory2ModelId = m.id,ParentTerritory2 = t1,Territory2TypeId = tt.id);
             insert t2;
            
             test.startTest();
             ZDOG_Users_Batch ZUB = new ZDOG_Users_Batch(m,'test');
             id idBatch = database.executeBatch(ZUB);
             ZUB.execute(null,SDogsList);
             test.stopTest();
         }  
    }
    
}