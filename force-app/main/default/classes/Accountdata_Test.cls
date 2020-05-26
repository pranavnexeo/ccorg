@isTest
private class Accountdata_Test {

static User TestUser;
static Approval_Process_Email_Notification__C emailnotification;

  public static testMethod void testmyaccountdata() {
  
            Account account = new Account(Name = 'TestAccount',type= 'Customer',SAP_city__c='Test',SAP_State__c='MH',recordtypeid='012E0000000LBWH',ownerid='005E0000002CTAo' );
            Accountdata controller=new Accountdata('account.ownerid','test','account.id','test');
            Accountdata.row controller1=new Accountdata.row('account.id','Test', '12345', '12345', '12345', 'India', 'MP','account.ownerid');
            //accountdata controller1=new row();
            Approval_Process_Email_Functions.sendhtmlnotification('Hi','Hello','ksherron@nexeosolutions.com','WMSDaniel Black');
            //Approval_Process_Email_Functions.sendplaintextnotification('Hi','Hello','ksherron@nexeosolutions.com','WMSDaniel Black');
           
             }
     }