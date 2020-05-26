@isTest
private class hours_of_operation_Test {
  public static testMethod void testmyhours_of_operation() {
  
    SAP_Plant__c p = new SAP_Plant__c(Plant_Code__c = '0000', Plant_Name__c = 'Test');
    insert p;
    
    Plant_Contact__c pc = new Plant_Contact__c(SAP_Plant__c = p.id, First_Name__c = 'Test', Last_Name__c = 'Test');
    insert pc;
    
    List<String> fields = new List<String>{
    'Hours of Operation',
    'Hours of Operation Saturday',
    'Carrier Pickup Hours',
    'Carrier Pickup Hours Saturday',
    'Carrier Delivery Hours',
    'Carrier Delivery Hours Saturday',
    'Plant Delivery Hours',
    'Plant Delivery Hours Saturday',
    'Customer Pickup Hours',
    'Customer Pickup Hours Saturday',
    'Small Package Hours',
    'Small Package Hours Saturday',
    'Next Day Orders',
    'Next Day Orders Saturday'
    };
    hours_of_operation hoo = new hours_of_operation(New ApexPages.standardController(p));
    
    for(string s:fields)
      hours_of_Operation.updateTime(p.id, s, 'EST', 720, 840);
    
    hours_of_operation.updateTimeZone(p.id, 'MST');
  }
}