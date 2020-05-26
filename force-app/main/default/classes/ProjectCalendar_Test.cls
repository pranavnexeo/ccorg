@isTest
public class ProjectCalendar_Test {

static ART_Project__c prj;
static ProjectCalendar ext;

static void init(){
    	ProjectTrackerTestUtils.initData(); 
        prj = new ART_Project__c(
        Name = 'testProject',
        Resourcing_Start_Date__c = system.today(),
        Resourcing_End_Date__c = system.today().AddDays(36));
        
        insert prj;
        
 }
 
 public static testMethod void myUnitTest() {
    
    init();
    
    ApexPages.StandardController con = new ApexPages.StandardController(prj);
    
    ext = new ProjectCalendar(con);
    }
    
}