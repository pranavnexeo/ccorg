@isTest(seeAllData=false)
public class FAAsettingCurrentLimitTest {

    static testMethod void TestMe() {
        Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        List<User> userList = [SELECT Id,Ashland_Employee_Number__c From User Where Ashland_Employee_Number__c = 'C754385' ];
        User u;
        if (userList.isEmpty()) {
            u = new User(Alias = 'sta2d34', Email='standard324user@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testfsdafing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standar324532duser@testorg.com',Ashland_Employee_Number__c='C754385');
        insert u;
        } else {
            u = userList.get(0);
        }
         
         FAA_Request__c objReq = new FAA_Request__c(Request_Status__c ='Pending',Delegator_Name__c =u.id);
        insert objReq;
        
        FAA_Request__c objReq1 = [select id,Delegator_Emp_Number__c from FAA_Request__c where id=:objReq.id];
        Category_Master__c objCM = new Category_Master__c(EmpId__c =objReq1.Delegator_Emp_Number__c,CategoryDesc__c ='029 - Taxes',Limit__c=500);
        insert objCM;
        Category_Limit__c objCL = new Category_Limit__c(FAA_Request__c  = objReq.id,Desired_US_Dollar_Limit__c  =120,category__c='029 - Taxes');
        insert objCL;
        objReq.Request_Status__c ='Approved';
        update objReq;
        
     }
}