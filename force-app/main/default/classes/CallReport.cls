global class CallReport
{
        
    webservice static String emailCallReport(String[] emailAddress, String id)
    {
        Boolean result;
        
        //Querying the visualforce email template to be used
        EmailTemplate emailTemplate = [Select Id, DeveloperName from EmailTemplate where DeveloperName = 'Call_Report'];
        
        //Setting the single email message object for sending        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(emailAddress);
        mail.setTargetObjectId(UserInfo.getUserId());        
        mail.setTemplateId(emailTemplate.Id);
        mail.setWhatId(id);
        mail.setSaveAsActivity(false);               
                
        //Sending email and getting the results
        Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                                
        result = emailResult[0].isSuccess();
        
        //Checking if email result is success and updating the Call Report Sent field - True
        if(result == True)
        {
            Call_Report__c callRep = [Select Id, Castings_Call_Report_Sent__c from Call_Report__c where Id =: id];
            callRep.Castings_Call_Report_Sent__c = True;
            update callRep;
            return 'Call Report has been emailed successfully.';
        }
        //Else display the error message
        else
        {
            Messaging.SendEmailError[] emailError = emailResult[0].getErrors();
            return emailError[0].getMessage();
        }
           
    }
}