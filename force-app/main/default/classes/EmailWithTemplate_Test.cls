@isTest
private class EmailWithTemplate_Test {
  public static testMethod void EmailWithTemplate() {
     List<EmailTemplate> templates = [ select id, folderid from emailtemplate limit 1];
     Contact c = new contact(FirstName=UserInfo.getFirstName(),
                             LastName=UserInfo.getLastName(),
                             Email=UserInfo.getUserName());
     insert c;
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
     User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                       TimeZoneSidKey='America/Los_Angeles',UserName='ksbc@gorg.com', IsActive = true);
     insert u;
     //ewt.tid = templates.get(0).id;
     //etw.fid = templates.get(0).folderid;
     //ewt.cid = c.id;
     //ewt.id = c.id;
     //ewt.field = 'email';
     //PageReference pageRef = new ;
     //Test.setCurrentPage(pageRef);
     apexpages.currentpage().getparameters().put('id',c.id);
     //pexpages.currentpage().getparameters().put('id', c.id);
     
     apexpages.currentpage().getparameters().put('field', 'email');
     apexpages.currentpage().getparameters().put('f', 'email');
     apexpages.currentpage().getparameters().put('tid', templates.get(0).id);
     apexpages.currentpage().getparameters().put('cid', c.id);
     apexpages.currentpage().getparameters().put('fid', templates.get(0).folderid);
     EmailWithTemplate ewt = new EmailWithTemplate(New ApexPages.standardcontroller(c));
     ewt.newtext = UserInfo.getUserEmail();
     
     ewt.ccstring = UserInfo.getUserEmail();
     
     ewt.bccstring= UserInfo.getUserEmail();
     ewt.save();
     ewt.sendEmail();
     ewt.complete();
     ewt.geturl();
     ewt.templatechanged();
     ewt.getrenderPreview();
     ewt.updaterecord();
     ewt.cancel();
     ewt.getpdfpage();
     ewt.showtemplateerror();
     
  }
}