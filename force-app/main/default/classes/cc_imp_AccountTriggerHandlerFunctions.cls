public without sharing class cc_imp_AccountTriggerHandlerFunctions {
	
	public static void processNexeo3DAccountUpdates(List<Account> newAccounts)
	{
		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('nexeo3d');

        if(storefrontSettings != null){
		  String profileNameFromSetting = storefrontSettings.Profile_Name__c ;

    		Profile profile = [SELECT Id, name from Profile where Id = :Userinfo.getProfileId()];

            String profileName = profile.name;
             
            if (profileName.equalsIgnoreCase(profileNameFromSetting))
            {
                Id recordTypeId =  cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(storefrontSettings.RecordTypeName__c , 'Account');

                for(Account myAccount : newAccounts) 
                {
                    myAccount.RecordTypeID = recordTypeId;

                    if (String.isNotBlank(myAccount.ccrz__CustomField1__c))
                    {
                        myAccount.VAT_Number__c = myAccount.ccrz__CustomField1__c;
                    }
                    if (String.isNotBlank(myAccount.ccrz__CustomField2__c))
                    {
                        myAccount.Registration_Sign_Up_For_Newsletter__c = (myAccount.ccrz__CustomField2__c == 'true');
                    }
                }
            } 
        }
	}

	public static void processMyNexeoAccountUpdates(List<Account> newAccounts)
	{
		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');

        if(storefrontSettings != null){
    		String profileNameFromSetting = storefrontSettings.Profile_Name__c ;

    		Profile profile = [SELECT Id, name from Profile where Id = :Userinfo.getProfileId()];

            String profileName = profile.name;
            if (profileName.equalsIgnoreCase(profileNameFromSetting))
            {
             	String primarySellerDefault = storefrontSettings.DefaultPrimarySellerUserId__c ;

    	   	    User defaultPrimarySeller =  [SELECT Id, name from User where userName = :primarySellerDefault];

     	        Id recordTypeId =  cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(storefrontSettings.RecordTypeName__c , 'Account');

                for(Account myAccount : newAccounts) 
                {
                    myAccount.Primary_Seller__c = defaultPrimarySeller.Id ; 
                    myAccount.Type = 'Prospect';
                    myAccount.Prospect_Sales_Org__c = storefrontSettings.ProspectSalesOrg__c  ; 
                    myAccount.Prospect_Dist_Channel__c = storefrontSettings.DistributionChannel__c ; 
                    myAccount.Prospect_Division__c = storefrontSettings.Division__c ; 
                    myAccount.Prospect_Sales_District__c = storefrontSettings.SalesDistrict__c ; 
                    myAccount.Prospect_Sales_Office__c = storefrontSettings.SalesOffice__c ; 
                    myAccount.Prospect_Sales_Group__c = storefrontSettings.SalesGroup__c ; 
                    myAccount.RecordTypeID = recordTypeId;

                    if (String.isNotBlank(myAccount.ccrz__CustomField1__c))
                    {
                        myAccount.Registration_Invoice_Number__c = myAccount.ccrz__CustomField1__c;
                    }
                    if (String.isNotBlank(myAccount.ccrz__CustomField2__c))
                    {
                        myAccount.Registration_Invoice_Amount__c = myAccount.ccrz__CustomField2__c;
                    }

                }
            }  
        }
	}
}