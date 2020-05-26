@IsTest
public class TriggerFDR_Test {
    
    public static testMethod void newFDR() {
        ProjectTrackerTestUtils.initData();
      	Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
		insert newFDR;
    }

    public static testMethod void updateFDR() {
        ProjectTrackerTestUtils.initData();
      	Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
        newFDR.Status__c = 'To Be Reviewed';
		insert newFDR;
        newFDR.Technology__c = 'Salesforce';
        newFDR.Status__c = 'Approved';
        update newFDR;
        newFDR.Status__c = 'To Be Reviewed';
		update newFDR;
        newFDR.Status__c = 'Approved';
        update newFDR;
    }
    
    public static testMethod void deleteFDR() {
        ProjectTrackerTestUtils.initData();
      	Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
        newFDR.Status__c = 'To Be Reviewed';
		insert newFDR;
        newFDR.Technology__c = 'Salesforce';
        newFDR.Status__c = 'Approved';
        update newFDR;
        delete newFDR;
    } 
}