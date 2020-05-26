Global Class SalesVarianceBatch implements Database.Batchable<SObject>{
    Global String q;
    List<SalesChurn__c> toupdatesaleschurn = New List<SalesChurn__c>();
    global SalesVarianceBatch(){
        q = 'select Id,Material_code__c,Account_Number__r.SAP_DivisionCode__c,Material_Code__r.Material_Desc__c,';
        q += 'Material_Code__r.Material_General_Data__c,Material_Code__r.Material_General_Data__r.Material_Base_Code__c,';
        q += 'Churn_Date__c,Base_Code_Description__c,ShipTo_Name__c,Name,ownerid,Account_Number__r.Specialty_Seller__c,';
        q += 'Account_Number__r.OwnerId from SalesChurn__c';
    }

    Global Database.QueryLocator Start(Database.BatchableContext bcMain){
        return Database.getQueryLocator(q);
    }
    
    Global void Execute(Database.BatchableContext bcMain, List<SalesChurn__c> scList){
 
        system.debug('scList '+scList);        
        for(SalesChurn__c  sc: scList){
            system.debug('sc.Account_Number__r.OwnerId is ****'+sc.Account_Number__r.OwnerId);
            system.debug('sc.ownerid is ****'+sc.ownerid);
            if(sc.Account_Number__r.SAP_DivisionCode__c == '31'){
                if(sc.Account_Number__r.Specialty_Seller__c != null){
                    if(sc.ownerid != sc.Account_Number__r.Specialty_Seller__c){
                        sc.ownerid=sc.Account_Number__r.Specialty_Seller__c;
                        toupdatesaleschurn.add(sc);
                    }
                }
                else{
                    if(sc.ownerid != sc.Account_Number__r.OwnerId){
                        sc.ownerid=sc.Account_Number__r.OwnerId;
                        toupdatesaleschurn.add(sc);
                    }
                }  
            }           
        }
    update toupdatesaleschurn;
    }
    
    Global void finish(Database.BatchableContext bcMain){
    }
}