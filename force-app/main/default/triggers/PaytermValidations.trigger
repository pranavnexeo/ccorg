trigger PaytermValidations on Pay_Term_Request__c (before Update) {  
    for (Pay_Term_Request__c a : Trigger.new) {
        system.debug('a.Status__c '+a.Status__c);
        system.debug('a.Approved_Terms__c '+a.Approved_Terms__c);
        
        if ((a.Status__c == 'Waiting Director Approval')&&(a.Approved_Terms__c==null)) {
                
            a.addError('Please fill the "Approved Terms" for the Pay Term request <a style=\'color:1B2BE0\' href=\'/' + a.id+ '\'>Click here to edit the record</a>');
        } 
       else if ((a.Status__c == 'Waiting VP Approval')&&(a.Is_VP_Approval_Required__c==null)) {
                
            a.addError('Please fill the "Is VP Approval Required for Next Approval" for the Pay Term request <a style=\'color:1B2BE0\' href=\'/' + a.id+ '\'>Click here to edit the record</a>');
        }                                                         
    }
}