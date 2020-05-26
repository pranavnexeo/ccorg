trigger updateAlternateToRequested on Price_Request_Transaction__c (after update) {
    Set<Id> PRTIds = new Set<Id>(); 
    Set<Id> PRTIdsAll = new Set<Id>(); 
//    Map<Id,String> PRTIdandCommentsMap = new Map<Id,String>();
    set<String>types = new set<String>{'Requested', 'Alternate'};
    List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
    
    //Approving Rejecting the records 
    system.debug('Inside trigger:'+Trigger.old[0].Approval_Status__c+'::'+Trigger.new[0].Approval_Status__c);
    if(Trigger.new[0].RejectAlternateFlag__c == true && Trigger.new[0].Approval_Status__c == 'Rejected-Alternate'){
        List<ProcessInstanceWorkitem> PWIs = [select id, ProcessInstance.TargetObjectId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :Trigger.new[0].id];
        system.debug('PWIs:'+PWIs );
        if(PWIs.size()>0){
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving the request as per 96 Hour Rule.');
        req2.setAction('Approve');   
        req2.setWorkitemId(PWIs[0].id);    
        
        
        Approval.ProcessResult results =  Approval.process(req2);
        
     
        }
    }
    
    for(Integer i=0;i<Trigger.new.size();i++){
    system.debug('Entered for:'+Trigger.old[i].Approval_Status__c+'::'+Trigger.new[i].Approval_Status__c);
        if(Trigger.old[i].Approval_Status__c == 'Rejected-Alternate' && (Trigger.new[i].Approval_Status__c == 'Pending Entry' || Trigger.new[i].Approval_Status__c == 'Approved' || Trigger.new[i].Approval_Status__c == 'SAP Transfer Open'))
            PRTIds.add(Trigger.new[i].Id);
        
        PRTIdsAll.add(Trigger.new[i].Id);
    }
    
    if(PRTIds.size()>0)
    {    sapprices = [select id, type__c,Price_Request_Transaction__c from SAP_Price__c where Price_Request_Transaction__c IN :PRTIds and type__c IN :types];
    
        
     }
    
    integer count = 0;
    
    for(String t:PRTIds){  
        for(Sap_Price__c pr:sapprices){ 
            if(pr.Price_Request_Transaction__c == t){
                if(pr.type__c == 'Alternate')
                    count++;
            }
     }
     
        if(count!=0){
            for(Sap_Price__c pr:sapprices){ 
                if(pr.Price_Request_Transaction__c == t){
                    if(pr.type__c == 'Alternate')
                        pr.type__c = 'Requested';
                    else
                        pr.type__c = pr.type__c + ' History';
                    
                }
            }
        }
    }   
    if(sapprices.size() > 0)
        upsert sapprices;
        
    /*PRTIdandCommentsMap = Approval_Functions.getLastApproversComments(PRTIdsAll);
    List<Price_Request_Transaction__c> prtList = new List<Price_Request_Transaction__c>();
    for(Integer i=0;i<Trigger.new.size();i++){
        if(Trigger.old[i].Approval_Status__c != 'Rejected-Alternate' && (Trigger.new[i].Approval_Status__c == 'Pending Entry' || Trigger.new[i].Approval_Status__c == 'Approved' || Trigger.new[i].Approval_Status__c == 'SAP Transfer Open')){  
            
            if(PRTIdandCommentsMap.get(Trigger.new[i].Id) != '' && PRTIdandCommentsMap.get(Trigger.new[i].Id) != null){
                Trigger.new[i].Reject_Alternate_Comments__c = PRTIdandCommentsMap.get(Trigger.new[i].Id);
                prtList.add(Trigger.new[i]);
            }
        }
     }    
     update prtlist;*/
    
    
}