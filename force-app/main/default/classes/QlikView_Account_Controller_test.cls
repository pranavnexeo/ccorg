@isTest
public class QlikView_Account_Controller_test{
     static testMethod void myUnitTest() {
          
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
     User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='saxs2bh77gfdhddc@gorg.com', IsActive = true);
//     insert u;
     test.startTest();
     Account_Region__c ar = new Account_Region__c (name = '1000',Region__c  = '');
     insert ar;       
      
          
      Account acct = new Account(Name = 'test',type = 'Customer',primary_seller__c = u.id,SAP_Sales_Org__c='1000');
      insert acct;
       
             
        
      ApexPages.standardcontroller controller = new ApexPages.standardcontroller(acct);
      QlikView_Account_Controller a = new QlikView_Account_Controller(controller);
     
    
            
     QlikView_Account_Controller.drop_leading_zeros('0000023000');
     test.stopTest();
      
      }
      
      
}