/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/21/2016
*    Created By:         Akansha Gupta 
*   Last Modified By:    Akansha Gupta 
*
*   **********************************************************************************************************************/

@isTest 
public class DeleteTierPricingCustomerPortal_Test {
    
    public static testMethod void MyTest(){
          
        Set<Id> PriceListItems = new Set<Id>();
                    
        ccrz__E_PriceList__c plist=new ccrz__E_PriceList__c();
        plist.ccrz__PricelistId__c='123456789';        
        insert plist;
        
        ccrz__E_Product__c product=new ccrz__E_Product__c(Name='ccrz__E_Product__c',ccrz__SKU__c='100000000000020157100030');
        insert product;
        
        ccrz__E_PriceListItem__c plistItem= new ccrz__E_PriceListItem__c();
        plistItem.ccrz__StartDate__c=Date.today();
      date myDate = date.newInstance(2083, 7, 15);
        plistItem.ccrz__EndDate__c=myDate;
        plistItem.ccrz__Pricelist__c=plist.Id;
        plistItem.ccrz__Product__c=product.Id;
        insert plistItem;
        PriceListItems.add(plistItem.Id);
        
        List<ccrz__E_Rule__c> lstrules = new List<ccrz__E_Rule__c>();
        ccrz__E_Rule__c crule = new ccrz__E_Rule__c(ccrz_pricelistitem__c = plistItem.Id,ccrz__RuleId__c = '12345678', ccrz__Name__c = 'test');
        insert crule;
        lstrules.add(crule);
        
        List<ccrz__E_PriceModifier__c> cpmodl = new List<ccrz__E_PriceModifier__c>();
        ccrz__E_PriceModifier__c cpmod = new ccrz__E_PriceModifier__c(ccrz__PriceModifierID__c = '987654321',ccrz__DiscountType__c = 'Sale',ccrz_PriceListItem__c = plistItem.Id );
        insert cpmod;
        cpmodl.add(cpmod);
        
        List<ccrz__E_RulePricingModifier__c> lstrulemod = new List<ccrz__E_RulePricingModifier__c>();
        ccrz__E_RulePricingModifier__c crulemod = new ccrz__E_RulePricingModifier__c(ccrz__PriceModifier__c = cpmod.id,ccrz__Rule__c = crule.id , ccrz__RulePriceModifierId__c = '123456789');
        insert crulemod;
        lstrulemod.add(crulemod);
        
        List<ccrz__E_RuleTargetPLI__c> crulelist = new List<ccrz__E_RuleTargetPLI__c>();
        ccrz__E_RuleTargetPLI__c crulet = new ccrz__E_RuleTargetPLI__c(ccrz__E_PriceListItem__c = plistItem.id,ccrz__E_Rule__c = crule.id);
        insert crulet;
        crulelist.add(crulet);
        
        DeleteTierPricingCustomerPortal d = new DeleteTierPricingCustomerPortal();
        
        d.deleteTiers(PriceListItems);  
        
      
        
    }
}