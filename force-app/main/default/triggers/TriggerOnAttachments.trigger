trigger TriggerOnAttachments on Attachment (after insert) {

    List<Id> parentIds=new List<Id>(); 
    for (Attachment att : trigger.new) {
         parentIds.add(att.ParentId); 
    } 
    List<Material_Sales_Data2__c> msd2 = [select id, Attachment_Exist__c from Material_Sales_Data2__c where id in :parentIds]; 
    if(msd2.size()>0) { 
        for (Material_Sales_Data2__c msd : msd2) { 
            msd.Attachment_Exist__c = true; 
        } 
        update msd2;
    }                   
}