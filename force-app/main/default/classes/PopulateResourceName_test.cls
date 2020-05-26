/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        3/1/2017
*    Author:             Shwetha Suvarna
*   Last Modified:       Shwetha Suvarna
*   Last Modified By:    3/1/2017
*
*   Short Description:  test class for Update resource names on Enhancement .
*   **********************************************************************************************************************/

@isTest
Public class PopulateResourceName_test{
    public static TestMethod void testMe(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
          insert u;
          
          Enhancement__c enh = new Enhancement__c(Name = 'test1',Project_Status__c = 'Open');
          insert enh;
          
          Enhancement_Resource__c enhRes = new Enhancement_Resource__c(Assigned_To__c=u.id,Enhancement__c=enh.id);
          insert enhRes;
          
          delete enhRes;
    }
    public static TestMethod void testMe1(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
          insert u;
          User u1 = new User(Alias = 'standt', Email='ooo@tetorg.com',EmailEncodingKey='UTF-8', LastName='Testng1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhc@gorg.com', IsActive = true);
          insert u1;
          User u2 = new User(Alias = 'standt2', Email='oofo@testorg.com',EmailEncodingKey='UTF-8', LastName='Tsting1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@ggorg.com', IsActive = true);
          insert u2;
          
          Enhancement__c enh = new Enhancement__c(Name = 'test1',Project_Status__c = 'Open');
          insert enh;
          
          Enhancement_Resource__c enhRes = new Enhancement_Resource__c(Assigned_To__c=u.id,Enhancement__c=enh.id);
          insert enhRes;
          
          Enhancement_Resource__c enhRes1 = new Enhancement_Resource__c(Assigned_To__c=u1.id,Enhancement__c=enh.id);
          insert enhRes1;
          
          Enhancement_Resource__c enhRes2 = new Enhancement_Resource__c(Assigned_To__c=u2.id,Enhancement__c=enh.id);
          insert enhRes2;
          
          delete enhRes;
    }
}