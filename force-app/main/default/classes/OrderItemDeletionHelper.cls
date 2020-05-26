/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/6/2016
*   Author:              Shwetha Suvarna
*   Last Modified:       10/13/2016
*   Last Modified By:    Shwetha Suvarna
*
*   Short Description:   Helper class to delete the orderitem for order for which SAP delete reject flag is D or R 
*   **********************************************************************************************************************/
global Class OrderItemDeletionHelper{
@future
    public static void deleteOrder(set<id> ordrItem){
        if(ordrItem.size()>0){
        list<ccrz__E_OrderItem__c> oi = [select id, name from ccrz__E_OrderItem__c where id in : ordrItem];
        	if(oi.size()>0) {
            	delete oi;
        	}  
        } 
    }
}