/**  
* @Name PriceSupportMaterialScheduler* @Purpose This class is used to schedule the process of updating the Material Related Field of the PriceSupports 
* @Author  Chandrakant
* @Version 1.0 
*/
global class PriceSupportMaterialScheduler implements Schedulable{
    
    global void execute (SchedulableContext SC){
    
        Update_PriceSuppMaterialFields_Records con=new Update_PriceSuppMaterialFields_Records();
         con.update_Method();
    
    }

}