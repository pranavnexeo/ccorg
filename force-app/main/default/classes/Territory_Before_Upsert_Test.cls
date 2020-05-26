@isTest
private class Territory_Before_Upsert_Test {

static SAP_Territory__c terr = new SAP_Territory__c();

public static testMethod void testmyterritorydata() {
    SAP_Sales_DOG__c sdog=new SAP_Sales_DOG__c(Name='Test');
    insert sdog;
    SAP_Seller__c ss = new SAP_Seller__c(name = 'test');
    insert ss;
    SAP_Seller__c ss1 = new SAP_Seller__c(name = 'test1');
    insert ss1;
    
    terr=new SAP_Territory__c(Name='myTerr',Description__c='Test',Employee_Ids__c='Test',Marked_for_Deletion__c='N',ZS_Partner__c=ss.id,YS_Partner__c=ss1.id,SAP_Sales_DOG__c = sdog.id);
    insert terr;
}
}