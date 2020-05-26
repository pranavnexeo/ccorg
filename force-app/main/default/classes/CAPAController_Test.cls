/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        19/09/2016
*    Author:             Akanksha Gupta
*   Last Modified:       19/09/2016
*   Last Modified By:    Akanksha Gupta
***********************************************************************************************************************/   

@isTest

public class CAPAController_Test {

    static testMethod void myUnitTest() {
    
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
    insert u;
    
    List<User> ulist = new List<User>();
    ulist.add(u);
  System.runAs(u){  
        
    Group testGroup = new Group(Name='test group', Type='Queue');
    insert testGroup; 
    

    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'CAPA__c');
    insert testQueue;
     
     GroupMember gm = new GroupMember (UserOrGroupId = u.id, GroupId =testGroup.id);
        insert gm;


      CAPA__c cp = new CAPA__c(OwnerId = testGroup.Id,Short_Description__c = 'testdata',Assigned_User__c = u.id);
    insert cp;
    
    ApexPages.standardController sc = new ApexPages.standardcontroller(cp);
    CAPAController CC = new CAPAController(sc);
    CC.selecteduser = 'Test';
    CC.displayPopup = false;
    try{
    CC.customSave();
    }
    catch(Exception e){}

   
    }
     
    
   }
    
 }