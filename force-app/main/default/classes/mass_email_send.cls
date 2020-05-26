public class mass_email_send{

public contact c{get; set;}
public boolean displaymessage{get; set;}

public mass_email_send(){
  displaymessage = false;
  c = new contact();
}
public pagereference send(){
  if(apexpages.currentpage().getparameters().containskey('tid')){
      string templateid = apexpages.currentpage().getparameters().get('tid');
      Mass_Email_batch r =new Mass_Email_batch(
         (!URL.getSalesforceBaseUrl().getHost().contains('na49') || Test.isRunningTest()),
         c.email, c.LastName, templateid, 'nexeosalesforce@nexeosolutions.com');
      id idbatch = database.executebatch(r);
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Email sent to NPS Contacts'));
      displaymessage= true;
  }else{
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error ,'No Template Specified'));
     
     
  }
  return null;
}

}