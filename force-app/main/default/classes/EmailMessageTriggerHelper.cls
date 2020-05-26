/*
Created By: Abhinay Raj
Date      : 27/10/2017
Perpose   : When user click on send Email through Supplier_Page_Detail page attach is not populating activity. 
To add attachemnent to related task we created this trigger.
*/
global class EmailMessageTriggerHelper
{
    @future
    public static void docLoad(Set<id> EmsIds)
    {   
        Set<id> Ids = New Set<id>();
        Map<Id, Id> EM_Task_Map = new Map<Id, Id>();
        List<EmailMessage> EMList = [Select id, ActivityId, ParentId from EmailMessage where Id in:EmsIds AND ActivityId!= null AND HasAttachment=true LIMIT 1000];
       
        For(EmailMessage O:EMList){
            Ids.add(O.id);
            EM_Task_Map.put(O.id, O.ActivityId); 
        }
        
        If(Ids != null && Ids.size()>0){
            insertAttachements(Ids, EM_Task_Map);
        }
       
    }
    
    public static void insertAttachements(Set<id> Ids, Map<Id, Id> EM_Task_Map)
    {   
        Attachment[] attList = [select id, name, body, ParentId from Attachment where ParentId = :Ids LIMIT 1000];
        List<Attachment> insertAttList = new List<Attachment>();
        
        for(Attachment a: attList){
            Attachment att = new Attachment(name = a.name, body = a.body, parentid=EM_Task_Map.get(a.ParentId));
            insertAttList.add(att);
        }
        if(insertAttList != null && insertAttList.size() > 0){
            insert insertAttList;
        }
       
    }
}