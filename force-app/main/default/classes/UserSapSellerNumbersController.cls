public with sharing class UserSapSellerNumbersController {

    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');

    public PageReference updateUserSellerNumbers() {
        Id processId;
        UserSapSellerNumbersBatchable b = new UserSapSellerNumbersBatchable();
        try {
            processId = Database.executeBatch(b);
            return ajpr;
        } catch(DmlException de) {
            System.debug(de.getMessage());
        }
        return null;
    }
    
    static testMethod void test01() {
    	Test.startTest();
    	UserSapSellerNumbersController c = new UserSapSellerNumbersController();
    	c.updateUserSellerNumbers();
    }
}