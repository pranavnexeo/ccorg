/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        04/04/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/04/2017
*
*   Short Description:  Schdeule Class for CC_Prospect_Cart_Delete_BatchClass.
*   **********************************************************************************************************************/


global without sharing class Schedule_Prospect_Cart_Batch_Delete implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        CC_Prospect_Cart_Delete_BatchClass b = new CC_Prospect_Cart_Delete_BatchClass();
        database.executebatch(b,200);
    }
    public void scheduleit()
    {
        Schedule_Prospect_Cart_Batch_Delete sch_class = new Schedule_Prospect_Cart_Batch_Delete();
        String cron_exp = '0 0 1,3,5,7,9,13,15,17,19,21,23 * * ?';
        if(!Test.isRunningTest())
        {
        	System.schedule('Delete Prospect Carts every 2 hours', cron_exp, sch_class);
        }
        else
        {
            System.schedule('Test Delete Prospect Carts', cron_exp, sch_class);
        }
    }
}