@istest
//Test class to cover PopulateSAPShipToNumber_Helper
public class PopulateSAPShipToNumber_Helper_Test {

    @isTest static void test_populateSAPShiptoNumberHelper() 
  {
      
      ccrz__E_Coupon__c coupon=new ccrz__E_Coupon__c();
      
      coupon.ccrz__CouponName__c='Test Coupon';
      coupon.ccrz__CouponCode__c='Test Coupon';
      coupon.ccrz__CouponType__c='Absolute';
      coupon.ccrz__CartTotalAmount__c=10;
      coupon.ccrz__MinQty__c=1;
      coupon.ccrz__MaxUse__c=999;
      coupon.ccrz__Storefront__c='nexeo3d';
      coupon.ccrz__RuleType__c='CartTotal';
      coupon.ccrz__StartDate__c=date.newInstance(1999,01,01);
      coupon.ccrz__EndDate__c=date.newInstance(2999,01,01);
  	  coupon.ccrz__DiscountType__c='Absolute';
      coupon.ccrz__TotalUsed__c=0;
      coupon.ccrz__TargetSpecQty__c=1;
      coupon.ccrz__TargetQty__c=1;
      
      Insert coupon;    
  	  Set<id> couponIds=new Set<id>();
      couponIds.add(coupon.Id);
      PopulateSAPShipToNumber_Helper helperClass=new PopulateSAPShipToNumber_Helper();
          helperClass.UpdateCoupons(couponIds);
      
      ccrz__E_Product__c product = new ccrz__E_Product__c();
      
      product.Name='Test Product';
      product.ccrz__SKU__c='';
      product.ccrz__Quantityperunit__c=1;
      product.ccrz__ProductType__c='Product';
      product.ccrz__EndDate__c=date.newInstance(1999, 01, 01);
      product.ccrz__StartDate__c=date.newInstance(2999, 01, 01);
      product.ccrz__ProductStatus__c='Released';
      product.ccrz__SKU__c='TEST';
      insert product;
      
      ccrz__E_Order__c orderHeader=new ccrz__E_Order__c();
      
      Insert orderHeader;
      
      
      
      ccrz__E_OrderItem__c orderItem=new ccrz__E_OrderItem__c();
      orderItem.ccrz__Coupon__c=coupon.id;
      orderItem.ccrz__Product__c=product.Id;
      orderItem.ccrz__StoreId__c='nexeo3d';
      orderItem.ccrz__ItemStatus__c='Available';
      orderItem.ccrz__AbsoluteDiscount__c=10;    
      orderItem.ccrz__Price__c=100;
      orderItem.ccrz__Quantity__c=2;
      
      
      
      
      orderItem.ccrz__Order__c=orderHeader.Id;
      orderItem.ccrz__Price__c=10;
      orderItem.ccrz__SubAmount__c=10;
      
      
      insert orderItem;
  
  }
    
    
}