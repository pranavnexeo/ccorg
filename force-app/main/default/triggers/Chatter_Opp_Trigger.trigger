trigger Chatter_Opp_Trigger on Opportunity (before delete, after insert) {
   
 User u = [select id, UserType from user where id = :userinfo.getuserid()];
 List<FeedItem> FI = new List<FeedItem>();
   
 if(u.UserType == 'Standard'){
   if(trigger.isdelete){  
     for(Opportunity o:trigger.old){
     if(o.accountid != null){
      FI.add(Chatter_Functions.createTextPostFI(o.accountid, 'Opportunity ' + o.name + ' deleted.' , 'Deleted Opportunity ' + o.name + ' on ' + system.now()));
     }
    }
   }
   
   if(trigger.isinsert){  
     for(Opportunity o:trigger.new){
      if(o.accountid != null){
      FI.add(Chatter_Functions.createLinkPostFI(o.accountid, 'Opportunity ' +  o.name + ' created.' , userinfo.getname() + ' created Opportunity ' + o.name + ' on ' + system.now(), new pagereference('/' + o.id).geturl()));
      }
     }
   }
 }
 if(FI.size() > 0){insert FI; }
}