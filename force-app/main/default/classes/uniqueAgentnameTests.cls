public class uniqueAgentnameTests{
    static testMethod void testAgentnameDupPreventer() {
         
        //Adding code to prevent have hardcoded IDs
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        User u1 = (User) testData.get('testUser1');
        User u2 = (User) testData.get('testUser2');
        
        List<FAA_Request__c> FAAToInsert = new List<FAA_Request__c>();
        
        FAA_Request__c faa=new FAA_Request__c();
	    faa.Request_Status__c='Pending';
	    faa.Agent_Name__c= u1.Id;
	    faa.Delegator_Name__c=u2.Id;
	    FAAToInsert.add(faa);
	    
	    FAA_Request__c faa1=new FAA_Request__c();
        faa1.Request_Status__c='Pending';
        faa1.Agent_Name__c=u1.Id;
        faa1.Delegator_Name__c=u2.Id;
        FAAToInsert.add(faa1);
        try { 
        	insert FAAToInsert;
        } catch (Exception e) {
            System.debug('it fails that means the validation works');
        }
        
        insert faa;
        
        try { 
        	insert faa1;
         } catch (Exception e) {
            System.debug('it fails that means the validation works');
        }
        
   }
   
}