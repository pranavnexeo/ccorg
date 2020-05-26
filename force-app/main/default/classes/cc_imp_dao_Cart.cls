public with sharing class cc_imp_dao_Cart {

	public static ccrz__E_Cart__c queryVatNumberByCartId(Id cartId){

	ccrz__E_Cart__c cart =  [	
					SELECT 
						ccrz__Account__r.VAT_Number__c,
						ccrz__SubtotalAmount__c,
						ccrz__ShipAmount__c,
						ccrz__Account__c,
						ccrz__Contact__c
					FROM 
						ccrz__E_Cart__c	 
					WHERE
					    ID =: cartId
					LIMIT
						1
					];

	  return cart;	
	}

	public static ccrz__E_Order__c getOrderForAccountAndCart(Id cartId, Id accountId, Id contactId ){

		ccrz__E_Order__c order = [
					SELECT
						Id,
						Name,
						VAT_Number__c,
						VAT_Tax_Classification__c
					FROM
						ccrz__E_Order__c
					WHERE
						ccrz__OriginatedCart__c =: cartId
						AND
						ccrz__Account__c =: accountId
						AND
						ccrz__Contact__c =: contactId
					LIMIT
						1
					];
		return order;

	}


}