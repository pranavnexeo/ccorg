@isTest
private class AccountCalendar_Test {

static User TestUser;
static Approval_Process_Email_Notification__C emailnotification;

  public static testMethod void testmyAccountCalendar() {
  
  
             
            Account account = new Account(Name = 'TestAccount',type= 'Customer',SAP_city__c='Test',SAP_State__c='MH',recordtypeid='012E0000000LBWH',ownerid='005E0000002CTAo' );
            Opportunity opp= new Opportunity (name='test1',closedate =system.today(),StageName='new');
            
             insert opp;
            //Open_Orders__c openorder= new Open_Orders__c (id='a2FE00000004CPL',name='test2',Sales_Order_number__c='0003980459',Expected_Ship_Date2__c=system.today());
            
            AccountCalendar controller=new AccountCalendar(new apexpages.standardcontroller(account));
            
             }
     }