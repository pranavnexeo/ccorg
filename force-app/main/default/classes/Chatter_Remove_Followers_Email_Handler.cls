global class Chatter_Remove_Followers_Email_Handler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.InboundEnvelope envelope) {
                                     
      Chatter_Functions.removeallfollows(email.subject.trim());
      return null;
  }

}