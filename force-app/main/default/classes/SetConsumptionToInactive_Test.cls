@isTest
private class SetConsumptionToInactive_Test {

    static testMethod void myUnitTest() {
      Test.startTest();
      try {
          Consumption__c c = [select id, status__c from consumption__c 
                               where status__c != 'Inactive' limit 1];
          system.debug('Status: ' + c.status__c);
          ApexPages.StandardController sc = new apexpages.standardcontroller(c);
          SetConsumptionToInactive inactivate = new SetConsumptionToInactive(sc);
          inactivate.inactivate();
          update c;
          system.debug('Status: ' + c.status__c);
      } catch(Exception e) {}
    }
}