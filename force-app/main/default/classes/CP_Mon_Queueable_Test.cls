@IsTest
public class CP_Mon_Queueable_Test {

       static testmethod  void testMonitoring(){
        
        cc_imp_mon_testUtils.initData();   
        Test.startTest();     
        CP_Mon_Queueable ad = new CP_Mon_Queueable();
        ID jobID = System.enqueueJob(ad);
        Test.stopTest();       
        
    }
}