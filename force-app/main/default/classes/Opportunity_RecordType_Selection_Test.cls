@isTest
private class Opportunity_RecordType_Selection_Test {
    public static testMethod void Opportunity_RecordType_Selection() {
        
        Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
         Account acc= (Account) testData.get('testGeneralAccount');
        //account acc = new account(name = 'test1234');
       // insert acc;
        contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
        insert cnt;
       // Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
       // insert nc;
        Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
        
        opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = cnt.id,CloseDate = system.today(),StageName = 'Concept');
        insert op;
        
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(op);
        Opportunity_RecordType_Selection CR = new Opportunity_RecordType_Selection(sc);
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        string temp = RTMap.get('Distribution Plastics').getrecordtypeid();
        Opportunity_RecordType_Selection.getURL(temp,'12345','34567','test','test','test','test');
        CR.rtype = 'test';
  
  }
     public static testMethod void Opportunity_RecordType_Selection1() {
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        string temp = RTMap.get('Distribution Targets').getrecordtypeid();
        Opportunity_RecordType_Selection.getURL(temp,'12345','34567','test','test','test','test');   
  }
  public static testMethod void Opportunity_RecordType_Selection2() {
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        string temp = RTMap.get('Distribution Environmental Services').getrecordtypeid();
        Opportunity_RecordType_Selection.getURL(temp,'12345','34567','test','test','test','test');   
  }
  }