global class Integration_Error_Email_Handler implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.InboundEnvelope envelope) {
    if(email.plaintextbody != null)
     Integration_Error_Functions.insertError(email.subject, email.plaintextbody);
    else if(email.htmlbody != null)
     Integration_Error_Functions.insertError(email.subject, email.htmlbody.striphtmltags());
      return null;
  }

}