trigger updateemployee on Category_Master__c (After insert) {
   for(Category_Master__c a : Trigger.new){
       
       
       List<Category_Master__c> checkDuplicate = [select id from Category_Master__c where CategoryDesc__c = :a.CategoryDesc__c and  EmpId__c =:a.EmpId__c and JointUserID__c =:a.JointUserID__c and Id != :a.Id]; 
        if(checkDuplicate.size() > 0){
            a.adderror('Record for combination of this Employee Id, Category and Joint User already exists. Please update the same record for any changes.');
       }
       
       list<User> UserData=[select id from User where EmployeeNumber = :a.EmpId__c or Ashland_Employee_Number__c = :a.EmpId__c];
       if (UserData.size()>0){
           
           List<Category_Master__c> cms = [select id, Employee__c,CategoryDesc__c from Category_Master__c where id =:a.Id]; 
           if(cms.size()>0){
              cms[0].Employee__c = UserData[0].id; 
              update cms;
          }
       }
   }
}