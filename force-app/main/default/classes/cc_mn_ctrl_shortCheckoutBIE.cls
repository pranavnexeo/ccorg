/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        04/24/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Controller for the new checkout flow
*   
*   
*	
*   **********************************************************************************************************************/
//Without sharing as some users may not have access to the Ship To or Bill To account
global without sharing class cc_mn_ctrl_shortCheckoutBIE {
    global billToShipTo currentShipToBillTo { get; set; }
    global String extendedJSON {get; set;}
    global String extendedCheckoutCartJSON {get; set;}
    
    
	global cc_mn_ctrl_shortCheckoutBIE(){
    	getCurrentShipToBillTo();
        getCurrentContact();
        String encryptedCartId = ApexPages.currentPage().getParameters().get('cartId');
        this.extendedCheckoutCartJSON = JSON.serialize(buildExtendedCartItemMap(encryptedCartId));
    }
    
    
    global void getCurrentContact() {
      String currentContactId = ccrz.cc_CallContext.currContact.Id;
      Contact currentContact = [SELECT Id, FirstName, LastName, Email, Phone 
                                	FROM Contact WHERE Id =: currentContactId];
        
       
       currentShipToBillTo.buyerFirstName = currentContact.FirstName ;
       currentShipToBillTo.buyerLastName = currentContact.LastName ;
       currentShipToBillTo.buyerPhone = currentContact.Phone ;
       currentShipToBillTo.buyerEmail = currentContact.Email ;
       extendedJSON = JSON.serialize(currentShipToBillTo);
        
    }
    
        /**
   	 * Method to retrive bill and ship to
   	 * realted to the effective account on 
   	 * current cart
    * */  
    global void getCurrentShipToBillTo() {
        currentShipToBillTo = new billToShipTo();
        //get current cartid from Context class
        String currentCartId = ccrz.cc_CallContext.currCartId;
         System.debug(' ccrz.cc_CallContext.currCartId on Class ' + ccrz.cc_CallContext.currCartId);
        //Now get effective account id from cart
        String effectiveAccountId = [SELECT Id, ccrz__EffectiveAccountID__c FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =: currentCartId ][0].ccrz__EffectiveAccountID__c;
        System.debug('effectiveAccountId   ' + effectiveAccountId);
        //Get account based on effective Account Id
        Account effectiveAccount = [SELECT Id, SAP_Bill_To_Account_ID__c, SAP_Accounting_Group__c, Parent_Account__c, ShippingStreet , ShippingCity,ShippingState, ShippingPostalCode, ShippingCountry, Name  FROM Account WHERE Id =: effectiveAccountId];
        //Set Ship To address
        currentShipToBillTo.shipToName = effectiveAccount.Name;
        currentShipToBillTo.shipToStreet = effectiveAccount.ShippingStreet;
        currentShipToBillTo.shipToCity = effectiveAccount.ShippingCity;
        currentShipToBillTo.shipToState = effectiveAccount.ShippingState;
        currentShipToBillTo.shipToPostalCode = effectiveAccount.ShippingPostalCode;
        currentShipToBillTo.shipToCountry = effectiveAccount.ShippingCountry;
        Account billToAccount = null;
        //Verify is current account is Sold To
        if (!effectiveAccount.SAP_Accounting_Group__c.contains('Sold')) {     
            Account soldToAccount = [SELECT Id, SAP_Bill_To_Account_ID__c, SAP_Accounting_Group__c, ShippingStreet , ShippingCity,ShippingState, ShippingPostalCode, ShippingCountry, Name FROM Account WHERE Id =: effectiveAccount.Parent_Account__c];
            billToAccount = [SELECT Id, SAP_Bill_To_Account_ID__c, SAP_Accounting_Group__c, ShippingStreet , ShippingCity,ShippingState, ShippingPostalCode, ShippingCountry, Name FROM Account WHERE Id =: soldToAccount.SAP_Bill_To_Account_ID__c];
            //Go to Sold To retrieve SAP Bill to account on shipToAccount
        } else {
            billToAccount = [SELECT Id, SAP_Bill_To_Account_ID__c, SAP_Accounting_Group__c, ShippingStreet , ShippingCity,ShippingState, ShippingPostalCode, ShippingCountry, Name FROM Account WHERE Id =: effectiveAccount.SAP_Bill_To_Account_ID__c];
        }    
		
        currentShipToBillTo.billToName = billToAccount.Name;
        currentShipToBillTo.billToStreet = billToAccount.ShippingStreet;
        currentShipToBillTo.billToCity = billToAccount.ShippingCity;
        currentShipToBillTo.billToState = billToAccount.ShippingState;
        currentShipToBillTo.billToPostalCode = billToAccount.ShippingPostalCode;
        currentShipToBillTo.billToCountry = billToAccount.ShippingCountry;
    }
    
	private Map<String,ExtendedCheckoutCartItem> buildExtendedCartItemMap(String encryptedCartId) {
        
        Map<String, ExtendedCheckoutCartItem> extendedCartItemMap = new Map<String, ExtendedCheckoutCartItem>();
        String cartCurrency='';
		 List<ccrz__E_Cart__c> cartSFDCid = [
            select 
            	id,
            	ccrz__CurrencyISOCode__c,
            	ccrz__TotalQuantity__c
            from
            	ccrz__E_Cart__c
            where 
            	ccrz__EncryptedId__c = : encryptedCartId Limit 1
        ];
      if(!cartSFDCid.isEmpty()){
        for(ccrz__E_Cart__c cart : cartSFDCid){
            if(cart.ccrz__TotalQuantity__c==0){
                cartCurrency='';
            }else{
                cartCurrency=cart.ccrz__CurrencyISOCode__c;
            }
            } 
            
        }
        else{
                cartCurrency='';
            
        }
        List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>(
            [
                SELECT
                    Id
                    , ccrz__Product__c,Price_Per_Unit__c
                FROM
                    ccrz__E_CartItem__c
                WHERE
                    ccrz__Cart__r.ccrz__EncryptedId__c = :encryptedCartId
            ]
        );

        Set<Id> productIdSet = new Set<Id>();
        for (ccrz__E_CartItem__c item : cartItemList) {
            productIdSet.add(item.ccrz__Product__c);
        }
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));

        for (ccrz__E_CartItem__c item : cartItemList) {
            ExtendedCheckoutCartItem newExtendedCartItem = new ExtendedCheckoutCartItem();
            ccrz__E_PriceListItem__c pli = pliMap.get(item.ccrz__Product__c);
            if (pli != null && pli.CPI__c != null) {
                newExtendedCartItem.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
                newExtendedCartItem.priceperunit=item.Price_Per_Unit__c;
                newExtendedCartItem.productNumber=String.valueOf(Integer.valueOf(pli.ccrz__Product__r.Product_Number__c));
                newExtendedCartItem.cartCurrency=cartCurrency;
            }

            extendedCartItemMap.put(item.Id, newExtendedCartItem);
        }

        return extendedCartItemMap;
    }

    global class ExtendedCheckoutCartItem {
        public String customerMaterialNumber {get; set;}
        public String productNumber {get; set;}    
        public String cartCurrency {get; set;}
        public Decimal priceperunit {get; set;}
    }
    
    /**
   	 * Class to store the shipToAddress and billToAddress 
    * */  
  	global class billToShipTo{
        global String shipToName { get; set; }
        global String shipToStreet { get; set; }
        global String shipToCity { get; set; }
        global String shipToState { get; set; }
        global String shipToPostalCode { get; set; }
        global String shipToCountry  { get; set; }
        global String billToName { get; set; }
        global String billToStreet { get; set; }        
        global String billToCity { get; set; }
        global String billToState { get; set; }
        global String billToPostalCode { get; set; }
        global String billToCountry  { get; set; }
        global String buyerFirstName { get; set; }
        global String buyerLastName { get; set; }
        global String buyerPhone { get; set; }
        global String buyerEmail { get; set; }
 	}


}