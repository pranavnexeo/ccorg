global with sharing class cc_3d_ctrl_OrderConfirmationBIE {

	public String extendedOrderJSON {get; set;}
	public Boolean updateSequence {get; set;}

	public cc_3d_ctrl_OrderConfirmationBIE() {
		final String encryptedOrderId = ApexPages.currentPage().getParameters().get('o');
	    this.extendedOrderJSON = JSON.serialize(buildExtendedOrderItemMap(encryptedOrderId));
	}

    @RemoteAction   
    global static void updateSequence(Map<String, ExtendedOrderItem> data) {
        List<ccrz__E_OrderItem__c> items = new List<ccrz__E_OrderItem__c>();
        for (String key : data.keySet()) {
            ExtendedOrderItem item = data.get(key);
            items.add(new ccrz__E_OrderItem__c(Id = key, cc_imp_Sequence__c = item.sequenceNumber));
        }
        update items;
    }

    /**
     *
     * retrieve additional order item fields
     *
     * @param: encryptedOrderId    The Encrypted Order Id
     * @return Map of Order Item SFDC ID => additional Order Item field wrapper class
     */
    Map<String,ExtendedOrderItem> buildExtendedOrderItemMap(String encryptedOrderId) {
        final Map<String, ExtendedOrderItem> extendedOrderItemMap = new Map<String,ExtendedOrderItem>();

        List<ccrz__E_OrderItem__c> items = [
            SELECT
                Id, 
                ccrz__Product__c,
                ccrz__Product__r.NexeoMaterialId__c,
                ccrz__Product__r.Product_Number__c,
                cc_imp_Sequence__c,
                Batch__c,
                ccrz__Order__R.ccrz__OrderId__c 
            FROM
                ccrz__E_OrderItem__c
            WHERE
                ccrz__Order__R.ccrz__EncryptedId__c = :encryptedOrderId
        ];

        Set<Id> productIdSet = new Set<Id>();
        for (ccrz__E_OrderItem__c orderItem : items) {
            productIdSet.add(orderItem.ccrz__Product__c);
        }
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));

        updateSequence = false;
        Integer index = 1;
        for (ccrz__E_OrderItem__c orderItem : items) {
            ExtendedOrderItem newExtendedOrderItem = new ExtendedOrderItem();
            newExtendedOrderItem.nexeoMaterialId = orderItem.ccrz__Product__r.NexeoMaterialId__c;
            newExtendedOrderItem.productNumber = orderItem.ccrz__Product__r.Product_Number__c;
            if (orderItem.cc_imp_Sequence__c == null) {
                orderItem.cc_imp_Sequence__c = index*100;
                index++;
                updateSequence = true;
            }
            newExtendedOrderItem.sequenceNumber = Integer.valueOf(orderItem.cc_imp_Sequence__c);
            newExtendedOrderItem.batchNumber = orderItem.Batch__c;
            newExtendedOrderItem.orderId = orderItem.ccrz__Order__R.ccrz__OrderId__c;

            ccrz__E_PriceListItem__c pli = pliMap.get(orderItem.ccrz__Product__c);
            if (pli != null && pli.CPI__c != null) {
                newExtendedOrderItem.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
            }

            extendedOrderItemMap.put(orderItem.Id, newExtendedOrderItem);
        }

        return extendedOrderItemMap;
    }
	//**************************************************************************
    // WRAPPER CLASS FOR ADDITIONAL ORDER ITEM FIELDS
    //**************************************************************************
    global class ExtendedOrderItem {
        public String nexeoMaterialId {get; set;}
        public String productNumber {get; set;}
        public String batchNumber {get; set;}
        public Integer sequenceNumber {get; set;}
        public String orderId {get; set;}
        public String customerMaterialNumber {get; set;}
    }
}