/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/07/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for Wrapper orderItemsWrapper
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class OrderItemsWrapper_Test {

    @IsTest
    public static void wrapper() {
        orderItemsWrapper orderItem = new orderItemsWrapper();
       	orderItem.nexeoMaterialId = 'SAP MaterialId';
        orderItem.productNumber = 'ProductNumber'; 
        orderItem.batchNumber = '';
        orderItem.batchNumber1 = ''; 
        orderItem.batchNumber2 = ''; 
        orderItem.batchNumber3 = ''; 
        orderItem.batchNumber4 = ''; 
        orderItem.batchNumber5 = ''; 
        orderItem.batchNumber6 = ''; 
        orderItem.batchNumber7 = ''; 
        orderItem.batchNumber8 = ''; 
        orderItem.batchNumber9 = ''; 
        orderItem.batchNumber10 = ''; 
        orderItem.batchNumber11 = ''; 
        orderItem.batchNumber12 = ''; 
        orderItem.batchNumber13 = ''; 
        orderItem.batchNumber14 = ''; 
        orderItem.batchNumber15 = ''; 
        orderItem.sequenceNumber = 7; 
        orderItem.orderId = 'id'; 
        orderItem.orderSFDCId = 'salesforceId'; 
        orderItem.orderItemId = 'Id'; 
        orderItem.customerMaterialNumber = 'materialNumber'; 
        orderItem.priceperunit = 10.8; 
        orderItem.sku = 'orderitem';
        orderItem.po = 'ponumber'; 
        orderItem.productdescription = 'decription'; 
        orderItem.Qty = 'qty'; 
        orderItem.SUOM = 'SUOM'; 
    }
}