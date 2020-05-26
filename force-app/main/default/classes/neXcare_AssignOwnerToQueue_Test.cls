/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        20/09/2016
*    Author:             Akanksha Gupta
*   Last Modified:       20/09/2016
*   Last Modified By:    Akanksha Gupta
***********************************************************************************************************************/   

@isTest(seeAllData=false)

public class neXcare_AssignOwnerToQueue_Test {

    static testMethod void myUnitTest() {
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
    //User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
     //        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
   // insert u;
    Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
    User u = (User) testData.get('testUser1'); 
    
    List<User> ulist = new List<User>();  
    ulist.add(u);
    
    List<Account> accl = new List<Account>();
    
    SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
    insert s; 
    
    Account acc = new Account(name = 'test',ZC_Partner__c = s.id,SAP_Customer_Group_2__c = 'COM',ZH_Partner__c=s.id);
    insert acc;
    Accl.add(acc);
    
     list<GroupMember> QueueLst = [select GroupId, group.name from GroupMember where UserOrGroupId =: u.id];
    
    NexCare__c nx = new NexCare__c(Assigned_User__c = u.id,IsCheckCSR__c = true);
    insert nx;
        
    
   }
    
 }