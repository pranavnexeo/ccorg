@istest
public  Class AvoidCustomerDeletion_Test {
    
    static testMethod void avoidCustomerDelete(){
    
       /* Account acc = new Account();
        acc.name = 'Test Account';
        acc.Type = 'Customer';
        insert acc; */
        
        Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
        Account acc= (Account) testData.get('testGeneralAccount');
        
        Delete acc;
       
        Test.startTest();
   }
}