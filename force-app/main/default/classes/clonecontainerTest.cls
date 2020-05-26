@isTest
private class clonecontainerTest
{
public static testMethod void unitTestinsert_Contact_Activity4Task()
{
Container_Specification_Document__c j=new Container_Specification_Document__c(Status__c='Approved',Package_Specification_Number__c='12345',Short_Description__c='Nothing',SAP_Container_Code__c='13456',Issue_Date__c=DateTime.parse('10/14/2011 11:46 AM'));
insert j;
Container_Specification_Document__c j2=new Container_Specification_Document__c(Status__c='Approved',Package_Specification_Number__c='12345',Short_Description__c='Nothing',SAP_Container_Code__c='13456',Issue_Date__c=DateTime.parse('10/14/2011 11:46 AM'),Master_Id__c=j.id);
insert j2;
update j2;
}
}