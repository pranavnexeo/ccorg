/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        04/04/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/04/2017
*
*   Short Description:  Test class for Schedule_Open_Cart_Batch_Delete Class.
*   **********************************************************************************************************************/


@isTest
private class Schedule_Open_Cart_Batch_Delete_Test {
    static testmethod void test1(){
        Test.startTest();
        Schedule_Open_Cart_Batch_Delete sp = new Schedule_Open_Cart_Batch_Delete();
        sp.scheduleit();   
        Test.stopTest();
    }  
}