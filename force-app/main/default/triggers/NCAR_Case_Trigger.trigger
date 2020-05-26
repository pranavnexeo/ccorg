/*@@The trigger submits the NCARs for the Record type 'Nexeo Standard Incident' and 'Nexeo Return'in the Approval
Process.
*/
trigger NCAR_Case_Trigger on NCAR_Cases__c (after insert,after update) {

   
    Map<String, String> recordTypemap = new Map<String, String>();
    
    // NCARIdList contains the ID of the NCARs to be submitted for the Approval Process at the Insert.
    List<Id> NCARIdList = new List<Id>();
    
    // NCARIdListQueue contains the ID of the NCARs to be submitted for the Plant Queue.
    List<Id> NCARIdListQueue = new List<Id>();
    
    // NCARIdListQueueApp contains the ID of the NCARs to be submitted for the Approval Process after update.
    List<Id> NCARIdListQueueApp = new List<Id>();
    
    List<Id> NCARRecType = new List<Id>();
    
    for(NCAR_Cases__c Ncar : trigger.new){
         
         //system.debug('Status Check Trigger: ' + NCAR.status__c);
         NCARRecType.add(Ncar.RecordTypeId);
         
    }
    
     for(RecordType rec : [Select Id,Name from RecordType where Id in : NCARRecType]){
         recordTypemap.put(rec.Id,rec.Name);
     }
     for(NCAR_Cases__c Ncar : trigger.new){
        System.debug('<++ Ncar ++>'+Ncar );
        if(recordTypemap.get(Ncar.RecordTypeId) != 'Nexeo DZ'&& 
           recordTypemap.get(Ncar.RecordTypeId) !='Nexeo Credit Debit Claim' && 
           NCAR.Saved_As_Draft__C == false)
             NCARIdList.add(Ncar.Id);
        
        if(recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return' && 
           Ncar.Type__c == 'Nexeo Physical Material Return' && 
           Ncar.Status__c == 'Waiting on Delivery Block release')     
              NCARIdListQueue.add(Ncar.Id);
            
        if(recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return' && 
           Ncar.Status__c == 'Rejected' && 
           NCAR.Reason_Rejected__c == 'More Information Required' &&
           NCAR.Saved_As_Draft__C == false
        ){     
             NCARIdListQueue.add(Ncar.Id);
             NCARIdListQueueApp.add(Ncar.Id);
        }

        // Added by Sana Tarique for incident# INC000002082647
           
        if(recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Standard Incident' && 
           Ncar.Status__c == 'Rejected' && 
           (NCAR.Reason_Rejected__c == 'More Information Required'|| NCAR.Reason_Rejected__c != 'Tiers Dispute') && 
             NCAR.Saved_As_Draft__C == false){     
             NCARIdListQueue.add(Ncar.Id);
             NCARIdListQueueApp.add(Ncar.Id);
        }   
        
        /*
        SYSTEM.DEBUG('TEST CASE: ' + (recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return' && 
           (Ncar.Type__c == 'Nexeo Paperwork Only Return' || Ncar.Type__c == 'Third Party Return') &&  
           (Ncar.Status__c == 'Submitted to Plant'||Ncar.Status__c == 'New')));
        
        SYSTEM.DEBUG('RECORDTYPE: ' + recordTypemap.get(Ncar.RecordTypeId) + ':' + (recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return' ));
        SYSTEM.DEBUG('TYPE: ' + NCAR.TYPE__C + ' : ' + (Ncar.Type__c == 'Nexeo Paperwork Only Return' || Ncar.Type__c == 'Third Party Return'));
        SYSTEM.DEBUG('STATUS = ' + Ncar.Status__c + ' : ' +  (Ncar.Status__c == 'Submitted to Plant'||Ncar.Status__c == 'New')); 
        */
        
        if((recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return' && 
            Ncar.Type__c == 'Nexeo Paperwork Only Return'  &&  
           (Ncar.Status__c == 'Submitted to Plant'||Ncar.Status__c == 'New')))
        {  NCARIdListQueue.add(Ncar.Id);
        //   SYSTEM.DEBUG('GOT HERE!');
        }
         
        if((recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return' && 
           Ncar.Type__c == 'Third Party Return' &&  NCAR.Saved_As_Draft__c == false &&
           (Ncar.Status__c == 'Submitted to Plant'||Ncar.Status__c == 'New')))
        {  NCARIdListQueueApp.add(Ncar.Id);
        //   SYSTEM.DEBUG('GOT HERE!');
        }          
        
        if(recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Standard Incident' && 
          (Ncar.Status__c == 'New') && 
           NCAR.Saved_As_Draft__C == false)
           {
             NCARIdListQueue.add(Ncar.Id);
             NCARIdListQueueApp.add(Ncar.Id);
          //   system.debug('-----GOT here for standard incident-----'+NCARIdListQueue);
          //   system.debug('-----GOT here for standard after update-----'+NCARIdListQueueApp);
            } 
            
        
        if(recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return'  &&  
           Ncar.Type__c == 'Nexeo Physical Material Return' &&
           Ncar.Status__c == 'Approved by Purchasing' && 
           NCAR.Saved_As_Draft__C == false){          
             NCARIdListQueueApp.add(Ncar.Id);      
             NCARIdListQueue.add(Ncar.Id); 
         }
         
        if((Ncar.Route_to__c == 'Dan Black' || Ncar.Route_to__c =='Mark Cramer') &&
            Ncar.Status__c == 'NCAR- ES Approval Process' && 
            NCAR.Saved_As_Draft__C == false){          
            
            NCARIdListQueue.add(Ncar.Id);  
           
         }
           
        if(recordTypemap.get(Ncar.RecordTypeId) == 'Nexeo Return'  &&  
           (Ncar.Type__c == 'Nexeo Physical Material Return'|| Ncar.Type__c == 'Nexeo Paperwork Only Return') 
           && NCAR.Saved_As_Draft__C == false &&  (NCAR.Status__c == 'New' || NCAR.Status__c == 'Approved by Plant')){
               NCARIdListQueueApp.add(Ncar.Id);
           }     
    } 
    
    
    
    if(Trigger.isInsert && Trigger.isAfter){

        List<Approval.ProcessSubmitRequest> reqs = new list<Approval.ProcessSubmitRequest>();       
        for(integer i = 0; i<NCARIdList.size();i++){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setObjectId(NCARIdList[i]);
                req1.setComments('Submitting for Approval');
                reqs.add(req1);
        }
       
        if(reqs!=null && reqs.size()>0){
            List<Approval.ProcessResult> results;
            Try{
                results = Approval.process(reqs);
            }Catch(Exception e){}
        }
        
 
    }
       
    if(Trigger.isUpdate && Trigger.isafter){
     
      List<Approval.ProcessSubmitRequest> reqs = new list<Approval.ProcessSubmitRequest>();
      for(integer i = 0; i<NCARIdListQueueApp.size();i++){
          // system.debug('-----got off the track:----- '+reqs);
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setObjectId(NCARIdList[i]);
          req1.setComments('Submitting for Approval');
          reqs.add(req1);
          //system.debug('-----reqs:----- ' +reqs);
      }
      //system.debug('-----reqs.size():-----'+reqs.size());
      if(reqs!=null && reqs.size()>0){
          //system.debug(' inside reqs loop');
          List<Approval.ProcessResult> results;
          Try{
              results = Approval.process(reqs);
          }Catch(Exception e){}
          //system.debug(' Approval.process(reqs)'+ Approval.process(reqs));
       }
       //system.debug('-----got off the approval submission:-----');
            
     }  
        /*
        for(NCAR_Cases__c Ncar : trigger.new){        
         system.debug('Status Check Trigger MIDDLE: ' + NCAR.status__c);     
        }  
        */
        Map<String, String> PCQueuemap = new Map<String, String>();
        Map<String, String> IdPCMap= new Map<String, String>();    
        List<NCAR__c> listNCAR_CS = NCAR__c.getall().values();
        system.debug('----listNCAR_CS----'+listNCAR_CS);
        List<String> queueList = new List<String>();
        Map<String,Id> QueueNameIdMap = new map<String,Id>();

        for(Group q :[select Id,Name from Group where Type = 'Queue'])
        QueueNameIdMap.put(q.Name,q.Id);
        
        for(NCAR__c cs:listNCAR_CS )
        {
            PCQueuemap.put(cs.Name,cs.NCAR_Queue__c);
           
        }
        system.debug('----PCQueuemap1----'+PCQueuemap);

        String queuename  = 'NCAR Default Queue';
        Id defaultQueueId  = [Select id from group where Name = :queuename Limit 1].Id;

        Map<id, List<ProcessInstanceWorkItem>> itemmap = new Map<Id, List<ProcessInstanceWorkItem>>();
        for( ProcessInstanceWorkItem workItem : [Select ProcessInstance.TargetObjectId, ActorId From ProcessInstanceWorkitem 
                                                where ProcessInstance.TargetObjectId in :NCARIdListQueue and 
                                                actorId = :defaultQueueId order by createddate desc]){
                                                if(itemmap.containskey(workitem.Processinstance.TargetObjectId))
                                                  itemmap.get(workitem.Processinstance.TargetObjectId).add(workitem);
                                                else
                                                  itemmap.put(workitem.ProcessInstance.TargetObjectId, new List<ProcessInstanceWorkItem>{workitem});
        }
        
        List<ProcessInstanceWorkItem> workitemlist = new List<ProcessInstanceWorkItem>();
        for( NCAR_Cases__c ncar: trigger.new){
        
            if(ncar.Status__c == 'Approved by Purchasing' || ncar.Status__c == 'Submitted To Plant' || ncar.Status__c == 'Submitted To Approver' || ncar.Status__c == 'New'||ncar.Status__c == 'Rejected'){
                if(ncar.Approval_Plant__c != ''){
                system.debug('----ncar.Approval_Plant__c----'+ncar.Approval_Plant__c);
                    if(PCQueueMap.containskey(ncar.Approval_Plant__c)){
                    system.debug('----got to the plant approval selection----');
                        String queueid = QueueNameIdMap.get(PCQueuemap.get(ncar.Approval_Plant__c));
                        system.debug('----got to the plant approval selection queueid ----'+queueid);
                        if(itemmap.containskey(ncar.id))
                            for( ProcessInstanceWorkItem workItem : itemmap.get(ncar.id)){
                                workItem.ActorId = queueid ;
                                system.debug('----workItem.ActorId----'+workItem.ActorId);
                                workitemlist.add(workitem);
                                system.debug('----PCQueuemap:-------'+PCQueuemap);
                                system.debug('------queueid-----'+queueid );
                            }
                    }
                }
            }
        }
        update workItemList;   
    
    /*   
    for(NCAR_Cases__c Ncar : trigger.new){        
         system.debug('Status Check Trigger END: ' + NCAR.status__c);     
    } */    
}