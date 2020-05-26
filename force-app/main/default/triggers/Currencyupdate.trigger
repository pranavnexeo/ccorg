trigger Currencyupdate on Pay_Term_Request__c(before Insert) {
for (Pay_Term_Request__c a : Trigger.new) {
//List<Pay_Term_Request__c> lstLead = [Select 1.CurrencyIsoCode, 1.Business_Unit__c,Sales_Org__c From Pay_Term_Request__c l limit 1];
if(a.Sales_Org__c == '1700')
{
a.CurrencyIsoCode='CAD';
}
else
{
a.CurrencyIsoCode='USD';
}
}
}