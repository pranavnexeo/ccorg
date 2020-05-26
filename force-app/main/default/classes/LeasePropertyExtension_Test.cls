@isTest
private class LeasePropertyExtension_Test {
    
    static Lease_Property__c leaseProperty;
    //static Keywords__c keyword;
    static LeasePropertyExtension ext;
    
    static void init(){
        
        //String State = 'USA';

        leaseProperty = new Lease_Property__c(State__c = 'Foreign Country-99',county__c='Foreign Country');
        insert leaseProperty;
        /*keyword = new Keywords__c(type__c = 'County',controller__c='state',item__c='county');
        insert keyword; */     
        
        Fee_Property__c fp = new Fee_Property__c(File__c = 'testfile');
        insert fp;
        
        List<County__c> cl = new List<County__c>();
        County__c c = new County__c(Name = '100',State__c = 'US',County__c ='Foreign Country');
        insert c;
        cl.add(c);
        
        apexpages.currentpage().getparameters().put('selectedState', c.id); 
        ApexPages.StandardController con = new ApexPages.StandardController(leaseProperty);
        ext = new LeasePropertyExtension(con);
    
    }
    
     static testMethod void myUnitTest() {
        init();
        ext.getAllCounties();
        ext.getCrossReferenceList();
        ext.getShowFinancials();
        ext.showLeaseFinancial();
        ext.emptyFlag = true;
    } 
    
}