@isTest
public class Schedule_CP_Mon_WS_Test {
    
    public static String CRON_EXP = '0 0 0/2 1/1 * ? *';
    
    static testmethod void test1(){
        cc_imp_mon_testUtils.initData();   
        Test.startTest(); 
        String jobId = System.schedule('Schedule_CP_Mon_WS', CRON_EXP, new Schedule_CP_Mon_WS());
        Test.stopTest();
    }
}