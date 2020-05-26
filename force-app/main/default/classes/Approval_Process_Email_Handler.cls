global class Approval_Process_Email_Handler implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.InboundEnvelope envelope) {
      Approval_Process_Email_Functions.sendnotification(email.plaintextbody, email.subject, email.fromaddress, email.fromName);
      return null;
  }

}