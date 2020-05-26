/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:       08 / 15 / 2018
*   Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Controller for My Pricing Page.
*   
*   
*	
*   **********************************************************************************************************************/
global with sharing class cc_mn_ctrl_MyPricing {
    
    global String archivedPriceLetters {get; set;}
    global List<MyPrincingWrapper> pricingPerAccountList {get; set;}
    global Integer totalPagesPricing {get; set;}
    global Integer totalRecordsPerPage {get; set;}
	global static Integer totalRecords {get; set;}
    
    
    global cc_mn_ctrl_MyPricing() {
        cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        totalRecordsPerPage = Integer.valueOf(customSettings.Pagination_My_Pricing__c);
        getArchivedPriceLetters();
       // getTotalPages();
    }
    
    /**
     * In order to get the total pages that we could have per this acccount
     * 
	*
    global Integer getTotalPages() {
        Integer totalPages = 1;
         try{
			System.debug('ccrz.cc_CallContext.effAccount.Id: ' + ccrz.cc_CallContext.effAccount.Id );
            Id currentPriceListId = [SELECT cc_imp_MyProductList__c FROM Account WHERE Id =: ccrz.cc_CallContext.effAccount.Id].cc_imp_MyProductList__c;
			System.debug('currentPriceListId: ' + currentPriceListId);
            String seachFormData = '';
            totalPages = cc_imp_hlpr_MyPricing.getTotalPages(seachFormData, currentPriceListId);
        }catch(Exception ex){
            System.debug('CP-Exception: '+ex.getLineNumber()+' '+ex.getMessage() + ' ' + ex.getStackTraceString());
            totalPages = 0;
        }
        return totalPages;
        
    }*/
    
    /**
     * In order to get the Archived Price letters of current user and current effective account
     * 
	**/
    global void getArchivedPriceLetters() {
        //In order to know how many Archives Price Letters we are going to show on the view
        //we are going to get the value from a custom setting
        System.debug('CP-Exception: ' + ccrz.cc_CallContext.effAccount.Id);
        try{
            archivedPriceLetters = JSON.serialize(cc_imp_hlpr_MyPricing.getArchivedPriceLetters());
        }catch(Exception ex){
            System.debug('CP-Exception: '+ex.getLineNumber()+' '+ex.getMessage());
            archivedPriceLetters = JSON.serialize(new List<Automated_Price_Letter__c> ());
        }            
    }
    
    /**
     * In order to get the list of all prices of the products related to the current 
     * effective account
     * 
	**/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getAllPricesPerAccount(ccrz.cc_RemoteActionContext ctx) {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        Boolean isSuccessful = true;
        Map<String, Object> mapToReturn;
        Integer totalPagesPerPriceList = 0;

        try {
            //First we are going to retrieve the Price List Id realted to the account
            Id currentPriceListId = [SELECT cc_imp_MyProductList__c FROM Account WHERE Id =: ccrz.cc_CallContext.effAccount.Id].cc_imp_MyProductList__c;
            //Using the price list Id we are going to retrieve the Price List items
            List<MyPrincingWrapper> myPricingListByAccount = cc_imp_hlpr_MyPricing.getAllPricing(currentPriceListId);
            totalPagesPerPriceList = cc_imp_hlpr_MyPricing.getTotalPages('', currentPriceListId);
            mapToReturn = new Map<String,Object>{'success' => true, 'pricing' => myPricingListByAccount, 'totalPagesPerPriceList' => totalPagesPerPriceList};
        } catch (Exception ex){
            isSuccessful = false;
          	mapToReturn = new Map<String, Object>{'success' => false, 'totalPagesPerPriceList' => totalPagesPerPriceList,'message' => ex.getMessage(), 'cause' => ex.getCause(), 'trace' => ex.getStackTraceString()};
        }
        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, isSuccessful, mapToReturn);

        return response;
    }    
    
    /**
     * In order to get the list of all prices of the products related to the current 
     * effective account
     * 
	**/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult searchAllPricesPerAccountByParams(ccrz.cc_RemoteActionContext ctx, String searchFormData) {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        Boolean isSuccessful = true;
        Map<String, Object> mapToReturn;
        Integer totalPagesPerPriceList = 0;
        System.debug(' searchFormData ' + searchFormData);
        try {
            //First we are going to retrieve the Price List Id realted to the account
            Id currentPriceListId = [SELECT cc_imp_MyProductList__c FROM Account WHERE Id =: ccrz.cc_CallContext.effAccount.Id].cc_imp_MyProductList__c;
            //Using the price list Id we are going to retrieve the Price List items
            List<MyPrincingWrapper> myPricingListByAccount = cc_imp_hlpr_MyPricing.getPricingByParams(currentPriceListId, searchFormData.unescapeHtml4());
            totalPagesPerPriceList = cc_imp_hlpr_MyPricing.getTotalPages(searchFormData, currentPriceListId);
            mapToReturn = new Map<String,Object>{'success' => true, 'pricing' => myPricingListByAccount, 'totalPagesPerPriceList' => totalPagesPerPriceList};  
        } catch (Exception ex){
            isSuccessful = false;
          	mapToReturn = new Map<String, Object>{'success' => false, 'totalPagesPerPriceList' => totalPagesPerPriceList, 'searchFormData' => searchFormData , 'message' => ex.getMessage(), 'cause' => ex.getCause(), 'trace' => ex.getStackTraceString()};
        }
        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, isSuccessful, mapToReturn);

        return response;
    }
    
    /**
     * In order to get the list of all prices of the products related to the current 
     * effective account
     * 
	**/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult sendMaterialEmail(ccrz.cc_RemoteActionContext ctx, String priceListItemId, String bodyMessage, String subject) {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        Boolean isSuccessful = false;
        Map<String, Object> mapToReturn;
        try {
            //First we are going to retrieve the Price List Id realted to the account
         //   Id currentPriceListId = [SELECT cc_imp_MyProductList__c FROM Account WHERE Id =: ccrz.cc_CallContext.effAccount.Id].cc_imp_MyProductList__c;
            //Using the price list Id we are going to retrieve the Price List items
            //List<MyPrincingWrapper> myPricingListByAccount = cc_imp_hlpr_MyPricing.getPricingByParams(currentPriceListId, searchFormData);
            isSuccessful = cc_imp_hlpr_MyPricing.sendEmailToRepresentative(priceListItemId, bodyMessage, subject);
            mapToReturn = new Map<String,Object>{'success' => isSuccessful, 'message' => 'Messae sent' };
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, mapToReturn);
        } catch (Exception ex){
            isSuccessful = false;
          	mapToReturn = new Map<String, Object>{'success' => false, 'message' => ex.getMessage(), 'cause' => ex.getCause(), 'trace' => ex.getStackTraceString()};
        }
        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, isSuccessful, mapToReturn);

        return response;
    }    
    

}