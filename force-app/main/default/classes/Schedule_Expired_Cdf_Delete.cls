global without sharing class Schedule_Expired_Cdf_Delete implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        expiredCdfDelete b = new expiredCdfDelete();
        database.executebatch(b,200);
    }
    
}