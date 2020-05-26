/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        11/20/2017
*    Author:             Ignacio Gonzalez
*   Short Description:  
*                       
*   **********************************************************************************************************************/

public without sharing class cc_mn_ContactHandler {

    public cc_mn_ContactHandler(){
    }
   
    public void OnAfterInsert(Contact[] newRecords){
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        for (Contact newContact:newRecords) {
                contactMap.put(newContact.Id, newContact);            
        }
        
        // added by abhinay
        MapLiveChatTranscript(newRecords);
        // end here
        updateUserCurrency(contactMap);
    }
    
    public void OnAfterUpdate(Contact[] oldRecords, Contact[] updatedRecords, Map<ID, Contact> recordMap){
        updateUserCurrency(recordMap);
    }
    
    /**
     * We are going to update the currency of the user tht is related to the contact
     */
    private void updateUserCurrency(Map<Id, Contact> contactMap){
        //Get profile  Id of the use on the Customer Portal
        if (Test.isRunningTest()) { 
            cc_imp_StorefrontSettings__c customSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
            if (null == customSetting) {
                cc_imp_StorefrontSettings__c settings = new cc_imp_StorefrontSettings__c(
                  Profile_Id__c = '00e5A000001fOdo', 
                  Name = 'mynexeo'
                );
                insert settings;
            } else {
                if(null == customSetting.Profile_Id__c) {
                    customSetting.Profile_Id__c = '00e5A000001fOdo';
                    update customSetting;
                }
            }

        }
        cc_imp_StorefrontSettings__c cusSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        Id portalProfile = Id.valueOf(cusSetting.Profile_Id__c);
        //Map of users by contacts
        Map<Id, User> userByContact = new Map<Id, User>(); 
        //Map of account per Contact
        Map<Id, Id> accountIdByContact = new Map<Id, Id>();
        //iterate over the contacts in order to get accounts and user ids
        Map<Id, Account> accountMap = new Map<Id, Account>();
        //List of users to update
        List<User> usersToUpdate = new List<User>();
        //The portal user always will have the same AccountId that the contact
        for (User userToUpdate:[SELECT Id, ContactId, ccrz__CC_CurrencyCode__c, AccountId  FROM User Where ContactId in :contactMap.keySet() and ProfileId =: portalProfile]) {
                userByContact.put(userToUpdate.ContactId, userToUpdate);
                accountIdByContact.put(userToUpdate.ContactId, userToUpdate.AccountId);
        }
        
        //Get the account in order to get the Currency related to the pricelist
        for (Account contactAccount:[SELECT Id, cc_imp_MyProductList__c, cc_imp_MyProductList__r.ccrz__CurrencyISOCode__c FROM Account Where Id in :accountIdByContact.values() and cc_imp_MyProductList__r.ccrz__CurrencyISOCode__c != null]) {
                accountMap.put(contactAccount.Id, contactAccount);              
         
        }
        
        //Iterate users to update the currency
        for (User portalUser: userByContact.values()) {
            //get the currency from the accountMap
            Account accFromUser = accountMap.get(portalUser.AccountId);

            if (null != accFromUser) {

                portalUser.ccrz__CC_CurrencyCode__c = accFromUser.cc_imp_MyProductList__r.ccrz__CurrencyISOCode__c;
                usersToUpdate.add(portalUser);
            }
            
        }
        
        if (!usersToUpdate.isEmpty()) {

                update usersToUpdate;
  
        }
    }
    
    //added by Abhinay to map livechattransit from lead to contact
    public static void MapLiveChatTranscript(list<Contact> triggerNew)
    {
        if(triggerNew.size()>0)
        {
            map<id,string> mapContactToLeadId = new map<id,string>();
            list<LiveChatTranscript> lstTransToUpdate = new list<LiveChatTranscript>();
            for(Contact objCon :triggerNew)
            {
                if(objCon.Lead_Id__c != null)
                {
                    mapContactToLeadId.put(objCon.Lead_Id__c,objCon.id);
                }
            }
            if(mapContactToLeadId.keySet().size()>0)
            {
                for(LiveChatTranscript objTrans: [select id,leadid,contactid from LiveChatTranscript where leadid in :mapContactToLeadId.keySet()])
                {
                    if(mapContactToLeadId.get(objTrans.leadid) != null)
                    {
                        objTrans.contactid = mapContactToLeadId.get(objTrans.leadid);
                        lstTransToUpdate.add(objTrans);
                    }
                }
                if(lstTransToUpdate.size()>0)
                    update lstTransToUpdate;
            }
        }
    }
   
}