@isTest
public class SupplierPricingUtilTest {

    public static testMethod void testRunAs() {
      
            Supplier_Pricing__c supplierPricing1 = new Supplier_Pricing__c(Is_Price_Changed__c=true,Product__c='1,3 Butylene Glycol',Supplier__c='Basic Chemical',region__c='Canada',Origin__c='Charlotte');
            insert supplierPricing1; 
            SupplierPricingUtil.clearPriceUpdateFlags( supplierPricing1.id );
            System.assertEquals(true, supplierPricing1.Is_Price_Changed__c);  

            SupplierPricingUtil.updateRegionPriceflag( 'xyz' ); 
            
            Supplier_Pricing__c supplierPricing2 = new Supplier_Pricing__c(Is_Price_Changed__c=true,Product__c='1,3 Butylene Glycol',Supplier__c='Basic Chemical',region__c='Canada',Origin__c='Charlotte');
            insert supplierPricing2; 
            SupplierPricingUtil.updateRegionPriceflag( 'Canada' ); 
            System.assertEquals(true, supplierPricing2.Is_Price_Changed__c);  
              
    }
}