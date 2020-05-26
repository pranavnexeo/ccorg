@isTest
Private class PricingMaterialValuesSync_Batch_Test{
//static User TestUser;
static testmethod void testMaterialvaluesnc() {

Material_Sales_Data2__c mat = new Material_Sales_Data2__c(name='abcd',  Material_Number__c='test',Sales_Org_Code__c='test',     Dist_Channel_Code__c='ss', Record_Key__c='test');
insert mat;
Map<Id, User> usersmap = new map<id, user>();
set<String> hstrings = new set<String>();
List<Material_Sales_Data2__c> mt=new List<Material_Sales_Data2__c>();
mt.add(mat);
Database.BatchableContext bc;
PricingMaterialValuesSync_Batch obj=new PricingMaterialValuesSync_Batch();
obj.start(bc);
obj.execute(bc,mt);
obj.finish(bc);
 
}}