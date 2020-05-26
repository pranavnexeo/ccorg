public without sharing class cc_imp_hlpr_Account {

        /**
     *
     * General query for all accounts the current user can access.
     *
     */
    public static Map<Id, Account> queryAccessibleAccountsById( Id currentAccount){
        Map<Id,Account> mainAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , SAP_DivisionCode__c
                , SAP_Sold_To_Account_Id__c 
                ,cc_imp_MyProductList__r.Pricing_Last_Refreshed__c
            FROM
                Account
            WHERE
                Id = :currentAccount
        ]);

        Map<Id,Account> childAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , SAP_Sold_To_Account_Id__c 
            	, SAP_DivisionCode__c
                ,cc_imp_MyProductList__r.Pricing_Last_Refreshed__c
            FROM
                Account
            WHERE
                // ParentId in :mainAccounts.keySet()
                SAP_Sold_To_Account_Id__c in :mainAccounts.keySet()
        ]);

        mainAccounts.putAll(childAccounts);
        return mainAccounts;
    }

    public static List<Account> lookupAccountsForRepricing(List<Id> accountIds){
        List<Account> accounts = new List<Account> ([
            SELECT
                Id
                , Name
                , Account_Number__c
                , Ship_To_Number__c
                , SAP_DivisionCode__c
                , Sold_To_Customer_Number__c
                , SAP_Sales_Org__c
                , SAP_DistChannel__c
            FROM
                Account
            WHERE
                Id in :accountIds

        ]);

        return accounts;
    }

    public static void updateAccountRepricingRefreshed(List<Id> accountIds){
			
         ccrz.ccLog.log('*** FGG: ' + accountIds);
        System.debug('FGG 61 hlprAccount '+accountIds);
        List<id> priceliststoUpdate= new List<id>();	
        List<Account> accountsToUpdate =[SELECT cc_imp_MyProductList__c FROM Account WHERE Id in: accountIds];        
        for(Account act: accountsToUpdate){
            priceliststoUpdate.add(act.cc_imp_MyProductList__c);            
        }   	
        
        List<ccrz__E_PriceList__c> ccp = [select id,Pricing_Last_Refreshed__c from ccrz__E_PriceList__c  where id in :priceliststoUpdate];
		
        for(ccrz__E_PriceList__c pricelist: ccp){
        pricelist.Pricing_Last_Refreshed__c=System.now();
        }
        if(ccp.size()>0){        
        update ccp;
        }

    }

}