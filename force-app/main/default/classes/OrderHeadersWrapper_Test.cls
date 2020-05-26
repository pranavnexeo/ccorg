/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/07/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for Wrapper orderHeadersWrapper
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class OrderHeadersWrapper_Test {
    
    @IsTest
    public static void wrapper() {
        orderHeadersWrapper newHeader = new orderHeadersWrapper();
        newHeader.poNumber = 'poNumber';
        newHeader.orderNumber = 'orderNumber';  
        newHeader.status = 'status';
        newHeader.encryptedid = 'id';        
    }

}