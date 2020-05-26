public with sharing class Chatter_Functions{
 
 public static void createLinkPost(ID recordid, string title, string body, string URL){
 
 if(recordid != null ){
 FeedItem post = new FeedItem();
 Post.Type = 'LinkPost';
 Post.Title = title;
 if(body.length() > 1000){
 Post.Body = body.substring(0,999);}
 else{
 Post.body = body;
 }
 Post.LinkURL = URL;
 Post.ParentID = recordId;
 insert post;
 }
 }
 
 public static void createLinkPost(ID recordid, string title, string body){
 
 
 String URL = new pagereference('/' + recordId).geturl();
 system.debug('URL: ' + URL);
 if(recordid != null ){
   createLinkPost(recordid, title, body, url);
 }
 }
 
 public static void createTextPost(ID recordid, string title, string body){
 
 if(recordid != null ){
 FeedItem post = new FeedItem();
 Post.Type = 'TextPost';
 Post.Title = title;
 if(body.length() > 1000){
 Post.Body = body.substring(0,999);}
 else{
 Post.body = body;
 }
 Post.ParentID = recordId;
 insert post;
 }
 
 }
 
 public static void createFilePost(id recordid, string body, attachment a){
 
  if(recordid != null ){
  FeedItem post = new FeedItem();
  post.ParentId = recordid;
  if(body.length() > 1000){
    Post.Body = body.substring(0,999);}
  else{
    Post.body = body;
  }
  post.ContentData = a.body;
  post.ContentFileName = a.name;
  insert post;
  post.ContentData = null;
  }
  
  
}
 
  public static FeedItem createLinkPostFI(ID recordid, string title, string body, string URL){
 
 if(recordid != null ){
 FeedItem post = new FeedItem();
 Post.Type = 'LinkPost';
 Post.Title = title;
 if(body.length() > 1000){
 Post.Body = body.substring(0,999);}
 else{
 Post.body = body;
 }
 Post.LinkURL = URL;
 Post.ParentID = recordId;
 return post;
 }
 else return null;
 }
 
 public static FeedItem createLinkPostFI(ID recordid, string title, string body){
 
 
 String URL = new pagereference('/' + recordId).geturl();
 system.debug('URL: ' + URL);
 if(recordid != null ){
   return createLinkPostFI(recordid, title, body, url);
 }
 else return null;
 }
 
 public Static FeedItem createTextPostFI(ID recordid, string title, string body){
 
 if(recordid != null ){
 FeedItem post = new FeedItem();
 Post.Type = 'TextPost';
 Post.Title = title;
 if(body.length() > 1000){
 Post.Body = body.substring(0,999);}
 else{
 Post.body = body;
 }
 Post.ParentID = recordId;
 return post;
 }
 else return null;
 
 }
 
 public static FeedItem createFilePostFI(id recordid, string body, attachment a){
 
  if(recordid != null ){
  FeedItem post = new FeedItem();
  post.ParentId = recordid;
  if(body.length() > 1000){
    Post.Body = body.substring(0,999);}
  else{
    Post.body = body;
  }
  post.ContentData = a.body;
  post.ContentFileName = a.name;
  return post;
  }else return null;
  
  
}
 public static void addfollow(id recordid, id userid){
 
   if(recordid != null ){
   Set<ID> followers = getfollowers(recordid);
   If(!followers.contains(userid)){
     EntitySubscription follow = new EntitySubscription (
                                    parentId = recordid,
                                    subscriberid = userid); 
     insert follow;
    }
   }

}

 public static void addfollow(id recordid){ 
   addfollow(recordid, userinfo.getuserid());
}


 public static void addfollow(id recordid, List<User> users){
   if(recordid != null ){
   Set<ID> followers = getfollowers(recordid); 
   List<EntitySubscription> follows = new list<EntitySubscription>();
      
    for(User u:users){
      If(!followers.contains(u.id)){
        EntitySubscription follow = new EntitySubscription (
                                    parentId = recordid,
                                    subscriberid = u.id);
        follows.add(follow); 
      }
    }                              
   if(follows.size() != 0){ insert follows; }
   }
}

 public static void addfollow(id recordid, List<String> users){
   
   if(recordid != null ){
   Set<string> userids = new set<string>();
   for(string u:users){
      userids.add(u.trim());
   }
   List<user> userlist = [select id from user where id in :userids];
   addfollow(recordid, userlist);
   }
}    


 public static void addfollow(list<sobject> records, id userid){
 
   if(userid != null ){
   List<EntitySubscription> follows = new list<EntitySubscription>();
   for(sobject record:records){
   EntitySubscription follow = new EntitySubscription (
                                    parentId = record.id,
                                    subscriberid = userid);
   follows.add(follow); 
   }                              
   insert follows;
   }
}

public static void addfollow(list<sobject> records){
  addfollow(records, userinfo.getuserid());
}

public static void removeallfollows(id recordid){
   if(recordid != null ){
   List<EntitySubscription> follows = [select id from EntitySubscription where 
                                          parentid = :recordid];
   delete follows;
   }
}

public static void removesubscriber(id recordid, List<User> users){
 if(recordid != null ){
   List<EntitySubscription> follows = [select id from EntitySubscription where 
                                          parentid = :recordid and subscriberid in :users];
   delete follows;
 }
}

public static void removesubscriber(id recordid, id userid){
   if(userid != null ){
     List<EntitySubscription> follows = [select id from EntitySubscription where 
                                          parentid = :recordid and subscriberid = :userid];
   delete follows;
   }
}

public static void removesubscriber(id recordid){
    removesubscriber(recordid, userinfo.getuserid());
}

public static void removesubscriber(List<sobject> records, id userid){
    if(userid != null ){
     Set<Id> recordids = new set<id>();
     for(sobject sobj:records)
     {
     recordids.add(sobj.id);
     }
     List<EntitySubscription> follows = [select id from EntitySubscription where 
                                          parentid in :recordids and subscriberid = :userid];
     delete follows;
     }
}

public static void removesubscriber(List<sobject> records){
    removesubscriber(records, userinfo.getuserid());
}
 
 public static list<NewsFeed> getmynewsfeed(){

List<NewsFeed> myfeed = new List<NewsFeed>();
/* 
 List<NewsFeed> myfeed = [SELECT Id, Type,
                           CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                           ParentId, Parent.Name,
                          Body, Title, LinkUrl, ContentData, ContentFileName,
                               (SELECT Id, FieldName, OldValue, NewValue
                                FROM FeedTrackedChanges ORDER BY Id DESC),
                               (SELECT Id, CommentBody, CreatedDate,
                                CreatedBy.FirstName, CreatedBy.LastName
                               FROM FeedComments ORDER BY CreatedDate LIMIT 10),
                              (SELECT CreatedBy.FirstName, CreatedBy.LastName
                               FROM FeedLikes)
                          FROM NewsFeed
                          ORDER BY CreatedDate DESC, Id DESC
                          LIMIT 20];
 */
 return myfeed;
 
 }
 
 
 public static list<AccountFeed> getAccountFeed(id Accountid){
 
 List<AccountFeed> myfeed = [SELECT Id, Type, 
                         CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                         ParentId, Parent.Name, 
                         Body, Title, LinkUrl, ContentData, ContentFileName,
                             (SELECT Id, FieldName, OldValue, NewValue 
                              FROM FeedTrackedChanges ORDER BY Id DESC), 
                             (SELECT Id, CommentBody, CreatedDate,
                              CreatedBy.FirstName, CreatedBy.LastName
                              FROM FeedComments ORDER BY CreatedDate LIMIT 10),
                             (SELECT CreatedBy.FirstName, CreatedBy.LastName
                              FROM FeedLikes)
                         FROM AccountFeed
                         WHERE ParentID = :accountid
                         ORDER BY CreatedDate DESC, Id DESC
                         LIMIT 20];
                         
 return myfeed;
 }                        

public static void updateuserstatus(String status)   {
   updateuserstatus(status, UserInfo.getUserId());      
}

public static void updateuserstatus(String status, id userid)   {
          User user = [select id, CurrentStatus from User where id = :userid];
          user.CurrentStatus = status;
          update user;
          
}

public static void updateuserstatus(String status, List<User> users){
         for(User u:users){
           u.currentstatus = status;
         }
         update users;
}


public static Set<ID> getfollowers(id parentid){
Set<ID> returnids = new set<ID>();
   for(EntitySubscription follower:
        [select id, subscriberid, subscriber.name
         from EntitySubscription
         where parentid =:parentid]){        
             returnids.add(follower.subscriberid);      
         }
   return returnids;
}
          
public static map<id, id>getManagerMap(List<sobject> sobjs){

  Set<ID> userids = new set<ID>();
  Map<ID, ID> managermap = new map<id, id>();
  for(sobject s:sobjs){
   userids.add((id)s.get('ownerid'));
  }
  
  List<user> users = [select id, managerid from user where id in :userids];
  for(user u:users){
    managermap.put(u.id, u.managerid);
  }
  return managermap;
}
}