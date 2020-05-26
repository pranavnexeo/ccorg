public with sharing class cc_imp_RequestForQuoteTriggerHandler {

    public static void createNexCareForNewRFQ(List <ccrz__E_RequestForQuote__c> rfqs) {
        List<NexCare__c> nexCareList = new List<NexCare__c>();
        Set<Id> rfqIds = new Set<Id>();
        Set<Id> cartIds = new Set<Id>();
        for (ccrz__E_RequestForQuote__c rfq : rfqs) {
            rfqIds.add(rfq.Id);
            cartIds.add(rfq.ccrz__Cart__c);
        }
        Map<Id, ccrz__E_RequestForQuote__c> rfqMap = getRFQData(rfqIds);
        Map<Id, ccrz__E_Cart__c> cartMap = getCartData(cartIds);

        for (ccrz__E_RequestForQuote__c rfq : rfqs) {
            ccrz__E_RequestForQuote__c rfqExtra = rfqMap.get(rfq.Id);
            ccrz__E_Cart__c cartExtra = cartMap.get(rfq.ccrz__Cart__c);

            NexCare__c nexCare = new NexCare__c();
            nexCare.RecordTypeId = cc_imp_hlpr_ContactUsCreateCase.getNexCareRecordId();
            nexCare.Account_Name__c = rfq.ccrz__Account__c;
            nexCare.Short_Description__c = 'Request For Quote';
            String description = 'Request For Quote Name: ' + rfq.Name  + '\n';
            if (rfqExtra != null) {
                description += 'Account: ' + rfqExtra.ccrz__Account__r.AccountNumber  + '\nContact: ' + rfqExtra.ccrz__Contact__r.Name + '\n';
            }
            else {
                description += 'Account Id: ' + rfq.ccrz__Account__c  + '\nContact Id: ' + rfq.ccrz__Contact__c + '\n';
            }
            if (cartExtra != null) {
                description += 'Cart Name: ' + cartExtra.Name + '\n';
                for (ccrz__E_CartItem__c ci : cartExtra.ccrz__E_CartItems__r) {
                    description += 'Product Number: ' + ci.ccrz__Product__r.Product_Number__c + '\n';
                }
            }
            else {
                description += 'Cart Id: ' + rfq.ccrz__Cart__c + '\n';
            }
            description += 
                'Amount: ' + rfq.ccrz__Amount__c + '\n' +
                'Close Date: ' + rfq.ccrz__CloseDate__c + '\n' +
                'Company: ' + rfq.ccrz__Company__c  + '\n' +
                'Description: ' + rfq.ccrz__Description__c + '\n' + 
                'Email: ' + rfq.ccrz__Email__c + '\n' +
                'HasOptedOutOfEmail: ' + rfq.ccrz__HasOptedOutOfEmail__c + '\n' + 
                'FirstName: ' + rfq.ccrz__FirstName__c + '\n' + 
                'LastName: ' + rfq.ccrz__LastName__c + '\n' +  
                'NextStep: ' + rfq.ccrz__NextStep__c + '\n' + 
                'Phone: ' + rfq.ccrz__Phone__c + '\n' + 
                'StageName: ' + rfq.ccrz__StageName__c + '\n' + 
                'Storefront: ' + rfq.ccrz__Storefront__c + '\n' +
                'Website: ' + rfq.ccrz__Website__c;

            nexCare.Description__c = description;


            nexCare.Contact_Name__c = rfq.ccrz__Contact__c;
            nexCare.Tier_1__c = 'Request';
            nexCare.Tier_2__c = 'Web Form – General';

            nexCareList.add(nexCare);
        } 
  
        if (nexCareList.size() > 0) {
            cc_imp_hlpr_ContactUsCreateCase.insertNexCares(nexCareList);
        }
    }

    private static Map<Id, ccrz__E_RequestForQuote__c> getRFQData(Set<Id> ids) {
        Map<Id, ccrz__E_RequestForQuote__c> rfqs = new Map<Id, ccrz__E_RequestForQuote__c>([
            SELECT 
                Id, ccrz__Account__c, ccrz__Account__r.AccountNumber, ccrz__Contact__c, ccrz__Contact__r.Name
            FROM
                ccrz__E_RequestForQuote__c
            WHERE
                Id IN :ids
        ]);
        return rfqs;
    }

    private static Map<Id, ccrz__E_Cart__c> getCartData(Set<Id> ids) {
         Map<Id, ccrz__E_Cart__c> carts = new Map<Id, ccrz__E_Cart__c>([
            SELECT 
                Id, Name,
                (SELECT Id, ccrz__Product__c, ccrz__Product__r.Product_Number__c FROM ccrz__E_CartItems__r)
            FROM
                ccrz__E_Cart__c
            WHERE
                Id IN :ids
        ]);
        return carts;
    }

}