//Global Class auditlogdelettion implements Database.Batchable<SObject>{
Global Class auditlogdelettion {
    /*
    Global String q;
    List<Audit_Log__c> aduitlog = New List<Audit_Log__c>();
    
    global auditlogdelettion(){
      q = 'select Id,CreatedDate,Record_Type__c from Audit_Log__c';
      

    }

    Global Database.QueryLocator Start(Database.BatchableContext bcMain){
        return Database.getQueryLocator(q);
    }
    
    Global void Execute(Database.BatchableContext bcMain, List<Audit_Log__c> scList){
 
       
           
    if(!scList.isempty()){
    
        DateTime newDate = System.Now().addYears(-2);  
        
        for(Audit_Log__c sc: scList){
           
            if(sc.createddate < newDate || sc.Record_Type__c== 'KNA1'){
               
                 aduitlog.add(sc); 
            }           
        }
    delete aduitlog;
    }    
    }
    
    Global void finish(Database.BatchableContext bcMain){
    }
*/
}