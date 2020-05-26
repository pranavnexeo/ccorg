trigger PackageDuplicatePreventer on Chemical_Package_Request__c(before insert, before update) {
    
    List<Id> CheReq=new List<Id>(); 
    Map<String, Chemical_Package_Request__c> cprMap = new Map<String, Chemical_Package_Request__c>();
    for (Chemical_Package_Request__c cpr : System.Trigger.new) {
       
        CheReq.add(cpr.Chemical_Request__c); 
         
    
        if ((cpr.Package_Type__c != null) && 
                (System.Trigger.isInsert ||
                (cpr.Package_Type__c != 
                    System.Trigger.oldMap.get(cpr.Id).Package_Type__c))) {
        
               
            if (cprMap.containsKey(cpr.Package_Type__c)) {
                cpr.Package_Type__c.addError('Another new Chemical Package Rquest for this Chemical Request has the '
                                    + 'same Package Type address.');
            } else {
                cprMap.put(cpr.Package_Type__c, cpr);
            }
       }
    }
    
      
    
    for (Chemical_Package_Request__c cpr : [SELECT Package_Type__c,Chemical_Request__c FROM Chemical_Package_Request__c
                      WHERE Package_Type__c IN :cprMap.KeySet() and Chemical_Request__c=:CheReq]) {
        Chemical_Package_Request__c newpackage = cprMap.get(cpr.Package_Type__c);
        newpackage.Package_Type__c.addError('A Chemical Package Rquest with this Package Type for this Chemical Request'
                               + 'already exists.');
    }
}