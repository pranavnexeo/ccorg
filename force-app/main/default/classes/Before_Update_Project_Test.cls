/* 
* Description: Test class for the trigger Before_Update_Project
* Date: 06 / 12 / 2018
* Developer: Ignacio Gonzalez
*/
@IsTest
public class Before_Update_Project_Test {
    
    @isTest static void updateProject() {
        
        Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();
        ART_Project__c project = (ART_Project__c) initialData.get('project');
        project.Project_Status__c = '6 - Complete'; 
        Database.SaveResult result = Database.update(project, false);
        //System.assertEquals(result.isSuccess(), false);
        
    }
    
    @isTest static void myTestUpdate2() {
        
        Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();
        ART_Project__c project = (ART_Project__c) initialData.get('project');
        project.Project_Status__c = '4 - Execute'; 
        Database.SaveResult result1 = Database.update(project, false);
        ART_Project__c workstream = new ART_Project__c();
        workstream.Name = 'Test Workstream';
        workstream.AFE_Approved__c = 'Not Required';
        workstream.Project_Status__c = '4 - Execute';
        workstream.Parent_Project__c = project.Id;
        insert workstream;
        
        project.Project_Status__c = '6 - Complete'; 
        Database.SaveResult result2 = Database.update(project, false);
        //System.assertEquals(result.isSuccess(), false);
        
    }    

}