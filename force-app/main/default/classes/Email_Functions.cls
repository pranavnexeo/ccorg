public class Email_Functions {

    //Sending Emails without a template
    
    public static Boolean sendEmail(List<String> toAddresses, 
                                     List<String> ccAddresses, 
                                     List<String> bccAddresses, 
                                     String replyToAddress,
                                     String senderDisplayName,
                                     Boolean BCCSender,
                                     Boolean IncludeSignature,
                                     String subject,
                                     String body,
                                     String htmlBody)
    {
    Boolean result = true;                         

    try {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        if (toAddresses != null) {if (toAddresses.size() > 0) {mail.setToAddresses(toAddresses);}}
        if (ccAddresses != null) {if (ccAddresses.size() > 0) {mail.setCcAddresses(ccAddresses);}}
        if (bccAddresses != null) {if (bccAddresses.size() > 0) {mail.setBccAddresses(bccAddresses);}}
        if (replyToAddress != null) {mail.setReplyTo(replyToAddress);}
        if (senderDisplayName != null) {mail.setSenderDisplayName(senderDisplayName);}
        if (subject != null) {mail.setSubject(subject);}
        if (BCCSender != null) {mail.setBccSender(BCCSender);}
        if (IncludeSignature != null) {mail.setUseSignature(IncludeSignature);}
        if (body != null) {mail.setPlainTextBody(body);}
        if (htmlBody != null) {mail.setHtmlBody(htmlBody);}

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    catch (Exception e) {result = false;}
      
    return result;
    }

    //Sending Emails with template
        
    public static Boolean sendEmailwithTemplate(Map<String,List<String>> IdToAddresses, List<Id> IdList, String templateName, String replyto)
    {
    Boolean result = true;                         

    try {
        List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
        String userinputtemplatename = 'Template: To Approver (Level1)';
        List<EmailTemplate> template = [select Id, Name, Subject, body, developername from EmailTemplate where developername =:templateName];
        for(EmailTemplate e: template){ system.debug('Template Name is:'+e.developername);
        system.debug('Template Id is:'+e.id);}   
        
        for(Integer i=0;i<IdList.size();i++){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(IdToAddresses.get(IdList[i]));
            
            system.debug('IdToAddresses:'+IdToAddresses.get(IdList[i]));
            system.debug('Template:'+template[0].Id);
            system.debug('IdList:'+IdList[i]);
            
            mail.setTemplateId(template[0].Id);
            List<User> userList = [Select Id from User where email =: IdToAddresses.get(IdList[i])[0]];
            mail.setTargetObjectId(userList[0].Id);
            mail.setwhatId(IdList[i]);
            if(replyto != '')
                mail.setReplyTo(replyto);
            mail.setSaveAsActivity(false);
            theEmails.add(mail);
        }
        Messaging.Email[] allMails = new List<Messaging.Email>();
        for( Integer j = 0; j < theEmails.size(); j++ ){
            allMails.add(theEmails.get(j));
        }
        system.debug('Callinf Send Emial : '+allMails);
        Messaging.sendEmail( allMails );
    }
    catch (Exception e) {result = false;}
      
    return result;
    }
     


    static testMethod void TestMe() {

    List<String> toAddresses = new List<String>();
    toAddresses.add('jhkeener@ashland.com');

    Boolean result = sendEmail(toAddresses,
                               null,
                               null,
                               'jhkeener@ashland.com','Jon Keener',
                               false,false,
                               'Test Class',
                               'This is a test of the Test Class.',null);  
       System.assertEquals(true,result);
                               
                               
        Map<String,List<String>> emailmap=new Map<String,List<String>>();
        emailmap.put('sana',toAddresses);
        List<String> IDtoAddresses = new List<String>();   
        IDtoAddresses.add(userinfo.getuserid());
      
                           
     boolean result1 = sendEmailwithTemplate(emailmap,IDtoAddresses,'testtemplate','test');                         
                               
                                   
                                                       
                                

    }
}