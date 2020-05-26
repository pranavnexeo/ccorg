Global Class DataDeletion_OpenOrders_Sch implements Schedulable{
    global void execute(SchedulableContext sc){
         DataDeletion_OpenOrders O = new DataDeletion_OpenOrders();
         database.executebatch(O,200); 
    }  
}