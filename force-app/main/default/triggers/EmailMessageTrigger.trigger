/*
Created By: Abhinay Raj
Date      : 27/10/2017
Perpose   : When user click on send Email through Supplier_Page_Detail page attach is not populating activity. 
To add attachemnent to related task we created this trigger.
*/
trigger EmailMessageTrigger on EmailMessage (After Insert) {
    
    if (Trigger.IsAfter && trigger.IsInsert){
        
        Set<id> Ids = New Set<id>();
        For(EmailMessage O:Trigger.New){
            If(O.ActivityId != null){
                Ids.add(O.id);
            }
        }
        EmailMessageTriggerHelper.docLoad(Ids);
        
    }
    
}