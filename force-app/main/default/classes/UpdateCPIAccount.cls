/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/22/2016
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Update CPI Account Lookup fields.
*   **********************************************************************************************************************/

public class UpdateCPIAccount {

    public void updateCPI(Map<Id,Id> CPIMap){
    	try{
        System.debug('FGG Call UpdateCPI');
        List<Customer_Product_Info__c> cpitoUpdate= new List<Customer_Product_Info__c>();
        Set<Id> ids=new set<Id>();
        
        ids=CPIMap.keySet();
        System.debug('List of Set size:'+ids.size());
        for(Customer_Product_Info__c cpi:[select CPI_Account__c from Customer_Product_Info__c where Id in:ids]){
            cpi.CPI_Account__c=CPIMap.get(cpi.Id);
            
            cpitoUpdate.add(cpi);
        	System.debug('FGG Call UpdateCPInside');
        }
        update cpitoUpdate;
    	}
    	catch(Exception exc){
    		
    	System.debug('Error in update UpdateCPIAccount');
    	}
    }
}