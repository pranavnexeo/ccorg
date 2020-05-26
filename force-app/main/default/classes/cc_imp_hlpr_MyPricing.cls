public with sharing class cc_imp_hlpr_MyPricing {
    
   	public static final List<String> STATUSES = new List<String>{'Released', 'Not Orderable'};
          
	static Map<String, String> pricingSortMap = new Map<String,String>();
    
    //static Set<String> pricingSpecialSortSet = new Set<String>();

	static {
        pricingSortMap.put('MaterialDescription','ccrz__Product__r.SAP_Material__r.Name');
		pricingSortMap.put('CustomerMaterialNumber', 'Customer_Material_Number__c');	
	}
    
    /*
  	static {
        pricingSpecialSortSet.add('accountTeam');
		pricingSpecialSortSet.add('incoTerms');	
	}*/
    
    public static List<MyPrincingWrapper> getAllPricing(Id priceListId) {
		// First we are going to retrieve the price List items     
		Map<Id, ccrz__E_PriceListItem__c> idsToRetrievePriceListTiers = new Map<Id, ccrz__E_PriceListItem__c> ();  
        Date theDay = Date.today();
        cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        Integer totalRecordsPerPage = Integer.valueOf(customSettings.Pagination_My_Pricing__c);
        List<ccrz__E_PriceListItem__c> priceListItems = new List<ccrz__E_PriceListItem__c >();
        for (ccrz__E_PriceListItem__c priceListItem : [SELECT Id, ccrz__Product__c, ccrz__Product__r.SAP_Material__c,
                                                          ccrz__Product__r.SAP_Material__r.Material_Number__c, 
                                                       	  ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c,
                                                          ccrz__Product__r.SAP_Material__r.Name, 
                                                          Customer_Material_Number__c, CSP_Experation_Date__c, 
                                                          CPI_Freight_Terms__c
                                                    FROM ccrz__E_PriceListItem__c 
                                                    WHERE 
                                                       ccrz__Pricelist__c =: priceListId
                                                   	AND
                                                        ccrz__Product__r.ccrz__ProductStatus__c in :STATUSES
                                                    AND
                                                        ccrz__StartDate__c <= :theDay
                                                    AND
                                                        ccrz__EndDate__c >= :theDay
                                                    AND
                                                        ccrz__Product__r.ccrz__StartDate__c <= :theDay
                                                    AND
                                                        ccrz__Product__r.ccrz__EndDate__c >= :theDay
                                                    ORDER BY
                                                        ccrz__Product__r.Name
                                                    LIMIT
                                                        :totalRecordsPerPage]) {
                                      priceListItems.add(priceListItem); 
                                      idsToRetrievePriceListTiers.put(priceListItem.Id, priceListItem);                     
         }
		//get tiers by product
		//product Id and the priceListItem related
        Map<Id,  List<TierPricingWrapper>> priceListItemTierMap = getPriceListItemTierBulk(idsToRetrievePriceListTiers);
        return assignPriceListTierToPriceListItem(priceListItems, priceListItemTierMap);

    }
    
    public static List<MyPrincingWrapper> getPricingByParams(Id priceListId, String searchFormData) {
 		// First we are going to retrieve the price List items     
		Map<Id, ccrz__E_PriceListItem__c> idsToRetrievePriceListTiers = new Map<Id, ccrz__E_PriceListItem__c>();  
        PricingQueryWrapper wrapper =  PricingQueryWrapper.parse(searchFormData);
        Date theDay = Date.today();
        String priceListIdString = String.valueOf(priceListId);
        String query = 'SELECT Id, ccrz__Product__c, ccrz__Product__r.SAP_Material__c, ccrz__Product__r.SAP_Material__r.Material_Number__c,';
        query += ' ccrz__Product__r.SAP_Material__r.Name, Customer_Material_Number__c, ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c, ';
        query += ' CPI_Freight_Terms__c, CSP_Experation_Date__c  FROM ccrz__E_PriceListItem__c WHERE ccrz__Pricelist__c =: priceListIdString ';
        query += ' AND ccrz__Product__r.ccrz__ProductStatus__c in :STATUSES ';
        query += ' AND ccrz__StartDate__c <= :theDay ';
        query += ' AND ccrz__EndDate__c >= :theDay ';
        query += ' AND ccrz__Product__r.ccrz__StartDate__c <= :theDay ';
        query += ' AND ccrz__Product__r.ccrz__EndDate__c >= :theDay ';
        
        if (null != wrapper.searchDataInput && String.isNotEmpty(wrapper.searchDataInput)) {
            String valueToUseOnLike = '%' + wrapper.searchDataInput.trim() + '%';
            query += ' AND ';
            query += ' ( ';
            query += ' ccrz__Product__r.SAP_Material__r.Name LIKE :valueToUseOnLike ';
            query += ' OR ';
            query += ' Customer_Material_Number__c LIKE :valueToUseOnLike ';
            query += ' )';
        } 
        
       
            if (null != wrapper.sortCriteria && String.isNotEmpty(wrapper.sortCriteria)) { 
                String pricingByColumn = pricingSortMap.get(wrapper.sortCriteria); 
                if (null != pricingByColumn) {
                    query += ' ORDER BY ';
                    query += pricingByColumn;
                    query += ' ' + wrapper.sortDir;
                    query +=' NULLS LAST';
                } else {
                    query += ' ORDER BY ';
                    query += ' ccrz__Product__r.Name ';
                }
            } else {
                query += ' ORDER BY ';
                query += ' ccrz__Product__r.Name ';
            }
            
            
            cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
            Integer totalRecordsPerPage = Integer.valueOf(customSettings.Pagination_My_Pricing__c);
            query += ' LIMIT  :totalRecordsPerPage';
            
            if (null != wrapper.page && String.isNotEmpty(wrapper.page)) {
                Integer intPage = Integer.valueOf(wrapper.page);
                if (intPage != 1) {
                    intPage --;
                    intPage *= 10;
                    query += ' OFFSET  :intPage'; 
                } 
            }  

        
        System.debug('getPricingByParams query ' + query);
       	List<ccrz__E_PriceListItem__c> priceListItems =(List<ccrz__E_PriceListItem__c>)Database.query( query );

       // List<ccrz__E_PriceListItem__c> priceListItems = new List<ccrz__E_PriceListItem__c >();
        for (ccrz__E_PriceListItem__c priceListItem : priceListItems) {
				idsToRetrievePriceListTiers.put(priceListItem.Id, priceListItem);                     
         }
		//get tiers by product
		//product Id and the priceListItem related
        Map<Id,  List<TierPricingWrapper>> priceListItemTierMap = getPriceListItemTierBulk(idsToRetrievePriceListTiers);
        return assignPriceListTierToPriceListItem(priceListItems, priceListItemTierMap);

       
    }
    
    public static List<MyPrincingWrapper> assignPriceListTierToPriceListItem(List<ccrz__E_PriceListItem__c> priceListItems, Map<Id,  List<TierPricingWrapper>> priceListItemTierMap) {
		List<MyPrincingWrapper> pricing = new List<MyPrincingWrapper>();
        // we are going to show the first characters based on Custom Setting
        cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        Set<String> materialTypesToValidate =  new Set<String>(customSettings.Material_Type_Send_Email_Primary_Seller__c.split(','));
        Account effectiveAccountWithRepresentative = cc_imp_hlpr_AccountMyPricing.getAccountWithRepresentative(ccrz.cc_CallContext.effAccount.Id);
        Map<String, String> incoTermSAP = new Map<String, String>();
        for(SAP_INCO_Term__c thiTerm :[SELECT INCO_Term_Code__c, INCO_Term_Name__c FROM SAP_INCO_Term__c]) {
            incoTermSAP.put(thiTerm.INCO_Term_Code__c, thiTerm.INCO_Term_Name__c);
        }
        for (ccrz__E_PriceListItem__c priceListItem : priceListItems) {
            List<TierPricingWrapper> tierPerItem = priceListItemTierMap.get(priceListItem.ccrz__Product__c);
            MyPrincingWrapper pricingWrapper = new MyPrincingWrapper();
            pricingWrapper.Id = priceListItem.Id;
			
            if (null != priceListItem.ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c && String.isNotBlank(priceListItem.ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c)) {
                pricingWrapper.pricingType = priceListItem.ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c;
            } else {
                pricingWrapper.pricingType = '';
            }
            
            if (materialTypesToValidate.contains(pricingWrapper.pricingType)) {
                pricingWrapper.sellerName = effectiveAccountWithRepresentative.YZ_Partner__r.ZS_Partner__r.User__r.Name;
                pricingWrapper.sellerEmail = effectiveAccountWithRepresentative.YZ_Partner__r.ZS_Partner__r.Email__c;
            } else {
				pricingWrapper.sellerName = effectiveAccountWithRepresentative.Primary_Seller__r.Name;     
                pricingWrapper.sellerEmail = effectiveAccountWithRepresentative.Primary_Seller__r.User_Email__c;
            }
            
            pricingWrapper.materialNumber = priceListItem.ccrz__Product__r.SAP_Material__r.Material_Number__c;
            pricingWrapper.materialDescription = priceListItem.ccrz__Product__r.SAP_Material__r.Name;
            pricingWrapper.customerMaterialNumber = priceListItem.Customer_Material_Number__c;
            pricingWrapper.customerName = ccrz.cc_CallContext.effAccount.Name;
            //get Inco Term from SAP Data
            /*
            String incoTerm = incoTermSAP.get(priceListItem.CPI_Freight_Terms__c);
            if (null != incoTerm) {
                pricingWrapper.incoTerms = incoTerm;
            } else {
                pricingWrapper.incoTerms = '';
            }*/
             pricingWrapper.incoTerms = priceListItem.CPI_Freight_Terms__c;
            
            if (null != tierPerItem) {
                pricingWrapper.tierList = tierPerItem;
            } else {
                pricingWrapper.tierList = new List<TierPricingWrapper>(); 
            }
            
            pricing.add(pricingWrapper);
        }
        
        return pricing;
        
    }
    
    // priceListItemId, Price Tier Item Tier
    public static Map<Id,  List<TierPricingWrapper>> getPriceListItemTierBulk(Map<Id, ccrz__E_PriceListItem__c> priceListItemsMap){
      
        Map<Id,  List<TierPricingWrapper>> tiers = new Map<Id,  List<TierPricingWrapper>>();
        Map<Id, List<ccrz__E_RuleTargetPLI__c>> pliRules = new Map<Id, List<ccrz__E_RuleTargetPLI__c>>(); // Id = ccrz__E_PriceListItem__c
        Map<Id, Id> rulesIds = new Map<Id, Id>();// pliRule.ccrz__E_Rule__c, ccrz__E_PriceListItem__c
        Set<Id> idsToRetrieve = new Set<Id>();
        List<Id> priceListItemsIds = new List<Id>(); 
        
        //We only need to retrieve a tier per product
        //no per price list item
        for (ccrz__E_PriceListItem__c priceListItem : priceListItemsMap.values()) {
            if(idsToRetrieve.add(priceListItem.ccrz__Product__c)) {
                priceListItemsIds.add(priceListItem.Id);
            }
        }
		        
        for (ccrz__E_RuleTargetPLI__c pliRule:[SELECT ccrz__E_Rule__c, ccrz__E_Rule__r.Name, ccrz__E_Rule__r.ccrz__RuleType__c, ccrz__E_PriceListItem__r.ccrz__Product__c,
              ccrz__E_PriceListItem__c, ccrz__E_PriceListItem__r.ccrz__StartDate__c, ccrz__E_PriceListItem__r.ccrz__EndDate__c,  ccrz__E_PriceListItem__r.CSP_Experation_Date__c FROM ccrz__E_RuleTargetPLI__c WHERE ccrz__E_PriceListItem__c IN:priceListItemsIds ORDER BY CreatedDate DESC]) {
  
                  List<ccrz__E_RuleTargetPLI__c> rulesOfThisPli = pliRules.get(pliRule.ccrz__E_PriceListItem__c);
                  if(rulesOfThisPli == null) {
                      rulesOfThisPli = new List<ccrz__E_RuleTargetPLI__c>();
                  }
                  
                  if (rulesOfThisPli.isEmpty()) {
                      rulesOfThisPli.add(pliRule);
                      rulesIds.put(pliRule.ccrz__E_Rule__c, pliRule.ccrz__E_PriceListItem__r.ccrz__Product__c);
                      pliRules.put(pliRule.ccrz__E_PriceListItem__c, rulesOfThisPli);
                  }
         }

        if (!pliRules.isEmpty()) {
      
            List<ccrz__E_RulePricingModifier__c> rpms = [SELECT ccrz__PriceModifier__r.ccrz__Amount__c, ccrz__PriceModifier__r.ccrz__Quantity__c, 
                                                         ccrz__PriceModifier__r.ccrz__DiscountType__c, ccrz__PriceModifier__r.Base_Price__c, 
                                                         ccrz__PriceModifier__r.Base_Price_UOM__c,ccrz__PriceModifier__r.Amount_UOM__c,ccrz__PriceModifier__r.Quantity_UOM__c,
                                                         ccrz__Rule__c, ccrz__StartDate__c, ccrz__EndDate__c,  ccrz__Rule__r.ccrz_pricelistitem__c
                                                         FROM ccrz__E_RulePricingModifier__c WHERE ccrz__Rule__c IN: rulesIds.keySet() ];
            
            for (ccrz__E_RulePricingModifier__c rpm : rpms) {
                Id priceListItemId = rulesIds.get(rpm.ccrz__Rule__c);
                List<ccrz__E_RuleTargetPLI__c> rulesOfThisPli = pliRules.get(rpm.ccrz__Rule__r.ccrz_pricelistitem__c);
                TierPricingWrapper tier = new TierPricingWrapper();
                String quantity = rpm.ccrz__PriceModifier__r.Quantity_UOM__c;
                if (quantity != null) {
                    tier.lowerBound = quantity;
                }
                tier.valueType = rpm.ccrz__PriceModifier__r.ccrz__DiscountType__c;
                tier.amount = rpm.ccrz__PriceModifier__r.Amount_UOM__c;
                tier.baseAmount = rpm.ccrz__PriceModifier__r.Base_Price_UOM__c;
                List<TierPricingWrapper> tiersByProduct = tiers.get(priceListItemId);
                  if(tiersByProduct == null) {
                      tiersByProduct = new List<TierPricingWrapper>();
                }

                if (null != rulesOfThisPli.get(0).ccrz__E_PriceListItem__r.ccrz__StartDate__c) {
                    tier.startDate = rulesOfThisPli.get(0).ccrz__E_PriceListItem__r.ccrz__StartDate__c.format();                 
                } else {
                    tier.startDate = '';
                }
                
                if (null != rulesOfThisPli.get(0).ccrz__E_PriceListItem__r.CSP_Experation_Date__c) {
                    tier.endDate = rulesOfThisPli.get(0).ccrz__E_PriceListItem__r.CSP_Experation_Date__c.format();                
                } else {
                    tier.endDate = '';
                }
                
                tiersByProduct.add(tier);    
                tiers.put(priceListItemId, tiersByProduct);
            }
        }
        
        return tiers;        
    }
    
    public static Boolean sendEmailToRepresentative(String priceListItemId, String bodyMessage, String subject){ 
        
        System.debug('FGG '+priceListItemId+' '+bodyMessage+' '+subject+' '+ccrz.cc_CallContext.effAccount.Id);
        Boolean isSuccessful = false;
        try {
        
            String customerName = ccrz.cc_CallContext.effAccount.Name;
            Id priceListItemIdFormat = Id.valueOf(priceListItemId);
            String representativeEmail = '';
            cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
            ccrz__E_PriceListItem__c priceListItem = [SELECT Id, ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c, ccrz__Product__r.SAP_Material__r.Name FROM ccrz__E_PriceListItem__c WHERE Id =: priceListItemIdFormat];
            String[] materialTypesToValidate = customSettings.Material_Type_Send_Email_Primary_Seller__c.split(',');
            Boolean sendEmailToSpecialtyPartner = false;
    		
            String currentMaterialType = (String.isBlank(priceListItem.ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c) ? '' : priceListItem.ccrz__Product__r.SAP_Material__r.Material_Group3_Desc__c.toLowerCase());
            //if the materialType is Commodity or Specialty
            //we are going to send to the  YZ_Partner__r email
            for (String materialType: materialTypesToValidate) {
               
                if (materialType.toLowerCase() == currentMaterialType) {
                    sendEmailToSpecialtyPartner = true;
                    break;
                }
            }
    
            Account effectiveAccountWithRepresentative = cc_imp_hlpr_AccountMyPricing.getAccountWithRepresentative(ccrz.cc_CallContext.effAccount.Id);
            System.debug('ccrz.cc_CallContext.effAccount.Id' + ccrz.cc_CallContext.effAccount.Id);
            System.debug(' effectiveAccountWithRepresentative ' + effectiveAccountWithRepresentative.Primary_Seller__c);
            System.debug(' effectiveAccountWithRepresentative ' + effectiveAccountWithRepresentative.Primary_Seller__r.User_Email__c);
            Map<Id, String> pageLabels = new Map<Id, String> ();
            for (ccrz__E_PageLabel__c pageLabel : [SELECT Id, ccrz__ValueRT__c FROM ccrz__E_PageLabel__c WHERE Id =: customSettings.My_Pricing_Nexeo_Email_Body__c ]) {
                        pageLabels.put(pageLabel.Id, pageLabel.ccrz__ValueRT__c);
            }
            
            //If we are going to send to Specialty Partner and the YZ_Partner__r email is not empty
            //then send to the YZ_Partner__r email
            if (sendEmailToSpecialtyPartner && String.isNotBlank(effectiveAccountWithRepresentative.YZ_Partner__r.ZS_Partner__r.Email__c) && effectiveAccountWithRepresentative.YZ_Partner__r.ZS_Partner__r.Email__c!=null) {
                System.debug('Send to SpecialtyPartner');
                representativeEmail = effectiveAccountWithRepresentative.YZ_Partner__r.ZS_Partner__r.Email__c;
            } else {
                // in this case we are going to send to the Primay Seller
                System.debug('Do not Send to SpecialtyPartner');
                representativeEmail = effectiveAccountWithRepresentative.Primary_Seller__r.User_Email__c;
            }
			System.debug('representativeEmail ' + representativeEmail);            
            String body = pageLabels.get(customSettings.My_Pricing_Nexeo_Email_Body__c);
            List<String> arguments = new List<String>();
            arguments.add(bodyMessage);
        
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			/*
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: customSettings.ORG_Default_Wide_Address__c];
            if ( owea.size() > 0 ) {
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            } */

            message.toAddresses = new String[] { representativeEmail };
            message.subject = subject;
            message.setHtmlBody(String.format(body, arguments));
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            isSuccessful = results[0].success; 
            System.debug('Send Email to Representative was ' + isSuccessful );
        } catch(Exception ex){
            System.debug('CP - message: ' + ex.getMessage());
            System.debug('CP - cause: ' + ex.getCause());
            System.debug('CP - trace: ' + ex.getStackTraceString());
        }
        
        return isSuccessful;
    }
    
    public static List<Automated_Price_Letter__c> getArchivedPriceLetters(){
        List<Automated_Price_Letter__c> accountAutomatedPriceLetters; 
        try {
            cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
            Integer numberOfRecordsToShow = Integer.valueOf(customSettings.Archived_Price_Letters_To_Show__c);
            accountAutomatedPriceLetters = [SELECT Id, CreatedDate, Name, Download__c, Attachment_Id__c FROM Automated_Price_Letter__c WHERE Account__c =: ccrz.cc_CallContext.effAccount.Id  ORDER BY CreatedDate DESC LIMIT :numberOfRecordsToShow];
        } catch(Exception ex){
            accountAutomatedPriceLetters = new List<Automated_Price_Letter__c>();
            System.debug('CP - message: ' + ex.getMessage());
            System.debug('CP - cause: ' + ex.getCause());
            System.debug('CP - trace: ' + ex.getStackTraceString());
        }
        
        return accountAutomatedPriceLetters;
    }
    
    public static Integer getTotalPages(String searchFormData, Id priceListId){
        Integer totalPages = 0; 
        try {
             	cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
             	Integer recordsPerPage = Integer.valueOf(customSettings.Pagination_My_Pricing__c);
             		// First we are going to retrieve the price List items     
                List<Id> idsToRetrievePriceListTiers = new List<Id>();  
                PricingQueryWrapper wrapper;
            	if(null != searchFormData && String.isNotEmpty(searchFormData)) {
                	wrapper =  PricingQueryWrapper.parse(searchFormData);
            	}
                Date theDay = Date.today();
                String priceListIdString = String.valueOf(priceListId);
            	String query = 'SELECT COUNT()';
                query += ' FROM ccrz__E_PriceListItem__c WHERE ccrz__Pricelist__c =: priceListIdString ';
                query += ' AND ccrz__Product__r.ccrz__ProductStatus__c in :STATUSES ';
                query += ' AND ccrz__StartDate__c <= :theDay ';
                query += ' AND ccrz__EndDate__c >= :theDay ';
                query += ' AND ccrz__Product__r.ccrz__StartDate__c <= :theDay ';
                query += ' AND ccrz__Product__r.ccrz__EndDate__c >= :theDay ';
            
                if (null != wrapper) {
                    if (null != wrapper.searchDataInput && String.isNotEmpty(wrapper.searchDataInput)) {
                        String valueToUseOnLike = '%' + wrapper.searchDataInput + '%';
                        query += ' AND ';
                        query += ' ( ';
                        query += ' ccrz__Product__r.SAP_Material__r.Name LIKE :valueToUseOnLike ';
                        query += ' OR ';
                        query += ' Account_Material__r.Customer_Material_Number__c LIKE :valueToUseOnLike ';
                        query += ' )';
                    } 
                }
            	
        
            	Integer totalRecords = Database.countQuery(query);
            	System.debug('totalRecords ' + totalRecords);	
			            	
            	totalPages = (Integer) Math.ceil((Decimal) totalRecords / recordsPerPage);
				System.debug('totalPages ' + totalPages);	
        } catch(Exception ex){
           
            System.debug('CP - message: ' + ex.getMessage());
            System.debug('CP - cause: ' + ex.getCause());
            System.debug('CP - trace: ' + ex.getStackTraceString());
        }
        
        return totalPages;
    }
    
    /*
    public static List<MyPrincingWrapper> getPricingBasedOnFormData(Id priceListId, String searchFormData) {
        //first get all 
        
        PricingQueryWrapper wrapper =  PricingQueryWrapper.parse(searchFormData);
		Boolean useSpecialSorting = false;
        if (null != wrapper.sortCriteria && String.isNotEmpty(wrapper.sortCriteria)) {
            if (pricingSpecialSortSet.contains(wrapper.sortCriteria)) {
           		useSpecialSorting = true;
            }
        }
		
        if (useSpecialSorting) {
        
        } else {
			return getPricingByParams(priceListId, searchFormData, true);        
        }
        for (MyPrincingWrapper currentPricing: myPricing) {
            if (wrapper.sortDir.contains('ASC')) {
                currentPricing.isAscending = true;  
            } else {
              currentPricing.isAscending = false;  
            }
            
        }
        myPricing.sort()
        return myPricing;
    }*/
    
    
}