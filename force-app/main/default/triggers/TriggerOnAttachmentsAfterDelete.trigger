trigger TriggerOnAttachmentsAfterDelete on Attachment (after delete) {
Integer numAtts=[select count() from attachment where parentid=:Trigger.old[0].ParentId];
List<Material_Sales_Data2__c> msd2 = [select id, Attachment_Exist__c from Material_Sales_Data2__c where id =:Trigger.old[0].ParentId];

                        if(msd2.size()>0 && numAtts==0)
                        {									
                                    msd2[0].Attachment_Exist__c = false;
                                    update msd2;
                        }    
}