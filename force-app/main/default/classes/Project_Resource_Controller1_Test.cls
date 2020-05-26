/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest
public class Project_Resource_Controller1_Test {

    static ART_Project__c prj;
    static Project_Resource__c prjRes;
    static Project_Resource__c prjRes1;
    static List<Double> val;
    static Project_Resource_Controller1 ext;
    
    static void init(){
   	 	Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();  
        prj = new ART_Project__c(
        Name = 'testProject',
        Resourcing_Start_Date__c = system.today(),
        Resourcing_End_Date__c = system.today().AddDays(36));
        prj.AFE_Approved__c = 'No';
        insert prj;
        
        prjres = new Project_Resource__c(
        Name = 'testProjectRes',
        Project__c = prj.Id,
        Week_Friday__c = system.today(),
        Resource_Group__c = 'Tech-ABAP',
        Hours__c = 7
        );
        
        insert prjres;  
         
        prjres1 = new Project_Resource__c(
        Name = 'testProjectRes1',
        Project__c = prj.Id,
        Week_Friday__c = system.today(),
        Resource_Group__c = 'Tech-Basis',
        Hours__c = 6
        );  
        
        insert prjres1;   
         
        val = new List<Double>();
        Double a = 1.00;  
        Double b = 11.00;
        val.add(a); 
        val.add(b);  
    }
    
    public static testMethod void myUnitTest() {
    
    init();
      
    
    ApexPages.StandardController con = new ApexPages.StandardController(prj);
    
    ext = new Project_Resource_Controller1(con);

    
    Project_Resource_Controller1.getResources();
    
    
        
    Project_Resource_Controller1.upsertResources(prj.Id,'Tech-Basis',val);
    
    }
    
}