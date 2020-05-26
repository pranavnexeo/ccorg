/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/6/2016
*   Author:              Shwetha Suvarna
*   Last Modified:       10/14/2016
*   Last Modified By:    Shwetha Suvarna
*
*   Short Description:   trigger to delete the orderitem for order for which SAP delete reject flag is D or R 
*   **********************************************************************************************************************/

trigger OrderItem_DeleteRecord on ccrz__E_OrderItem__c (Before Insert, Before Update, After Insert, After Update) {
    
    set<id> orderItem = new set<id>();
    set<id> UsedCoupons=new set<id>();
    List<ccrz__E_OrderItem__c> orderItemsWithCoupons = new List<ccrz__E_OrderItem__c>();
    list<ccrz__E_OrderItem__c> listOrderItems=new list<ccrz__E_OrderItem__c>();
    if(Trigger.isAfter){
        
    	for(ccrz__E_OrderItem__c oi: Trigger.New){
        	System.debug('FGG coupon '+oi.ccrz__Coupon__c);
        	if(oi.ccrz__OrderItemStatus__c == 'Deleted' || oi.ccrz__OrderItemStatus__c == 'Rejected'){
            	orderItem.add(oi.id);
        	}     
        System.debug('FGG Coupon '+oi.ccrz__Coupon__c+' Total '+oi.Total_Used_Updated__c+' StoreId '+oi.ccrz__StoreId__c);
    	}
        if(orderItem.size()>0){
        		OrderItemDeletionHelper.deleteOrder(orderItem);
    		}
    }
    if(Trigger.isBefore){
        
    for(ccrz__E_OrderItem__c oi: Trigger.New){
        
       if(oi.ccrz__StoreId__c=='nexeo3d' && oi.ccrz__Coupon__c!=null && oi.Total_Used_Updated__c!=true){         
        orderItemsWithCoupons.add(oi);
        UsedCoupons.add(oi.ccrz__Coupon__c);
        oi.Total_Used_Updated__c=true;
        }
     
     
    }
        System.debug('FGG Used Coupons size '+UsedCoupons.size());
        
        System.debug('FGG orderItemsWithCoupons '+orderItemsWithCoupons);
        if(UsedCoupons.size()>0){
            PopulateSAPShipToNumber_Helper updateCoupons=new PopulateSAPShipToNumber_Helper();
            System.debug('FGG UsedCoupons has values before getting into SplitOrderItemsWithCouopons'+orderItemsWithCoupons.size());            
            updateCoupons.SplitOrderItemsWithCoupons(orderItemsWithCoupons);
            updateCoupons.UpdateCoupons(UsedCoupons);
        }
        else{
            System.debug('FGG UsedCoupons is Empty');            
        }
    }
 
    }