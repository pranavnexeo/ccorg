trigger DeletePSJunctionRecords on SAP_Price_Support__c (Before Update) {
List<Price_Support_Junction__c> psj = new List<Price_Support_Junction__c>();
List<SAP_Price_Support__c> Sapprice = new List<SAP_Price_Support__c>();

    for(SAP_Price_Support__c ps : trigger.new){
        If(ps.Expiration_Date__c < system.today() || ps.Effective_Date__c > system.today() || ps.Deletion_Indicator__c == 'X'){
            Sapprice.add(ps);    
        }
    }
    If(Sapprice.size() > 0){
        psj = [Select id from Price_Support_Junction__c where SAP_Price_Support__c =: Sapprice];
    }
    If(Sapprice.size() > 0){
        delete psj;
    }
}