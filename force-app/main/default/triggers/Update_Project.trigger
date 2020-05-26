trigger Update_Project on ART_Project__c (before update,after update,after insert) {
    
    if(Trigger.isUpdate && Trigger.isBefore){
        List<Project_Status_Log__c> logs = new List<Project_Status_Log__c>();
        for(ART_Project__c p:trigger.new){
            if(p.Project_Status__c != trigger.oldmap.get(p.id).Project_Status__c)
            {
                DateTime dt = p.lastmodifieddate;
                if(p.Status_Last_Modified__c != null)
                    dt = p.Status_Last_Modified__c;
                Project_Status_Log__c log = new Project_Status_Log__c( 
                Status__c = trigger.oldmap.get(p.id).Project_Status__c,
                Date_Entered_Status__c = dt,
                Date_Exited_Status__c = system.now(),
                Days_In_Status__c = ((system.now().getTime() - dt.getTime()) / (1000 * 60 * 60 * 24)),
                Project__c = p.id);
                logs.add(log);
                p.Status_Last_Modified__c = system.now();
            }   
        
        }
        if(logs.size() > 0)
        insert logs;
    }
    
   /* if(Trigger.isInsert && Trigger.isAfter){
        List<Id> projID = new List<Id>();
        Map<Id,Id> businessContact = new Map<Id,Id>();
        Map<Id,Id> projOwner = new Map<Id,Id>();
        for(ART_Project__c project :trigger.new){
            projID.add(project.Id);
            businessContact.put(project.Id,project.User_Contact__c);
            projOwner.put(project.Id,project.OwnerId);
        
        }
        if(projID!=null && projID.size()>0){
            List<EntitySubscription> enSubs = new List<EntitySubscription>(); 
            
            for (Integer i=0;i<projID.size();i++){
            Set<Id> userToFollow = new Set<Id>();
            List<Id> userToFollowList = new List<Id>();
            if(projOwner.get(projID[i])!=null){
                userToFollow.add(projOwner.get(projID[i]));
            }
            
            if(businessContact.get(projID[i])!=null){
                userToFollow.add(businessContact.get(projID[i]));
            }
            
            for(String s: userToFollow){
            userToFollowList.add(s);
            
            }
           
            
            for(Integer count =0;count<userToFollowList.size();count++){
            
                EntitySubscription ensub = new EntitySubscription(
                ParentId = projID[i],
                SubscriberId =  userToFollowList[count]);
                enSubs.add(ensub);
             }   
            
            }
            
            insert enSubs;
        
        }
        
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        
        List<Id> enhID = new List<Id>();
        Map<Id,Id> businessContact = new Map<Id,Id>();
        Map<Id,Id> businessContactNew = new Map<Id,Id>();
        Map<Id,Id> projOwner = new Map<Id,Id>();
        List<ART_Project__c> oldData = trigger.old;
        List<ART_Project__c> newData = trigger.new;
        Map<Id,List<Id>> projUserMap = new Map<Id,List<Id>>();
        Map<Id,List<Id>> projUserMapFollow = new Map<Id,List<Id>>();
        for(Integer i=0;i<newData.size();i++){
        Set<Id> UserToUnfollow = new  Set<Id>();
        Set<Id> UserToFollow = new Set<Id>();
        List<Id> UserToUnfollowNew = new  List<Id>();
        List<Id> UserToFollowNew = new List<Id>();
        
        if(newData[i].Id == oldData[i].Id && newData[i].Project_Status__c == '9 - Complete'){
         UserToUnfollow.add(oldData[i].User_Contact__c);
         UserToUnfollow.add(oldData[i].OwnerId);
        }
        
        
        if(newData[i].Id == oldData[i].Id && ( newData[i].User_Contact__c != oldData[i].User_Contact__c || newData[i].OwnerId != oldData[i].OwnerId)&& newData[i].Project_Status__c != '9 - Complete')
        {
        
           if(newData[i].User_Contact__c != oldData[i].User_Contact__c){
                if(oldData[i].User_Contact__c != newData[i].Assigned_To__c && oldData[i].User_Contact__c != newData[i].OwnerId){
                    userToUnFollow.add(oldData[i].User_Contact__c);
                }
                userToFollow.add(newData[i].User_Contact__c);
               
            }
            
            if(newData[i].OwnerId != oldData[i].OwnerId){
                if(oldData[i].OwnerId != newData[i].Assigned_To__c && oldData[i].OwnerId != newData[i].User_Contact__c){
                    userToUnFollow.add(oldData[i].OwnerId);
                }
                userToFollow.add(newData[i].OwnerId);
                
            }
            
             
        }
        
         if(userToUnFollow!=null){
            for(Id s : userToUnFollow){
                     UserToUnfollowNew.add(s);
                 }
        }    
        
         if(userToFollow!=null){ 
              for(Id s : userToFollow){
                 UserToFollowNew.add(s);
             }
          }  
            
            projUserMap.put(newData[i].Id,UserToUnfollowNew);
            projUserMapFollow.put(newData[i].Id,UserToFollowNew);
            enhID.add(newData[i].Id);
        
        }
        
        List<EntitySubscription> entSubs = [Select Id,ParentId,SubscriberId from EntitySubscription where ParentId in: projUserMap.keyset()];
        List<EntitySubscription> entSubsToCreate = new List<EntitySubscription>();
        List<EntitySubscription> entSubsToDelete = new List<EntitySubscription>();
        for(Integer count=0;count<enhID.size();count++){
         List<Id> userSetFollow = new List<Id>();
         List<Id> userSetFollowNew = new List<Id>();
         List<Id> userSetNotFollow = new List<Id>();
         
         userSetNotFollow.addall(projUserMap.get(enhID[count]));
         userSetFollow.addall(projUserMapFollow.get(enhID[count]));
         userSetFollowNew.addall(projUserMapFollow.get(enhID[count]));
         
         
         if(userSetFollow!=null && userSetFollow.size()>0){
             for(Integer j=0;j<userSetFollow.size();j++){
                 for(EntitySubscription sub:entSubs){
                     if(sub.ParentId == enhID[count] && sub.SubscriberId == userSetFollow[j]){
                            userSetFollowNew.remove(j);
                     }
                 }
             }
         
         }
         
         
         if(userSetFollowNew!=null && userSetFollowNew.size()>0){
             for(Integer k=0;k<userSetFollowNew.size();k++){
              EntitySubscription ensub = new EntitySubscription(
                    ParentId =enhID[count],
                    SubscriberId =  userSetFollowNew[k]);
                    entSubsToCreate.add(ensub);
             }
         
         }
         
         insert entSubsToCreate;
         
         if(userSetNotFollow!=null && userSetNotFollow.size()>0){
                 for(Integer i=0;i<userSetNotFollow.size();i++){
                    for(EntitySubscription sub:entSubs){
                        if(sub.ParentId == enhID[count] && sub.SubscriberId == userSetNotFollow[i]){
                            entSubsToDelete.add(sub);
                        }
                    }
                
                }
            
              }
          }
          delete entSubsToDelete;
}*/

}