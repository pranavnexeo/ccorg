public with sharing class cc_imp_ContactTriggerHandlerFunctions {
	

  public static void processNexeo3DContactUpdates(Set<Id> newContactIdSet)
  {
    ccrz.ccLog.log(System.LoggingLevel.INFO, 'in 3d');

    cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('nexeo3d');

    if(storefrontSettings != null){

      String profileNameFromSetting = storefrontSettings.Profile_Name__c ;
      Profile profile = [SELECT Id, name from Profile where Id = :Userinfo.getProfileId()];
      String profileName = profile.name;

      if (profileName.equalsIgnoreCase(profileNameFromSetting))
      {  
        List <Contact> contactToUpdateList = new List<Contact>();
        List <Contact> newContactList = cc_imp_hlpr_TriggerHelper.fetchContactAndAccountFieldsForNexeo3D(newContactIdSet);
        for ( Contact newContact: newContactList)
        {
          String customField2 =  newContact.Account.ccrz__CustomField2__c;
          if (String.isNotBlank(customField2) && customField2.equalsIgnoreCase('true'))
          {
            newContact.signupNewsLetterFlag__c = Boolean.valueOf(customField2) ;

            contactToUpdateList.add(newContact);
          }
        } 

        if (contactToUpdateList.size() > 0)
        {
          cc_imp_hlpr_TriggerHelper.updateContacts(contactToUpdateList);
        }
      }
    }
  }


  public static void processMyNexeoContactUpdates(Set<Id> newContactIdSet)
  {
    cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
//ccrz.ccLog.log(System.LoggingLevel.INFO, 'FGG-'+storefrontSettings.Profile_Name__c );
            
    if(storefrontSettings != null){
      String profileNameFromSetting = storefrontSettings.Profile_Name__c ;
      Profile profile = [SELECT Id, name from Profile where Id = :Userinfo.getProfileId()];
      String profileName = profile.name;
	ccrz.ccLog.log(System.LoggingLevel.INFO, 'FGG-'+profileName);
      if (profileName.equalsIgnoreCase(profileNameFromSetting))
      {
        // String primarySellerDefault = storefrontSettings.DefaultPrimarySellerUserId__c ;
        // User defaultPrimarySeller =  [SELECT Id, name from User where userName = :primarySellerDefault];
        //Id caseAssignmentGroupId =  cc_imp_util_Storefront.getQueueIdByName(storefrontSettings.Default_CSR_Queue_Name__c);
        List <NexCare__c> listOfNexCareToCreate = new List<NexCare__c>();
        List <Contact> newContactList = cc_imp_hlpr_TriggerHelper.fetchContactAndAccountFieldsForMyNexeo(newContactIdSet);

        for ( Contact newContact: newContactList)
        {
          String customField1 =  newContact.Account.ccrz__CustomField1__c;
          String customField2 =  newContact.Account.ccrz__CustomField2__c;

          String existingCustomerResponse =  'Existing Nexeo customer = No';
          if(String.isNotBlank(customField1) && String.isNotBlank(customField2))
          {                
            existingCustomerResponse = 'Existing Nexeo customer = Yes\nInvoice # = ' + customField1 + '\nInvoice Amount = ' + customField2;
          }

          String contactString = newContact.name + '\n' + newContact.PHONE  + '\n' + newContact.EMAIL;

          String accountDetailsString = createAccountDetailStringForCase(newContact.Account);//, defaultPrimarySeller.name);

          NexCare__c nexCare = new NexCare__c();
          nexCare.RecordTypeId = cc_imp_hlpr_ContactUsCreateCase.getNexCareRecordId();
          nexCare.Account_Name__c = newContact.Account.Id;
          nexCare.Short_Description__c = 'New User Registration';
          nexCare.Description__c = existingCustomerResponse + '\n' + contactString + '\n' + accountDetailsString;
          nexCare.Contact_Name__c = newContact.Id;
          nexCare.Tier_1__c = 'Request';
          nexCare.Tier_2__c = 'New user request';

          listOfNexCareToCreate.add(nexCare);
        } 
  
        if (listOfNexCareToCreate.size() > 0 )
        {
          cc_imp_hlpr_ContactUsCreateCase.insertNexCares(listOfNexCareToCreate);
        }
      }    
    }
  }


  private static String createAccountDetailStringForCase(Account account){ //, String defaultSellerName)
    String billingStreetString = account.BillingStreet != null ? account.BillingStreet : '';
    String billingCityString = account.BillingCity != null ? account.BillingCity : '';
    String billingPostalCodeString = account.BillingPostalCode != null ? account.BillingPostalCode : '';
    String billingStateString = account.BillingState != null ? account.BillingState : '';
    String billingCountryString = account.BillingCountry != null ? account.BillingCountry : '';

    String shippingStreetString = account.ShippingStreet != null ? account.ShippingStreet : '';
    String shippingCityString = account.ShippingCity != null ? account.ShippingCity : '';
    String shippingPostalCodeString = account.ShippingPostalCode != null ? account.ShippingPostalCode : '';
    String shippingStateString = account.ShippingState != null ? account.ShippingState : '';
    String shippingCountryString = account.ShippingCountry != null ? account.ShippingCountry : '';

    String accountDetailsString = 
      // defaultSellerName 
      //+ '\n' + account.Type 
      //+ '\n' + account.Prospect_Sales_Org__c  
      //+ '\n' +  account.Prospect_Dist_Channel__c  
      //+ '\n' + account.Prospect_Division__c 
      //+ '\n' + account.Prospect_Sales_District__c 
      //+ '\n' + account.Prospect_Sales_Office__c 
      //+ '\n' + account.Prospect_Sales_Group__c + 'Is Tax Exempt /' + account.ccrz__TaxExemptAccount__c 
      + '\n' + billingStreetString 
      + '\n' + billingCityString 
      + '\n' + billingStateString 
      + '\n' + billingPostalCodeString 
      + '\n' + billingCountryString 
      + '\n' + shippingStreetString 
      + '\n' + shippingCityString 
      + '\n' + shippingStateString 
      + '\n' + shippingPostalCodeString 
      + '\n' + shippingCountryString;

    return accountDetailsString;
  }

  public static void processNexeo3DContactBeforeUpdates(List<Contact> newContacts) {
      cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('nexeo3d');

      if(storefrontSettings != null){ // This is mostly to avoid breaking non-Community triggers
  
        String profileNameFromSetting = storefrontSettings.Profile_Name__c ;

        Profile profile = [SELECT Id, name from Profile where Id = :Userinfo.getProfileId()];

        String profileName = profile.name;
         
        if (profileName.equalsIgnoreCase(profileNameFromSetting))
        {
            Id recordTypeId =  cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(storefrontSettings.ContactRecordTypeName__c , 'Contact');
  
            for(Contact c : newContacts) 
            {
                  c.RecordTypeID = recordTypeId;
            }
        } 
      }
  }

  public static void processMyNexeoContactBeforeUpdates(List<Contact> newContacts)
  {
      cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');


      if(storefrontSettings != null){ // This is mostly to avoid breaking non-Community triggers

        String profileNameFromSetting = storefrontSettings.Profile_Name__c ;

        Profile profile = [SELECT Id, name from Profile where Id = :Userinfo.getProfileId()];

        String profileName = profile.name;

        if (profileName.equalsIgnoreCase(profileNameFromSetting))
        {
            Id recordTypeId =  cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(storefrontSettings.ContactRecordTypeName__c , 'Contact');

            for(Contact c : newContacts) 
            {
                  c.RecordTypeID = recordTypeId;
            }
        }  
      }
  }

  public static void deleteOpenCartsOnAccountChange(Map<Id, Contact> oldContactMap, Map<Id, Contact> newContactMap){

      Set<Id> contactsWithUpdatedAccounts = new Set<Id>();
      for(Contact con :oldContactMap.values()){
        if(con.AccountId != newContactMap.get(con.Id).AccountId){
          contactsWithUpdatedAccounts.add(con.Id);
        }
      }

      // Select open carts for the contact and delete them
      List<ccrz__E_Cart__c> openCarts = [
        SELECT 
          Id
        FROM 
          ccrz__E_Cart__c
        WHERE
          ccrz__CartStatus__c = 'Open'
        AND
          ccrz__Contact__c in :contactsWithUpdatedAccounts
      ];

      if(openCarts != null && openCarts.size() > 0){
        delete openCarts;
      }
  }

}