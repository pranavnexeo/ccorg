public without sharing class cc_imp_hlpr_UserAdmin {

    public static void insertContact(Contact c){
        insert c;
    }
    public static void updateContact(Contact c){
        update c;
    }
    public static void insertUser(User u, Boolean sendEmail){
        if(sendEmail == null){
            sendEmail = false;
        }

        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.EmailHeader.triggerUserEmail = sendEmail;
        // insert u;
        Database.insert(u, dmlo);
    }
    public static void updateUser(User u){
        update u;
    }
    public static void resetPassword(User u){
        System.resetPassword(u.Id, true);
    }
    public static void assignProfileToUser(Id profileId, User u){
        u.ProfileId = profileId;
    }

    public static Contact queryContactById(Id contactId){
        Contact c = [
            SELECT
                  Id
                , AccountId
                , cc_imp_Is_MyNexeo_Admin__c
            FROM
                Contact
            WHERE
                Id = :contactId
            LIMIT
                1
        ];
        return c;
    }
    
    public static Map<Id, ccrz__E_AccountAddressBook__c> getShippingAddresses(Set <Id> accountIds){
        return new Map<Id, ccrz__E_AccountAddressBook__c>([
            SELECT
                Id
                , ccrz__Account__c

                // Fields from ContactAddr
                , ccrz__E_ContactAddress__r.Id
                , ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c
                , ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c
                , ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c
                , ccrz__E_ContactAddress__r.ccrz__City__c
                , ccrz__E_ContactAddress__r.ccrz__StateISOCode__c
                , ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c
                , ccrz__E_ContactAddress__r.ccrz__PostalCode__c
            FROM 
                ccrz__E_AccountAddressBook__c
            WHERE
                ccrz__Account__c in :accountIds
            AND
                ccrz__AddressType__c = 'Shipping'
        ]);
    }
}