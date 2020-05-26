@isTest
private class Chatter_Create_Link_Post_Test{
    static testMethod void testChatter(){
    try{
        account acc = new account(name = 'test');
        insert acc;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        Chatter_Create_Link_Post cht = new Chatter_Create_Link_Post();
        email.subject = acc.id;
        email.plaintextbody = 'dsfdsfdsfdfdsfsdfsdfsdfdgdfg';
        
        cht.handleInboundEmail(email,env);
        }
        catch (exception e) {
        
        }
        
    }    
}