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
private class GenerateReleaseFromRequests_Test {

static testMethod void myUnitTest() {
        Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();
        Date nextrelease = system.today();
        ART_Project__c proj = new ART_Project__c(name='Test Proj');
        insert Proj;
        ART_Request__c Req1 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        ART_Request__c Req2 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        ART_Request__c Req3 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        ART_Request__c Req4 = new ART_Request__c(name='Test Req', project__c = proj.id, Target_Date_for_Release__c = nextrelease, Planning_to_Test_in_Sandbox__c = true, Planning_to_Build_in_Sanfbox__c = true, request_date__c = system.today(), status__c = 'Approved for Release');
        List<Art_Request__c> reqs = new list<ART_Request__c>();
        reqs.add(req1);
        reqs.add(req2);
        reqs.add(req3);
        reqs.add(req4);
        insert reqs;
        Apexpages.standardcontroller stdcon = new ApexPages.standardcontroller(req1);
        GenerateReleaseFromRequests GR = new GenerateReleaseFromRequests(stdcon);
        GR.SelectedStatus = 'Approved for Release';
        GR.statuschanged();
        GR.sortresults();
        GR.approverequests();
        GR.rejectrequests();
        GR.myapprovalschanged();
        for(GenerateReleaseFromRequests.Request r:GR.requests){
          r.isselected = true;
        }
        
        GR.createrelease();
        ART_Release__c r = new ART_Release__c(name='Test Release');
        insert r;
        



}
}