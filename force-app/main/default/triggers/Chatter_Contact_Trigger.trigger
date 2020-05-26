trigger Chatter_Contact_Trigger on Contact (before delete, after insert) {
   
   User u = [select id, UserType from user where id = :userinfo.getuserid()];
   List<FeedItem>FI = new List<FeedItem>();
   
 if(u.UserType == 'Standard'){
   
   if(trigger.isdelete){  
     for(Contact c:trigger.old){
     if(c.accountid != null){
      FI.add(Chatter_Functions.createTextPostFI(c.accountid,  c.firstname + ' ' + c.lastname + ' deleted.' , ' Deleted Contact ' + c.firstname + ' ' + c.lastname + ' on ' + system.now()));
     }
    }
   }
   
   if(trigger.isinsert){  
     for(Contact c:trigger.new){
      if(c.accountid != null){
      system.debug('ContactId: ' + c.id + ' Accountid: ' + c.accountid + ' Name: ' + c.firstname + ' ' + c.Lastname);
      FI.add(Chatter_Functions.createLinkPostFI(c.accountid, 'Contact ' +  c.firstname + ' ' + c.lastname + ' created.' , userinfo.getname() + ' created ' +  c.firstname + ' ' + c.lastname + ' on ' + system.now(), new pagereference('/' + c.id).geturl()));
     }
    }
   }
  }
if(FI.size() > 0){insert FI; }
}