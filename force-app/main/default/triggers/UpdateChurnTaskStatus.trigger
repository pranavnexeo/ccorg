trigger UpdateChurnTaskStatus on SalesChurn__c (after update) { 
    Set<Id> churnids = new set<Id>();
        for(SalesChurn__c s : trigger.new){
            churnids.add(s.Id);
        }

    List<SalesChurn__c> sclist = [Select Id,Reason__c from SalesChurn__c where Id In:churnids];
    List<Task> tlist = [Select Id, WhatId from Task where Whatid in :sclist];
     for(Integer i=0;i<sclist.size();i++){  
        for(Integer k=0;k<tlist.size();k++){
            if(tlist[k].WhatId == sclist[i].Id && sclist[i].Reason__c !=null && tlist.size()>0)
                tlist[k].Status = 'Completed';
        }
    }
    Update tlist;
}