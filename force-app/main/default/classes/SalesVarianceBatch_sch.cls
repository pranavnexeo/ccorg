Global Class SalesVarianceBatch_sch implements Schedulable{
    global void execute(SchedulableContext sc){
        SalesVarianceBatch sv = new SalesVarianceBatch();
        id idBatch = database.executeBatch(sv);
    }
}