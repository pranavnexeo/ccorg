/* 
* Description: Handler class for Trigger EventManagerAlert on Event
* Date: 10 / 08 / 2018
* Developer: Ignacio Gonzalez
*/
@IsTest
public class EventManagerAlert_Test { 
    
   static Map<String, Object> data;
    
   static {
       data = new Map<String, Object>();
       Profile profile = [select id from profile where name='System Administrator'];
       
       User user1 = new User(alias = 'standt', email='standarduser1@testorgnexeo.com', 
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='standarduser1@testorgnexeo.com',SAP_Cust_Num__c='0000011111');
       insert user1;
       
       User user2 = new User(alias = 'standt', email='standarduser2@testorgnexeo.com', 
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User1', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='standarduser2@testorgnexeo.com',SAP_Cust_Num__c='0000011111');
       insert user2;
       
       User user3 = new User(alias = 'standt', email='standarduser3@testorgnexeo.com', managerId = user2.Id,
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User2', languagelocalekey='en_US', backup__c = user1.Id,
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='standarduser3@testorgnexeo.com',SAP_Cust_Num__c='0000011111');
       insert user3;  
      
       Account accountTest = new Account(Name = 'Test Account', OwnerId = user3.Id);
       insert accountTest;
       
       Event newNexeoSalesCall = new Event();
       newNexeoSalesCall.Subject = 'Test Event';
       newNexeoSalesCall.Type = 'Technical';
       newNexeoSalesCall.StartDateTime = DateTime.now();
       newNexeoSalesCall.EndDateTime = DateTime.now();
       newNexeoSalesCall.WhatId = accountTest.Id;
       newNexeoSalesCall.Manager_Alert__c = 'Yes';
       insert newNexeoSalesCall;
       
       data.put('newNexeoSalesCall', newNexeoSalesCall);       
   
   }  
    
   public static testMethod void newSalesNexeoCall() {
      Event newNexeoSalesCall = (Event) data.get('newNexeoSalesCall');
      newNexeoSalesCall = [SELECT Id, Type__c, Type FROM Event WHERE Id =: newNexeoSalesCall.Id];
      System.assert(newNexeoSalesCall.Type__c == newNexeoSalesCall.Type); 
   }
    
   public static testMethod void updateSalesNexeoCall() {
      Event newNexeoSalesCall = (Event) data.get('newNexeoSalesCall');
      newNexeoSalesCall.Type = 'Conference Call';
      update newNexeoSalesCall;
      newNexeoSalesCall = [SELECT Id, Type__c, Type FROM Event WHERE Id =: newNexeoSalesCall.Id];
      System.assert(newNexeoSalesCall.Type__c == newNexeoSalesCall.Type);   
   } 

}