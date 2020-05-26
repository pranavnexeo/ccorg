/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        04/13/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/13/2017
*
*   Short Description:  Class to populate Invoice number from CC Invoice into CC orders by matching 
*                       SAP Order Id fields in CC Invoice and CC orders.
*   **********************************************************************************************************************/

public class CC_nex_Invoice 
{

    public static void update_SAPinvoice_in_ccorder(List<ccrz__E_Invoice__c> invoices)
    {
        Map<String, String> ordid_to_invid= new Map<String, String>();
        
        for(ccrz__E_Invoice__c inv : invoices)
        {
            if(inv.SAP_Order_ID__c != NULL && inv.ccrz__InvoiceId__c != NULL && inv.ccrz__Storefront__c == 'nexeo3d')
            {
                ordid_to_invid.put(inv.SAP_Order_ID__c,inv.ccrz__InvoiceId__c);
            }            
        }
        
        List<ccrz__E_Order__c> orders = [Select Id, ccrz__OrderId__c from ccrz__E_Order__c where ccrz__OrderId__c in : ordid_to_invid.keySet()];
        
        for(ccrz__E_Order__c ord : orders)
        {
            if(ordid_to_invid.get(ord.ccrz__OrderId__c) != NULL)
            {
                ord.Invoice_Number__c = ordid_to_invid.get(ord.ccrz__OrderId__c);
            }
        }
        System.debug(orders);
        try
        {
        	update orders;
        }
        catch(Exception e)
        {
            System.debug('Error in updating orders with invoice numbers from SAP :' + e.getMessage());
        }
    }
}