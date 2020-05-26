public with sharing class cc_imp_dao_Account {

    /**
     *
     * Returns the CSR for the given account Id, or null if
     * the CSR is blank.
     *
     * TODO - update to get the CSR from the territory
     *
     */
    public static Id getCSRForAccount(Id accountId){
        Account a = queryAccountByAccountId(accountId);
        if(a == null){
            return null;
        }
        return a.ZC_Partner__c;
    }
    
   public static Id getSellerForAccount(Id accountId){
        Account a = queryAccountByAccountId(accountId);
        if(a == null){
            return null;
        }
        return a.Primary_Seller__c;
    }


    /**
     *
     * General query for additional Account fields when the
     * account Id is available.
     *
     */
    public static Account queryAccountByAccountId(Id accountId){
        return [
            SELECT
                Id
                , AccountNumber
                , Primary_Seller__c
                , ZC_Partner__c
            	, SAP_DivisionCode__c
            FROM
                Account
            WHERE
                Id = :accountId
            LIMIT
                1
        ];
    }

    /**
     *
     * General query for all accounts the current user can access.
     *
     */
    public static Map<Id, Account> queryAccessibleAccounts(){
        Map<Id,Account> mainAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , SAP_Sold_To_Account_Id__c 
            FROM
                Account
        ]);

        Map<Id,Account> childAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , SAP_Sold_To_Account_Id__c 
            FROM
                Account
            WHERE
                // ParentId in :mainAccounts.keySet()
                SAP_Sold_To_Account_Id__c in :mainAccounts.keySet()
        ]);

        mainAccounts.putAll(childAccounts);
        return mainAccounts;
    }



    public static Account getAccountForViewCreditRequest(String accountId)
    {
        Account raccount =  cc_mn_imp_viewcredit.getAccountForViewCreditRequest(accountId);
        
        return raccount;

    }

    public static Map<Id, ccrz__E_AccountAddressBook__c> getShippingAddresses(Set <Id> accountIds){
        return new Map<Id, ccrz__E_AccountAddressBook__c>([
            SELECT
                Id
                , ccrz__Account__c
                , ccrz__AddressType__c

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

    public static Map<Id, ccrz__E_AccountAddressBook__c> getBillingAndShippingAddresses(Set <Id> accountIds){
        return new Map<Id, ccrz__E_AccountAddressBook__c>([
            SELECT
                Id
                , ccrz__Account__c
                , ccrz__AddressType__c
                , ccrz__Default__c

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
                ccrz__AccountId__c in :accountIds
            AND
            (
                ccrz__AddressType__c = 'Shipping'
            OR
                ccrz__AddressType__c = 'Billing'
            )
        ]);
    }

        /**
     *
     * General query for all accounts the current user can access.
     *
     */
    public static Map<Id, Account> queryAccessibleAccountsWithAddress(){
        Map<Id,Account> mainAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , SAP_Sold_To_Account_Id__c 
                , ShippingStreet
                , ShippingCity
                , ShippingState
                , ShippingPostalCode
            FROM
                Account
        ]);

        Map<Id,Account> childAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , SAP_Sold_To_Account_Id__c 
                , ShippingStreet
                , ShippingCity
                , ShippingState
                , ShippingPostalCode
            FROM
                Account
            WHERE
                // ParentId in :mainAccounts.keySet()
                SAP_Sold_To_Account_Id__c in :mainAccounts.keySet()
        ]);

        mainAccounts.putAll(childAccounts);
        return mainAccounts;
    }



}