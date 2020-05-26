Global class expiredCdfDelete implements Database.Batchable<sObject> {
	Global String q;
    List<Contract> con = New List<Contract>();
    Date olddate = system.today().addyears(-2);
    String stat = 'Expired';
    global expiredCdfDelete(){
      q = 'select Id, Status, EndDate from Contract where Status =: stat and EndDate <= :olddate';
      

    }

    Global Database.QueryLocator Start(Database.BatchableContext bcMain){
        return Database.getQueryLocator(q);
    }
    
    Global void Execute(Database.BatchableContext bcMain, List<Contract> cList){
 
       
           
    if(!cList.isempty()){
        for(Contract c: cList){
           
            if(c.EndDate <= olddate && c.Status == 'Expired'){
               
                 con.add(c); 
            }           
        }
    delete con;
    }    
    }
    
    Global void finish(Database.BatchableContext bcMain){
    }
}