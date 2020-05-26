/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Calendar_Test{

    static testMethod void myUnitTest() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a; 
      // Account a = new account();
      //  a.name = 'Test';
      //  insert a;
        Opportunity o = new Opportunity();
        o.closedate = system.today();
        o.name = 'Test';
        o.accountid = a.id;
        o.stagename = 'Open';
        insert o;
        CalEventItem c = new CalEventItem(o, 'CloseDate', 'Name', 'Opportunity');
        CalMonth.Week cmw = new CalMonth.Week();
        List<CalEventItem> items = new List<CalEventItem>();
        List<CalMonth.Week> Witems = new List<CalMonth.Week>();
       // String mo = 'abcdaaaaaa';
         PageReference pageRef = Page.AccountCalendar;
         //Page.getweeks().put('id',a.id);
        Test.setCurrentpage(pageRef);
        //cal.editoptions;
        //for (Integer mi=0 ; mi<=12 ; mi++ )
        //System.debug('mi: ' + mi);
        items.add(c);
        Calendar cal = new Calendar(items);
        CalendarComponent cc = new CalendarComponent();
       // CalMonth cm = new CalMonth();
        cc.setsobj(items);
        cc.showmore();
        cc.showless();
        cc.showoptions();
        cc.saveoptions();
       // cc.saveevent();
       // cc.showevent();
        cc.hideevent();
        cal.getstartdate();
        cal.getenddate();
       // cmw.addMonth(Witems);
        cal.getWeeks();
        cal.getMonth();
       
        

        
        

                      
    }
}