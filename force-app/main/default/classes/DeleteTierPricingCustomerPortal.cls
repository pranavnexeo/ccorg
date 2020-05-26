/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/1/2016
*    Author:             Francisco Garcia
*   Last Modified:       03/23/2017
*   Last Modified By:   Naren Karthik
*
*   Short Description:  Delete Stored tier pricing in cc objects before get new ones. 
*                    - Fix for "Too many DML rows: 10001" on Update of SAP returned PriceListItem 
*   **********************************************************************************************************************/
public without sharing class DeleteTierPricingCustomerPortal {
    
    
     public boolean deleteTiers(Set<Id> PriceListItems){
         
         System.debug('Check point 5a : '+Limits.getDMLRows());
         
         // Delete Rules.   
         List<ccrz__E_Rule__c> lstrulesToDelete = new List<ccrz__E_Rule__c>([select Id from ccrz__E_Rule__c where ccrz_pricelistitem__c in:PriceListItems]);
         
         System.debug('Check point 5b : '+Limits.getDMLRows());
         // Delete RuleTargetPLI's
         List<ccrz__E_RuleTargetPLI__c> lstruleTargetPLIToDelete = new List<ccrz__E_RuleTargetPLI__c>([select Id from ccrz__E_RuleTargetPLI__c where ccrz__E_PriceListItem__c in:PriceListItems]);

         System.debug('Check point 5c : '+Limits.getDMLRows());
         // Delete Price Modifiers
         List<ccrz__E_PriceModifier__c> lstPriceModifierToDelete = new List<ccrz__E_PriceModifier__c>([select Id from ccrz__E_PriceModifier__c where ccrz_PriceListItem__c in:PriceListItems]);

         System.debug('Check point 5d : '+Limits.getDMLRows());
         // Delete Rule Pricing Modifiers
         List<ccrz__E_RulePricingModifier__c> lstrulePricingModifierToDelete = new List<ccrz__E_RulePricingModifier__c>([select Id from ccrz__E_RulePricingModifier__c where ccrz__Rule__c in:lstrulesToDelete]);
         
         System.debug('Number of cc Rules deleted :'+lstrulesToDelete.size());
         System.debug('Number of cc Rule Target PLIs deleted :'+lstruleTargetPLIToDelete.size());
         System.debug('Number of cc Price modifiers deleted :'+lstPriceModifierToDelete.size());
         System.debug('Number of cc Rule price modifiers deleted :'+lstrulePricingModifierToDelete.size());
         
         System.debug('Check point 5e : '+Limits.getDMLRows());
         
         try{
             System.debug(lstrulePricingModifierToDelete[0].id);
             delete lstrulePricingModifierToDelete;
         	 System.debug(lstPriceModifierToDelete[0].id);          
             delete lstPriceModifierToDelete;
             delete lstruleTargetPLIToDelete;
             delete lstrulesToDelete;
             System.debug('Check point 5f : '+Limits.getDMLRows());
             return true;
         }catch(Exception ex){
            return false;    
         }
    }   
}