@isTest 
Private class DataDeletion_OpenOrders_Sch_Test{
    public static testMethod void TestMe(){
       
     SchedulableContext sc = null;
     DataDeletion_OpenOrders_Sch oos = new DataDeletion_OpenOrders_Sch();
     String sch = '0 0 23 * * ?';
     system.schedule('DataDeletion_OpenOrders',sch,oos);
    
     
    }
}