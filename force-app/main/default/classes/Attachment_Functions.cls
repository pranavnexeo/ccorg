public with sharing class Attachment_Functions {

    public static Map<Id, List<Attachment>> getAttachments(Set<Id> objectIds) {
        Map<Id, List<Attachment>> amap = new Map<Id, List<Attachment>>();
        List<Attachment> alist = [select BodyLength,
                                         ContentType, 
                                         CreatedById,
                                         Id, 
                                         LastModifiedDate,
                                         Name, 
                                         ParentId
                                    from Attachment
                                   where ParentId in :objectIds
                                 ];
        if (alist.isEmpty()) {
        	return null;
        }
        List<Attachment> blist;
        Id objectId;
        for (Attachment a : alist) {
            objectId = a.ParentId;
            if (!amap.containsKey(objectId)) {
            	amap.put(objectId, new List<Attachment>());
            }
            blist = amap.get(objectId);
            blist.add(a);
            amap.put(objectId, blist);
        }
        return amap;
    }
}