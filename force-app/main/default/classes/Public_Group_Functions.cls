public class Public_Group_Functions {

  public static Id LookupPublicGroupId(String name) {
    Id result = null;
    try {result = [SELECT Id FROM Group WHERE Name = :name AND Type = 'Regular'].Id;}
    catch (Exception e) {}
    return result;
  }

  public static Id LookupQueueId(String name) {
    Id result = null;
    try {result = [SELECT Id FROM Group WHERE Name = :name AND Type = 'Queue'].Id;}
    catch (Exception e) {}
    return result;
  }

  public static Id AddUsertoGroup(Id userId,Id groupId) {
    GroupMember gm = new GroupMember();
    gm.GroupId = GroupId;
    gm.UserOrGroupId = userId;
    insert gm;
    return gm.Id;
  }

  public static void RemoveUserfromGroup(Id userId,Id groupId) {
    GroupMember gm = [SELECT Id FROM GroupMember WHERE GroupId = :groupId AND UserOrGroupId = :userId];
    if (gm != null)
      {
        delete gm;
      }
  }

  public static Boolean UserExistsinGroup(Id userId, Id groupId) {
    Boolean result = false;
    Integer userCount = [SELECT count() FROM GroupMember WHERE GroupId = :groupId AND UserOrGroupId = :userId];
    if (userCount > 0) {result = true;}
    return result;
  }
    
  public static Map<String,Id> CreateSampleRequestQueueGroup(String nameIn) {
    
    Map<String,Id> results = new Map<String,Id>();
    
    if ((LookupPublicGroupId('Sample Request Admin Group') != null) &&
        (LookupPublicGroupId(nameIn) == null) &&
        (LookupQueueId(nameIn) == null))
      {
      Group newGroup = new Group(Name=nameIn,Type='Regular',DoesSendEmailToMembers=false);
      Group newQueue = new Group(Name=nameIn,Type='Queue',DoesSendEmailToMembers=true);
      
      QueueSobject newQueueSobject = new QueueSobject();
      
      //Create Groups as needed
      insert newGroup;
  
      //Create Queues as needed
      insert newQueue;
          
      //Create QueueSobject records as needed
      QueueSobject queuesobject = new QueueSobject(QueueId=newQueue.Id,SobjectType='Sample_Request__c');
      insert queuesobject;
          
      //Associate Groups to Queues as needed
      GroupMember newGroupMember = new GroupMember(GroupId=newQueue.Id,UserOrGroupId=newGroup.Id);
      insert newGroupMember;
  
      //Insert Sample Request Admin Group
      GroupMember newAdminGroupMember = new GroupMember(GroupId=newGroup.Id,UserOrGroupId=LookupPublicGroupId('Sample Request Admin Group'));
      insert newAdminGroupMember;
      
      results.put('GroupId',newGroup.Id);
      results.put('QueueId',newQueue.Id);
      }   

    return results;      
  }
  
    public static Map<String, Id> getRegularGroupNameIdMap(Set<String> groupNames) {
        Map<String, Id> gmap = new Map<String, Id>();
        for(List<Group> glist : [select id, name 
                                   from group
                                  where type = 'Regular'
                                    and name in :groupNames
                                ]) {
            for(Group g : glist) {
                gmap.put(g.name, g.id);
            }
        }
        return gmap;
    }
    
    private static Set<String> getSalesAreaPublicGroupNames() {
        Set<String> sapgs = new Set<String>();
        Map<String, SalesAreaPublicGroups__c> sapgMap = SalesAreaPublicGroups__c.getAll();
        Set<String> keys = sapgMap.keySet();
        for (String key : keys) {
            SalesAreaPublicGroups__c sapg = sapgMap.get(key);
            if (sapg == null) {
                continue;
            }
            String pgs = sapg.PublicGroups__c;
            String[] pga = pgs.split('\r\n');
            for(String pg : pga) {
                sapgs.add(pg);
            }
        }
        return sapgs;
    }

    public static Map<String, List<String>> getSalesAreaPublicGroupIds() {
        Map<String, List<String>> rmap = new Map<String, List<String>>();
        Map<String, SalesAreaPublicGroups__c> sapgMap = SalesAreaPublicGroups__c.getAll();
        Set<String> sapgs = getSalesAreaPublicGroupNames();
        Map<String, Id> gmap = getRegularGroupNameIdMap(sapgs); 
        Set<String> keys = sapgMap.keySet();
        for (String key : keys) {
            key = key.toUpperCase();
            List<String> groupids = new List<String>();
            SalesAreaPublicGroups__c sapg = sapgMap.get(key);
            if (sapg == null) {
                continue;
            }
            String pgs = sapg.PublicGroups__c;
            String[] pga = pgs.split('\r\n');
            for(String pg : pga) {
                //System.debug(key+':'+pg+':'+gmap.get(pg));

                if (gmap.containsKey(pg)) {
                    groupids.add(gmap.get(pg));
                }
            }
            
            rmap.put(key, groupids);
        }
        return rmap;
    }

//The End
}