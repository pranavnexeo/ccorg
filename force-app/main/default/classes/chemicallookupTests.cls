@istest
public class chemicallookupTests{
    static testMethod void testowneridchemicalupdate() {
       Map<String, SObject> testData = NexeoTestUtils_Test.initData();
       User u = (User) testData.get('testUser1');
       Sample_Analysis_Request__c  sampleRequest = new Sample_Analysis_Request__c();
       sampleRequest.Requested_by__c = u.Id;
       insert sampleRequest;
       Competitive_Analysis_Report__c car=new Competitive_Analysis_Report__c();
      car.Date__c=Date.Today();
      
      car.Lab_Number__c=sampleRequest.Id;
     
     car.Analysis__c='Test';
     car.Comment__c='test';
     car.Ownerid=u.Id;
      insert car;
      update car;
      
     /* Certificate_Of_Analysis__c cofa1=new Certificate_Of_Analysis__c();
        cofa1.Batch__c='MC02BEE05';
        cofa1.Material__c='a0eE0000000Uhb8';
        cofa1.Supplier_Name__c='001E000000BtKEj';
        insert cofa1;*/
        
   }
  
}