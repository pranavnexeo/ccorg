global with sharing class cc_imp_mn_ctrl_OrderViewES {

    public String extendedOrderJSON {get; set;}
    public Boolean updateSequence {get; set;}
    public Boolean isES {get;set;}

    public cc_imp_mn_ctrl_OrderViewES() {
       final String encryptedOrderId = ApexPages.currentPage().getParameters().get('o');
       //final String encryptedOrderId ='9a4c089f-c755-419e-8920-6f130840eb8b';
       Account a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.effAccountId);        
        isES = false;
        if(a.SAP_DivisionCode__c!=null){
            if(a.SAP_DivisionCode__c=='34')
            {
              isES=True;  
            }
        }

       this.extendedOrderJSON = JSON.serialize(buildExtendedOrderItemMap(encryptedOrderId));
    }


    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchMSDS(ccrz.cc_RemoteActionContext ctx, String materialId) {
        return cc_imp_util_Storefront.fetchSDSInfo(ctx,materialId);
    }

    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchProfileDoc(ccrz.cc_RemoteActionContext ctx, String materialId) {
        return null;//fetchProfile(ctx,materialId);
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

        String theId = null;
        if (!String.isBlank(callOutResponse.document)) {
            Attachment attach = new Attachment(Name = materialId + '-' + batchNumber + '.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, ParentId = sfid);
            attach.body = EncodingUtil.base64Decode(callOutResponse.document);
            insert attach;
            theId = attach.Id;
            cc_imp_mn_AttachmentCleanup.cleanup();
        }

        Map<String,Object> data = new Map<String,Object>{'success' => callOutResponse.success, 'cofaData' => theId, 'message' => callOutResponse.message};

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, calloutResponse.success, data);
        
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
                ccrz__Order__R.ccrz__OrderId__c,Container__c,Substance_ID__c,
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
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequenceES(new List<Id>(productIdSet));

        updateSequence = false;
        Integer index = 1;
        for (ccrz__E_OrderItem__c orderItem : items) {
            ExtendedOrderItem newExtendedOrderItem = new ExtendedOrderItem();
            newExtendedOrderItem.nexeoMaterialId =orderItem.ccrz__Product__r.NexeoMaterialId__c;            
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
            system.debug('orderItem.ccrz__Product__c=='+orderItem.ccrz__Product__c);
            ccrz__E_PriceListItem__c pli = pliMap.get(orderItem.ccrz__Product__c);
            system.debug('pli=='+pli);
            //newExtendedOrderItem.customerMaterialNumber ='abc12';
            //newExtendedOrderItem.ProfileDesc ='test Desc';
            if (pli != null && pli.CPI__c != null) {
                newExtendedOrderItem.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
                newExtendedOrderItem.ProfileDesc = pli.CPI__r.Material_Description__c;
            }
            system.debug('newExtendedOrderItem.customerMaterialNumber=='+newExtendedOrderItem.customerMaterialNumber);
            
            newExtendedOrderItem.SubstanccId = orderItem.Substance_ID__c;
            if(!string.isBlank(newExtendedOrderItem.SubstanccId))
                newExtendedOrderItem.isSubstanceId = true;
            else
                newExtendedOrderItem.isSubstanceId = false;
            
            newExtendedOrderItem.Container = orderItem.Container__c;
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
        public string Container {get; set;}
        public boolean isSubstanceId{get;set;}
        public string SubstanccId {get; set;}
        public string ProfileDesc {get; set;}
        public String sku {get; set;}
    }
}