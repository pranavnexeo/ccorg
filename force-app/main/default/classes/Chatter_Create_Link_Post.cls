global class Chatter_Create_Link_Post implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.InboundEnvelope envelope) {
      String NL = '\n';
      String CRNL = '\r\n';
      String sub = email.subject.trim();
      
      List<String> sa = email.plaintextbody.split(NL);
      String title = sa.get(0);
              
      If(sa.get(0) == 'Force.com Sandbox'){
        sa.set(0, '');
        sa.set(1, '');
        sub = email.subject.substring(19).trim();
        title = sa.get(2);
      }
                                            
      Chatter_Functions.createLinkPost(sub, title, email.plaintextbody.substring(0, 999));
      return null;
  }

}