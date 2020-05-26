trigger Chatter_Sample_Trigger on Sample_Request__c (before delete, after insert) {
   
      User u = [select id, UserType from user where id = :userinfo.getuserid()];
      List<FeedItem> FI = new List<FeedItem>();
      
 if(u.UserType == 'Standard'){
   
   
   if(trigger.isdelete){  
     for(Sample_Request__c s:trigger.old){
      if(s.account__c != null){
      FI.add(Chatter_Functions.createTextPostFI(s.account__c, s.name + ' deleted.' , ' deleted ' + s.name + ' on ' + system.now()));
      }
     }
   }
   
   if(trigger.isinsert){  
     for(Sample_Request__c s:trigger.new){
      if(s.account__c != null){
      FI.add(Chatter_Functions.createLinkPostFI(s.account__c, s.name + ' created.' , ' created ' + s.name + ' on ' + system.now(), new pagereference('/' + s.id).geturl()));
      }
     }
   }
 }
 If(FI.size() > 0){ insert FI; }
}