@isTest(SeeAllData=false)
public class apexjsoncontrollertest{
    static milestone__c mls,mls1;
    static ART_Project__c prj;
    public static testmethod void Test_Method(){
        Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();
        prj = new ART_Project__c(
        Name = 'testProject',
        Resourcing_Start_Date__c = system.today(),
        Resourcing_End_Date__c = system.today().AddDays(36));
        
        insert prj;
        
        mls = new milestone__c(Name = 'Test',Start__c = system.today(),End__c = system.today().AddDays(26),Project__c = prj.Id);
        insert mls;
        
        
        mls1 = new milestone__c(Name = 'Test1',End__c = system.today().AddDays(16),Project__c = prj.Id);
        insert mls1;
        ApexPages.currentPage().getParameters().put('projectId',prj.id);
        apexjsoncontroller a = new apexjsoncontroller();
        a.projectid = prj.Id;
        apexjsoncontroller.milestone m= new apexjsoncontroller.milestone();
        apexjsoncontroller.project ab = new apexjsoncontroller.project();

        
        
    }
}