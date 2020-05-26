/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/15/2017
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description: Helper class used to update the Total Used field for CC Coupon object.
*                    
*					
*   **********************************************************************************************************************/

public class PopulateSAPShipToNumber_Helper {

    
    public void UpdateCoupons(Set<id> ids){
        System.debug('FGG Helper '+ids.size());
            List<ccrz__E_Coupon__c>  couponstoUpdate =new List<ccrz__E_Coupon__c>([select id,	ccrz__TotalUsed__c from ccrz__E_Coupon__c where id in: ids]);
    		{
                for(ccrz__E_Coupon__c  coupon : couponstoUpdate){
                    coupon.ccrz__TotalUsed__c++;
                }
                update couponstoUpdate;
        	}
    }
    public void SplitOrderItemsWithCoupons(List<ccrz__E_OrderItem__c> orderItemsWithCoupons){
        System.debug('FGG GOT TO SplitOrderItemsWithCoupons');
        List<ccrz__E_OrderItem__c> orderItemstoSplit=new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c orderItem: orderItemsWithCoupons){
            
            if(orderItem.ccrz__Quantity__c>orderItem.Coupon_Spec_Quantity__c){
        	orderItemstoSplit.add(orderItem);    
            System.debug('FGG quantity is more than coupon quantity for '+orderItem);    
            }
            
        }
        List<ccrz__E_OrderItem__c> orderItemstoInsert=new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_OrderItem__c> orderItemstoUpdate=new List<ccrz__E_OrderItem__c>();        
        for(ccrz__E_OrderItem__c orderItem: orderItemstoSplit){
            ccrz__E_OrderItem__c itemtoInsert=orderItem.clone(true,true,false,false);
            
            
            orderItem.ccrz__Quantity__c=orderItem.Coupon_Spec_Quantity__c;
            orderItem.ccrz__SubAmount__c=(orderItem.ccrz__Quantity__c*orderItem.ccrz__Price__c)-orderItem.ccrz__AbsoluteDiscount__c;
            itemtoInsert.ccrz__Quantity__c=itemtoInsert.ccrz__Quantity__c-orderItem.Coupon_Spec_Quantity__c;
            itemtoInsert.ccrz__AbsoluteDiscount__c=0;
            itemtoInsert.ccrz__PercentDiscount__c=0;
            itemtoInsert.ccrz__SubAmount__c=(itemtoInsert.ccrz__Quantity__c*itemtoInsert.ccrz__Price__c);
            itemtoInsert.ccrz__Coupon__c=null;
          
            orderItemstoInsert.add(itemtoInsert);    
            orderItemstoUpdate.add(orderItem);
        }
        //update orderItemstoUpdate;
        insert orderItemstoInsert;
    }
        
}