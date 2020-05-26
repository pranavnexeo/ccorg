public class CP_Mon_Queueable implements Queueable, Database.AllowsCallouts{
    
    public void execute(QueueableContext context) {

        cc_imp_WebServiceMonitoring mon = new cc_imp_WebServiceMonitoring();
    }

}