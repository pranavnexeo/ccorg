@isTest
private class PriceSupportReqEmailService_Test{
    
    static testMethod void myUnitTest(){
    List<string> fs = new List<string>();
    fs.add('test\n');
    fs.add('test1');
    Messaging.InboundEmail email = new Messaging.InboundEmail() ;
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    Price_Support_Request__c psr = new Price_Support_Request__c(CurrencyIsoCode = 'USD');
    insert psr;
    system.debug('testpsr'+psr.name);
    email.subject = '<'+psr.name+'123';
    
    email.plainTextBody = 'test \n test1';
    PriceSupportReqEmailService psre = new PriceSupportReqEmailService();
    //psre.spliststrings = fs;
    psre.handleInboundEmail(email,env);   
    }
}