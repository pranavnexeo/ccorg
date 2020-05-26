@isTest
Public class SalesVarianceBatch_sch_Test{
    public static testMethod void TestMe(){
        SchedulableContext scMain;
        SalesVarianceBatch_sch var = new SalesVarianceBatch_sch();
        var.execute(scMain);
    }
}