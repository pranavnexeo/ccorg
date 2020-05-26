global class Chatter_Add_Follower_Email_Handler implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.InboundEnvelope envelope) {
      String NL = '\n';
      String CRNL = '\r\n';
      
      List<String> sa = email.plaintextbody.split(NL);
              
      If(sa.get(0) == 'Force.com Sandbox'){
        sa.set(0, '');
        sa.set(1, '');
      }
                                            
      Chatter_Functions.addfollow(email.subject.trim(), sa);
      return null;
  }

}