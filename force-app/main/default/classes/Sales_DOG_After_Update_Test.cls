@isTest
private class Sales_DOG_After_Update_Test {

static SAP_Sales_DOG__c sdog = new SAP_Sales_DOG__c();
static SAP_Territory__c terr = new SAP_Territory__c();

public static testMethod void testmySalesDog() {
    
    sdog=new SAP_Sales_DOG__c(Name='Test');
    insert sdog;
    
    sdog.name = 'test1';
    update sdog;
    terr=new SAP_Territory__c(Name='myTerr',Description__c='Test',Employee_Ids__c='Test',SAP_Sales_DOG__c=sdog.id,Marked_for_Deletion__c='N');
    insert terr;
    
    terr.Description__c='Test1';
    update terr;
    //List<SAP_Territory__c> terrs = [select id from SAP_Territory__c where SAP_Sales_DOG__c =:sdog.id];
    //if(terrs.size() > 0)
    //update terrs;
    
   
    
    
}
}