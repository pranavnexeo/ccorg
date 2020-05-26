@isTest
private class Mass_Email_Wizard_Test {

  public static testMethod void test_Mass_Email_Wizard() {
      Test.startTest();
      Mass_Email_Wizard mew = new Mass_Email_Wizard();
      Mass_Email_Wizard.node n = new Mass_Email_Wizard.node();
      n = new Mass_Email_Wizard.node('id', 'name', 'type');
      n = new Mass_Email_Wizard.node('id', 'name', 'type', new Mass_Email_Wizard.state());
      n = new Mass_Email_Wizard.node('id', 'name', 'icon', 'type');
      n = new Mass_Email_Wizard.node('id', 'name', 'icon', 'type', new Mass_Email_Wizard.state(false, false, false));
      
      mass_email_send mes = new mass_email_send();
      EmailTemplate t = [select id from EmailTemplate where isActive = true limit 1];
      ApexPages.currentpage().getparameters().put('tid', t.id);
      mes.c.lastName = UserInfo.getName();
      mes.c.email = UserInfo.getUserEmail();
      mes.send();
     Test.stopTest();
  }
}