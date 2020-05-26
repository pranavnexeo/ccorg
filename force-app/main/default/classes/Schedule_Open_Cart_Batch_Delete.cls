/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        04/04/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/04/2017
*
*   Short Description:  Schdeule Class for CC_Open_Cart_Delete_BatchClass.
*   **********************************************************************************************************************/


global without sharing class Schedule_Open_Cart_Batch_Delete implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        CC_Open_Cart_Delete_BatchClass b = new CC_Open_Cart_Delete_BatchClass();
        database.executebatch(b,200);
    }
    public void scheduleit()
    {
        Schedule_Open_Cart_Batch_Delete sch_class = new Schedule_Open_Cart_Batch_Delete();
        String cron_exp = '0 0 20 * * ?';
        if(!Test.isRunningTest())
        {        
        	System.schedule('Delete Open Carts at 8:00 P.M everyday', cron_exp, sch_class);
        }
        else
        {
            System.schedule('Test Delete Open Carts', cron_exp, sch_class);
        }
    }
}