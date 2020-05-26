global with sharing class cc_imp_mn_ctrl_OrderView {

    public String extendedOrderJSON {get; set;}
    public Boolean updateSequence {get; set;}
    global billToShipTo currentShipToBillTo { get; set; }
    global String urlHistoryRedirect { get; set; }
    public string strMaterialId{get;set;}
    public string poNumber {get; set;}
        
        
        
    public cc_imp_mn_ctrl_OrderView() {
       final String encryptedOrderId = ApexPages.currentPage().getParameters().get('o');
       getCurrentShipToBillTo(encryptedOrderId);
       this.extendedOrderJSON = JSON.serialize(buildExtendedOrderItemMap(encryptedOrderId));
       cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
       urlHistoryRedirect =  customSettings.OrderReviewRedirect__c;
       poNumber=getPONumber(encryptedOrderId);
    }
    public string getPONumber(String encryptedOrderId){
        ccrz__E_Order__c currentOrder=[select id FROM ccrz__E_Order__c WHERE ccrz__EncryptedId__c = :encryptedOrderId];
        ccrz__E_TransactionPayment__c AccountNumber= [Select ccrz__AccountNumber__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =:currentOrder.id];
       
        return AccountNumber.ccrz__AccountNumber__c;
       
    }

    global void getCurrentShipToBillTo(String encryptedOrderId) {
        currentShipToBillTo = new billToShipTo();
        ccrz__E_Order__c currentOrder = [SELECT Id,
                                                Shipping_To__r.ccrz__CompanyName__c,
                                                Shipping_To__r.ccrz__AddressFirstline__c,
                                                Shipping_To__r.ccrz__City__c,
                                                Shipping_To__r.ccrz__State__c,
                                                Shipping_To__r.ccrz__StateISOCode__c,
                                                Shipping_To__r.ccrz__PostalCode__c,
                                                Shipping_To__r.ccrz__Country__c,
                                                Shipping_To__r.ccrz__CountryISOCode__c,
                                                Billing_To__r.ccrz__CompanyName__c,
                                                Billing_To__r.ccrz__AddressFirstline__c,
                                                Billing_To__r.ccrz__City__c,
                                                Billing_To__r.ccrz__State__c,
                                                Billing_To__r.ccrz__StateISOCode__c,
                                                Billing_To__r.ccrz__PostalCode__c,
                                                Billing_To__r.ccrz__Country__c,
                                                Billing_To__r.ccrz__CountryISOCode__c                                         
                                         FROM ccrz__E_Order__c
                                         WHERE ccrz__EncryptedId__c = :encryptedOrderId];
        
            currentShipToBillTo.shipToName = currentOrder.Shipping_To__r.ccrz__CompanyName__c;
            currentShipToBillTo.shipToStreet = currentOrder.Shipping_To__r.ccrz__AddressFirstline__c;
            currentShipToBillTo.shipToCity = currentOrder.Shipping_To__r.ccrz__City__c;
            currentShipToBillTo.shipToState = currentOrder.Shipping_To__r.ccrz__State__c;
            currentShipToBillTo.shipToPostalCode = currentOrder.Shipping_To__r.ccrz__PostalCode__c;
            currentShipToBillTo.shipToCountry = currentOrder.Shipping_To__r.ccrz__Country__c;
            
            currentShipToBillTo.billToName = currentOrder.Billing_To__r.ccrz__CompanyName__c;
            currentShipToBillTo.billToStreet = currentOrder.Billing_To__r.ccrz__AddressFirstline__c;
            currentShipToBillTo.billToCity = currentOrder.Billing_To__r.ccrz__City__c;
            currentShipToBillTo.billToState = currentOrder.Billing_To__r.ccrz__State__c;
            currentShipToBillTo.billToPostalCode = currentOrder.Billing_To__r.ccrz__PostalCode__c;
            currentShipToBillTo.billToCountry = currentOrder.Billing_To__r.ccrz__Country__c;        
    }

    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchMSDS(ccrz.cc_RemoteActionContext ctx, String materialId) {
        return cc_imp_util_Storefront.fetchSDSInfo(ctx,materialId);
    }

    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchMSDSAttachment(ccrz.cc_RemoteActionContext ctx, String materialId, String sfid) {
        return cc_imp_util_Storefront.fetchSDSAttachment(ctx,materialId,sfid);
    }

    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchCofA(ccrz.cc_RemoteActionContext ctx, String materialId, String batchNumber) {
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

        cc_mn_json_CofAResponse calloutResponse = cc_mn_api_CofA.fetchCofA(ccrz.cc_CallContext.storefront, materialId, batchNumber);
        Map<String,Object> data = new Map<String,Object>{'success' => callOutResponse.success, 'cofaData' => callOutResponse.document, 'message' => callOutResponse.message};

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, calloutResponse.success, data);
        
        return response;
    }

    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchCofAAttachment(ccrz.cc_RemoteActionContext ctx, String materialId, String batchNumber, String sfid) {
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

        cc_mn_json_CofAResponse calloutResponse = cc_mn_api_CofA.fetchCofA(ccrz.cc_CallContext.storefront, materialId, batchNumber);
        //cc_mn_json_CofAResponse calloutResponse = cc_mn_api_CofA.fetchCofA(ccrz.cc_CallContext.storefront, '000000000000056043', '0056G02977');
        String theId = null;
        system.debug('callOutResponse.document=='+callOutResponse.document );
        if (!String.isBlank(callOutResponse.document)) {
            Attachment attach = new Attachment(Name = materialId + '-' + batchNumber + '.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, ParentId = sfid);
            attach.body = EncodingUtil.base64Decode(callOutResponse.document);
            insert attach;
            theId = attach.Id;
            system.debug('theId =='+theId );
            cc_imp_mn_AttachmentCleanup.cleanup();
        }

        Map<String,Object> data = new Map<String,Object>{'success' => callOutResponse.success, 'cofaData' => theId, 'message' => callOutResponse.message};

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, calloutResponse.success, data);
        system.debug('response=='+response);
        return response;
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
                Batch1__c,
                Batch2__c,
                Batch3__c,
                Batch4__c,
                Batch5__c,
                Batch6__c,
                Batch7__c,
                Batch8__c,
                Batch9__c,
                Batch10__c,
                Batch11__c,
                Batch12__c,
                Batch13__c,
                Batch14__c,
                Batch15__c,
                ccrz__Order__R.ccrz__OrderId__c,
                Price_Per_Unit__c
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
            newExtendedOrderItem.nexeoMaterialId =orderItem.ccrz__Product__r.NexeoMaterialId__c;   
            strMaterialId = orderItem.ccrz__Product__r.NexeoMaterialId__c;
            newExtendedOrderItem.productNumber = orderItem.ccrz__Product__r.Product_Number__c;
            newExtendedOrderItem.priceperunit= orderItem.Price_Per_Unit__c;
            newExtendedOrderItem.sku=String.valueOf(Integer.valueOf(orderItem.ccrz__Product__r.Product_Number__c));      
            if (orderItem.cc_imp_Sequence__c == null) {
                orderItem.cc_imp_Sequence__c = index*100;
                index++;
                updateSequence = true;
            }
            newExtendedOrderItem.sequenceNumber = Integer.valueOf(orderItem.cc_imp_Sequence__c);
            newExtendedOrderItem.batchNumber = orderItem.Batch__c;
            newExtendedOrderItem.batchNumber1 = orderItem.Batch1__c;
            newExtendedOrderItem.batchNumber2 = orderItem.Batch2__c;
            newExtendedOrderItem.batchNumber3 = orderItem.Batch3__c;
            newExtendedOrderItem.batchNumber4 = orderItem.Batch4__c;
            newExtendedOrderItem.batchNumber5 = orderItem.Batch5__c;
            newExtendedOrderItem.batchNumber6 = orderItem.Batch6__c;
            newExtendedOrderItem.batchNumber7 = orderItem.Batch7__c;
            newExtendedOrderItem.batchNumber8 = orderItem.Batch8__c;
            newExtendedOrderItem.batchNumber9 = orderItem.Batch9__c;
            newExtendedOrderItem.batchNumber10 = orderItem.Batch10__c;
            newExtendedOrderItem.batchNumber11 = orderItem.Batch11__c;
            newExtendedOrderItem.batchNumber12 = orderItem.Batch12__c;
            newExtendedOrderItem.batchNumber13 = orderItem.Batch13__c;
            newExtendedOrderItem.batchNumber14 = orderItem.Batch14__c;
            newExtendedOrderItem.batchNumber15 = orderItem.Batch15__c;
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
        public String batchNumber1 {get; set;}
        public String batchNumber2 {get; set;}
        public String batchNumber3 {get; set;}
        public String batchNumber4 {get; set;}
        public String batchNumber5 {get; set;}
        public String batchNumber6 {get; set;}
        public String batchNumber7 {get; set;}
        public String batchNumber8 {get; set;}
        public String batchNumber9 {get; set;}
        public String batchNumber10 {get; set;}
        public String batchNumber11 {get; set;}
        public String batchNumber12 {get; set;}
        public String batchNumber13 {get; set;}
        public String batchNumber14 {get; set;}
        public String batchNumber15 {get; set;}
        public Integer sequenceNumber {get; set;}
        public String orderId {get; set;}
        public String customerMaterialNumber {get; set;}
        public Decimal priceperunit {get; set;}
        public String sku {get; set;}
    }
    
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
    }
}