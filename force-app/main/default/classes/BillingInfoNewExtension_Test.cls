@isTest
private class BillingInfoNewExtension_Test {

static testMethod void myUnitTest() {     
Billto_Cost_Center_Code__c b=new Billto_Cost_Center_Code__c(New_Bill_Code__c='test',Active_Billto_Code__c='Y',Bill_Code_Description__c='test',Report_Grouping_Code_Description_new__c='01-Corporate',Company_Code__c='494',Business_Area__c='Florida',Actual_Cost_Center_Code__c='00302675',Actual_Cost_Center_Code_Description__c='Recharge to LRD');
insert b;
Billto_Cost_Center_Code__c abc = [select Id,Name from Billto_Cost_Center_Code__c where Id =: b.Id];


ApexPages.currentPage().getParameters().put('PriceReqDtl',abc.Name);
BillingInfoNewExtension n=new BillingInfoNewExtension(new ApexPages.StandardController(b));
n.getRecDetails();
}
}