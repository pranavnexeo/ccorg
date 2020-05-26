public without sharing class cc_imp_hlpr_AccountMyPricing {
    
    
    public static Account getAccountWithRepresentative(Id accountId) {
        return [SELECT Id, YZ_Partner__r.ZS_Partner__r.Email__c, Primary_Seller__c, Primary_Seller__r.User_Email__c,
                YZ_Partner__r.ZS_Partner__r.User__r.Name, Primary_Seller__r.Name FROM Account WHERE Id =: accountId];        
    }

}