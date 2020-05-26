trigger CompatibilityDuplicatePreventer on Container_Chemical_Junction__c(before insert) {
  
    List<Id> CheReq=new List<Id>(); 
    Map<String, Container_Chemical_Junction__c> cprMap = new Map<String, Container_Chemical_Junction__c>();
    Map<String, Container_Chemical_Junction__c> cprccjMap = new Map<String, Container_Chemical_Junction__c>();
    Boolean isThereNewStandardRecord = false;
    
    for (Container_Chemical_Junction__c cpr : System.Trigger.new) {
    
        if(cpr.Compatibility__c == 'Standard'){
            isThereNewStandardRecord = true;
        }
        CheReq.add(cpr.Chemical_Package_Request__c); 
    
        if ((cprccjMap.containsKey(cpr.Container_Specification_Document__c))) {
            
            cpr.Container_Specification_Document__c.addError('Same container cannot be added for different compatibilities.');
            
        }else if (cprMap.containsKey('Standard')){
            
            cpr.Container_Specification_Document__c.addError('There can be only one container with Standard compatibility.');
                             
        } else {
            cprMap.put(cpr.Compatibility__c, cpr);
            cprccjMap.put(cpr.Container_Specification_Document__c, cpr);
        }
    
    }
    
    if(isThereNewStandardRecord){ 
    
        for (Container_Chemical_Junction__c cpr : [SELECT Compatibility__c,Chemical_Package_Request__c 
            FROM Container_Chemical_Junction__c WHERE Compatibility__c = 'Standard'
                and Chemical_Package_Request__c=:CheReq]) {
            
                Container_Chemical_Junction__c newpackage = cprMap.get(cpr.Compatibility__c);
                newpackage.Compatibility__c.addError('There can be only one container with Standard compatibility.');
        }
    }
    
    
    for (Container_Chemical_Junction__c cpr1 : [SELECT Compatibility__c,Chemical_Package_Request__c,
        Container_Specification_Document__c FROM Container_Chemical_Junction__c 
            WHERE Container_Specification_Document__c IN :cprccjMap.KeySet() 
                and Chemical_Package_Request__c=:CheReq]) {
      
        
        Container_Chemical_Junction__c newpackage1 = cprccjMap.get(cpr1.Container_Specification_Document__c);
        newpackage1.Container_Specification_Document__c.addError('Same container cannot be added for different compatibilities.');
                               
    }
}