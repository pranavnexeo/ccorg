@isTest
public class FAACurrentLimitTest {
    static testMethod void testCurrentLimit() {

  		//Adding code to prevent have hardcoded IDs
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
        User u = (User) testData.get('testUser1');
        
        FAA_Request__c faa=new FAA_Request__c();
        faa.Request_Status__c='Pending';
        faa.Agent_Name__c = u.Id;
        faa.Delegator_Name__c = u.Id;
        insert faa;
        system.debug('FAA Id is : '+faa.id);
        
        /*
        List <FAA_Request__c> faalist=[select id from FAA_Request__c ];
        system.debug('size is : '+faalist.size());
        */
        Category_Master__c CategoryMaster=new Category_Master__c (CategoryDesc__c = 'Payroll',
        EmpId__c = u.Ashland_Employee_Number__c,EmpName__c='Bradley' ,Limit__c=190); 
        insert CategoryMaster;
        system.debug('CategoryMaster Id is : '+CategoryMaster.id);
        
        Category_Limit__c CategoryLimit=new Category_Limit__c (Category__c = 'Payroll',
        Desired_US_Dollar_Limit__c=140.00,Current_US_Dollar_Limit__c=120.00,FAA_Request__c=faa.Id); 
        insert CategoryLimit;
        system.debug('CategoryLimit Id is : '+CategoryLimit.id);
        
        
     /*   Category_Limit__c[] clist=[select id,Category__c ,Desired_US_Dollar_Limit__c,Current_US_Dollar_Limit__c,
        FAA_Request__c from Category_Limit__c where id=:CategoryLimit.id];
        clist[0].Desired_US_Dollar_Limit__c=140.00;
       */ 
        
        faa.Request_Status__c='Approved';
        update faa;
        
    }
        
}