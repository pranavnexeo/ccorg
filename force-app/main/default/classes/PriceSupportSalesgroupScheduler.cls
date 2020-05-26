/**  
* @Name PriceSupportSalesforceSchedule* @Purpose This class is used to schedule the process of updating the sales group of the PriceSupports 
* @Author  Chandrakant
* @Version 1.0 
*/
global class PriceSupportSalesgroupScheduler implements Schedulable{
    
    global void execute (SchedulableContext SC){
    
        Update_PriceSupport_Records con=new Update_PriceSupport_Records();
         con.update_Method();
    
    }

}