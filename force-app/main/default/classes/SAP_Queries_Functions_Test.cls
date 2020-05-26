@isTest
public class SAP_Queries_Functions_Test {

public static testMethod void testmysap() {

Account a = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
insert a;

SAP_Queries_Functions sqf = new SAP_Queries_Functions();

SAP_Queries_Functions.isAHWT_China(a);
SAP_Queries_Functions.isChinaSalesOrg(a);
SAP_Queries_Functions.getPaymentTermExplanations();
SAP_Queries_Functions.getPaymentTermExplanations(a.id);


}
}