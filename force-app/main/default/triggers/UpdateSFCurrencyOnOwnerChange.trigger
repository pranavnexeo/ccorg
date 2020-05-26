Trigger UpdateSFCurrencyOnOwnerChange on ccrz__E_Cart__c (after update) {
	try{
	    String cartId = null;
		for(ccrz__E_Cart__c a : Trigger.new){
	    	if(a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId){
	        	cartId = a.Id;//Owner has changed , Identified the Cart on which SFDC Currency need to updated
	        	break;//Only 1 Cart needs to be updated , Ignore List of Carts getting updated.
	    	}
		}
	    if(cartId != null){
	    	List<ccrz__E_Cart__c> cartList = [select ccrz__Storefront__c,CurrencyIsoCode,ccrz__CurrencyISOCode__c,(select CurrencyIsoCode from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id =:cartId];
	    	
            
            if(cartList != null && cartList.size()>0 && cartList[0].ccrz__Storefront__c!='nexeo3d'){
	    		ccrz__E_Cart__c cartToBeUpdated = cartList[0];
	    		cartToBeUpdated.CurrencyIsoCode = cartToBeUpdated.ccrz__CurrencyISOCode__c;
	    		update cartToBeUpdated;
	    		List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
	    		for(ccrz__E_CartItem__c ci : cartToBeUpdated.ccrz__E_CartItems__r) {
	    			ci.CurrencyIsoCode = cartToBeUpdated.ccrz__CurrencyISOCode__c;
	    			cartItemList.add(ci);
	    		}
	    		update cartItemList;
	    	}
	    }
	}
	catch(Exception e){
		System.debug(e.getStackTraceString());
		ccrz.ccLog.log(e);
	}
}