@isTest
private class ProjectTrigger_Test {

  public static testMethod void test_ProjectTrigger() {
    Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();  
    ART_Project__c proj = new ART_Project__c(name='Test Proj', Project_Status__c = 'test1');
    proj.AFE_Approved__c = 'Yes';  
    insert Proj;
    proj.Project_Status__c = 'test2';
    update Proj;
         
  }
     }