global without sharing class cc_imp_ctrl_mn_EffectiveAccountSelector 
{
    public Boolean showEffAccountSelector { get { return shouldDisplayEffectiveAccountDialog();}  set; }
    public String accountsJSON {get; private set;}
    public String curAccount {get; private set;}
    public String curContactId {get; private set;}
   
    public class CustAddress {
        public String address1;
        public String city;
        public String country;
        public String countryCode;
        public String partnerId;
        public String postalCode;
        public String state;
    }
    public class CustAccount {
        public String sfid;
        public String accountNumber;
        public String name;
        public CustAddress billingAddress = new CustAddress();
        public CustAddress shippingAddress = new CustAddress();
        //public List<CustAccount> childAccounts = new List<CustAccount>();
    }
    public List<CustAccount> accounts {get;private set;}
    public Map<Id, CustAccount> parentAccountMap = new Map<Id, CustAccount>();

    public cc_imp_ctrl_mn_EffectiveAccountSelector(){     
        queryAvailableAccounts();
        
    }

    public void queryAvailableAccounts(){
        try {
            // Map<Id, Account> allAccounts = cc_imp_dao_Account.queryAccessibleAccountsWithAddress();
            Map<Id, Account> allAccounts = queryAccessibleAccountsWithAddress();
            // Determine the parent accounts and the child accounts
            accounts = new List<CustAccount>();
            List<CustAccount> fullListOfAccounts = new List<CustAccount>();
            CustAccount curAct;
            CustAccount parentAcct = new CustAccount();
            for(Account a :allAccounts.values()){
                curAct = new CustAccount();
                            // Copy account fields to the parent or child
                curAct.sfid = a.Id;
                curAct.accountNumber = a.AccountNumber;
                curAct.name = a.Name;
                curAct.shippingAddress.partnerId = a.CIS_Prospect_Number__c;
                curAct.shippingAddress.address1 = a.ShippingStreet;
                curAct.shippingAddress.city = a.ShippingCity;
                curAct.shippingAddress.state = a.ShippingState;
                curAct.shippingAddress.country = a.ShippingCountry;
                curAct.shippingAddress.countryCode = a.ShippingCountry;
                curAct.shippingAddress.postalCode = a.ShippingPostalCode;
                curAct.billingAddress.partnerId = a.CIS_Prospect_Number__c;
                curAct.billingAddress.address1 = a.BillingStreet;
                curAct.billingAddress.city = a.BillingCity;
                curAct.billingAddress.state = a.BillingState;
                curAct.billingAddress.country = a.BillingCountry;
                curAct.billingAddress.countryCode = a.BillingCountry;
                curAct.billingAddress.postalCode = a.BillingPostalCode;

                fullListOfAccounts.add(curAct);
            }
            accounts = fullListOfAccounts;
            //Set cookie if there is only one account
            if (fullListOfAccounts.size() == 1) {
                CustAccount acc = fullListOfAccounts.get(0);
                isESUser(acc.sfid);
            }
            accountsJSON = JSON.serialize(fullListOfAccounts);

        }
        catch(Exception e){
            accountsJSON = JSON.serialize(e.getMessage());
        }
    }

    public static Boolean shouldDisplayEffectiveAccountDialog ()
    {
        Boolean retValue = Boolean.valueOf(true);

        final Map<String,String> paramMap = ApexPages.currentPage().getParameters();

        System.debug('\n\n@@paramMap: ' + paramMap + '\n\n');

        if (paramMap.containsKey('effectiveAccount') )
        {
            retValue = Boolean.valueOf(false);
            //setting cookie to know if current account is ES
            isESUser(null);
        }
          

        return retValue;
        
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkPricingStatus(ccrz.cc_RemoteActionContext ctx ){
                 
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        try{
            
            List<Id> accountsThatNeedToBeRePriced = new List<Id>();
            
            boolean updatedPricing = false;
            Decimal priceRefreshingHours=0;
            CC_SFDC_Settings__c cusSetting=CC_SFDC_Settings__c.getInstance('CPI_MyNexeo');
            if(cusSetting!=null){
                priceRefreshingHours=cusSetting.Pricing_Refresh_time__c;
            }
            //get all accounts
            Id accountId = ccrz.cc_CallContext.currAccount.Id;
            
            Map<Id, Account> accounts = cc_imp_hlpr_Account.queryAccessibleAccountsById(accountId);
            
            if(accounts!=null && accounts.size()>0){
                Set<Id> keys = accounts.keySet();
                for(Id key: keys){
                    Account tempAccount = accounts.get(key);
                   // DateTime dt = tempAccount.cc_imp_MyProductList__r.Pricing_Last_Refreshed__c;
                   // if(dt == null || dt.addHours(Integer.valueof(priceRefreshingHours)) < System.now()){
                        accountsThatNeedToBeRePriced.add(key);                       
                     //   }
                    }
                if(accountsThatNeedToBeRePriced.size()>=1){
                        
                        cc_imp_hlpr_Account.updateAccountRepricingRefreshed(accountsThatNeedToBeRePriced );
                        updatedPricing = true;
                    updatePricingForAccount( accountsThatNeedToBeRePriced );
                        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, new Map<String,Object> {
                        'success' => true,
                        'updatedPricing' => updatedPricing
                    });
                }
                else{
                        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, new Map<String,Object> {
                        'success' => true,
                        'updatedPricing' => false
                    });
                    
                }
                }

            

           }catch(Exception e){
                System.debug('FGG '+e.getMessage());
                cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, new Map<String,Object> {
                        'success' => false,
                        'message' => e.getMessage(),
                        'cause' => e.getCause(),
                        'trace' => e.getStackTraceString()
                    });
            }
        system.debug(response);   
        return response;

    }


    @future(callout=true)
    public static void updatePricingForAccount(List<Id> accountIds){

        List<Account> accountsToPrice = cc_imp_hlpr_Account.lookupAccountsForRepricing(accountIds);

        PricingCustomerPortal pricingObject = new PricingCustomerPortal();
        if(! Test.isRunningTest()){ // do not perform the actual update if running tests
            boolean pricingStatus=pricingObject.getPricingFromSAP( accountsToPrice );
            if(!pricingStatus){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    //message.toAddresses = new String[] { 'fgarcia@nexeosolutions.com'};
                    message.toAddresses = new String[] { 'fgarcia@nexeosolutions.com', 'pbivens@nexeosolutions.com' };
                    message.optOutPolicy = 'FILTER';
                    message.subject = 'There were errors while processing Pricing Update for CP';                   
                    message.plainTextBody = 'There were errors while processing Pricing Update for CP for the following account ids '+accountIds;
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }                               
            }
            system.debug('FGG Effective '+pricingStatus);
        }
    }

    public static Map<Id, Account> queryAccessibleAccountsWithAddress(){

        Id curUserId = ccrz.cc_CallContext.currUserId;
        Id curContactId = ccrz.cc_CallContext.currContact.Id;
    ccrz.ccLog.log('** curUserId: '+curUserId);
        ccrz.ccLog.log('** curContactId: '+curContactId);
        Id mainAccountId = [
            SELECT
                AccountId
            FROM
                Contact
            WHERE
                Id = :curContactId
            LIMIT 1
        ].AccountId;

        List<CC_Account_Contact_Association__c> assns = [
            SELECT 
                Id
                , Account__c
                , Contact__c
            FROM
                CC_Account_Contact_Association__c
            WHERE
                Contact__c =: curContactId
        ];
        Set<Id> addAccountIds = new Set<Id>();
        addAccountIds.add(mainAccountId);
        for(CC_Account_Contact_Association__c ca :assns){
            addAccountIds.add(ca.Account__c);
        }
        ccrz.ccLog.log('** Account ids: ' + JSON.serializePretty(addAccountIds));

        Map<Id,Account> mainAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , AccountNumber
                , SAP_Sold_To_Account_Id__c
                , SAP_DivisionCode__c 
                , Parent_Account__c
                , ShippingStreet
                , ShippingCity
                , ShippingState
                , ShippingPostalCode
                , ShippingCountry
                , BillingStreet
                , BillingCity
                , BillingState
                , BillingPostalCode
                , BillingCountry
                , CIS_Prospect_Number__c
            FROM
                Account
            WHERE
                (Id in :addAccountIds

                OR
                Parent_Account__c in :addAccountIds)

                and

                ccrz__UsedByCloudcraze__c = true
        ]);

        ccrz.ccLog.log('** MainAccounts: ' + JSON.serializePretty(mainAccounts));
        Map<Id,Account> childAccounts = new Map<Id,Account>([
            SELECT
                Id
                , Name
                , ParentId
                , AccountNumber
                , SAP_Sold_To_Account_Id__c 
                , SAP_DivisionCode__c
                , Parent_Account__c
                , ShippingStreet
                , ShippingCity
                , ShippingState
                , ShippingPostalCode
                , ShippingCountry
                , BillingStreet
                , BillingCity
                , BillingState
                , BillingPostalCode
                , BillingCountry
                , CIS_Prospect_Number__c
            FROM
                Account
            WHERE

                (Parent_Account__c in :mainAccounts.keySet()
            
            OR
                Id in :addAccountIds)

            and

                ccrz__UsedByCloudcraze__c = true

        ]);
        ccrz.ccLog.log('** Child: ' + JSON.serializePretty(childAccounts));
        mainAccounts.putAll(childAccounts);
        return mainAccounts;

    }
    
    // In order to set the cookie
    global static void isESUser(Id accountId) {    
        System.debug('ccrz.cc_CallContext.effAccountId ' + ccrz.cc_CallContext.effAccountId);
        System.debug('ccrz.cc_CallContext.currAccount.Id ' + ccrz.cc_CallContext.currAccount.Id);
        Id accountToRetrieve = accountId;
        if (null == accountToRetrieve) {
            accountToRetrieve = Id.valueOf(ccrz.cc_CallContext.effAccountId);
        }
        Account a = cc_imp_dao_Account.queryAccountByAccountId(accountToRetrieve);     
        Boolean isES = false;
        if(a.SAP_DivisionCode__c != null){
            if(a.SAP_DivisionCode__c == '34') {
              isES = true;  
            }
        }
        // setting a session cookie
        Cookie isESUser = new Cookie('isESUser', String.valueOf(isES), '/mynexeo' , -1, true);
        ApexPages.currentPage().setCookies(new Cookie[]{isESUser});
    }
}