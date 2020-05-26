/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        09/23/2016
*   Author:              Sneha Likhar
*   Last Modified:       10/14/2016
*   Last Modified By:    Akansha Gupta
*
* **********************************************************************************************************************/

@isTest(seeAllData=false)
private class ccProductUpsert_Nexeo_Test {
    
    public static testMethod void testMe() {
        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String sorg1 = '123';
        String dchan = '12';
        
        List<ccrz__E_Product__c> ccpl = new List<ccrz__E_Product__c>();
        ccrz__E_Product__c ccp = new ccrz__E_Product__c(NexeoMaterialId__c = 'test12',Nexeo3D__c=true,ccrz__SKU__c=matnum + sorg + dchan,DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC');
        ccpl.add(ccp);
        ccrz__E_Product__c ccp1 = new ccrz__E_Product__c(NexeoMaterialId__c = 'test12',ccrz__SKU__c=matnum + sorg1 + dchan,DivisionCode__c='31',ccrz__TaxRateId__c = 'test',Supplier__c='test',Segment__c='test',Diameter__c='1.75 mm',Sub_Category__c='Sample',Color__c='Black',Weight__c='500gr',ccrz__ShipSeparately__c = true,Category__c = 'TPC');
        ccpl.add(ccp1);
        insert ccpl;
    }
}