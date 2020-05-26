/**  
* @Name PriceSupportSupplierPIscheduler* @Purpose This class is used to schedule the process of updating the PI Number of the PriceSupports 
* @Author  Chandrakant
* @Version 1.0 
*/
global class PriceSupportSupplierPIscheduler implements Schedulable{
    
    global void execute (SchedulableContext SC){
    
        Update_PriceSuppforSuppProf_Records con=new Update_PriceSuppforSuppProf_Records();
         con.update_Method();
    
    }

}